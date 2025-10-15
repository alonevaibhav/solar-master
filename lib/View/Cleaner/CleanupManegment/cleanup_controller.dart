

import 'dart:typed_data';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../../../API Service/api_service.dart';
import '../../../Route Manager/app_routes.dart';
import '../../../Services/data_parser.dart';
import '../../../Services/init.dart';
import '../../../utils/constants.dart';
import 'dart:developer' as developer;


class CleaningManagementController extends GetxController {
  final todaysSchedules = Rxn<List<Map<String, dynamic>>>();
  final taskDetails = Rxn<Map<String, dynamic>>();
  final reportData = Rxn<Map<String, dynamic>>();

  final isLoading = false.obs;
  final isTaskDetailsLoading = false.obs;
  final isMaintenanceModeLoading = false.obs;
  final errorMessage = ''.obs;
  final selectedTaskId = 0.obs;

  final taskStatus = ''.obs;
  final maintenanceETA = 120.obs;
  final remainingETA = 0.obs;
  final isMaintenanceModeEnabled = false.obs;
  final isETAActive = false.obs;
  final elapsedETA = 0.obs;

  Timer? _etaTimer;
  SharedPreferences? _prefs;

  static const String _etaStartTimeKey = 'eta_start_time';
  static const String _etaDurationKey = 'eta_duration';
  static const String _taskIdKey = 'current_task_id';
  static const String _etaActiveKey = 'eta_active';

  List<Map<String, dynamic>> get pendingCleanups {
    if (todaysSchedules.value == null) return [];
    return todaysSchedules.value!
        .where((schedule) => schedule['status'] == 'pending')
        .toList();
  }

  String? uuid;

  void setUuid(String? newUuid) {
    uuid = newUuid;
    developer.log("UUID set to: $uuid", name: 'Controller');
  }

  void printUuidInfo() {
    developer.log("=== UUID Information ===", name: 'Controller');
    developer.log("UUID: ${uuid ?? 'NULL'}", name: 'Controller');
    developer.log("Is UUID null: ${uuid == null}", name: 'Controller');
    developer.log(
        "Is UUID empty: ${uuid?.isEmpty ?? true}", name: 'Controller');
    developer.log("UUID length: ${uuid?.length ?? 0}", name: 'Controller');
    developer.log("========================", name: 'Controller');
  }

  void clearData() {
    developer.log(
        'Clearing CleaningManagementController data...', name: 'Controller');
    developer.log('Stack trace: ${StackTrace.current}', name: 'Controller');

    try {
      uuid = null;
      taskDetails.value = null;
      reportData.value = null;

      // DON'T clear todaysSchedules - this causes the issue
      // todaysSchedules.value = null;  // REMOVED

      isLoading.value = false;
      isTaskDetailsLoading.value = false;
      isMaintenanceModeLoading.value = false;
      errorMessage.value = '';
      selectedTaskId.value = 0;
      taskStatus.value = '';
      currentScheduleId.value = 0;
      currentReportId = null;
      isMaintenanceModeEnabled.value = false;
      isETAActive.value = false;
      maintenanceETA.value = 120;
      remainingETA.value = 0;
      elapsedETA.value = 0;

      _etaTimer?.cancel();
      _etaTimer = null;

      currentImei.value = '';
      currentTopic.value = '';
      numberOfBoxes.value = 0;

      _clearETAData();

      developer.log('CleaningManagementController data cleared successfully',
          name: 'Controller');
    } catch (e) {
      developer.log('Error clearing CleaningManagementController data: $e',
          name: 'Controller');
    }
  }

  List<Map<String, dynamic>> get ongoingCleanups {
    if (todaysSchedules.value == null) return [];
    return todaysSchedules.value!
        .where((schedule) => schedule['status'] == 'cleaning')
        .toList();
  }

  List<Map<String, dynamic>> get completedCleanups {
    if (todaysSchedules.value == null) return [];
    return todaysSchedules.value!
        .where((schedule) => schedule['status'] == 'done')
        .toList();
  }

