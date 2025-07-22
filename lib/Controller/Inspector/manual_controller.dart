import 'package:get/get.dart';
import 'dart:typed_data';

import '../../Services/data_parser.dart';

class ManualController extends GetxController {
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

  @override
  void onInit() {
    super.onInit();
    // Initialize parameters 450-499 with default values
    for (int i = 450; i < 500; i++) {
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

      // Controller is ready to receive real MQTT messages
      // Parameters will be updated when parseModbusMessage() is called with real data

      parametersData.value = {
        'imei': currentImei.value.isEmpty ? 'Waiting for data...' : currentImei.value,
        'topic': currentTopic.value.isEmpty ? 'Waiting for data...' : currentTopic.value,
        'timestamp': DateTime.now().toIso8601String(),
        'parameters': Map.fromEntries(
            parameterValues.entries.map((e) => MapEntry(e.key.toString(), e.value.value))
        ),
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

      // Update only parameters 450-499 from the parsed data
      for (int i = 450; i < 500; i++) {
        if (parameterValues.containsKey(i) && i < allParameters.length) {
          parameterValues[i]!.value = allParameters[i];
        }
      }

      // Update parameters data
      parametersData.value = {
        'imei': currentImei.value,
        'topic': currentTopic.value,
        'timestamp': DateTime.now().toIso8601String(),
        'parameters': Map.fromEntries(
            parameterValues.entries.map((e) => MapEntry(e.key.toString(), e.value.value))
        ),
      };

      print('📊 Updated parameters 450-499 for IMEI: ${currentImei.value}');
      print('Parameters 450-499 values:');
      for (int i = 450; i < 500; i++) {
        if (parameterValues.containsKey(i)) {
          print('    Parameter $i = ${parameterValues[i]!.value}');
        }
      }

    } catch (e) {
      errorMessage.value = 'Error parsing MQTT message: $e';
      Get.snackbar('Parse Error', errorMessage.value);
    }
  }

  /// Update a specific parameter value
  void updateParameter(int index, int newValue) {
    if (parameterValues.containsKey(index)) {
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
    }
  }

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

      // TODO: Send modified parameters to device via MQTT or API
      // For now, just update the local data structure

      // Update main data structure
      parametersData.value = {
        ...parametersData.value ?? {},
        'parameters': Map.fromEntries(
            parameterValues.entries.map((e) => MapEntry(e.key.toString(), e.value.value))
        ),
        'lastModified': DateTime.now().toIso8601String(),
        'modifiedCount': modifiedParameters.length,
      };

      // Clear modified parameters tracking
      modifiedParameters.clear();

      Get.snackbar(
        'Success',
        'Parameters updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Save Error',
        'Failed to save parameters: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Reset all parameters to their original values
  Future<void> resetParameters() async {
    try {
      isLoading.value = true;

      // Reset parameters to 0 (or fetch original values from server if available)
      for (int i = 450; i < 500; i++) {
        if (parameterValues.containsKey(i)) {
          parameterValues[i]!.value = 0;
        }
      }

      modifiedParameters.clear();

      Get.snackbar(
        'Reset Complete',
        'All parameters reset to default values',
        snackPosition: SnackPosition.BOTTOM,
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

  /// Get total count of modified parameters
  int get modifiedCount => modifiedParameters.length;
}

