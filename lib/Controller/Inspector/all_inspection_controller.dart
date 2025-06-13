import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../API Service/api_service.dart';
import '../../Model/Inspector/all_inspection_model.dart';

class AllInspectionsController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();
  final allInspection = <Map<String, dynamic>>[].obs;
  final selectedWeekFilter = Rxn<String>();

  // Keep original data for filtering
  final List<Map<String, dynamic>> _originalInspections = [];

  @override
  void onInit() {
    super.onInit();
    print('📱 AllInspectionsController initialized');
    fetchAllInspections();
  }

  Future<void> fetchAllInspections() async {

    try {
      isLoading.value = true;
      errorMessage.value = null;

      final storedUid = await ApiService.getUid();

      if (storedUid == null) {
        throw Exception('User ID not found');
      }

      final response = await ApiService.get<InspectionResponse>(
        endpoint: '/schedules/inspector-schedules/inspector/$storedUid/weekly',
        fromJson: (json) {
          return InspectionResponse.fromJson(json);
        },
      );



      if (response.success && response.data != null) {
        final data = response.data!.data;

        List<Map<String, dynamic>> flattenedInspections = [];

        if (data.isNotEmpty) {
          data.forEach((weekKey, weekInspections) {

            if (weekInspections.isNotEmpty) {
              try {
                final weekMaps = weekInspections.map((inspection) {
                  final jsonMap = inspection.toJson();
                  return jsonMap;
                }).toList();

                flattenedInspections.addAll(weekMaps);
              } catch (e) {
              }
            }
          });
        }


        // Clear and update safely
        _originalInspections.clear();
        _originalInspections.addAll(flattenedInspections);

        // Update reactive list
        allInspection.clear();
        allInspection.addAll(flattenedInspections);



        // Log first few inspections for debugging
        if (allInspection.isNotEmpty) {
          print('🔍 First inspection sample:');
          final firstInspection = allInspection.first;

        }

      } else {
        final errorMsg = response.errorMessage ?? 'Failed to load inspection items';
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('💥 Exception in fetchAllInspections: $e');
      print('📚 Stack trace: ${StackTrace.current}');

      errorMessage.value = e.toString();

      // Clear all data safely
      _originalInspections.clear();
      allInspection.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void filterByWeek(String? week) {


    selectedWeekFilter.value = week;

    try {
      if (week == null) {
        // Show all inspections
        allInspection.clear();
        allInspection.addAll(_originalInspections);
      } else {
        // Filter by specific week
        final filtered = _originalInspections.where((inspection) {
          final inspectionWeek = inspection['week'];
          final match = inspectionWeek != null && inspectionWeek.toString() == week;
          if (match) {
          }
          return match;
        }).toList();

        allInspection.clear();
        allInspection.addAll(filtered);
      }

    } catch (e) {
      // Fallback to showing all
      allInspection.clear();
      allInspection.addAll(_originalInspections);
    }
  }

  String get currentFilterText {
    return selectedWeekFilter.value == null ? 'All Weeks' : 'Week ${selectedWeekFilter.value}';
  }

  bool isWeekFilterActive(String week) {
    return selectedWeekFilter.value == week;
  }

  bool get isAllFilterActive {
    return selectedWeekFilter.value == null;
  }

  Future<void> refreshInspections() async {
    print('🔄 Manual refresh triggered');
    await fetchAllInspections();
  }
}