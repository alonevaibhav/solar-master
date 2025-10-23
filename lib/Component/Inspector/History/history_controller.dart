//
//
//
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../API Service/api_service.dart';
// import '../../../Model/Inspector/history_model.dart';
// import '../../../utils/constants.dart';
//
// class InspectorHistoryController extends GetxController {
//   var isLoading = false.obs;
//   var isLoadingMore = false.obs;
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
//   // Pagination variables
//   var currentPage = 1.obs;
//   var itemsPerPage = 10;
//   var hasMoreData = true.obs;
//   List<CycleData> allCycles = [];
//
//   // Date filter variables
//   TextEditingController? _startDateController;
//   TextEditingController? _endDateController;
//
//   TextEditingController get startDateController {
//     _startDateController ??= TextEditingController();
//     return _startDateController!;
//   }
//
//   TextEditingController get endDateController {
//     _endDateController ??= TextEditingController();
//     return _endDateController!;
//   }
//
//   var isDateFilterActive = false.obs;
//   var filterStartDate = Rxn<int>();
//   var filterEndDate = Rxn<int>();
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
//     // Initialize controllers here
//     _startDateController = TextEditingController();
//     _endDateController = TextEditingController();
//   }
//
//   /// Formats year and month to YYYYMM format (e.g., 2025 & 09 = 2509)
//   String _formatYearMonth(int year, int month) {
//     String yearStr = year.toString().substring(2);
//     String monthStr = month.toString().padLeft(2, '0');
//     return '$yearStr$monthStr';
//   }
//
//   /// Parse date from "HH:MM:SS DD/MM/YY" format and return the day
//   int? _parseDateFromTime(String timeStr) {
//     try {
//       // Format: "01:03:40 12/01/25"
//       List<String> parts = timeStr.split(' ');
//       if (parts.length >= 2) {
//         String datePart = parts[1]; // "12/01/25"
//         List<String> dateComponents = datePart.split('/');
//         if (dateComponents.isNotEmpty) {
//           return int.parse(dateComponents[0]); // Day
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error parsing date from time: $e');
//       }
//     }
//     return null;
//   }
//
//   /// Check if a cycle matches the date filter
//   bool _matchesDateFilter(CycleData cycle) {
//     if (!isDateFilterActive.value) return true;
//
//     // Get the date from completed_at or started_at
//     String? dateTimeStr = cycle.summary.completedAt ?? cycle.summary.startedAt;
//     if (dateTimeStr == null) return false;
//
//     int? cycleDay = _parseDateFromTime(dateTimeStr);
//     if (cycleDay == null) return false;
//
//     int startDate = filterStartDate.value ?? 1;
//     int endDate = filterEndDate.value ?? startDate;
//
//     // If endDate is less than startDate, swap them
//     if (endDate < startDate) {
//       int temp = startDate;
//       startDate = endDate;
//       endDate = temp;
//     }
//
//     return cycleDay >= startDate && cycleDay <= endDate;
//   }
//
//   /// Apply date filter to cycles
//   List<CycleData> _applyDateFilter(List<CycleData> cyclesList) {
//     if (!isDateFilterActive.value) return cyclesList;
//
//     return cyclesList.where((cycle) => _matchesDateFilter(cycle)).toList();
//   }
//
//   /// Update date filter based on text field inputs
//   void updateDateFilter() {
//     String startText = startDateController.text.trim();
//     String endText = endDateController.text.trim();
//
//     if (startText.isEmpty) {
//       isDateFilterActive.value = false;
//       filterStartDate.value = null;
//       filterEndDate.value = null;
//       _reapplyFilterToCycles();
//       return;
//     }
//
//     try {
//       int? startDate = int.tryParse(startText);
//       int? endDate = endText.isNotEmpty ? int.tryParse(endText) : null;
//
//       if (startDate != null && startDate >= 1 && startDate <= 31) {
//         filterStartDate.value = startDate;
//
//         if (endDate != null && endDate >= 1 && endDate <= 31) {
//           filterEndDate.value = endDate;
//         } else {
//           filterEndDate.value = startDate; // Single date filter
//         }
//
//         isDateFilterActive.value = true;
//         _reapplyFilterToCycles();
//       } else {
//         isDateFilterActive.value = false;
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error updating date filter: $e');
//       }
//       isDateFilterActive.value = false;
//     }
//   }
//
//   /// Reapply filter to existing cycles data
//   void _reapplyFilterToCycles() {
//     if (allCycles.isEmpty) return;
//
//     // Apply date filter
//     List<CycleData> filteredCycles = _applyDateFilter(allCycles);
//
//     // Reset pagination
//     currentPage.value = 1;
//
//     // Load first page of filtered data
//     int endIndex = itemsPerPage > filteredCycles.length
//         ? filteredCycles.length
//         : itemsPerPage;
//
//     cycles.value = filteredCycles.sublist(0, endIndex);
//     hasMoreData.value = filteredCycles.length > itemsPerPage;
//
//     if (kDebugMode) {
//       print('Filter applied: ${cycles.length}/${filteredCycles.length} cycles shown');
//     }
//   }
//
//   /// Clear date filter
//   void clearDateFilter() {
//     if (_startDateController != null && !_startDateController!.hasListeners) {
//       startDateController.clear();
//     }
//     if (_endDateController != null && !_endDateController!.hasListeners) {
//       endDateController.clear();
//     }
//     filterStartDate.value = null;
//     filterEndDate.value = null;
//     isDateFilterActive.value = false;
//     _reapplyFilterToCycles();
//   }
//
//   /// Get display text for active date filter
//   String getDateFilterDisplay() {
//     if (!isDateFilterActive.value) return '';
//
//     int start = filterStartDate.value ?? 1;
//     int end = filterEndDate.value ?? start;
//
//     if (start == end) {
//       return 'Filtering: Date $start';
//     } else {
//       return 'Filtering: Date $start - $end';
//     }
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
//       // Reset pagination
//       currentPage.value = 1;
//       hasMoreData.value = true;
//       allCycles.clear();
//
//       String yrmn = _formatYearMonth(selectedYear.value, selectedMonth.value);
//
//       if (kDebugMode) {
//         print('Fetching MQTT history for Plant: $plantID, YearMonth: $yrmn');
//       }
//
//       final response = await ApiService.get<Map<String, dynamic>>(
//         endpoint: deviceLogAsPerMonth(int.parse(yrmn), plantID!),
//         fromJson: (data) => data as Map<String, dynamic>,
//         includeToken: true,
//       );
//
//       if (response.success && response.data != null) {
//         _handleSuccessResponse(response.data!);
//         clearDateFilter(); // Reset date filter on new data load
//       } else {
//         if (response.statusCode == 404) {
//           _handleNoLogsScenario('No data available for the selected month');
//         } else {
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
//   /// Load more cycles (pagination)
//   Future<void> loadMoreCycles() async {
//     if (isLoadingMore.value || !hasMoreData.value) return;
//
//     try {
//       isLoadingMore.value = true;
//
//       // Apply date filter to get filtered list
//       List<CycleData> filteredCycles = _applyDateFilter(allCycles);
//
//       // Calculate start and end index for pagination
//       int startIndex = currentPage.value * itemsPerPage;
//       int endIndex = startIndex + itemsPerPage;
//
//       if (startIndex >= filteredCycles.length) {
//         hasMoreData.value = false;
//         return;
//       }
//
//       // Get next batch of cycles
//       List<CycleData> nextBatch = filteredCycles.sublist(
//         startIndex,
//         endIndex > filteredCycles.length ? filteredCycles.length : endIndex,
//       );
//
//       // Add to displayed cycles
//       cycles.addAll(nextBatch);
//       currentPage.value++;
//
//       // Check if there's more data
//       if (endIndex >= filteredCycles.length) {
//         hasMoreData.value = false;
//       }
//
//       if (kDebugMode) {
//         print('Loaded more cycles: ${cycles.length}/${filteredCycles.length}');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error loading more cycles: $e');
//       }
//     } finally {
//       isLoadingMore.value = false;
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
//       isCollectingData.value = true;
//
//       if (kDebugMode) {
//         print('Triggering data collection for Plant UUID: $plantUuid');
//       }
//
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
//         await loadMqttHistoryByYearMonth(); // Refresh data after collection
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
//       isCollectingData.value = false;
//     }
//   }
//
//   void updateYear(int year) {
//     selectedYear.value = year;
//     clearDateFilter(); // Reset date filter when year changes
//   }
//
//   void updateMonth(int month) {
//     selectedMonth.value = month;
//     clearDateFilter(); // Reset date filter when month changes
//   }
//
//   void _handleSuccessResponse(Map<String, dynamic> responseData) {
//     try {
//       List<CycleData> processedCycles = [];
//
//       List<dynamic>? cyclesData = responseData['cycles'] as List<dynamic>?;
//
//       if (cyclesData == null || cyclesData.isEmpty) {
//         _handleNoLogsScenario('No cleaning cycles found for the selected month');
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
//
//       // Store all cycles
//       allCycles = processedCycles;
//
//       // Apply date filter
//       List<CycleData> filteredCycles = _applyDateFilter(allCycles);
//
//       // Load first page
//       int endIndex = itemsPerPage > filteredCycles.length
//           ? filteredCycles.length
//           : itemsPerPage;
//       cycles.value = filteredCycles.sublist(0, endIndex);
//
//       // Set hasMoreData flag
//       hasMoreData.value = filteredCycles.length > itemsPerPage;
//
//       if (kDebugMode) {
//         print('MQTT History loaded: ${cycles.length}/${filteredCycles.length} cycles (Page 1)');
//       }
//     } catch (e) {
//       _setError('Error processing cycle data: ${e.toString()}');
//       if (kDebugMode) {
//         print('Error parsing response: $e');
//       }
//     }
//   }
//
//   void _handleNoLogsScenario(String message) {
//     cycles.clear();
//     allCycles.clear();
//     hasError.value = false;
//     errorMessage.value = '';
//     hasMoreData.value = false;
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
//     allCycles.clear();
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
//     allCycles.clear();
//     _clearError();
//     _setLoading(false);
//     currentPage.value = 1;
//     hasMoreData.value = true;
//     clearDateFilter();
//   }
//
//   @override
//   void onClose() {
//     // Safely dispose controllers if they exist
//     _startDateController?.dispose();
//     _endDateController?.dispose();
//     _startDateController = null;
//     _endDateController = null;
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

  // Date filter variables
  TextEditingController? _startDateController;
  TextEditingController? _endDateController;

  TextEditingController get startDateController {
    _startDateController ??= TextEditingController();
    return _startDateController!;
  }

  TextEditingController get endDateController {
    _endDateController ??= TextEditingController();
    return _endDateController!;
  }

  var isDateFilterActive = false.obs;
  var filterStartDate = Rxn<int>();
  var filterEndDate = Rxn<int>();

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
    // Initialize controllers here
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
  }

  /// Formats year and month to YYYYMM format (e.g., 2025 & 09 = 2509)
  String _formatYearMonth(int year, int month) {
    String yearStr = year.toString().substring(2);
    String monthStr = month.toString().padLeft(2, '0');
    return '$yearStr$monthStr';
  }

  /// Parse date from "HH:MM:SS DD/MM/YY" format and return the day
  int? _parseDateFromTime(String timeStr) {
    try {
      // Format: "01:03:40 12/01/25"
      List<String> parts = timeStr.split(' ');
      if (parts.length >= 2) {
        String datePart = parts[1]; // "12/01/25"
        List<String> dateComponents = datePart.split('/');
        if (dateComponents.isNotEmpty) {
          return int.parse(dateComponents[0]); // Day
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing date from time: $e');
      }
    }
    return null;
  }

  /// Check if a cycle matches the date filter
  bool _matchesDateFilter(CycleData cycle) {
    if (!isDateFilterActive.value) return true;

    // Get the date from completed_at or started_at
    String? dateTimeStr = cycle.summary.completedAt ?? cycle.summary.startedAt;
    if (dateTimeStr == null) return false;

    int? cycleDay = _parseDateFromTime(dateTimeStr);
    if (cycleDay == null) return false;

    int startDate = filterStartDate.value ?? 1;
    int endDate = filterEndDate.value ?? startDate;

    // If endDate is less than startDate, swap them
    if (endDate < startDate) {
      int temp = startDate;
      startDate = endDate;
      endDate = temp;
    }

    return cycleDay >= startDate && cycleDay <= endDate;
  }

  /// Apply date filter to cycles
  List<CycleData> _applyDateFilter(List<CycleData> cyclesList) {
    if (!isDateFilterActive.value) return cyclesList;

    return cyclesList.where((cycle) => _matchesDateFilter(cycle)).toList();
  }

  /// Update date filter based on text field inputs
  void updateDateFilter() {
    String startText = startDateController.text.trim();
    String endText = endDateController.text.trim();

    if (startText.isEmpty) {
      isDateFilterActive.value = false;
      filterStartDate.value = null;
      filterEndDate.value = null;
      _reapplyFilterToCycles();
      return;
    }

    try {
      int? startDate = int.tryParse(startText);
      int? endDate = endText.isNotEmpty ? int.tryParse(endText) : null;

      if (startDate != null && startDate >= 1 && startDate <= 31) {
        filterStartDate.value = startDate;

        if (endDate != null && endDate >= 1 && endDate <= 31) {
          filterEndDate.value = endDate;
        } else {
          filterEndDate.value = startDate; // Single date filter
        }

        isDateFilterActive.value = true;
        _reapplyFilterToCycles();
      } else {
        isDateFilterActive.value = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating date filter: $e');
      }
      isDateFilterActive.value = false;
    }
  }

  /// Reapply filter to existing cycles data
  void _reapplyFilterToCycles() {
    if (allCycles.isEmpty) return;

    // Apply date filter
    List<CycleData> filteredCycles = _applyDateFilter(allCycles);

    // Reset pagination
    currentPage.value = 1;

    // Load first page of filtered data
    int endIndex = itemsPerPage > filteredCycles.length
        ? filteredCycles.length
        : itemsPerPage;

    cycles.value = filteredCycles.sublist(0, endIndex);
    hasMoreData.value = filteredCycles.length > itemsPerPage;

    if (kDebugMode) {
      print('Filter applied: ${cycles.length}/${filteredCycles.length} cycles shown');
    }
  }

  /// Clear date filter
  void clearDateFilter() {
    if (_startDateController != null && !_startDateController!.hasListeners) {
      startDateController.clear();
    }
    if (_endDateController != null && !_endDateController!.hasListeners) {
      endDateController.clear();
    }
    filterStartDate.value = null;
    filterEndDate.value = null;
    isDateFilterActive.value = false;
    _reapplyFilterToCycles();
  }

  /// Get display text for active date filter
  String getDateFilterDisplay() {
    if (!isDateFilterActive.value) return '';

    int start = filterStartDate.value ?? 1;
    int end = filterEndDate.value ?? start;

    if (start == end) {
      return 'Filtering: Date $start';
    } else {
      return 'Filtering: Date $start - $end';
    }
  }

  /// Fetches MQTT history data for selected year and month
  /// Auto-fallback: If 2025 September has no data, try October
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
        clearDateFilter(); // Reset date filter on new data load
      } else {
        // Check if this is September 2025 with no data
        if (selectedYear.value == 2025 && selectedMonth.value == 9) {
          if (kDebugMode) {
            print('September 2025 has no data, trying October 2025...');
          }

          // Show message to user
          Get.snackbar(
            'Info',
            'No data found for September 2025. Loading October 2025...',
            backgroundColor: Colors.blue[100],
            colorText: Colors.blue[800],
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
          );

          // Auto-switch to October
          selectedMonth.value = 10;

          // Retry with October
          await loadMqttHistoryByYearMonth();
          return;
        }

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

      // Apply date filter to get filtered list
      List<CycleData> filteredCycles = _applyDateFilter(allCycles);

      // Calculate start and end index for pagination
      int startIndex = currentPage.value * itemsPerPage;
      int endIndex = startIndex + itemsPerPage;

      if (startIndex >= filteredCycles.length) {
        hasMoreData.value = false;
        return;
      }

      // Get next batch of cycles
      List<CycleData> nextBatch = filteredCycles.sublist(
        startIndex,
        endIndex > filteredCycles.length ? filteredCycles.length : endIndex,
      );

      // Add to displayed cycles
      cycles.addAll(nextBatch);
      currentPage.value++;

      // Check if there's more data
      if (endIndex >= filteredCycles.length) {
        hasMoreData.value = false;
      }

      if (kDebugMode) {
        print('Loaded more cycles: ${cycles.length}/${filteredCycles.length}');
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
        await loadMqttHistoryByYearMonth(); // Refresh data after collection
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

    // If switching to 2025 and current month is before September, set to September
    if (year == 2025 && selectedMonth.value < 9) {
      selectedMonth.value = 9;
    }

    clearDateFilter(); // Reset date filter when year changes
  }

  void updateMonth(int month) {
    selectedMonth.value = month;
    clearDateFilter(); // Reset date filter when month changes
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

      // Apply date filter
      List<CycleData> filteredCycles = _applyDateFilter(allCycles);

      // Load first page
      int endIndex = itemsPerPage > filteredCycles.length
          ? filteredCycles.length
          : itemsPerPage;
      cycles.value = filteredCycles.sublist(0, endIndex);

      // Set hasMoreData flag
      hasMoreData.value = filteredCycles.length > itemsPerPage;

      if (kDebugMode) {
        print('MQTT History loaded: ${cycles.length}/${filteredCycles.length} cycles (Page 1)');
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
    clearDateFilter();
  }

  @override
  void onClose() {
    // Safely dispose controllers if they exist
    _startDateController?.dispose();
    _endDateController?.dispose();
    _startDateController = null;
    _endDateController = null;
    clearData();
    super.onClose();
  }
}