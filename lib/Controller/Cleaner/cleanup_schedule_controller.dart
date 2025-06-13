import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../API Service/api_service.dart';
import '../../Route Manager/app_routes.dart';
import '../../utils/constants.dart';

class CleanupScheduleController extends GetxController {
  // Reactive variables
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final searchQuery = ''.obs;
  final selectedTab = 0.obs; // 0 for pending, 1 for completed

  // Data storage using Map<String, dynamic>
  final allSchedules = <Map<String, dynamic>>[].obs;
  final pendingSchedules = <Map<String, dynamic>>[].obs;
  final completedSchedules = <Map<String, dynamic>>[].obs;

  // Selected area and task details
  final filteredSchedules = <Map<String, dynamic>>[].obs;
  final selectedTaskData = Rxn<Map<String, dynamic>>();

  // Task status tracking (separate from API data)
  final taskStatuses = <int, String>{}.obs; // task_id -> status (pending/ongoing/completed)
  final taskETAs = <int, int>{}.obs; // task_id -> remaining minutes from duration

  // Search controller
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadSchedules();
    _initializeTaskTimer();
  }

  @override
  void onReady() {
    super.onReady();
    ever(selectedTab, (_) => _filterSchedulesByTab());
    ever(searchQuery, (_) => _performSearchFilter());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Initialize timer for ETA countdown
  void _initializeTaskTimer() {
    Stream.periodic(const Duration(minutes: 1)).listen((_) {
      _updateTaskETAs();
    });
  }

  // Load schedules from API
  Future<void> loadSchedules() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Retrieve inspectorId from SharedPreferences
      final inspectorId = await ApiService.getUid();

      if (inspectorId == null) {
        throw Exception('Inspector ID not found');
      }

      // Make GET request using ApiService
      final response = await ApiService.get<List<dynamic>>(
        // endpoint: '/schedules/cleaner-schedules/today/$inspectorId',
        endpoint: getTodayScheduleCleaner(int.parse(inspectorId)),
        fromJson: (json) {
          if (json['success'] == true) {
            return List<dynamic>.from(json['data'] ?? []);
          } else {
            throw Exception('Failed to load schedules');
          }
        },
      );

      if (response.success) {
        // Ensure response.data is not null, provide an empty list if it is
        final List<dynamic> responseData = response.data ?? [];

        // Convert each item to a Map<String, dynamic>
        allSchedules.value = responseData.map((item) => item as Map<String, dynamic>).toList();

        _initializeTaskStatuses();
        _categorizeSchedules();
      } else {
        throw Exception(response.errorMessage ?? 'Failed to load schedules');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load schedules: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Initialize task statuses (separate tracking)
  void _initializeTaskStatuses() {
    for (var schedule in allSchedules) {
      final id = schedule['id'] as int;
      final duration = schedule['duration'] as int; // 120 minutes from JSON

      // Initialize with default status (you can modify this logic)
      taskStatuses[id] = 'pending'; // Default status
    }
  }

  // Categorize schedules based on status
  void _categorizeSchedules() {
    pendingSchedules.clear();
    completedSchedules.clear();

    for (var schedule in allSchedules) {
      final id = schedule['id'] as int;
      final status = taskStatuses[id] ?? 'pending';

      if (status == 'completed') {
        completedSchedules.add(schedule);
      } else {
        // Both pending and ongoing appear in pending tab
        pendingSchedules.add(schedule);
      }
    }

    _filterSchedulesByTab();
  }

  // Update ETA for ongoing tasks
  void _updateTaskETAs() {
    final updatedETAs = <int, int>{};

    taskETAs.forEach((taskId, currentETA) {
      if (currentETA > 0) {
        updatedETAs[taskId] = currentETA - 1;
      } else {
        // Task completed, update status
        taskStatuses[taskId] = 'completed';
        _moveTaskToCompleted(taskId);
      }
    });

    taskETAs.value = updatedETAs;
  }

  // Move completed task from pending to completed
  void _moveTaskToCompleted(int taskId) {
    final taskIndex =
        pendingSchedules.indexWhere((task) => task['id'] == taskId);
    if (taskIndex != -1) {
      final task = pendingSchedules[taskIndex];
      pendingSchedules.removeAt(taskIndex);
      completedSchedules.add(task);
      _filterSchedulesByTab();
    }
  }

  // Filter schedules by selected tab
  void _filterSchedulesByTab() {
    if (selectedTab.value == 0) {
      // Pending tab - show pending and ongoing
      filteredSchedules.value = pendingSchedules.where((schedule) {
        return _matchesSearchQuery(schedule);
      }).toList();
    } else {
      // Completed tab
      filteredSchedules.value = completedSchedules.where((schedule) {
        return _matchesSearchQuery(schedule);
      }).toList();
    }
  }

  // Perform search filtering
  void _performSearchFilter() {
    _filterSchedulesByTab();
  }

  // Check if schedule matches search query
  bool _matchesSearchQuery(Map<String, dynamic> schedule) {
    if (searchQuery.value.isEmpty) return true;

    final query = searchQuery.value.toLowerCase();
    return schedule['area_name']?.toString().toLowerCase().contains(query) ==
            true ||
        schedule['plant_location']?.toString().toLowerCase().contains(query) ==
            true ||
        schedule['cleaner_name']?.toString().toLowerCase().contains(query) ==
            true;
  }

  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Switch between tabs
  void switchTab(int index) {
    selectedTab.value = index;
  }

  // Get task status
  String getTaskStatus(int taskId) {
    return taskStatuses[taskId] ?? 'pending';
  }

  // Get task ETA
  int? getTaskETA(int taskId) {
    return taskETAs[taskId];
  }

  // Select task for details view
  void selectTask(Map<String, dynamic> taskData) {
    selectedTaskData.value = taskData;
    Get.toNamed(AppRoutes.cleanerNew);
  }

  // Start task (change status to ongoing)
  void startTask(int taskId) {
    final schedule = allSchedules.firstWhere((s) => s['id'] == taskId);
    final duration = schedule['duration'] as int; // Use duration from JSON

    taskStatuses[taskId] = 'ongoing';
    taskETAs[taskId] = duration; // Set ETA to full duration

    _categorizeSchedules();

    Get.snackbar(
      'Task Started',
      'Cleaning task has been started',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    );
  }

  // Complete task
  void completeTask(int taskId) {
    taskStatuses[taskId] = 'completed';
    taskETAs.remove(taskId);

    _categorizeSchedules();

    Get.snackbar(
      'Task Completed',
      'Cleaning task has been completed successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    );
  }

  // Refresh schedules
  Future<void> refreshSchedules() async {
    await loadSchedules();
  }

  // Get area schedules grouped by area
  Map<String, List<Map<String, dynamic>>> getSchedulesByArea() {
    final Map<String, List<Map<String, dynamic>>> groupedSchedules = {};

    for (var schedule in filteredSchedules) {
      final areaName = schedule['area_name']?.toString() ?? 'Unknown Area';

      if (!groupedSchedules.containsKey(areaName)) {
        groupedSchedules[areaName] = [];
      }

      groupedSchedules[areaName]!.add(schedule);
    }

    return groupedSchedules;
  }

  // Get pending count for today
  int get pendingCount => pendingSchedules.length;

  // Get completed count for today
  int get completedCount => completedSchedules.length;

  // Format ETA display
  String formatETA(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return remainingMinutes > 0
          ? '${hours}h ${remainingMinutes}m'
          : '${hours}h';
    }
  }
}
