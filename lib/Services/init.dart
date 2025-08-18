// import 'dart:typed_data';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import '../Controller/Cleaner/info_plantC_controller.dart';
// import '../Controller/Inspector/automatic_controller.dart';
// import '../Controller/Inspector/info_plant_detail_controller.dart';
// import '../Controller/Inspector/manual_controller.dart';
// import '../View/Cleaner/CleanupManegment/cleanup_controller.dart';
// import 'mqtt-service.dart';
//
// class AppInitializer {
//   static SolarMQTTService? mqttService;
//   static late ModbusParametersController modbusController;
//   static late ManualController manualController;
//   static late CleaningManagementController cleaningManagementController;
//   static late InfoPlantDetailController infoPlantDetailController;
//   static late InfoPlantCleanerDetailController infoPlantCleanerDetailController;
//   static bool _isInitialized = false;
//
//   static Future<void> initialize({String? uuid}) async {
//     if (_isInitialized) return;
//
//     // Initialize both controllers
//     modbusController = Get.put(ModbusParametersController());
//     manualController = Get.put(ManualController());
//     cleaningManagementController = Get.put(CleaningManagementController());
//     infoPlantDetailController = Get.put(InfoPlantDetailController());
//     infoPlantCleanerDetailController = Get.put(InfoPlantCleanerDetailController());
//
//     _isInitialized = true;
//   }
//
//   // Method to initialize MQTT with specific UUID
//   static Future<void> reinitializeWithUUID(String uuid) async {
//     try {
//       // Disconnect existing connection if any
//       if (mqttService != null) {
//         // Check if mqttService exists before disconnecting
//         mqttService!.disconnect();
//         mqttService = null; // Clear the reference
//       }
//
//       // Initialize MQTT service with the specific UUID
//       mqttService = SolarMQTTService(
//         onDataReceived: (String topic, Uint8List payload) {
//           modbusController.parseModbusMessage(topic, payload);
//           manualController.parseManualMessage(topic, payload);
//           cleaningManagementController.parseCleanerMessage(topic, payload);
//           infoPlantDetailController.parseModbusMessage(topic, payload);
//           infoPlantCleanerDetailController.parseModbusMessage(topic, payload);
//         },
//         onConnectionChanged: (bool isConnected) {
//           print('MQTT Connection status: $isConnected for UUID: $uuid');
//         },
//         onError: (String error) {
//           print('MQTT Error: $error');
//         },
//       );
//
//       await mqttService!.initialize();
//       await mqttService!.connect();
//       await mqttService!.subscribe('vidani/vm/$uuid/data');
//     } catch (e) {
//       print('❌ Error reinitializing MQTT: $e');
//       throw e;
//     }
//   }
//
//   // Optional: Method to safely disconnect MQTT
//   static Future<void> disconnectMQTT() async {
//     if (mqttService != null) {
//       mqttService!.disconnect();
//       mqttService = null;
//     }
//   }
//
//   // Optional: Method to check if MQTT is connected
//   static bool get isMQTTConnected {
//     return mqttService?.isConnected ?? false;
//   }
//
// }
//
//
//
//
//
//
//


