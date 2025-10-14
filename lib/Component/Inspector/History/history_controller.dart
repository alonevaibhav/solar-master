//
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:get/get.dart';
// import 'package:flutter/foundation.dart';
// import 'dart:convert';
// import '../../../API Service/api_service.dart';
// import '../../../utils/constants.dart';
//
// class InspectorHistoryController extends GetxController {
//   // Observable variables for state management
//   var isLoading = false.obs;
//   var historyData = <dynamic>[].obs;
//   var errorMessage = ''.obs;
//   var hasError = false.obs;
//
//   String? uuid;
//
//   void setUuid(String? newUuid) {
//     uuid = newUuid;
//     print("UUID set to: $uuid");
//   }
//
//   void printUuidInfo() {
//     print("UUID: ${uuid ?? 'NULL'}");
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Removed automatic loading - let the widget control when to load
//   }
//
//   /// Fetches MQTT history data for a given UUID
//   Future<void> loadMqttHistory() async {
//     if (uuid == null || uuid!.isEmpty) {
//       _setError('ID cannot be empty');
//       return;
//     }
//
//     try {
//       _setLoading(true);
//       _clearError();
//
//       // Make the GET API call using ApiService
//       // Changed to expect Map<String, dynamic> since API now returns paginated response
//       final response = await ApiService.get<Map<String, dynamic>>(
//         endpoint: mqttHistoryGet(uuid!),
//         fromJson: (data) => data as Map<String, dynamic>,
//         includeToken: true,
//       );
//
//       if (response.success && response.data != null) {
//         // Handle successful response
//         _handleSuccessResponse(response.data!);
//       } else {
//         // Handle API error
//         _setError(response.errorMessage ?? 'Failed to load MQTT history');
//       }
//     } catch (e) {
//       // Handle unexpected errors
//       _setError('An unexpected error occurred: ${e.toString()}');
//       if (kDebugMode) {
//         print('Error in loadMqttHistory: $e');
//       }
//     } finally {
//       _setLoading(false);
//     }
//   }
//
//   /// Refreshes the MQTT history data
//   Future<void> refreshMqttHistory() async {
//     await loadMqttHistory();
//   }
//
//   /// Handles successful API response
//   void _handleSuccessResponse(Map<String, dynamic> responseData) {
//     // Extract the data array from the response
//     List<dynamic> data = [];
//
//     // Check if response contains 'data' field (pagination structure)
//     if (responseData.containsKey('data')) {
//       data = responseData['data'] as List<dynamic>? ?? [];
//     }
//     // If no 'data' field, check if it's directly an array
//     else if (responseData is List<dynamic>) {
//       data = responseData as List;
//     }
//     // Otherwise, treat the entire response as data
//     else {
//       data = [responseData];
//     }
//
//     // Process each cleaning cycle item
//     List<Map<String, dynamic>> processedData = [];
//
//     for (var item in data) {
//       if (item is Map<String, dynamic>) {
//         Map<String, dynamic> processedItem = {
//           'id': item['id'],
//           'topic': item['topic'],
//           'timestamp': item['timestamp'],
//           'plant_id': item['plant_id'],
//           'raw_cleaning_data': item['cleaning_data'],
//         };
//
//         // Parse the cleaning_data JSON string
//         try {
//           if (item['cleaning_data'] != null) {
//             var cleaningData = jsonDecode(item['cleaning_data']);
//
//             // Extract cleaning cycle information
//             processedItem['cycle'] = cleaningData['cycle'] ?? 'Unknown';
//             processedItem['time'] = cleaningData['time'] ?? 'Unknown time';
//             processedItem['complete'] = cleaningData['complete'] ?? 0;
//             processedItem['status'] = cleaningData['status'] ?? 'Unknown status';
//             processedItem['solenoid'] = cleaningData['solenoid'] ?? 'Unknown';
//
//             // Create a user-friendly message
//             String completionText = (cleaningData['complete'] == 1) ? 'Completed' : 'Incomplete';
//             processedItem['display_message'] =
//             'Cycle ${cleaningData['cycle'] ?? 'Unknown'} - ${cleaningData['status'] ?? 'Unknown status'} ($completionText)';
//           } else {
//             processedItem['cycle'] = 'Unknown';
//             processedItem['time'] = 'Unknown time';
//             processedItem['complete'] = 0;
//             processedItem['status'] = 'No data';
//             processedItem['solenoid'] = 'Unknown';
//             processedItem['display_message'] = 'No cleaning data available';
//           }
//         } catch (e) {
//           processedItem['cycle'] = 'Unknown';
//           processedItem['time'] = 'Unknown time';
//           processedItem['complete'] = 0;
//           processedItem['status'] = 'Parse error';
//           processedItem['solenoid'] = 'Unknown';
//           processedItem['display_message'] = 'Invalid data format';
//
//           if (kDebugMode) {
//             print('Error parsing cleaning_data: $e');
//           }
//         }
//
//         processedData.add(processedItem);
//       }
//     }
//
//     // Sort by timestamp (newest first)
//     processedData.sort((a, b) {
//       try {
//         DateTime aTime = DateTime.parse(a['timestamp'] ?? '');
//         DateTime bTime = DateTime.parse(b['timestamp'] ?? '');
//         return bTime.compareTo(aTime);
//       } catch (e) {
//         return 0;
//       }
//     });
//
//     historyData.value = processedData;
//
//     if (kDebugMode) {
//       print('MQTT History loaded successfully: ${historyData.length} items');
//     }
//   }
//
//   /// Sets loading state
//   void _setLoading(bool loading) {
//     isLoading.value = loading;
//   }
//
//   /// Sets error state and message
//   void _setError(String message) {
//     hasError.value = true;
//     errorMessage.value = message;
//     historyData.clear();
//     if (kDebugMode) {
//       print('Error in InspectorHistoryController: $message');
//     }
//   }
//
//   /// Clears error state
//   void _clearError() {
//     hasError.value = false;
//     errorMessage.value = '';
//   }
//
//   /// Clears all data and resets state
//   void clearData() {
//     historyData.clear();
//     _clearError();
//     _setLoading(false);
//   }
//
//   @override
//   void onClose() {
//     // Clean up resources when controller is destroyed
//     clearData();
//     super.onClose();
//   }
// }

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../../API Service/api_service.dart';
import '../../../Model/Inspector/history_model.dart';
import '../../../utils/constants.dart';

