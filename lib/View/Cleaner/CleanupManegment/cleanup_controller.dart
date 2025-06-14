

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../Route Manager/app_routes.dart';

class CleaningManagementController extends GetxController {
  // Reactive variables for API data
  final todaysSchedules = Rxn<List<Map<String, dynamic>>>();
  final taskDetails = Rxn<Map<String, dynamic>>();
  final reportData = Rxn<Map<String, dynamic>>();

  // UI State management
  final isLoading = false.obs;
  final isTaskDetailsLoading = false.obs;
  final isMaintenanceModeLoading = false.obs;
  final errorMessage = ''.obs;
  final selectedTaskId = 0.obs;

  // Task status management
  final taskStatus = 'pending'.obs;
  final maintenanceETA = 2.obs; // Default 2 hours
  final isMaintenanceModeEnabled = false.obs;

  // Computed properties
  List<Map<String, dynamic>> get pendingCleanups {
    if (todaysSchedules.value == null) return [];
    return todaysSchedules.value!.where((schedule) =>
    reportData.value?['status'] == 'pending' ||
        reportData.value == null
    ).toList();
  }

  List<Map<String, dynamic>> get ongoingCleanups {
    if (todaysSchedules.value == null) return [];
    return todaysSchedules.value!.where((schedule) =>
    reportData.value?['status'] == 'ongoing'
    ).toList();
  }

  List<Map<String, dynamic>> get completedCleanups {
    if (todaysSchedules.value == null) return [];
    return todaysSchedules.value!.where((schedule) =>
    reportData.value?['status'] == 'done'
    ).toList();
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

  Future<void> fetchTodaysSchedules() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await Future.delayed(const Duration(seconds: 1));

      final response = {
        "message": "Today's cleaner schedules retrieved successfully",
        "success": true,
        "data": [
          {
            "id": 2,
            "cleaner_id": 3,
            "inspector_id": 8,
            "plant_id": 25,
            "week": "2",
            "day": "sa",
            "schedule_date": null,
            "cleaning_start_time": "08:00:00",
            "inspection_time": "10:00:00",
            "assignedBy": null,
            "duration": 120,
            "notes": "",
            "isActive": 1,
            "cleaner_name": "Alice Smith",
            "inspector_name": "John Doe",
            "plant_user_id": 3,
            "plant_dist_id": 28,
            "plant_taluka_id": 13,
            "plant_area_id": 4,
            "plant_total_panels": 32,
            "plant_capacity_w": 5.5,
            "plant_location": "Building A, Floor 1",
            "plant_latlng": null,
            "plant_isActive": 0,
            "plant_isDeleted": 0,
            "plant_under_maintenance": 0,
            "plant_info": "",
            "distributor_name": null,
            "taluka_name": "Pune City",
            "area_name": "Baner"
          }
        ],
        "errors": []
      };

      if (response['success'] == true) {
        todaysSchedules.value = List<Map<String, dynamic>>.from(response['data'] as Iterable<dynamic>);
        if (todaysSchedules.value!.isNotEmpty) {
          await fetchReportData(todaysSchedules.value!.first['id']);
        }
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch schedules');
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

  Future<void> fetchReportData(int scheduleId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final response = {
        "message": "Report fetched successfully",
        "success": true,
        "data": {
          "id": 32,
          "schedule_id": scheduleId,
          "plant_id": 25,
          "date": "2023-10-13T18:30:00.000Z",
          "time": "05:08:45",
          "cleaning_date": "2023-10-13T18:30:00.000Z",
          "cleaning_time": "05:08:45",
          "status": "pending",
          "inspected_by": 8,
          "inspector_schedule": null,
          "createdAt": "2023-10-14T05:08:45.000Z",
          "updatedAt": "2023-10-14T05:08:45.000Z",
          "inspector_review": null,
          "client_review": null,
          "ratings": null
        },
        "errors": []
      };

      if (response['success'] == true) {
        reportData.value = response['data'] as Map<String, dynamic>;
        taskStatus.value = reportData.value?['status'] ?? 'pending';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> updateTaskStatus(String newStatus) async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 1));

      if (reportData.value != null) {
        final updatedReport = Map<String, dynamic>.from(reportData.value!);
        updatedReport['status'] = newStatus;
        reportData.value = updatedReport;
        taskStatus.value = newStatus;
      }

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

  Future<void> enableMaintenanceMode() async {
    try {
      isMaintenanceModeLoading.value = true;

      if (taskStatus.value == 'pending') {
        await updateTaskStatus('ongoing');
        isMaintenanceModeEnabled.value = true;

        Get.snackbar(
          'Maintenance Started',
          'Task is now in progress. ETA: ${maintenanceETA.value} hours',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else if (taskStatus.value == 'ongoing') {
        await updateTaskStatus('done');
        isMaintenanceModeEnabled.value = false;

        Get.snackbar(
          'Maintenance Completed',
          'Task has been completed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
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
      case 'ongoing':
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
      case 'ongoing':
        return currentStatus == 'ongoing' ? Colors.blue.shade400 : Colors.grey.shade400;
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
    } else if (taskStatus.value == 'ongoing') {
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
    return taskStatus.value == 'pending' || taskStatus.value == 'ongoing';
  }

  String get maintenanceButtonText {
    switch (taskStatus.value) {
      case 'pending':
        return 'Start Cleaning';
      case 'ongoing':
        return 'Complete Cleaning (ETA: ${maintenanceETA.value}h)';
      default:
        return 'Task Completed';
    }
  }

  Color get maintenanceButtonColor {
    switch (taskStatus.value) {
      case 'pending':
        return Colors.blue.shade500;
      case 'ongoing':
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
