import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../../../API Service/api_service.dart';
import '../../../utils/constants.dart';

class InspectorHistoryController extends GetxController {
  // Observable variables for state management
  var isLoading = false.obs;
  var historyData = <dynamic>[].obs;
  var errorMessage = ''.obs;
  var hasError = false.obs;

  String? uuid;

  void setUuid(String? newUuid) {
    uuid = newUuid;
    print("UUID set to: $uuid");
  }

  void printUuidInfo() {
    print("=== UUID Information In Slot ===");
    print("UUID: ${uuid ?? 'NULL'}");
    print("Is UUID null: ${uuid == null}");
    print("Is UUID empty: ${uuid?.isEmpty ?? true}");
    print("UUID length: ${uuid?.length ?? 0}");
    print("========================");
  }

  @override
  void onInit() {
    super.onInit();
    // Removed automatic loading - let the widget control when to load
  }

  /// Fetches MQTT history data for a given UUID
  Future<void> loadMqttHistory() async {
    if (uuid == null || uuid!.isEmpty) {
      _setError('UUID cannot be empty');
      return;
    }

    try {
      _setLoading(true);
      _clearError();

      // Make the GET API call using ApiService
      // Changed to expect List<dynamic> directly since API returns an array
      final response = await ApiService.get<List<dynamic>>(
        endpoint: mqttHistoryGet(uuid!),
        fromJson: (data) => data as List<dynamic>, // Expecting array directly
        includeToken: true,
      );

      if (response.success && response.data != null) {
        // Handle successful response
        _handleSuccessResponse(response.data!);
      } else {
        // Handle API error
        _setError(response.errorMessage ?? 'Failed to load MQTT history');
      }
    } catch (e) {
      // Handle unexpected errors
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

  /// Handles successful API response
  void _handleSuccessResponse(List<dynamic> data) {
    // Process each notification item to extract and parse notification_data
    List<Map<String, dynamic>> processedData = [];

    for (var item in data) {
      if (item is Map<String, dynamic>) {
        Map<String, dynamic> processedItem = {
          'id': item['id'],
          'imei': item['imei'],
          'topic': item['topic'],
          'created_at': item['created_at'],
          'raw_notification_data': item['notification_data'],
        };

        // Parse the notification_data JSON string
        try {
          if (item['notification_data'] != null) {
            var notificationData = jsonDecode(item['notification_data']);
            processedItem['parsed_message'] =
                notificationData['message'] ?? 'No message';
          } else {
            processedItem['parsed_message'] = 'No message';
          }
        } catch (e) {
          processedItem['parsed_message'] = 'Invalid message format';
          if (kDebugMode) {
            print('Error parsing notification_data: $e');
          }
        }

        processedData.add(processedItem);
      }
    }

    historyData.value = processedData;

    if (kDebugMode) {
      print('MQTT History loaded successfully: ${historyData.length} items');
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
    historyData.clear();
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
    historyData.clear();
    _clearError();
    _setLoading(false);
  }

  @override
  void onClose() {
    // Clean up resources when controller is destroyed
    clearData();
    super.onClose();
  }
}
