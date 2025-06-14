import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../API Service/api_service.dart';
import '../../../Route Manager/app_routes.dart';
import '../../../utils/constants.dart';

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
  final maintenanceETA = 120.obs; // Default 120 minutes
  final isMaintenanceModeEnabled = false.obs;

  // 1. FILTER METHODS - These should return correct counts based on API response
  List<Map<String, dynamic>> get pendingCleanups {
    if (todaysSchedules.value == null) return [];
    print('All schedules: ${todaysSchedules.value?.map((s) => {'id': s['id'], 'status': s['status']}).toList()}');

    final pending = todaysSchedules.value!.where((schedule) =>
    schedule['status'] == 'pending'
    ).toList();

    print('Pending cleanups: ${pending.length} items');
    return pending;
  }

  List<Map<String, dynamic>> get ongoingCleanups {
    if (todaysSchedules.value == null) return [];

    final ongoing = todaysSchedules.value!.where((schedule) =>
    schedule['status'] == 'cleaning'
    ).toList();

    print('Ongoing cleanups: ${ongoing.length} items');
    return ongoing;
  }

  List<Map<String, dynamic>> get completedCleanups {
    if (todaysSchedules.value == null) return [];

    final completed = todaysSchedules.value!.where((schedule) =>
    schedule['status'] == 'done'
    ).toList();

    print('Completed cleanups: ${completed.length} items');
    return completed;
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

  @override
  void onInit() {
    super.onInit();
    fetchTodaysSchedules();
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
          // Update taskStatus based on selected task if any

            final selectedTask = todaysSchedules.value!.firstWhere((schedule) => schedule['id'] == selectedTaskId.value,
              orElse: () => <String, dynamic>{},
            );
            if (selectedTask.isNotEmpty) {
              taskStatus.value = selectedTask['status'] ?? 'pending';
            }

            final status = todaysSchedules.value?.first['status'] ?? 'pending';
            print('Fetched schedules with status: $status');


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
        // Update task status from the schedule data
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
        // Keep the status from todaysSchedules as primary source
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

      // Update the status in todaysSchedules
      if (todaysSchedules.value != null && selectedTaskId.value > 0) {
        final scheduleIndex = todaysSchedules.value!.indexWhere(
              (schedule) => schedule['id'] == selectedTaskId.value,
        );

        if (scheduleIndex != -1) {
          todaysSchedules.value![scheduleIndex]['status'] = newStatus;
          todaysSchedules.refresh(); // Trigger reactive update
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

  void _showCompletionDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Complete Cleaning Task',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        content: Text(
          'How would you like to mark this cleaning task?',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _updateTaskStatusToFinal('failed');
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Failed',
              style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _updateTaskStatusToFinal('done');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Completed',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
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
        // Update the status in todaysSchedules
        if (todaysSchedules.value != null && selectedTaskId.value > 0) {
          final scheduleIndex = todaysSchedules.value!.indexWhere(
                (schedule) => schedule['id'] == selectedTaskId.value,
          );

          if (scheduleIndex != -1) {
            todaysSchedules.value![scheduleIndex]['status'] = finalStatus;
            todaysSchedules.refresh(); // Trigger reactive update
          }
        }

        await fetchReportData(selectedTaskId.value);

        String title = finalStatus == 'done' ? 'Cleaning Completed' : 'Cleaning Failed';
        String message = finalStatus == 'done'
            ? 'Task has been completed successfully'
            : 'Task has been marked as failed';
        Color backgroundColor = finalStatus == 'done' ? Colors.green : Colors.red;

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

  Future<void> enableMaintenanceMode() async {
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
          isMaintenanceModeEnabled.value = true;

          // Update the status in todaysSchedules
          if (todaysSchedules.value != null && selectedTaskId.value > 0) {
            final scheduleIndex = todaysSchedules.value!.indexWhere(
                  (schedule) => schedule['id'] == selectedTaskId.value,
            );

            if (scheduleIndex != -1) {
              todaysSchedules.value![scheduleIndex]['status'] = 'cleaning';
              todaysSchedules.refresh(); // Trigger reactive update
            }
          }

          await fetchReportData(selectedTaskId.value);

          Get.snackbar(
            'Cleaning Started',
            'Task is now in progress. ETA: ${maintenanceETA.value} minutes',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        } else {
          throw Exception(response.errorMessage ?? 'Failed to update status');
        }
      } else if (taskStatus.value == 'cleaning') {
        _showCompletionDialog();
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

  void navigateToTaskDetails(Map<String, dynamic> taskData) {
    taskDetails.value = taskData;
    selectedTaskId.value = taskData['id'];
    taskStatus.value = taskData['status'] ?? 'pending'; // Set status from schedule data
    fetchReportData(taskData['id']);
    Get.toNamed(AppRoutes.clenupDetailsPage);
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
        return currentStatus == 'pending' ? Colors.orange.shade400 : Colors.red.shade400;
      case 'cleaning':
        return currentStatus == 'cleaning' ? Colors.blue.shade400 : Colors.grey.shade400;
      case 'completed':
        return currentStatus == 'done' ? Colors.green.shade400 : Colors.green.shade300;
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
        return 'Complete Cleaning (ETA: ${maintenanceETA.value}m)';
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

      return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return timeString;
    }
  }
}