  int get totalPanels {
    return taskDetails.value?['plant_total_panels'] ?? 0;
  }

  double get plantCapacity {
    return (taskDetails.value?['plant_capacity_w'] ?? 0.0).toDouble();
  }

  String get plantLocation {
    return taskDetails.value?['plant_location'] ?? 'Unknown Location';
  }

  String get cleaningStartTime {
    return taskDetails.value?['cleaning_start_time'] ?? '08:00 AM';
  }

  String get plantName {
    return taskDetails.value?['plant_name']?.toString() ?? 'N/A';
  }

  String get plantAddress {
    return taskDetails.value?['plant_address']?.toString() ?? 'N/A';
  }

  String get talukaName {
    return taskDetails.value?['taluka_name']?.toString() ?? 'N/A';
  }

  String get areaName {
    return taskDetails.value?['area_name']?.toString() ?? 'N/A';
  }

  int get plantTotalPanels {
    return taskDetails.value?['plant_total_panels'] ?? 0;
  }

  double get plantAreaSqM {
    final value = taskDetails.value?['plant_area_squrM'];
    if (value == null) return 0.0;
    return value is int ? value.toDouble() : (value as num).toDouble();
  }

  double get plantCapacityW {
    final value = taskDetails.value?['plant_capacity_w'];
    if (value == null) return 0.0;
    return value is int ? value.toDouble() : (value as num).toDouble();
  }


  String get plantuuid {
    return taskDetails.value?['plant_uuid'] ?? 0;
  }

  @override
  void onInit() {
    super.onInit();
    _initSharedPreferences();
    fetchTodaysSchedules();
  }

  @override
  void onClose() {
    _etaTimer?.cancel();
    super.onClose();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    await _restoreETAState();
  }

  Future<void> _restoreETAState() async {
    if (_prefs == null) return;

    final isActive = _prefs!.getBool(_etaActiveKey) ?? false;
    final savedTaskId = _prefs!.getInt(_taskIdKey) ?? 0;
    final startTime = _prefs!.getInt(_etaStartTimeKey) ?? 0;
    final duration = _prefs!.getInt(_etaDurationKey) ?? 0;

    if (isActive && savedTaskId > 0 && startTime > 0) {
      if (savedTaskId == selectedTaskId.value) {
        final currentTime = DateTime
            .now()
            .millisecondsSinceEpoch;
        final elapsedSeconds = ((currentTime - startTime) / 1000).floor();
        final remainingSeconds = (duration * 60) - elapsedSeconds;

        if (remainingSeconds > 0) {
          remainingETA.value = remainingSeconds;
          isETAActive.value = true;
          isMaintenanceModeEnabled.value = true;
          taskStatus.value = 'cleaning';
          _startETATimer();
        } else {
          await _clearETAData();
        }
      }
    }
  }

  final currentImei = ''.obs;
  final currentTopic = ''.obs;
  final numberOfBoxes = 0.obs;