class InspectorHistoryController extends GetxController {
  // Observable variables for state management
  var isLoading = false.obs;
  var cycles = <CycleData>[].obs;
  var errorMessage = ''.obs;
  var hasError = false.obs;

  String? plantID;

  void setUuid(String? newUuid) {
    plantID = newUuid;
    print("ID set to: $plantID");
  }

  void printUuidInfo() {
    print("ID: ${plantID ?? 'NULL'}");
  }

  @override
  void onInit() {
    super.onInit();
  }

  /// Fetches MQTT history data for a given UUID
  Future<void> loadMqttHistory() async {
    if (plantID == null || plantID!.isEmpty) {
      _setError('ID cannot be empty');
      return;
    }

    try {
      _setLoading(true);
      _clearError();

      // Make the GET API call using ApiService
      final response = await ApiService.get<Map<String, dynamic>>(
        endpoint: mqttHistoryGet(plantID!),
        fromJson: (data) => data as Map<String, dynamic>,
        includeToken: true,
      );

      if (response.success && response.data != null) {
        _handleSuccessResponse(response.data!);
      } else {
        _setError(response.errorMessage ?? 'Failed to load MQTT history');
      }
    } catch (e) {
      _setError('An unexpected error occurred: ${e.toString()}');
      if (kDebugMode) {
        print('Error in loadMqttHistory: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  /// Refreshes the MQTT history data
  Future<void> refreshMqttHistory() async {
    await loadMqttHistory();
  }

  /// Handles successful API response with new JSON structure
  void _handleSuccessResponse(Map<String, dynamic> responseData) {
    try {
      List<CycleData> processedCycles = [];

      // Extract cycles array from response
      List<dynamic>? cyclesData = responseData['cycles'] as List<dynamic>?;

      if (cyclesData == null || cyclesData.isEmpty) {
        _setError('No cycle data available');
        return;
      }

      // Process each cycle
      for (var cycleJson in cyclesData) {
        if (cycleJson is Map<String, dynamic>) {
          CycleData cycle = CycleData.fromJson(cycleJson);
          processedCycles.add(cycle);
        }
      }

      // Sort cycles by cycle number (newest first)
      processedCycles.sort((a, b) => b.cycleNumber.compareTo(a.cycleNumber));

      cycles.value = processedCycles;

      if (kDebugMode) {
        print('MQTT History loaded successfully: ${cycles.length} cycles');
      }
    } catch (e) {
      _setError('Error processing cycle data: ${e.toString()}');
      if (kDebugMode) {
        print('Error parsing response: $e');
      }
    }
  }

  /// Sets loading state
  void _setLoading(bool loading) {
    isLoading.value = loading;
  }

  /// Sets error state and message
  void _setError(String message) {
    hasError.value = true;
    errorMessage.value = message;
    cycles.clear();
    if (kDebugMode) {
      print('Error in InspectorHistoryController: $message');
    }
  }

  /// Clears error state
  void _clearError() {
    hasError.value = false;
    errorMessage.value = '';
  }

  /// Clears all data and resets state
  void clearData() {
    cycles.clear();
    _clearError();
    _setLoading(false);
  }

  @override
  void onClose() {
    clearData();
    super.onClose();
  }
}

