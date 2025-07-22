// In your main app initialization
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Controller/Inspector/automatic_controller.dart';
import '../Controller/Inspector/manual_controller.dart';
import 'mqtt-service.dart';

class AppInitializer {
  static late SolarMQTTService mqttService;
  static late ModbusParametersController modbusController;
  static late ManualController manualController;

  static Future<void> initialize() async {
    // Initialize both controllers
    modbusController = Get.put(ModbusParametersController());
    manualController = Get.put(ManualController());

    // Initialize MQTT service with direct integration
    mqttService = SolarMQTTService(
      onDataReceived: (String topic, Uint8List payload) {
        // Directly parse MQTT data when received
        modbusController.parseModbusMessage(topic, payload);
        manualController.parseManualMessage(topic, payload);
      },
      onConnectionChanged: (bool isConnected) {
        print('MQTT Connection status: $isConnected');
      },
      onError: (String error) {
        print('MQTT Error: $error');
      },
    );

    await mqttService.initialize();
    await mqttService.connect();
    await mqttService.subscribe('vidani/vm/862360073414729/data');
  }
}