  void parseCleanerMessage(String topic, Uint8List payloadBytes) {
    try {
      developer.log('parseCleanerMessage called - START', name: 'MQTT');

      currentImei.value = ModbusDataParser.extractImei(topic);
      currentTopic.value = topic;
      developer.log('IMEI and topic set', name: 'MQTT');

      final allParameters = ModbusDataParser.parseParameters(payloadBytes);
      developer.log(
          'Parameters parsed, length: ${allParameters.length}', name: 'MQTT');

      developer.log(
        'Condition check: 561 < ${allParameters.length} = ${561 <
            allParameters.length}',
        name: 'MQTT',
      );

      if (561 < allParameters.length) {
        developer.log('About to set numberOfBoxes.value', name: 'MQTT');
        numberOfBoxes.value = allParameters[561];
        developer.log(
            'numberOfBoxes.value set to: ${numberOfBoxes.value}', name: 'MQTT');
        developer.log(
            'Parsed number of boxes: ${numberOfBoxes.value}', name: 'MQTT');
      } else {
        developer.log(
          'Condition failed - array length: ${allParameters.length}',
          name: 'MQTT',
          level: 900,
        );
      }

      developer.log('parseCleanerMessage completed - END', name: 'MQTT');
    } catch (e, stackTrace) {
      developer.log(
        'Exception caught: $e',
        name: 'MQTT',
        error: e,
        stackTrace: stackTrace,
        level: 1000,
      );
      errorMessage.value = 'Error parsing MQTT message: $e';
      Get.snackbar('Parse Error', errorMessage.value);
    }
  }

  bool get isCurrentTaskETAActive {
    return isETAActive.value &&
        _prefs?.getInt(_taskIdKey) == selectedTaskId.value;
  }

  void _startETATimer() {
    _etaTimer?.cancel();

    _etaTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedETA.value++;

      if (elapsedETA.value >= maintenanceETA.value * 60) {
        if (elapsedETA.value == maintenanceETA.value * 60) {
          Get.snackbar(
            'ETA Reached',
            'Estimated cleaning time completed. Task still in progress.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      }
    });
  }

  String get formattedElapsedTime {
    final hours = (elapsedETA.value / 3600).floor();
    final minutes = ((elapsedETA.value % 3600) / 60).floor();
    final seconds = elapsedETA.value % 60;

    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(
        2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void _onETACompleted() async {
    isETAActive.value = false;
    await _clearETAData();

    Get.snackbar(
      'ETA Completed',
      'Estimated cleaning time has finished. Please complete the task.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );
  }

  Future<void> _saveETAState() async {
    if (_prefs == null) return;

    await _prefs!.setInt(_etaStartTimeKey, DateTime
        .now()
        .millisecondsSinceEpoch);
    await _prefs!.setInt(_etaDurationKey, maintenanceETA.value);
    await _prefs!.setInt(_taskIdKey, selectedTaskId.value);
    await _prefs!.setBool(_etaActiveKey, true);
  }

  Future<void> _clearETAData() async {
    if (_prefs == null) return;

    await _prefs!.remove(_etaStartTimeKey);
    await _prefs!.remove(_etaDurationKey);
    await _prefs!.remove(_taskIdKey);
    await _prefs!.setBool(_etaActiveKey, false);

    isETAActive.value = false;
    remainingETA.value = 0;
  }

  String get formattedRemainingTime {
    if (remainingETA.value <= 0) return "00:00:00";

    final hours = (remainingETA.value / 3600).floor();
    final minutes = ((remainingETA.value % 3600) / 60).floor();
    final seconds = remainingETA.value % 60;

    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(
        2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  RxInt currentScheduleId = 0.obs;

  Future<void> fetchTodaysSchedules() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final inspectorId = await ApiService.getUid();

      if (inspectorId == null) {
        throw Exception('Inspector ID not found');
      }

      await Future.delayed(const Duration(seconds: 1));

      final response = await ApiService.get<List<dynamic>>(
        endpoint: getTodayScheduleCleaner(int.parse(inspectorId)),
        fromJson: (json) {
          if (json['success'] == true) {
            return List<dynamic>.from(json['data'] ?? []);
          } else {
            throw Exception('Failed to load schedules');
          }
        },
      );

      if (response.success && response.data != null) {
        todaysSchedules.value = List<Map<String, dynamic>>.from(response.data!);
        if (todaysSchedules.value!.isNotEmpty) {
          final selectedTask = todaysSchedules.value!.firstWhere(
                (schedule) => schedule['id'] == selectedTaskId.value,
            orElse: () => <String, dynamic>{},
          );
          if (selectedTask.isNotEmpty) {
            taskStatus.value = selectedTask['status'] ?? 'pending';
          }
        }
      } else {
        throw Exception(response.errorMessage ?? 'Failed to fetch schedules');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to fetch today\'s schedules: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTaskDetails(int scheduleId) async {
    try {
      isTaskDetailsLoading.value = true;
      selectedTaskId.value = scheduleId;

      final taskData = todaysSchedules.value?.firstWhere(
            (schedule) => schedule['id'] == scheduleId,
        orElse: () => <String, dynamic>{},
      );

      if (taskData != null && taskData.isNotEmpty) {
        taskDetails.value = taskData;
        taskStatus.value = taskData['status'] ?? 'pending';
        await fetchReportData(scheduleId);
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to fetch task details: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isTaskDetailsLoading.value = false;
    }
  }

  int? currentReportId;

  Future<void> fetchReportData(int scheduleId) async {
    try {
      String endpoint = getTodayReport(scheduleId);

      final response = await ApiService.get<Map<String, dynamic>>(
        endpoint: endpoint,
        fromJson: (json) {
          if (json['success'] == true) {
            return json['data'] as Map<String, dynamic>;
          } else {
            throw Exception('Failed to load report');
          }
        },
      );

      if (response.success && response.data != null) {
        reportData.value = response.data!;
        final scheduleStatus = todaysSchedules.value?.firstWhere(
              (schedule) => schedule['id'] == scheduleId,
          orElse: () => <String, dynamic>{},
        )['status'];

        if (scheduleStatus != null) {
          taskStatus.value = scheduleStatus;
        } else {
          taskStatus.value = reportData.value?['status'] ?? 'pending';
        }
        currentReportId = reportData.value?['id'];
      } else {
        throw Exception(response.errorMessage ?? 'Failed to fetch report data');
      }
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> updateTaskStatus(String newStatus) async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 1));

      if (todaysSchedules.value != null && selectedTaskId.value > 0) {
        final scheduleIndex = todaysSchedules.value!.indexWhere(
              (schedule) => schedule['id'] == selectedTaskId.value,
        );

        if (scheduleIndex != -1) {
          todaysSchedules.value![scheduleIndex]['status'] = newStatus;
          todaysSchedules.refresh();
        }
      }

      if (reportData.value != null) {
        final updatedReport = Map<String, dynamic>.from(reportData.value!);
        updatedReport['status'] = newStatus;
        reportData.value = updatedReport;
      }

      taskStatus.value = newStatus;

      Get.snackbar(
        'Success',
        'Task status updated to ${newStatus.toUpperCase()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to update task status: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showCompletionDialog(context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        elevation: 8,
        backgroundColor: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated Icon Header
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.task_alt_rounded,
                  size: 40.w,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 20.h),

              // Title
              Text(
                'Complete Cleaning Task',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10.h),

              // Subtitle
              Text(
                'How would you like to mark this task?',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 24.h),

              // Action Buttons
              Row(
                children: [
                  // Failed Button
                  Expanded(
                    child: _buildActionButton(
                      context: context,
                      label: 'Failed',
                      icon: Icons.cancel_rounded,
                      gradient: LinearGradient(
                        colors: [Colors.red.shade400, Colors.red.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shadowColor: Colors.red,
                      onPressed: () {
                        Navigator.of(context).pop();
                        _updateTaskStatusToFinal('failed');
                      },
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // Completed Button
                  Expanded(
                    child: _buildActionButton(
                      context: context,
                      label: 'Completed',
                      icon: Icons.check_circle_rounded,
                      gradient: LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shadowColor: Colors.green,
                      onPressed: () {
                        Navigator.of(context).pop();
                        _updateTaskStatusToFinal('done');
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Cancel Button
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.close_rounded,
                      size: 16.w,
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Gradient gradient,
    required Color shadowColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12.r),
          child: Ink(
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 28.w,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateMaintenanceModeOnCompletion(String finalStatus) async {
    developer.log(
        "_updateMaintenanceModeOnCompletion called with status: $finalStatus",
        name: 'Maintenance');

    try {
      int maintenanceValue = 0;
      developer.log(
          "Maintenance value to send for completion: $maintenanceValue",
          name: 'Maintenance');

      final requestBody = {
        "type": "control",
        "id": 1,
        "key": 1,
        "value": maintenanceValue,
      };

      if (uuid == null || uuid!.isEmpty) {
        developer.log(
            "UUID is null or empty. Skipping maintenance mode update.",
            name: 'Maintenance');
        return;
      }

      final endpoint = mqttCleanerPost(uuid!);
      developer.log(
          "API endpoint for completion: $endpoint", name: 'Maintenance');

      final response = await ApiService.post<Map<String, dynamic>>(
        endpoint: endpoint,
        body: requestBody,
        fromJson: (json) => json as Map<String, dynamic>,
        includeToken: true,
      );

      if (response.success) {
        developer.log(
            "Success - Maintenance mode disabled after task completion",
            name: 'Maintenance');
      } else {
        developer.log(
            "Failed to disable maintenance mode: ${response.errorMessage}",
            name: 'Maintenance');
      }
    } catch (e) {
      developer.log("Exception in _updateMaintenanceModeOnCompletion: $e",
          name: 'Maintenance');
    }
  }

  Future<void> _updateTaskStatusToFinal(String finalStatus) async {
    try {
      isMaintenanceModeLoading.value = true;

      if (currentReportId == null) {
        throw Exception('Report ID not found');
      }

      final response = await ApiService.put<Map<String, dynamic>>(
        endpoint: putTodayReport(currentReportId!),
        body: {
          'status': finalStatus,
        },
        fromJson: (json) {
          if (json['success'] == true) {
            return json['data'] as Map<String, dynamic>;
          } else {
            throw Exception(json['message'] ?? 'Failed to update status');
          }
        },
      );

      if (response.success) {
        await _updateMaintenanceModeOnCompletion(finalStatus);

        _etaTimer?.cancel();
        await _clearETAData();

        isMaintenanceModeEnabled.value = false;

        if (todaysSchedules.value != null && selectedTaskId.value > 0) {
          final scheduleIndex = todaysSchedules.value!.indexWhere(
                (schedule) => schedule['id'] == selectedTaskId.value,
          );

          if (scheduleIndex != -1) {
            todaysSchedules.value![scheduleIndex]['status'] = finalStatus;
            todaysSchedules.refresh();
          }
        }

        await fetchReportData(selectedTaskId.value);

        String title = finalStatus == 'done'
            ? 'Cleaning Completed'
            : 'Cleaning Failed';
        String message = finalStatus == 'done'
            ? 'Task has been completed successfully'
            : 'Task has been marked as failed';
        Color backgroundColor = finalStatus == 'done' ? Colors.green : Colors
            .red;

        Get.snackbar(
          title,
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: backgroundColor,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        throw Exception(response.errorMessage ?? 'Failed to update status');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to update task status: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isMaintenanceModeLoading.value = false;
    }
  }

  void toggleMaintenanceMode(context) async {
    developer.log("toggleMaintenanceMode triggered", name: 'Maintenance');

    try {
      isMaintenanceModeEnabled.value = !isMaintenanceModeEnabled.value;

      await Future.wait([
        updateCleaningStatus(context),
        saveMaintenanceModeParameters(),
      ]);
    } catch (e) {
      isMaintenanceModeEnabled.value = !isMaintenanceModeEnabled.value;
      developer.log("toggleMaintenanceMode failed: $e", name: 'Maintenance');
    }
  }

  Future<void> updateCleaningStatus(context) async {
    try {
      if (currentReportId == null) {
        throw Exception('Report ID not found');
      }

      if (taskStatus.value == 'pending') {
        isMaintenanceModeLoading.value = true;

        final response = await ApiService.put<Map<String, dynamic>>(
          endpoint: putTodayReport(currentReportId!),
          body: {
            'status': 'cleaning',
          },
          fromJson: (json) {
            if (json['success'] == true) {
              return json['data'] as Map<String, dynamic>;
            } else {
              throw Exception(json['message'] ?? 'Failed to update status');
            }
          },
        );

        if (response.success) {
          taskStatus.value = 'cleaning';
          isMaintenanceModeEnabled.value = true;
          isETAActive.value = true;
          elapsedETA.value = 0;

          _startETATimer();
          await saveMaintenanceModeParameters();
          await _saveETAState();

          if (todaysSchedules.value != null && selectedTaskId.value > 0) {
            final scheduleIndex = todaysSchedules.value!.indexWhere(
                  (schedule) => schedule['id'] == selectedTaskId.value,
            );

            if (scheduleIndex != -1) {
              todaysSchedules.value![scheduleIndex]['status'] = 'cleaning';
              todaysSchedules.refresh();
            }
          }

          await fetchReportData(selectedTaskId.value);

          Get.snackbar(
            'Cleaning Started',
            'Task is now in progress.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        } else {
          throw Exception(response.errorMessage ?? 'Failed to update status');
        }
      } else if (taskStatus.value == 'cleaning') {
        _showCompletionDialog(context);
        return;
      } else {
        return;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to update maintenance status: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isMaintenanceModeLoading.value = false;
    }
  }

  Future<void> saveMaintenanceModeParameters({bool? forceValue}) async {
    developer.log("saveMaintenanceModeParameters called", name: 'Maintenance');
    developer.log("Current UUID: $uuid", name: 'Maintenance');
    developer.log(
        "Current maintenance mode status: ${isMaintenanceModeEnabled.value}",
        name: 'Maintenance');
    developer.log("Force value parameter: $forceValue", name: 'Maintenance');

    try {
      isMaintenanceModeLoading.value = true;
      errorMessage.value = '';

      int maintenanceValue;
      if (forceValue != null) {
        maintenanceValue = forceValue ? 1 : 0;
        developer.log("Using forced maintenance value: $maintenanceValue",
            name: 'Maintenance');
      } else {
        maintenanceValue = isMaintenanceModeEnabled.value ? 1 : 0;
        developer.log("Using current maintenance value: $maintenanceValue",
            name: 'Maintenance');
      }

      final requestBody = {
        "type": "control",
        "id": 1,
        "key": 1,
        "value": maintenanceValue,
      };
      developer.log("Request body: $requestBody", name: 'Maintenance');

      if (uuid == null || uuid!.isEmpty) {
        throw Exception("UUID is null or empty. Cannot make API call.");
      }

      final endpoint = mqttCleanerPost(uuid!);
      developer.log("API endpoint: $endpoint", name: 'Maintenance');

      developer.log("Making API call...", name: 'Maintenance');
      final response = await ApiService.post<Map<String, dynamic>>(
        endpoint: endpoint,
        body: requestBody,
        fromJson: (json) => json as Map<String, dynamic>,
        includeToken: true,
      );

      developer.log("API response received:", name: 'Maintenance');
      developer.log("Success: ${response.success}", name: 'Maintenance');
      developer.log("Status Code: ${response.statusCode}", name: 'Maintenance');
      developer.log("Data: ${response.data}", name: 'Maintenance');
      developer.log(
          "Error Message: ${response.errorMessage}", name: 'Maintenance');

      if (response.success) {
        developer.log(
            "Success - Maintenance mode ${maintenanceValue == 1
                ? 'enabled'
                : 'disabled'} successfully",
            name: 'Maintenance'
        );

        if (forceValue == null) {
          Get.snackbar(
            'Success',
            'Maintenance mode ${maintenanceValue == 1
                ? 'enabled'
                : 'disabled'} successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
        }
      } else {
        String errorMsg = response.errorMessage ??
            'Failed to update maintenance mode';

        if (response.statusCode == 401) {
          errorMsg = 'Authentication failed. Please login again.';
        } else if (response.statusCode == 400) {
          errorMsg =
          'Invalid maintenance mode request: ${response.errorMessage}';
        } else if (response.statusCode == 404) {
          errorMsg = 'Device not found. Please check the UUID.';
        }

        developer.log("API Error: $errorMsg", name: 'Maintenance');
        throw Exception(errorMsg);
      }
    } catch (e) {
      String errorMsg = e.toString();
      developer.log("Exception caught: $errorMsg", name: 'Maintenance');

      if (errorMsg.startsWith('Exception: ')) {
        errorMsg = errorMsg.substring(11);
      }

      errorMessage.value = errorMsg;

      if (forceValue == null) {
        isMaintenanceModeEnabled.value = !isMaintenanceModeEnabled.value;

        Get.snackbar(
          'Maintenance Mode Error',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }

      rethrow;
    } finally {
      isMaintenanceModeLoading.value = false;
      developer.log(
          "saveMaintenanceModeParameters completed, isMaintenanceModeLoading set to false",
          name: 'Maintenance'
      );
    }
  }

  Future<void> navigateToTaskDetails(Map<String, dynamic> taskData) async {
    // Only stop the timer if switching tasks, but DON'T clear todaysSchedules data
    if (selectedTaskId.value != taskData['id'] && isETAActive.value) {
      _etaTimer?.cancel();
      isETAActive.value = false;
      remainingETA.value = 0;
    }

    final uuid = taskData['plant_uuid']?.toString();

    if (uuid != null) {
      developer.log('Initializing MQTT for plant UUID: $uuid', name: 'Navigation');
      setUuid(uuid);
      await AppInitializer.reinitializeWithUUID(uuid);
      developer.log('MQTT successfully initialized for UUID: $uuid', name: 'Navigation');
    } else {
      developer.log('No UUID found for selected plant', name: 'Navigation');
    }

    taskDetails.value = taskData;
    selectedTaskId.value = taskData['id'];
    taskStatus.value = taskData['status'] ?? 'pending';

    _restoreETAState();
    fetchReportData(taskData['id']);

    Get.toNamed(AppRoutes.clenupDetailsPage, arguments: taskData);
  }

  Future<void> refreshData() async {
    await fetchTodaysSchedules();
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'cleaning':
        return Colors.blue;
      case 'done':
        return Colors.green;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color getStatusCardColor(String cardType) {
    final currentStatus = taskStatus.value;

    switch (cardType.toLowerCase()) {
      case 'pending':
        return currentStatus == 'pending'
            ? Colors.orange.shade400
            : Colors.red.shade400;
      case 'cleaning':
        return currentStatus == 'cleaning'
            ? Colors.blue.shade400
            : Colors.grey.shade400;
      case 'completed':
        return currentStatus == 'done'
            ? Colors.green.shade400
            : Colors.green.shade300;
      default:
        return Colors.grey.shade400;
    }
  }

  Map<String, int> getPanelCounts() {
    final total = totalPanels;
    int completed = 0;

    if (taskStatus.value == 'done') {
      completed = total;
    } else if (taskStatus.value == 'cleaning') {
      completed = (total * 0.5).round();
    }

    final pending = total - completed;

    return {
      'total': total,
      'completed': completed,
      'pending': pending,
    };
  }

  bool get isTaskDataValid {
    return taskDetails.value != null &&
        taskDetails.value!.containsKey('id') &&
        taskDetails.value!.containsKey('plant_location');
  }

  bool get shouldShowMaintenanceButton {
    return taskStatus.value == 'pending' || taskStatus.value == 'cleaning';
  }

  String get maintenanceButtonText {
    switch (taskStatus.value) {
      case 'pending':
        return 'Start Cleaning';
      case 'cleaning':
        if (isETAActive.value) {
          return 'Complete Cleaning (${formattedElapsedTime})';
        }
        return 'Complete Cleaning';
      default:
        return 'Task Completed';
    }
  }

  Color get maintenanceButtonColor {
    switch (taskStatus.value) {
      case 'pending':
        return Colors.blue.shade500;
      case 'cleaning':
        return Colors.green.shade500;
      default:
        return Colors.grey.shade400;
    }
  }

  String formatTime(String timeString) {
    try {
      final parts = timeString.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

      return '${displayHour.toString().padLeft(2, '0')}:${minute.toString()
          .padLeft(2, '0')} $period';
    } catch (e) {
      return timeString;
    }
  }
}