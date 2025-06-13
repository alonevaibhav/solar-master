import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:solar_app/Route%20Manager/app_routes.dart';
import 'dart:async';
import '../../Model/Cleaner/inspection_model.dart';

class TodayInspectionsController extends GetxController {
  // Reactive list of inspections
  final RxList<InspectionModel> pendingInspections = <InspectionModel>[].obs;
  final RxList<InspectionModel> completedInspections = <InspectionModel>[].obs;

  // Search functionality
  final RxString searchQuery = ''.obs;

  // Segment control
  final RxInt selectedSegment = 0.obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Task detail related variables
  final RxString currentTaskId = ''.obs;
  final RxBool isTaskDetailView = false.obs;
  final RxString taskStatus = 'pending'.obs;
  final RxInt remainingMinutes = 100.obs;

  // Timer for ongoing tasks
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Fetch initial inspections when controller is initialized
    fetchInspections();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // Fetch inspections (mock implementation)
  Future<void> fetchInspections() async {
    try {
      isLoading.value = true;

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      pendingInspections.value = [
        InspectionModel(
            id: 'task1',
            plantName: 'pune Plant',
            location: 'abc-1 Pune Maharashtra(411052)',
            isCompleted: false,
            ownerPhone: '+91 8003375461',
            autoCleanTime: 'hh:mm',
            completedPoints: 20,
            pendingPoints: 7,
            totalPoints: 32,
            valves: [
              'Panel Valve - 1',
              'Panel Valve - 2',
              'Panel Valve - 3',
              'Panel Valve - 4',
              'Panel Valve - 5'
            ])
      ];

      completedInspections.value = [
        InspectionModel(
            id: 'task2',
            plantName: 'mumbai Plant',
            location: 'XYZ-1 Pune Maharashtra(411052)',
            isCompleted: true,
            ownerPhone: '+91 8003375461',
            autoCleanTime: 'hh:mm',
            completedPoints: 20,
            pendingPoints: 7,
            totalPoints: 32,
            valves: [
              'Panel Valve - 1',
              'Panel Valve - 2',
              'Panel Valve - 3',
              'Panel Valve - 4'
            ])
      ];
    } catch (e) {
      // Handle error
      Get.snackbar('Error', 'Failed to load inspections');
    } finally {
      isLoading.value = false;
    }
  }

  // Filter inspections based on search query
  List<InspectionModel> getFilteredPendingInspections() {
    return pendingInspections
        .where((inspection) =>
            inspection.plantName
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ||
            inspection.location
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  List<InspectionModel> getFilteredCompletedInspections() {
    return completedInspections
        .where((inspection) =>
            inspection.plantName
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ||
            inspection.location
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Task detail methods

  // Open task detail view
  void openTaskDetail(String taskId, bool isCompleted) {
    isTaskDetailView.value = true;
    currentTaskId.value = taskId;

    if (isCompleted) {
      taskStatus.value = 'completed';
    } else {
      taskStatus.value = 'pending';
    }

    // Navigate to task detail view
    Get.toNamed(AppRoutes.cleanerTaskDetailView,
        arguments: {
      'taskId': taskId,
      'status': isCompleted ? 'completed' : 'pending'
    });
  }

  // Get current inspection
  InspectionModel? getCurrentInspection() {
    if (currentTaskId.isEmpty) return null;

    // Check in pending inspections
    final pendingResult = pendingInspections
        .firstWhereOrNull((inspection) => inspection.id == currentTaskId.value);

    if (pendingResult != null) return pendingResult;

    // Check in completed inspections
    return completedInspections.firstWhereOrNull((inspection) => inspection.id == currentTaskId.value);
  }

  // Task actions
  void startCleaning() {
    taskStatus.value = 'inProgress';
    _startTimer();
    Get.snackbar('Info', 'Cleaning process started');
  }

  void completeTask() {
    _timer?.cancel();
    taskStatus.value = 'completed';

    // Update the inspection in the lists
    final inspection = getCurrentInspection();
    if (inspection != null) {
      // Remove from pending list
      pendingInspections.removeWhere((item) => item.id == inspection.id);

      // Add to completed list with updated status
      final updatedInspection = inspection.copyWith(isCompleted: true);
      completedInspections.add(updatedInspection);
    }

    Get.snackbar('Success', 'Task completed successfully');
  }

  void enableMaintenanceMode() {
    if (taskStatus.value == 'pending') {
      startCleaning();
    } else {
      Get.snackbar('Info', 'Maintenance mode already enabled');
    }
  }

  void toggleValve(String valveName, bool state) {
    final message = '$valveName ${state ? 'activated' : 'deactivated'}';

    // Toast message
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void callOwner() {
    final inspection = getCurrentInspection();
    if (inspection != null) {
      // TODO: Implement actual call functionality
      Get.snackbar('Info', 'Calling owner at ${inspection.ownerPhone}');
    }
  }

  void openLocation() {
    final inspection = getCurrentInspection();
    if (inspection != null) {
      // TODO: Implement actual location opening logic
      Get.snackbar('Info', 'Opening location: ${inspection.location}');
    }
  }

  void refreshTaskDetails() {
    // Refresh current task details
    fetchInspections();
  }

  // Start a timer for ongoing tasks
  void _startTimer() {
    _timer?.cancel();
    remainingMinutes.value = 55; // Reset timer

    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (remainingMinutes.value > 0) {
        remainingMinutes.value--;
      } else {
        timer.cancel();
        completeTask();
      }
    });
  }
}