// 6. UPDATED AppInitializer with controller clearing



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
  static String? _currentUUID;
  static bool _isReconnecting = false;

  static Future<void> initialize({String? uuid}) async {
    if (_isInitialized) return;

    modbusController = Get.put(ModbusParametersController());
    manualController = Get.put(ManualController());
    cleaningManagementController = Get.put(CleaningManagementController());
    infoPlantDetailController = Get.put(InfoPlantDetailController());
    infoPlantCleanerDetailController = Get.put(InfoPlantCleanerDetailController());

    _isInitialized = true;
  }

  static Future<void> reinitializeWithUUID(String uuid) async {
    if (_isReconnecting) {
      print('⚠️ MQTT reinitializtion already in progress, skipping...');
      return;
    }

    if (_currentUUID == uuid && mqttService != null && mqttService!.isConnected) {
      print('✅ Already connected to UUID: $uuid');
      return;
    }

    _isReconnecting = true;

    try {
      print('🔄 Reinitializing MQTT for UUID: $uuid');

      // Step 1: Cleanup previous MQTT connection
      await _cleanupMQTTConnection();

      // Step 2: 🔥 CLEAR ALL CONTROLLER DATA (THE FIX!)
      await _clearAllControllerData();

      // Step 3: Wait for cleanup
      await Future.delayed(Duration(milliseconds: 500));

      // Step 4: Initialize new MQTT service
      mqttService = SolarMQTTService(
        onDataReceived: (String topic, Uint8List payload) {
          if (_currentUUID == uuid) {
            modbusController.parseModbusMessage(topic, payload);
            manualController.parseManualMessage(topic, payload);
            cleaningManagementController.parseCleanerMessage(topic, payload);
            infoPlantDetailController.parseModbusMessage(topic, payload);
            infoPlantCleanerDetailController.parseModbusMessage(topic, payload);
          }
        },
        onConnectionChanged: (bool isConnected) {
          print('MQTT Connection status: $isConnected for UUID: $uuid');
          if (!isConnected && _currentUUID == uuid) {
            print('⚠️ Lost connection for current UUID: $uuid');
          }
        },
        onError: (String error) {
          print('MQTT Error for UUID $uuid: $error');
        },
      );

      // Step 5: Connect and subscribe
      await mqttService!.initialize();
      await mqttService!.connect();
      await mqttService!.subscribe('vidani/vm/$uuid/data');

      _currentUUID = uuid;

      print('✅ MQTT successfully initialized and connected for UUID: $uuid');

    } catch (e) {
      print('❌ Error reinitializing MQTT for UUID $uuid: $e');
      await _cleanupMQTTConnection();
      throw e;
    } finally {
      _isReconnecting = false;
    }
  }

  // 🔥 THE KEY FIX: Clear all controller data
  static Future<void> _clearAllControllerData() async {
    try {
      print('🧹 Clearing all controller data for UI reset...');

      // Clear each controller's data
      if (Get.isRegistered<ModbusParametersController>()) {
        modbusController.clearData();
      }
      //
      if (Get.isRegistered<ManualController>()) {
        manualController.clearData();
      }
      //
      if (Get.isRegistered<CleaningManagementController>()) {
        cleaningManagementController.clearData();
      }
      //
      if (Get.isRegistered<InfoPlantDetailController>()) {
        infoPlantDetailController.clearData();
      }

      if (Get.isRegistered<InfoPlantCleanerDetailController>()) {
        infoPlantCleanerDetailController.clearData();
      }

      print('✅ All controller data cleared - UI will show fresh state');
    } catch (e) {
      print('⚠️ Error clearing controller data: $e');
    }
  }

  static Future<void> _cleanupMQTTConnection() async {
    if (mqttService != null) {
      try {
        print('🧹 Cleaning up previous MQTT connection...');

        if (_currentUUID != null) {
          await mqttService!.unsubscribe('vidani/vm/$_currentUUID/data');
        }

        mqttService!.disconnect();
        print('✅ Previous MQTT connection cleaned up successfully');
      } catch (e) {
        print('⚠️ Error during MQTT cleanup: $e');
      } finally {
        mqttService = null;
        _currentUUID = null;
      }
    }
  }

  static Future<void> disconnectMQTT() async {
    _isReconnecting = false;
    await _cleanupMQTTConnection();
    await _clearAllControllerData();
  }

  static bool get isMQTTConnected {
    return mqttService?.isConnected ?? false;
  }

  static String? get currentUUID {
    return _currentUUID;
  }

  static Future<void> forceReset() async {
    _isReconnecting = false;
    await _cleanupMQTTConnection();
    await _clearAllControllerData();
    print('🔄 Force reset completed');
  }
}