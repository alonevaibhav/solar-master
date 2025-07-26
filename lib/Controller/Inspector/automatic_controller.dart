

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import '../../API Service/api_service.dart';
import '../../Services/data_parser.dart';
import '../../utils/constants.dart';

class ModbusParametersController extends GetxController {
  String? uuid;

  ModbusParametersController();

  void setUuid(String? newUuid) {
    uuid = newUuid;
    print("UUID set to: $uuid");
  }

  void printUuidInfo() {
    print("=== UUID Information ===");
    print("UUID: ${uuid ?? 'NULL'}");
    print("Is UUID null: ${uuid == null}");
    print("Is UUID empty: ${uuid?.isEmpty ?? true}");
    print("UUID length: ${uuid?.length ?? 0}");
    print("========================");
  }

  // Reactive state variables
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final parametersData = Rxn<Map<String, dynamic>>();

  // Store individual parameter values (index 50-99)
  final parameterValues = <int, RxInt>{}.obs;

  // Track which parameters have been modified
  final modifiedParameters = <int>{}.obs;

  // IMEI and topic information
  final currentImei = ''.obs;
  final currentTopic = ''.obs;

  // Number of boxes (from parameter 561)
  final numberOfBoxes = 0.obs;

  @override
  void onInit() {
    super.onInit();

    print("here is the  initialized with UUID: ${uuid ?? 'null'}");

    // Initialize parameters 50-99 with default values
    for (int i = 50; i < 100; i++) {
      parameterValues[i] = 0.obs;
    }
    // Initialize ALL 50 parameters (50-99) with dummy data (0 values)
    for (int i = 50; i < 100; i++) {
      parameterValues[i] = _generateDummyValue().obs;
    }
    loadInitialData();
  }

  @override
  void onReady() {
    super.onReady();
    // Any additional setup after widget is ready
  }

  @override
  void onClose() {
    super.onClose();
    // Clean up resources
  }

// 2. Updated dummy data generator to return 0
  int _generateDummyValue() {
    return 0; // Always return 0 for dummy data
  }

// 3. Update parseModbusMessage to handle live vs dummy data
  void parseModbusMessage(String topic, Uint8List payloadBytes) {
    try {
      currentImei.value = ModbusDataParser.extractImei(topic);
      currentTopic.value = topic;

      final allParameters = ModbusDataParser.parseParameters(payloadBytes);

      // Update parameter 561 (number of boxes)
      if (561 < allParameters.length) {
        numberOfBoxes.value = allParameters[561];
      }

      // Update LIVE data for active boxes only (50 to 49+numberOfBoxes)
      for (int i = 50; i < 50 + numberOfBoxes.value && i < 100; i++) {
        if (parameterValues.containsKey(i) && i < allParameters.length) {
          parameterValues[i]!.value = allParameters[i];
        }
      }

      // Reset dummy data to 0 for inactive boxes (beyond numberOfBoxes)
      for (int i = 50 + numberOfBoxes.value; i < 100; i++) {
        if (parameterValues.containsKey(i)) {
          parameterValues[i]!.value = 0;
        }
      }

      print('📊 Live data for ${numberOfBoxes.value} boxes, dummy (0) for remaining ${50 - numberOfBoxes.value} boxes');
    } catch (e) {
      errorMessage.value = 'Error parsing MQTT message: $e';
    }
  }

  /// Load initial data (ready to receive real MQTT messages)
  Future<void> loadInitialData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      parametersData.value = {
        'imei': currentImei.value.isEmpty
            ? 'Waiting for data...'
            : currentImei.value,
        'topic': currentTopic.value.isEmpty
            ? 'Waiting for data...'
            : currentTopic.value,
        'timestamp': DateTime.now().toIso8601String(),
        'numberOfBoxes': numberOfBoxes.value,
        'parameters': _getActiveParametersMap(),
      };
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to initialize: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }


  /// Get only active parameters as a map (based on numberOfBoxes)
  Map<String, int> _getActiveParametersMap() {
    final maxParameterToShow = 49 + numberOfBoxes.value;
    return Map.fromEntries(parameterValues.entries
        .where((e) => e.key >= 50 && e.key <= maxParameterToShow)
        .map((e) => MapEntry(e.key.toString(), e.value.value)));
  }

  /// Get the list of active box parameters (only those that should be shown)
  Map<int, RxInt> get activeBoxParameters {
    final maxParameterToShow = 49 + numberOfBoxes.value;
    return Map.fromEntries(parameterValues.entries
        .where((e) => e.key >= 50 && e.key <= maxParameterToShow));
  }

