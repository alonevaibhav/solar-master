
import 'package:get/get.dart';
import '../../API Service/Model/Request/plant_model.dart';
import '../../API Service/api_service.dart';
import '../../Route Manager/app_routes.dart';
import '../../utils/constants.dart';

class CleanerPlantInfoController extends GetxController {
  // Observable lists and variables
  final plants = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final selectedPlant = Rx<Map<String, dynamic>?>(null);
  final plantDetails = Rx<Map<String, dynamic>?>(null);

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
        endpoint: getCleanerPlantsInfoUrl(int.parse(storedUid)),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.success) {
        // Access the 'data' key in the response which contains the list of plants
        final responseData = response.data;
        if (responseData != null && responseData.containsKey('data')) {
          final List<dynamic> plantsList = responseData['data'];
          plants.value = plantsList.map((plant) => Plant.fromJson(plant).toJson()).toList();
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

  // View plant details
  void viewPlantDetails(int plantId) {
    final plant = plants.firstWhere((plant) => plant['id'] == plantId);
    selectedPlant.value = plant;
    Get.toNamed(AppRoutes.cleanerPlantInfoDetailsPage, arguments: plant);
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
