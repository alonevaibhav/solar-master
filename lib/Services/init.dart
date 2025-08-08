import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Controller/Cleaner/info_plantC_controller.dart';
import '../Controller/Inspector/automatic_controller.dart';
import '../Controller/Inspector/info_plant_detail_controller.dart';
import '../Controller/Inspector/manual_controller.dart';
import '../View/Cleaner/CleanupManegment/cleanup_controller.dart';
import 'mqtt-service.dart';

class AppInitializer {
  static SolarMQTTService? mqttService;
  static late ModbusParametersController modbusController;
  static late ManualController manualController;
  static late CleaningManagementController cleaningManagementController;
  static late InfoPlantDetailController infoPlantDetailController;
  static late InfoPlantCleanerDetailController infoPlantCleanerDetailController;
  static bool _isInitialized = false;

  static Future<void> initialize({String? uuid}) async {
    if (_isInitialized) return;

    // Initialize both controllers
    modbusController = Get.put(ModbusParametersController());
    manualController = Get.put(ManualController());
    cleaningManagementController = Get.put(CleaningManagementController());
    infoPlantDetailController = Get.put(InfoPlantDetailController());
    infoPlantCleanerDetailController = Get.put(InfoPlantCleanerDetailController());

    _isInitialized = true;
  }

  // Method to initialize MQTT with specific UUID
  static Future<void> reinitializeWithUUID(String uuid) async {
    try {
      // Disconnect existing connection if any
      if (mqttService != null) {
        // Check if mqttService exists before disconnecting
        mqttService!.disconnect();
        mqttService = null; // Clear the reference
      }

      // Initialize MQTT service with the specific UUID
      mqttService = SolarMQTTService(
        onDataReceived: (String topic, Uint8List payload) {
          modbusController.parseModbusMessage(topic, payload);
          manualController.parseManualMessage(topic, payload);
          cleaningManagementController.parseCleanerMessage(topic, payload);
          infoPlantDetailController.parseModbusMessage(topic, payload);
          infoPlantCleanerDetailController.parseModbusMessage(topic, payload);
        },
        onConnectionChanged: (bool isConnected) {
          print('MQTT Connection status: $isConnected for UUID: $uuid');
        },
        onError: (String error) {
          print('MQTT Error: $error');
        },
      );

      await mqttService!.initialize();
      await mqttService!.connect();
      await mqttService!.subscribe('vidani/vm/$uuid/data');
    } catch (e) {
      print('❌ Error reinitializing MQTT: $e');
      throw e;
    }
  }

  // Optional: Method to safely disconnect MQTT
  static Future<void> disconnectMQTT() async {
    if (mqttService != null) {
      mqttService!.disconnect();
      mqttService = null;
    }
  }

  // Optional: Method to check if MQTT is connected
  static bool get isMQTTConnected {
    return mqttService?.isConnected ?? false;
  }

}
