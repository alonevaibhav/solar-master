// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../API Service/api_service.dart';
// import '../../../Model/Inspector/history_model.dart';
// import '../../../utils/constants.dart';
//
// class InspectorHistoryController extends GetxController {
//   var isLoading = false.obs;
//   var cycles = <CycleData>[].obs;
//   var errorMessage = ''.obs;
//   var hasError = false.obs;
//
//   var selectedYear = DateTime.now().year.obs;
//   var selectedMonth = DateTime.now().month.obs;
//
//   String? plantID;
//   String? plantUuid;
//
//   void setPlantId(String? newUuid) {
//     plantID = newUuid;
//     print("ID set to: $plantID");
//   }
//
//   void printUuidInfo(plantUUID) {
//     plantUuid = plantUUID;
//     print("Plant UUID: ${plantUUID ?? 'NULL'}");
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//   }
//
//   /// Formats year and month to YYYYMM format (e.g., 2025 & 09 = 2509)
//   String _formatYearMonth(int year, int month) {
//     String yearStr =
//         year.toString().substring(2); // Get last 2 digits (25 from 2025)
//     String monthStr =
//         month.toString().padLeft(2, '0'); // Pad month with 0 if needed
//     return '$yearStr$monthStr'; // Returns 2509
//   }
//
//   /// Fetches MQTT history data for selected year and month
//   Future<void> loadMqttHistoryByYearMonth() async {
//     if (plantID == null || plantID!.isEmpty) {
//       _setError('Plant ID cannot be empty');
//       return;
//     }
//
//     try {
//       _setLoading(true);
//       _clearError();
//
//       // Format year and month (e.g., 2025, 09 -> 2509)
//       String yrmn = _formatYearMonth(selectedYear.value, selectedMonth.value);
//
//       if (kDebugMode) {
//         print('Fetching MQTT history for Plant: $plantID, YearMonth: $yrmn');
//       }
//
//       // Make the GET API call using the formatted year-month
//       final response = await ApiService.get<Map<String, dynamic>>(
//         endpoint: deviceLogAsPerMonth(int.parse(yrmn), plantID!),
//         fromJson: (data) => data as Map<String, dynamic>,
//         includeToken: true,
//       );
//
//       if (response.success && response.data != null) {
//         _handleSuccessResponse(response.data!);
//       } else {
//         // Check if it's a 404 error (table doesn't exist) or empty data
//         if (response.statusCode == 404) {
//           // Table doesn't exist - treat as "no logs available"
//           _handleNoLogsScenario('No data available for the selected month');
//         } else {
//           // Other errors - show as actual error
//           _setError(response.errorMessage ?? 'Failed to load MQTT history');
//         }
//       }
//     } catch (e) {
//       _setError('An unexpected error occurred: ${e.toString()}');
//       if (kDebugMode) {
//         print('Error in loadMqttHistoryByYearMonth: $e');
//       }
//     } finally {
//       _setLoading(false);
//     }
//   }
//
//   var isCollectingData = false.obs;
//
//   /// Triggers data collection for the plant using UUID
//   Future<void> triggerDataCollection() async {
//     if (plantUuid == null || plantUuid!.isEmpty) {
//       if (kDebugMode) {
//         print('Plant UUID is null or empty, cannot trigger data collection');
//       }
//       Get.snackbar(
//         'Error',
//         'Plant UUID is not available',
//         backgroundColor: Colors.red[100],
//         colorText: Colors.red[800],
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     try {
//       isCollectingData.value = true; // Start loading
//
//       if (kDebugMode) {
//         print('Triggering data collection for Plant UUID: $plantUuid');
//       }
//
//       // Make the POST API call
//       final response = await ApiService.post<Map<String, dynamic>>(
//         endpoint: deviceDataCollectionCommand(plantUuid!),
//         body: {},
//         fromJson: (data) => data as Map<String, dynamic>,
//         includeToken: true,
//       );
//
//       if (response.success) {
//         if (kDebugMode) {
//           print('Data collection triggered successfully');
//           print('Response: ${response.data}');
//         }
//         Get.snackbar(
//           'Success',
//           'Data collected successfully',
//           backgroundColor: Colors.green[100],
//           colorText: Colors.green[800],
//           snackPosition: SnackPosition.BOTTOM,
//           icon: Icon(Icons.check_circle, color: Colors.green[800]),
//         );
//       } else {
//         if (kDebugMode) {
//           print('Failed to trigger data collection: ${response.errorMessage}');
//         }
//         Get.snackbar(
//           'Failed',
//           response.errorMessage ?? 'Failed to collect data',
//           backgroundColor: Colors.orange[100],
//           colorText: Colors.orange[800],
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error triggering data collection: $e');
//       }
//       Get.snackbar(
//         'Error',
//         'An error occurred while collecting data',
//         backgroundColor: Colors.red[100],
//         colorText: Colors.red[800],
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isCollectingData.value = false; // Stop loading
//     }
//   }
//
//   /// Updates selected year
//   void updateYear(int year) {
//     selectedYear.value = year;
//   }
//
//   /// Updates selected month
//   void updateMonth(int month) {
//     selectedMonth.value = month;
//   }
//
//   void _handleSuccessResponse(Map<String, dynamic> responseData) {
//     try {
//       List<CycleData> processedCycles = [];
//
//       List<dynamic>? cyclesData = responseData['cycles'] as List<dynamic>?;
//
//       if (cyclesData == null || cyclesData.isEmpty) {
//         // Empty cycles array - not an error, just no logs
//         _handleNoLogsScenario(
//             'No cleaning cycles found for the selected month');
//         return;
//       }
//
//       for (var cycleJson in cyclesData) {
//         if (cycleJson is Map<String, dynamic>) {
//           CycleData cycle = CycleData.fromJson(cycleJson);
//           processedCycles.add(cycle);
//         }
//       }
//
//       processedCycles.sort((a, b) => b.cycleNumber.compareTo(a.cycleNumber));
//       cycles.value = processedCycles;
//
//       if (kDebugMode) {
//         print('MQTT History loaded successfully: ${cycles.length} cycles');
//       }
//     } catch (e) {
//       _setError('Error processing cycle data: ${e.toString()}');
//       if (kDebugMode) {
//         print('Error parsing response: $e');
//       }
//     }
//   }
//
//   /// Handles the scenario where no logs are available (not an error)
//   void _handleNoLogsScenario(String message) {
//     cycles.clear();
//     hasError.value = false;
//     errorMessage.value = '';
//
//     if (kDebugMode) {
//       print('No logs available: $message');
//     }
//   }
//
//   void _setLoading(bool loading) {
//     isLoading.value = loading;
//   }
//
//   void _setError(String message) {
//     hasError.value = true;
//     errorMessage.value = message;
//     cycles.clear();
//     if (kDebugMode) {
//       print('Error in InspectorHistoryController: $message');
//     }
//   }
//
//   void _clearError() {
//     hasError.value = false;
//     errorMessage.value = '';
//   }
//
//   void clearData() {
//     cycles.clear();
//     _clearError();
//     _setLoading(false);
//   }
//
//   @override
//   void onClose() {
//     clearData();
//     super.onClose();
//   }
// }


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../API Service/api_service.dart';
import '../../../Model/Inspector/history_model.dart';
import '../../../utils/constants.dart';

class InspectorHistoryController extends GetxController {
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var cycles = <CycleData>[].obs;
  var errorMessage = ''.obs;
  var hasError = false.obs;

  var selectedYear = DateTime.now().year.obs;
  var selectedMonth = DateTime.now().month.obs;

  String? plantID;
  String? plantUuid;

  // Pagination variables
  var currentPage = 1.obs;
  var itemsPerPage = 10;
  var hasMoreData = true.obs;
  List<CycleData> allCycles = [];

  void setPlantId(String? newUuid) {
    plantID = newUuid;
    print("ID set to: $plantID");
  }

  void printUuidInfo(plantUUID) {
    plantUuid = plantUUID;
    print("Plant UUID: ${plantUUID ?? 'NULL'}");
  }

  @override
  void onInit() {
    super.onInit();
  }

  /// Formats year and month to YYYYMM format (e.g., 2025 & 09 = 2509)
  String _formatYearMonth(int year, int month) {
    String yearStr = year.toString().substring(2);
    String monthStr = month.toString().padLeft(2, '0');
    return '$yearStr$monthStr';
  }

  /// Fetches MQTT history data for selected year and month
  Future<void> loadMqttHistoryByYearMonth() async {
    if (plantID == null || plantID!.isEmpty) {
      _setError('Plant ID cannot be empty');
      return;
    }

    try {
      _setLoading(true);
      _clearError();

      // Reset pagination
      currentPage.value = 1;
      hasMoreData.value = true;
      allCycles.clear();

      String yrmn = _formatYearMonth(selectedYear.value, selectedMonth.value);

      if (kDebugMode) {
        print('Fetching MQTT history for Plant: $plantID, YearMonth: $yrmn');
      }

      final response = await ApiService.get<Map<String, dynamic>>(
        endpoint: deviceLogAsPerMonth(int.parse(yrmn), plantID!),
        fromJson: (data) => data as Map<String, dynamic>,
        includeToken: true,
      );

      if (response.success && response.data != null) {
        _handleSuccessResponse(response.data!);
      } else {
        if (response.statusCode == 404) {
          _handleNoLogsScenario('No data available for the selected month');
        } else {
          _setError(response.errorMessage ?? 'Failed to load MQTT history');
        }
      }
    } catch (e) {
      _setError('An unexpected error occurred: ${e.toString()}');
      if (kDebugMode) {
        print('Error in loadMqttHistoryByYearMonth: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  /// Load more cycles (pagination)
  Future<void> loadMoreCycles() async {
    if (isLoadingMore.value || !hasMoreData.value) return;

    try {
      isLoadingMore.value = true;

      // Calculate start and end index for pagination
      int startIndex = currentPage.value * itemsPerPage;
      int endIndex = startIndex + itemsPerPage;

      if (startIndex >= allCycles.length) {
        hasMoreData.value = false;
        return;
      }

      // Get next batch of cycles
      List<CycleData> nextBatch = allCycles.sublist(
        startIndex,
        endIndex > allCycles.length ? allCycles.length : endIndex,
      );

      // Add to displayed cycles
      cycles.addAll(nextBatch);
      currentPage.value++;

      // Check if there's more data
      if (endIndex >= allCycles.length) {
        hasMoreData.value = false;
      }

      if (kDebugMode) {
        print('Loaded more cycles: ${cycles.length}/${allCycles.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading more cycles: $e');
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  var isCollectingData = false.obs;

  /// Triggers data collection for the plant using UUID
  Future<void> triggerDataCollection() async {
    if (plantUuid == null || plantUuid!.isEmpty) {
      if (kDebugMode) {
        print('Plant UUID is null or empty, cannot trigger data collection');
      }
      Get.snackbar(
        'Error',
        'Plant UUID is not available',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isCollectingData.value = true;

      if (kDebugMode) {
        print('Triggering data collection for Plant UUID: $plantUuid');
      }

      final response = await ApiService.post<Map<String, dynamic>>(
        endpoint: deviceDataCollectionCommand(plantUuid!),
        body: {},
        fromJson: (data) => data as Map<String, dynamic>,
        includeToken: true,
      );

      if (response.success) {
        if (kDebugMode) {
          print('Data collection triggered successfully');
          print('Response: ${response.data}');
        }
        Get.snackbar(
          'Success',
          'Data collected successfully',
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
          snackPosition: SnackPosition.BOTTOM,
          icon: Icon(Icons.check_circle, color: Colors.green[800]),
        );
      } else {
        if (kDebugMode) {
          print('Failed to trigger data collection: ${response.errorMessage}');
        }
        Get.snackbar(
          'Failed',
          response.errorMessage ?? 'Failed to collect data',
          backgroundColor: Colors.orange[100],
          colorText: Colors.orange[800],
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error triggering data collection: $e');
      }
      Get.snackbar(
        'Error',
        'An error occurred while collecting data',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCollectingData.value = false;
    }
  }

  void updateYear(int year) {
    selectedYear.value = year;
  }

  void updateMonth(int month) {
    selectedMonth.value = month;
  }

  void _handleSuccessResponse(Map<String, dynamic> responseData) {
    try {
      List<CycleData> processedCycles = [];

      List<dynamic>? cyclesData = responseData['cycles'] as List<dynamic>?;

      if (cyclesData == null || cyclesData.isEmpty) {
        _handleNoLogsScenario('No cleaning cycles found for the selected month');
        return;
      }

      for (var cycleJson in cyclesData) {
        if (cycleJson is Map<String, dynamic>) {
          CycleData cycle = CycleData.fromJson(cycleJson);
          processedCycles.add(cycle);
        }
      }

      processedCycles.sort((a, b) => b.cycleNumber.compareTo(a.cycleNumber));

      // Store all cycles
      allCycles = processedCycles;

      // Load first page
      int endIndex = itemsPerPage > allCycles.length ? allCycles.length : itemsPerPage;
      cycles.value = allCycles.sublist(0, endIndex);

      // Set hasMoreData flag
      hasMoreData.value = allCycles.length > itemsPerPage;

      if (kDebugMode) {
        print('MQTT History loaded: ${cycles.length}/${allCycles.length} cycles (Page 1)');
      }
    } catch (e) {
      _setError('Error processing cycle data: ${e.toString()}');
      if (kDebugMode) {
        print('Error parsing response: $e');
      }
    }
  }

  void _handleNoLogsScenario(String message) {
    cycles.clear();
    allCycles.clear();
    hasError.value = false;
    errorMessage.value = '';
    hasMoreData.value = false;

    if (kDebugMode) {
      print('No logs available: $message');
    }
  }

  void _setLoading(bool loading) {
    isLoading.value = loading;
  }

  void _setError(String message) {
    hasError.value = true;
    errorMessage.value = message;
    cycles.clear();
    allCycles.clear();
    if (kDebugMode) {
      print('Error in InspectorHistoryController: $message');
    }
  }

  void _clearError() {
    hasError.value = false;
    errorMessage.value = '';
  }

  void clearData() {
    cycles.clear();
    allCycles.clear();
    _clearError();
    _setLoading(false);
    currentPage.value = 1;
    hasMoreData.value = true;
  }

  @override
  void onClose() {
    clearData();
    super.onClose();
  }
}