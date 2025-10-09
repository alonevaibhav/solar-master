//
// import 'package:get/get.dart';
// import '../../API Service/Model/Request/plant_model.dart';
// import '../../API Service/api_service.dart';
// import '../../Route Manager/app_routes.dart';
// import '../../Services/init.dart';
// import '../../utils/constants.dart';
//
// class PlantInfoController extends GetxController {
//   // Observable lists and variables
//   final plants = <Map<String, dynamic>>[].obs;
//   final isLoading = false.obs;
//   final errorMessage = ''.obs;
//   final selectedPlant = Rx<Map<String, dynamic>?>(null);
//   final plantDetails = Rx<Map<String, dynamic>?>(null);
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchPlants();
//   }
//
//   // Fetch all assigned plants
//   Future<void> fetchPlants() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       // Retrieve the stored UID
//       final storedUid = await ApiService.getUid();
//
//       if (storedUid == null) {
//         throw Exception('No UID found');
//       }
//
//       // Use the UID as the inspector ID to fetch plants
//       final response = await ApiService.get<Map<String, dynamic>>(
//         endpoint: getInspectorPlantsUrl(int.parse(storedUid)),
//         fromJson: (json) => json as Map<String, dynamic>,
//       );
//
//       if (response.success) {
//         // Access the 'data' key in the response which contains the list of plants
//         final responseData = response.data;
//         if (responseData != null && responseData.containsKey('data')) {
//           final List<dynamic> plantsList = responseData['data'];
//           plants.value = plantsList.map((plant) => Plant.fromJson(plant).toJson()).toList();
//         } else {
//           throw Exception('Unexpected API response format');
//         }
//       } else {
//         throw Exception(response.errorMessage);
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//       Get.snackbar('Error', 'Failed to fetch plants');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
//   // Fetch plant details by ID
//   Future<Map<String, dynamic>?> fetchPlantDetails(String plantId) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       // Mock API call
//       await Future.delayed(Duration(seconds: 1));
//
//       // Return the same plant data that's already in the plants list
//       final plant = plants.firstWhere((p) => p['id'].toString() == plantId, orElse: () => <String, dynamic>{},);
//
//       if (plant.isEmpty) {
//         throw Exception('Plant not found');
//       }
//
//
//       plantDetails.value = plant;
//       return plant;
//
//     } catch (e) {
//       errorMessage.value = e.toString();
//       Get.snackbar('Error', 'Failed to fetch plant details');
//       return null;
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   final RxBool isNavigating = false.obs;
//   final RxString loadingPlantId = ''.obs;
//
// // Modified viewPlantDetails method
//   Future<void> viewPlantDetails(int plantId) async {
//     // Prevent multiple navigation attempts
//     if (isNavigating.value) return;
//
//     try {
//       // Set loading state
//       isNavigating.value = true;
//       loadingPlantId.value = plantId.toString();
//
//       final plant = plants.firstWhere((plant) => plant['id'] == plantId);
//       selectedPlant.value = plant;
//
//       // Get UUID from the selected plant
//       final uuid = plant['uuid']?.toString();
//
//       if (uuid != null) {
//         print('Initializing MQTT for plant UUID: $uuid');
//         // Initialize/reinitialize MQTT with the selected plant's UUID
//         await AppInitializer.reinitializeWithUUID(uuid);
//         print('✅ MQTT successfully initialized for UUID: $uuid');
//       } else {
//         print('⚠️ No UUID found for selected plant');
//       }
//
//       // Navigate to plant details with plant data
//       Get.toNamed(AppRoutes.inspectorDetailsSection, arguments: plant);
//
//     } catch (e) {
//       print('❌ Error in viewPlantDetails: $e');
//       // Still navigate even if MQTT initialization fails
//       final plant = plants.firstWhere((plant) => plant['id'] == plantId);
//       selectedPlant.value = plant;
//       Get.toNamed(AppRoutes.inspectorDetailsSection, arguments: plant);
//     } finally {
//       // Reset loading state
//       isNavigating.value = false;
//       loadingPlantId.value = '';
//     }
//   }
//
//   // Refresh plants data
//   Future<void> refreshPlants() async {
//     await fetchPlants();
//   }
//
//   @override
//   void onClose() {
//     // Clean up resources
//     super.onClose();
//   }
// }

import 'package:get/get.dart';
import '../../API Service/Model/Request/plant_model.dart';
import '../../API Service/api_service.dart';
import '../../Route Manager/app_routes.dart';
import '../../Services/init.dart';
import '../../utils/constants.dart';

class PlantInfoController extends GetxController {
  // Observable lists and variables
  final plants = <Map<String, dynamic>>[].obs;
  final filteredPlants = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final selectedPlant = Rx<Map<String, dynamic>?>(null);
  final plantDetails = Rx<Map<String, dynamic>?>(null);

