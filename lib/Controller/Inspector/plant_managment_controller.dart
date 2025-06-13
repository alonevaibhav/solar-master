import 'package:get/get.dart';

import '../../Route Manager/app_routes.dart';

class PlantManagementController extends GetxController {
  // Observable lists and variables
  final plants = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final selectedPlant = Rx<Map<String, dynamic>?>(null);

  // For alert handling
  final alertLevel = 'High'.obs;

  // For schedule dialogs
  final selectedDay = 'Monday'.obs;
  final hour = 8.obs;
  final minute = 0.obs;
  final amPm = 'AM'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlants();
  }

  // Fetch all assigned plants
  Future<void> fetchPlants() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Mock API call
      await Future.delayed(Duration(seconds: 1));

      // Simulate receiving plants data
      plants.value = [
        {
          'id': '2',
          'name': 'XYZ Plant Name',
          'location': 'XYZ-1 Pune Maharashtra(411052)',
          'autoCleanTime': 'hh:mm',
          'isOnline': true,
        },
        {
          'id': '3',
          'name': 'ZBC Plant Name',
          'location': 'XYZ-1 Pune Maharashtra(411052)',
          'autoCleanTime': 'hh:mm',
          'isOnline': true,
        },
      ];
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to fetch plants');
    } finally {
      isLoading.value = false;
    }
  }

  // View plant details
  void viewPlantDetails(String plantId) {
    final plant = plants.firstWhere((plant) => plant['id'] == plantId);
    selectedPlant.value = plant;
    Get.toNamed(AppRoutes.inspectorPlantDetails, arguments: plant);
  }

  // Add a new cleaning schedule
  Future<void> addCleaningSchedule(
      String plantId, String day, String time, String amPm) async {
    try {
      isLoading.value = true;

      // Validate inputs
      if (day.isEmpty || time.isEmpty) {
        throw Exception('Day and time are required');
      }

      // Mock API call
      await Future.delayed(Duration(seconds: 1));

      // Add schedule to plant
      final index = plants.indexWhere((plant) => plant['id'] == plantId);
      if (index == -1) throw Exception('Plant not found');

      final plant = Map<String, dynamic>.from(plants[index]);

      final newSchedule = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'day': day,
        'time': time,
        'amPm': amPm,
        'isActive': true,
        'isMarkedForDeletion': false,
      };

      // Update the plant with the new schedule
      final List<Map<String, dynamic>> schedules =
          List<Map<String, dynamic>>.from(plant['schedules'] ?? []);
      schedules.add(newSchedule);
      plant['schedules'] = schedules;

      plants[index] = plant;

      if (selectedPlant.value?['id'] == plantId) {
        selectedPlant.value = plant;
      }

      Get.snackbar('Success', 'Cleaning schedule added successfully');
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to add cleaning schedule');
    } finally {
      isLoading.value = false;
    }
  }

  // Edit a cleaning schedule
  Future<void> editCleaningSchedule(String plantId, String scheduleId,
      String day, String time, String amPm) async {
    try {
      isLoading.value = true;

      // Validate inputs
      if (day.isEmpty || time.isEmpty) {
        throw Exception('Day and time are required');
      }

      // Mock API call
      await Future.delayed(Duration(seconds: 1));

      // Find plant and update schedule
      final plantIndex = plants.indexWhere((plant) => plant['id'] == plantId);
      if (plantIndex == -1) throw Exception('Plant not found');

      final plant = Map<String, dynamic>.from(plants[plantIndex]);
      final List<Map<String, dynamic>> schedules =
          List<Map<String, dynamic>>.from(plant['schedules'] ?? []);

      final scheduleIndex =
          schedules.indexWhere((schedule) => schedule['id'] == scheduleId);
      if (scheduleIndex == -1) throw Exception('Schedule not found');

      schedules[scheduleIndex] = {
        ...schedules[scheduleIndex],
        'day': day,
        'time': time,
        'amPm': amPm,
      };

      plant['schedules'] = schedules;
      plants[plantIndex] = plant;

      if (selectedPlant.value?['id'] == plantId) {
        selectedPlant.value = plant;
      }

      Get.snackbar('Success', 'Cleaning schedule updated successfully');
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to update cleaning schedule');
    } finally {
      isLoading.value = false;
    }
  }

  // Delete a cleaning schedule
  Future<void> markScheduleForDeletion(
      String plantId, String scheduleId) async {
    try {
      isLoading.value = true;

      // Mock API call
      await Future.delayed(Duration(seconds: 1));

      // Find plant and delete the schedule
      final plantIndex = plants.indexWhere((plant) => plant['id'] == plantId);
      if (plantIndex == -1) throw Exception('Plant not found');

      final plant = Map<String, dynamic>.from(plants[plantIndex]);
      final List<Map<String, dynamic>> schedules =
          List<Map<String, dynamic>>.from(plant['schedules'] ?? []);

      final scheduleIndex =
          schedules.indexWhere((schedule) => schedule['id'] == scheduleId);
      if (scheduleIndex == -1) throw Exception('Schedule not found');

      // Remove the schedule from the list
      schedules.removeAt(scheduleIndex);

      // Update the plant's schedules
      plant['schedules'] = schedules;
      plants[plantIndex] = plant;

      // Update the selected plant if it's the one being modified
      if (selectedPlant.value?['id'] == plantId) {
        selectedPlant.value = plant;
      }

      Get.snackbar('Success', 'Cleaning schedule deleted successfully');
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to delete schedule');
    } finally {
      isLoading.value = false;
    }
  }

  // Update alert level
  void updateAlertLevel(String level) {
    alertLevel.value = level;
  }

  // Methods to update dialog state
  void setSelectedDay(String day) {
    selectedDay.value = day;
  }

  void setHour(int h) {
    hour.value = h;
  }

  void setMinute(int m) {
    minute.value = m;
  }

  void setAmPm(String value) {
    amPm.value = value;
  }
}
