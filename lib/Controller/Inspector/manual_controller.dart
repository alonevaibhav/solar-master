
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import '../../API Service/api_service.dart';
import '../../Services/data_parser.dart';
import 'package:http/http.dart' as http;

import '../../utils/constants.dart';


class ManualController extends GetxController {


  String? uuid;

  ManualController();

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

  // Store individual parameter values (index 450-499)
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
    // Initialize parameters 450-499 with default values
    for (int i = 450; i < 500; i++) {
      parameterValues[i] = 0.obs;
    }
    // Initialize slot timing parameters (550-557)
    for (int i = 550; i <= 557; i++) {
      parameterValues[i] = 0.obs;
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

  /// Load initial data (ready to receive real MQTT messages)
  Future<void> loadInitialData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      parametersData.value = {
        'imei': currentImei.value.isEmpty ? 'Waiting for data...' : currentImei.value,
        'topic': currentTopic.value.isEmpty ? 'Waiting for data...' : currentTopic.value,
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

  /// Parse Modbus message from MQTT using real parser
  void parseManualMessage(String topic, Uint8List payloadBytes) {
    try {
      // Extract IMEI from topic
      currentImei.value = ModbusDataParser.extractImei(topic);
      currentTopic.value = topic;

      // Parse all parameters using the real parser
      final allParameters = ModbusDataParser.parseParameters(payloadBytes);

      // Update parameter 561 (number of boxes) FIRST
      if (561 < allParameters.length) {
        numberOfBoxes.value = allParameters[561];
      }
      // Update slot timing parameters (550-557)
      for (int i = 550; i <= 557; i++) {
        if (parameterValues.containsKey(i) && i < allParameters.length) {
          parameterValues[i]!.value = allParameters[i];
        }
      }

      // Calculate the maximum parameter index to show based on numberOfBoxes
      final maxParameterToShow = 449 + numberOfBoxes.value;

      // Update only the active parameters (up to numberOfBoxes count)
      for (int i = 450; i <= maxParameterToShow && i < 500; i++) {
        if (parameterValues.containsKey(i) && i < allParameters.length) {
          parameterValues[i]!.value = allParameters[i];
        }
      }

      // Reset inactive parameters to 0 (beyond numberOfBoxes count)
      for (int i = maxParameterToShow + 1; i < 500; i++) {
        if (parameterValues.containsKey(i)) {
          parameterValues[i]!.value = 0;
        }
      }

      // Update parameters data with only active parameters
      parametersData.value = {
        'imei': currentImei.value,
        'topic': currentTopic.value,
        'timestamp': DateTime.now().toIso8601String(),
        'numberOfBoxes': numberOfBoxes.value,
        'parameters': _getActiveParametersMap(),
      };

      print('📊 Updated parameters for ${numberOfBoxes.value} boxes for IMEI: ${currentImei.value}');
      print('Number of boxes: ${numberOfBoxes.value}');
      print('Active box parameters values:');
      for (int i = 450; i < 450 + numberOfBoxes.value; i++) {
        if (parameterValues.containsKey(i)) {
          print('    Box ${i-449} (Parameter $i) = ${parameterValues[i]!.value}');
        }
      }

    } catch (e) {
      errorMessage.value = 'Error parsing MQTT message: $e';
      Get.snackbar('Parse Error', errorMessage.value);
    }
  }
  // Get slot timings as a list of maps for easy display
  List<Map<String, dynamic>> get slotTimingsForDisplay {
    return [
      {'code': 550, 'value': getParameterValue(550), 'description': 'Slot 1 ON Time'},
      {'code': 554, 'value': getParameterValue(554), 'description': 'Slot 1 OFF Time'},
      {'code': 551, 'value': getParameterValue(551), 'description': 'Slot 2 ON Time'},
      {'code': 555, 'value': getParameterValue(555), 'description': 'Slot 2 OFF Time'},
      {'code': 552, 'value': getParameterValue(552), 'description': 'Slot 3 ON Time'},
      {'code': 556, 'value': getParameterValue(556), 'description': 'Slot 3 OFF Time'},
      {'code': 553, 'value': getParameterValue(553), 'description': 'Slot 4 ON Time'},
      {'code': 557, 'value': getParameterValue(557), 'description': 'Slot 4 OFF Time'},
    ];
  }

  /// Get only active parameters as a map (based on numberOfBoxes)
  Map<String, int> _getActiveParametersMap() {
    final maxParameterToShow = 449 + numberOfBoxes.value;
    return Map.fromEntries(
        parameterValues.entries
            .where((e) => e.key >= 450 && e.key <= maxParameterToShow)
            .map((e) => MapEntry(e.key.toString(), e.value.value))
    );
  }

  /// Get the list of active box parameters (only those that should be shown)
  Map<int, RxInt> get activeBoxParameters {
    final maxParameterToShow = 449 + numberOfBoxes.value;
    return Map.fromEntries(
        parameterValues.entries
            .where((e) => e.key >= 450 && e.key <= maxParameterToShow)
    );
  }

  /// Update a specific parameter value (only allow active parameters)
  void updateParameter(int index, int newValue) {
    final maxParameterToShow = 449 + numberOfBoxes.value;

    if (parameterValues.containsKey(index) &&
        index >= 450 &&
        index <= maxParameterToShow) {
      // Validation
      if (newValue < 0 || newValue > 65535) {
        Get.snackbar(
          'Invalid Value',
          'Parameter value must be between 0 and 65535',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      parameterValues[index]!.value = newValue;
      modifiedParameters.add(index);

      // Update the parameters data
      parametersData.value = {
        ...parametersData.value ?? {},
        'parameters': _getActiveParametersMap(),
      };

    } else {
      Get.snackbar(
        'Invalid Parameter',
        'Box ${index - 449} is not active (only ${numberOfBoxes.value} boxes available)',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // /// Save all modified parameters
  // Future<void> saveParameters() async {
  //   if (modifiedParameters.isEmpty) {
  //     Get.snackbar(
  //       'No Changes',
  //       'No parameters have been modified',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //     return;
  //   }
  //
  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';
  //
  //
  //     // First get the authentication token
  //     final token = await getToken();
  //     if (token == null || token.isEmpty) {
  //       throw Exception('Authentication token not found. Please login again.');
  //     }
  //
  //     // Prepare the value string for the API call
  //     String valueString = '';
  //     for (int i = 450; i < 450 + numberOfBoxes.value; i++) {
  //       // Format each value as 5 digits with leading zeros
  //       valueString += parameterValues[i]!.value.toString().padLeft(5, '0');
  //       if (i < 499 + numberOfBoxes.value) {
  //         valueString += ',';
  //       }
  //     }
  //
  //     // Prepare the request body
  //     final requestBody = {
  //       "type": "config",
  //       "id": 1,
  //       "key": "upvlt5",
  //       "value": valueString,
  //     };
  //
  //     // Prepare headers with the token
  //     final headers = {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     };
  //
  //     // Make the POST request
  //     final response = await http.post(
  //       Uri.parse('https://smartsolarcleaner.com/api/api/mqtt/publish/$uuid'),
  //       headers: headers,
  //       body: jsonEncode(requestBody),
  //     ).timeout(const Duration(seconds: 30));
  //
  //     if (response.statusCode == 200) {
  //       // Update main data structure with only active parameters
  //       parametersData.value = {
  //         ...parametersData.value ?? {},
  //         'parameters': _getActiveParametersMap(),
  //         'lastModified': DateTime.now().toIso8601String(),
  //         'modifiedCount': modifiedParameters.length,
  //       };
  //
  //       // Clear modified parameters tracking
  //       modifiedParameters.clear();
  //
  //     } else {
  //       // More detailed error handling
  //       String errorMessage = 'Failed to save parameters';
  //       if (response.statusCode == 401) {
  //         errorMessage =  'Something went Wrong: ${response.body}';
  //       } else if (response.statusCode == 400) {
  //         errorMessage = 'Invalid request: ${response.body}';
  //       } else {
  //         errorMessage = 'Error ${response.statusCode}: ${response.body}';
  //       }
  //       throw Exception(errorMessage);
  //     }
  //   } on TimeoutException {
  //     throw Exception('Request timed out. Please try again.');
  //   } catch (e) {
  //     errorMessage.value = e.toString();
  //     Get.snackbar(
  //       'Save Error',
  //       e.toString(),
  //       snackPosition: SnackPosition.BOTTOM,
  //       duration: const Duration(seconds: 3),
  //     );
  //     rethrow;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

// // Add this method to your controller class
//   static Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }

  /// Save all modified parameters
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
      for (int i = 450; i < 450 + numberOfBoxes.value; i++) {
        // Format each value as 5 digits with leading zeros
        valueString += parameterValues[i]!.value.toString().padLeft(5, '0');
        if (i < 499 + numberOfBoxes.value) {
          valueString += ',';
        }
      }

      // Prepare the request body
      final requestBody = {
        "type": "config",
        "id": 1,
        "key": "upvlt5",
        "value": valueString,
      };

      // Make the POST request using ApiService
      final response = await ApiService.post<Map<String, dynamic>>(
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
          errorMsg = 'Something went Wrong: ${response.errorMessage}';
        } else if (response.statusCode == 400) {
          errorMsg = 'Invalid request: ${response.errorMessage}';
        } else if (response.statusCode == 404) {
          errorMsg = 'Device not found. Please check the UUID.';
        } else {
          errorMsg = 'Error ${response.statusCode}: ${response.errorMessage}';
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

  /// Reset all active parameters to their original values
  Future<void> resetParameters() async {
    try {
      isLoading.value = true;

      // Reset only the active box parameters to 0
      final maxParameterToShow = 449 + numberOfBoxes.value;
      for (int i = 450; i <= maxParameterToShow; i++) {
        if (parameterValues.containsKey(i)) {
          parameterValues[i]!.value = 0;
        }
      }

      modifiedParameters.clear();

      Get.snackbar(
        'Reset Complete',
        'All active parameters reset to default values',
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Reset Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }


  // Add this method to ModbusParametersController class

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

    final int startIndex = 450;
    final int maxParameterToShow = startIndex - 1 + numberOfBoxes.value;
    int updatedCount = 0;

    for (int i = startIndex; i <= maxParameterToShow && i <= 499; i++) {
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
    return index >= 450 && index <= (449 + numberOfBoxes.value);
  }

  /// Get total count of modified parameters
  int get modifiedCount => modifiedParameters.length;
}