// 6. Update methods to handle only live data modifications
  void updateParameter(int index, int newValue) {
    // Only allow updates to live data boxes
    if (index >= 50 && index < 50 + numberOfBoxes.value) {
      if (newValue < 0 || newValue > 65535) {
        Get.snackbar('Invalid Value', 'Parameter value must be between 0 and 65535');
        return;
      }

      parameterValues[index]!.value = newValue;
      modifiedParameters.add(index);
    } else {
      // For dummy data boxes, set to 0 when changed
      parameterValues[index]!.value = 0;
      Get.snackbar('Dummy Data', 'Box ${index - 49} contains dummy data (set to 0). Only first ${numberOfBoxes.value} boxes are editable.');
    }
  }

  // Add this debug version to your controller to troubleshoot API calls
  Future<void> saveValveParameters(int newBoxCount) async {
    print("🔧 saveValveParameters called with newBoxCount: $newBoxCount");
    print("🔧 Current UUID: $uuid");

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Update numberOfBoxes with the new value
      numberOfBoxes.value = newBoxCount;
      print("🔧 Updated numberOfBoxes to: ${numberOfBoxes.value}");

      // Reset dummy data boxes to 0 when numberOfBoxes changes
      for (int i = 50 + numberOfBoxes.value; i < 100; i++) {
        if (parameterValues.containsKey(i)) {
          parameterValues[i]!.value = 0;
        }
      }

      // Prepare the value string for modbus format
      String dynamicValue = newBoxCount.toString().padLeft(5, '0');
      String valueString = "139,001,001,$dynamicValue,006";
      print("🔧 Modbus value string: $valueString");

      // Prepare the request body
      final requestBody = {
        "type": "config",
        "id": 1,
        "key": "modbus",
        "value": valueString,
      };
      print("🔧 Request body: $requestBody");

      // Check if UUID is valid
      if (uuid == null || uuid!.isEmpty) {
        throw Exception("UUID is null or empty. Cannot make API call.");
      }

      final endpoint = mqttSchedulePost(uuid!);
      print("🔧 API endpoint: $endpoint");

      // Make the POST request using ApiService
      print("🔧 Making API call...");
      final response = await ApiService.post<Map<String, dynamic>>(
        endpoint: endpoint,
        body: requestBody,
        fromJson: (json) => json as Map<String, dynamic>,
        includeToken: true,
      );

      print("🔧 API response received:");
      print("🔧 Success: ${response.success}");
      print("🔧 Status Code: ${response.statusCode}");
      print("🔧 Data: ${response.data}");
      print("🔧 Error Message: ${response.errorMessage}");

      if (response.success) {
        // Update main data structure with only active parameters
        parametersData.value = {
          ...parametersData.value ?? {},
          'parameters': _getActiveParametersMap(),
          'lastModified': DateTime.now().toIso8601String(),
          'modifiedCount': modifiedParameters.length,
          'numberOfBoxes': numberOfBoxes.value,
        };

        // Clear modified parameters tracking
        modifiedParameters.clear();

        print("🔧 ✅ Success - Parameters updated successfully");
        // Show success message
        Get.snackbar(
          'Success',
          'Modbus parameters saved successfully (${numberOfBoxes.value} valves)',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      } else {
        // Handle error response from ApiService
        String errorMsg = response.errorMessage ?? 'Failed to save modbus parameters';

        // Customize error message based on status code
        if (response.statusCode == 401) {
          errorMsg = 'Authentication failed. Please login again.';
        } else if (response.statusCode == 400) {
          errorMsg = 'Invalid modbus request: ${response.errorMessage}';
        } else if (response.statusCode == 404) {
          errorMsg = 'Device not found. Please check the UUID.';
        }

        print("🔧 ❌ API Error: $errorMsg");
        throw Exception(errorMsg);
      }
    } catch (e) {
      // Handle any errors (network, timeout, etc.)
      String errorMsg = e.toString();
      print("🔧 ❌ Exception caught: $errorMsg");

      // Clean up error message if it contains 'Exception: '
      if (errorMsg.startsWith('Exception: ')) {
        errorMsg = errorMsg.substring(11);
      }

      errorMessage.value = errorMsg;
      Get.snackbar(
        'Save Error',
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      rethrow;
    } finally {
      isLoading.value = false;
      print("🔧 saveValveParameters completed, isLoading set to false");
    }
  }


  Future<void> saveParameters() async {
    if (modifiedParameters.isEmpty) {
      Get.snackbar(
        'No Changes',
        'No parameters have been modified',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Prepare the value string for the API call
      String valueString = '';
      for (int i = 50; i < 50 + numberOfBoxes.value; i++) {
        // Format each value as 5 digits with leading zeros
        valueString += parameterValues[i]!.value.toString().padLeft(5, '0');
        if (i < 49 + numberOfBoxes.value) {
          valueString += ',';
        }
      }

      // Prepare the request body
      final requestBody = {
        "type": "config",
        "id": 1,
        "key": "upvlt1",
        "value": valueString,
      };

      // Make the POST request using ApiService
      final response = await ApiService.post<Map<String, dynamic>>(
        // endpoint: '/api/mqtt/publish/$uuid',
        endpoint: mqttSchedulePost(uuid!),
        body: requestBody,
        fromJson: (json) => json as Map<String, dynamic>,
        includeToken: true,
      );

      if (response.success) {
        // Update main data structure with only active parameters
        parametersData.value = {
          ...parametersData.value ?? {},
          'parameters': _getActiveParametersMap(),
          'lastModified': DateTime.now().toIso8601String(),
          'modifiedCount': modifiedParameters.length,
        };

        // Clear modified parameters tracking
        modifiedParameters.clear();

        // Show success message
        Get.snackbar(
          'Success',
          'Parameters saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Handle error response from ApiService
        String errorMsg = response.errorMessage ?? 'Failed to save parameters';

        // Customize error message based on status code
        if (response.statusCode == 401) {
          errorMsg = 'Authentication failed. Please login again.';
        } else if (response.statusCode == 400) {
          errorMsg = 'Invalid request: ${response.errorMessage}';
        } else if (response.statusCode == 404) {
          errorMsg = 'Device not found. Please check the UUID.';
        }

        throw Exception(errorMsg);
      }
    } catch (e) {
      // Handle any errors (network, timeout, etc.)
      String errorMsg = e.toString();

      // Clean up error message if it contains 'Exception: '
      if (errorMsg.startsWith('Exception: ')) {
        errorMsg = errorMsg.substring(11);
      }

      errorMessage.value = errorMsg;
      Get.snackbar(
        'Save Error',
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }


  /// Set all active parameters to the same value
  void setAllParametersTo(int value) {
    if (numberOfBoxes.value == 0) {
      Get.snackbar(
        'No Active Boxes',
        'No boxes available to set',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Validate range
    if (value < 0 || value > 65535) {
      Get.snackbar(
        'Invalid Value',
        'Value must be between 0 and 65535',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final maxParameterToShow = 49 + numberOfBoxes.value;
    int updatedCount = 0;

    for (int i = 50; i <= maxParameterToShow; i++) {
      if (parameterValues.containsKey(i)) {
        parameterValues[i]!.value = value;
        modifiedParameters.add(i);
        updatedCount++;
      }
    }

    // Update parameters data
    parametersData.value = {
      ...parametersData.value ?? {},
      'parameters': _getActiveParametersMap(),
    };

    Get.snackbar(
      'Success',
      'All $updatedCount boxes set to $value',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
    );
  }

  /// Reset all active parameters to their original values
  Future<void> resetParameters() async {
    try {
      isLoading.value = true;

      // Reset only the active box parameters to 0
      final maxParameterToShow = 49 + numberOfBoxes.value;
      for (int i = 50; i <= maxParameterToShow; i++) {
        if (parameterValues.containsKey(i)) {
          parameterValues[i]!.value = 0;
        }
      }

      modifiedParameters.clear();

      Get.snackbar(
        'Reset Complete',
        'All active parameters reset to default values',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Reset Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  /// Get parameter value by index
  int getParameterValue(int index) {
    return parameterValues[index]?.value ?? 0;
  }

  /// Check if parameter has been modified
  bool isParameterModified(int index) {
    return modifiedParameters.contains(index);
  }

  /// Check if a parameter index is active (within numberOfBoxes range)
  bool isParameterActive(int index) {
    return index >= 50 && index <= (49 + numberOfBoxes.value);
  }

  /// Get total count of modified parameters
  int get modifiedCount => modifiedParameters.length;
}