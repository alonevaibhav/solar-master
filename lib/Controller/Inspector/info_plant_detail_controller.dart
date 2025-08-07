import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'dart:typed_data';
import '../../API Service/api_service.dart';
import '../../Services/data_parser.dart';
import '../../utils/constants.dart';

enum HealthStatus { good, warning, critical }

class InfoPlantDetailController extends GetxController {
  final isMaintenanceModeEnabled = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  String? uuid;

  // IMEI and topic information
  final currentImei = ''.obs;
  final currentTopic = ''.obs;

  // Number of boxes (from parameter 561)
  final numberOfBoxes = 0.obs;
  final parameterValues = <int, RxInt>{}.obs;

  // Additional parameters with validation
  final rtcTime = 0.obs; // Parameter 560 - Time in seconds
  final floot = 0.obs; // Parameter 595 - Validation: <500 = red, >=500 = green
  final pressure =
      0.obs; // Parameter 596 - Validation: <500 = red, >=500 = green

  @override
  void onInit() {
    super.onInit();
    print("InfoPlantDetailController initialized");
  }

  @override
  void onReady() {
    super.onReady();
    print("InfoPlantDetailController ready");
  }

  @override
  void onClose() {
    super.onClose();
    print("InfoPlantDetailController disposed");
  }

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

  // // Convert seconds to HH:MM:SS format
  // String get formattedRtcTime {
  //   int totalSeconds = rtcTime.value;
  //   int hours = totalSeconds ~/ 3600;
  //   int minutes = (totalSeconds % 3600) ~/ 60;
  //   int seconds = totalSeconds % 60;
  //
  //   return '${hours.toString().padLeft(2, '0')}:'
  //       '${minutes.toString().padLeft(2, '0')}:'
  //       '${seconds.toString().padLeft(2, '0')}';
  // }

  // Convert minutes to HH:MM format
  String get formattedRtcTime {
    int totalMinutes = rtcTime.value;
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}';
  }

  // Get status for floot parameter
  HealthStatus get flootStatus {
    if (floot.value < 500) {
      return HealthStatus.critical;
    } else {
      return HealthStatus.good;
    }
  }

  // Get status for pressure parameter
  HealthStatus get pressureStatus {
    if (pressure.value < 500) {
      return HealthStatus.critical;
    } else {
      return HealthStatus.good;
    }
  }

  // Simple toggle button method
  Future<void> toggleMaintenanceMode() async {
    try {
      isLoading.value = true;

      // Toggle the UI state
      final newState = !isMaintenanceModeEnabled.value;

      // Send to API
      await _sendMaintenanceModeToDevice(newState);

      // Update UI state only after successful API call
      isMaintenanceModeEnabled.value = newState;

      // Show success message
      Get.snackbar(
        'Success',
        'Maintenance mode ${newState ? 'enabled' : 'disabled'}',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Show error message
      Get.snackbar(
        'Error',
        'Failed to toggle maintenance mode: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Send maintenance mode command to device
  Future<void> _sendMaintenanceModeToDevice(bool enable) async {
    if (uuid == null || uuid!.isEmpty) {
      throw Exception('UUID not found');
    }

    final requestBody = {
      "type": "control",
      "id": 1,
      "key": 1,
      "value": enable ? 1 : 0, // 1 = ON, 0 = OFF
    };

    final response = await ApiService.post<Map<String, dynamic>>(
      endpoint: mqttSchedulePost(uuid!),
      body: requestBody,
      fromJson: (json) => json as Map<String, dynamic>,
      includeToken: true,
    );

    if (!response.success) {
      throw Exception(
          response.errorMessage ?? 'Failed to update maintenance mode');
    }
  }

  void parseModbusMessage(String topic, Uint8List payloadBytes) {
    try {
      currentImei.value = ModbusDataParser.extractImei(topic);
      currentTopic.value = topic;

      final allParameters = ModbusDataParser.parseParameters(payloadBytes);

      // Update parameter 560 (RTC Time)
      if (559 < allParameters.length) {
        rtcTime.value = allParameters[559];
        print(
            '🕒 RTC Time (560): ${rtcTime.value} - Formatted: $formattedRtcTime');
      }

      // Update parameter 561 (number of boxes)
      if (561 < allParameters.length) {
        numberOfBoxes.value = allParameters[561];
      }

      // Update parameter 595 (Floot) with validation
      if (595 < allParameters.length) {
        floot.value = allParameters[595];
        print(
            '🌊 Floot (595): ${floot.value} - Status: ${flootStatus == HealthStatus.good ? "GOOD" : "CRITICAL"}');
      }

      // Update parameter 596 (Pressure) with validation
      if (596 < allParameters.length) {
        pressure.value = allParameters[596];
        print(
            '🔘 Pressure (596): ${pressure.value} - Status: ${pressureStatus == HealthStatus.good ? "GOOD" : "CRITICAL"}');
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

      print(
          '📊 Live data for ${numberOfBoxes.value} boxes, dummy (0) for remaining ${50 - numberOfBoxes.value} boxes');
      print(
          '📊 Additional Parameters - RTC: $formattedRtcTime, Floot: ${floot.value} (${flootStatus == HealthStatus.good ? "✅" : "❌"}), Pressure: ${pressure.value} (${pressureStatus == HealthStatus.good ? "✅" : "❌"})');
    } catch (e) {
      errorMessage.value = 'Error parsing MQTT message: $e';
    }
  }
}
