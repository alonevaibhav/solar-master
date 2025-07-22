import 'package:get/get.dart';
import 'dart:typed_data';

class ModbusParametersController extends GetxController {
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

  @override
  void onInit() {
    super.onInit();
    // Initialize parameters 50-99 with default values
    for (int i = 50; i < 100; i++) {
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

  /// Load initial data (simulate MQTT message parsing)
  Future<void> loadInitialData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Mock API call - simulate receiving MQTT message
      await Future.delayed(Duration(seconds: 1));

      // Simulate parsed data
      final mockTopic = "vidani/vm/862360073414729/data";
      final mockData = _generateMockData();

      parseModbusMessage(mockTopic, mockData);

      parametersData.value = {
        'imei': currentImei.value,
        'topic': currentTopic.value,
        'timestamp': DateTime.now().toIso8601String(),
        'parameters': Map.fromEntries(
            parameterValues.entries.map((e) => MapEntry(e.key.toString(), e.value.value))
        ),
      };

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load initial data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Parse Modbus message from MQTT
  void parseModbusMessage(String topic, Uint8List payloadBytes) {
    try {
      // Extract IMEI from topic
      currentImei.value = extractImei(topic);
      currentTopic.value = topic;

      // Parse parameters focusing on indices 50-99
      final allParameters = parseParameters(payloadBytes);

      // Update only parameters 50-99
      for (int i = 50; i < 100 && i < allParameters.length; i++) {
        if (parameterValues.containsKey(i)) {
          parameterValues[i]!.value = allParameters[i];
        }
      }

    } catch (e) {
      errorMessage.value = 'Error parsing MQTT message: $e';
      Get.snackbar('Parse Error', errorMessage.value);
    }
  }

  /// Extract IMEI from MQTT topic
  String extractImei(String topic) {
    final parts = topic.split('/');
    return parts.length > 2 ? parts[2] : 'Unknown';
  }

  /// Parse binary payload and return parameter values
  List<int> parseParameters(Uint8List payloadBytes) {
    final parameters = <int>[];

    try {
      for (int index = 0; index < 1400 && index < payloadBytes.length - 1;) {
        final f = payloadBytes[index];
        final l = payloadBytes[++index];
        final value = f * 256 + l;
        parameters.add(value);
        index++;
      }
    } catch (e) {
      print('Error parsing parameters: $e');
    }

    return parameters;
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

      // Mock API call to save parameters
      await Future.delayed(Duration(seconds: 2));

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
        'Parameters saved successfully',
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

      // Mock API call to get original values
      await Future.delayed(Duration(seconds: 1));

      // Reset to mock original values
      final mockData = _generateMockData();
      final originalParameters = parseParameters(mockData);

      for (int i = 50; i < 100 && i < originalParameters.length; i++) {
        if (parameterValues.containsKey(i)) {
          parameterValues[i]!.value = originalParameters[i];
        }
      }

      modifiedParameters.clear();

      Get.snackbar(
        'Reset Complete',
        'All parameters reset to original values',
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Reset Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  /// Generate mock binary data for testing
  Uint8List _generateMockData() {
    final random = DateTime.now().millisecondsSinceEpoch;
    final data = <int>[];

    // Generate 200 parameters (400 bytes)
    for (int i = 0; i < 200; i++) {
      final value = (random + i * 13) % 1000; // Mock values
      data.add((value >> 8) & 0xFF); // High byte
      data.add(value & 0xFF); // Low byte
    }

    return Uint8List.fromList(data);
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