  // Search and filter
  final searchQuery = ''.obs;
  final activeFilter = 'active'.obs; // 'active', 'inactive', 'all'
  final showFilterMenu = false.obs;

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

      // Retrieve the stored UID
      final storedUid = await ApiService.getUid();

      if (storedUid == null) {
        throw Exception('No UID found');
      }

      // Use the UID as the inspector ID to fetch plants
      final response = await ApiService.get<Map<String, dynamic>>(
        endpoint: getInspectorPlantsUrl(int.parse(storedUid)),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.success) {
        // Access the 'data' key in the response which contains the list of plants
        final responseData = response.data;
        if (responseData != null && responseData.containsKey('data')) {
          final List<dynamic> plantsList = responseData['data'];
          plants.value = plantsList.map((plant) => Plant.fromJson(plant).toJson()).toList();
          filterPlants(); // Apply initial filter
        } else {
          throw Exception('Unexpected API response format');
        }
      } else {
        throw Exception(response.errorMessage);
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to fetch plants');
    } finally {
      isLoading.value = false;
    }
  }

  // Filter plants based on search query and active status - REAL TIME
  void filterPlants() {
    List<Map<String, dynamic>> filtered = List.from(plants);

    // Filter by active status first
    if (activeFilter.value == 'active') {
      filtered = filtered.where((plant) => plant['isActive'] == 1).toList();
    } else if (activeFilter.value == 'inactive') {
      filtered = filtered.where((plant) => plant['isActive'] == 0).toList();
    }
    // If 'all', don't filter by status

    // Then filter by search query
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((plant) {
        final name = (plant['name'] ?? '').toString().toLowerCase();
        return name.contains(query);
      }).toList();
    }

    filteredPlants.value = filtered;
  }

  // Update search query - REAL TIME
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filterPlants(); // Filter immediately
  }

  // Set active filter - REAL TIME
  void setActiveFilter(String filter) {
    activeFilter.value = filter;
    showFilterMenu.value = false;
    filterPlants(); // Filter immediately
  }

  // Toggle filter menu
  void toggleFilterMenu() {
    showFilterMenu.value = !showFilterMenu.value;
  }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
    filterPlants();
  }

  // Get active plant count
  int get activePlantCount => plants.where((plant) => plant['isActive'] == 1).length;

  // Get inactive plant count
  int get inactivePlantCount => plants.where((plant) => plant['isActive'] == 0).length;

  // Fetch plant details by ID
  Future<Map<String, dynamic>?> fetchPlantDetails(String plantId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Mock API call
      await Future.delayed(Duration(seconds: 1));

      // Return the same plant data that's already in the plants list
      final plant = plants.firstWhere((p) => p['id'].toString() == plantId, orElse: () => <String, dynamic>{},);

      if (plant.isEmpty) {
        throw Exception('Plant not found');
      }

      plantDetails.value = plant;
      return plant;

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to fetch plant details');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  final RxBool isNavigating = false.obs;
  final RxString loadingPlantId = ''.obs;

  // Modified viewPlantDetails method
  Future<void> viewPlantDetails(int plantId) async {
    // Prevent multiple navigation attempts
    if (isNavigating.value) return;

    try {
      // Set loading state
      isNavigating.value = true;
      loadingPlantId.value = plantId.toString();

      final plant = plants.firstWhere((plant) => plant['id'] == plantId);
      selectedPlant.value = plant;

      // Get UUID from the selected plant
      final uuid = plant['uuid']?.toString();

      if (uuid != null) {
        print('Initializing MQTT for plant UUID: $uuid');
        // Initialize/reinitialize MQTT with the selected plant's UUID
        await AppInitializer.reinitializeWithUUID(uuid);
        print('✅ MQTT successfully initialized for UUID: $uuid');
      } else {
        print('⚠️ No UUID found for selected plant');
      }

      // Navigate to plant details with plant data
      Get.toNamed(AppRoutes.inspectorDetailsSection, arguments: plant);

    } catch (e) {
      print('❌ Error in viewPlantDetails: $e');
      // Still navigate even if MQTT initialization fails
      final plant = plants.firstWhere((plant) => plant['id'] == plantId);
      selectedPlant.value = plant;
      Get.toNamed(AppRoutes.inspectorDetailsSection, arguments: plant);
    } finally {
      // Reset loading state
      isNavigating.value = false;
      loadingPlantId.value = '';
    }
  }

  // Refresh plants data
  Future<void> refreshPlants() async {
    await fetchPlants();
  }

  @override
  void onClose() {
    // Clean up resources
    super.onClose();
  }
}