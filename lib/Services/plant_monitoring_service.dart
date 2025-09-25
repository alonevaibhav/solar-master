import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'dart:typed_data';
import '../services/notification_service.dart';
import '../services/data_parser.dart';

enum HealthStatus { good, warning, critical }

class PlantMonitoringService extends GetxService {
  static PlantMonitoringService get instance => Get.find<PlantMonitoringService>();

  // Only track notification states - no plant data stored
  final Map<String, bool> _waterNotified = {};
  final Map<String, bool> _pressureNotified = {};

  @override
  void onInit() {
    super.onInit();
    developer.log('PlantMonitoringService initialized', name: 'PlantMonitor');
  }

  // Process MQTT data for any plant
  void processMqttData(String topic, Uint8List payloadBytes) {
    try {
      final uuid = _extractUuidFromTopic(topic);
      if (uuid.isEmpty) return;

      final parameters = ModbusDataParser.parseParameters(payloadBytes);

      // Check floot (parameter 595)
      if (parameters.length > 595) {
        _checkWaterStatus(uuid, parameters[595]);
      }

      // Check pressure (parameter 596)
      if (parameters.length > 596) {
        _checkPressureStatus(uuid, parameters[596]);
      }

    } catch (e) {
      developer.log('Error processing MQTT: $e', name: 'PlantMonitor');
    }
  }

  void _checkWaterStatus(String uuid, int flootValue) {
    final isCurrentlyCritical = flootValue < 500;
    final key = '${uuid}_water';
    final wasNotified = _waterNotified[key] ?? false;

    if (isCurrentlyCritical && !wasNotified) {
      // Send critical notification
      NotificationService.instance.showNotification(
        title: "Water Critical",
        body: "Water empty for plant ${_getPlantName(uuid)}",
        priority: NotificationPriority.high,
      );
      _waterNotified[key] = true;
      developer.log('Water critical alert sent for $uuid', name: 'PlantMonitor');

    } else if (!isCurrentlyCritical && wasNotified) {
      // Reset notification state when status improves
      _waterNotified[key] = false;
      developer.log('Water status improved for $uuid', name: 'PlantMonitor');
    }
  }

  void _checkPressureStatus(String uuid, int pressureValue) {
    final isCurrentlyCritical = pressureValue < 500;
    final key = '${uuid}_pressure';
    final wasNotified = _pressureNotified[key] ?? false;

    if (isCurrentlyCritical && !wasNotified) {
      // Send critical notification
      NotificationService.instance.showNotification(
        title: "Pressure Critical",
        body: "High pressure for plant ${_getPlantName(uuid)}",
        priority: NotificationPriority.high,
      );
      _pressureNotified[key] = true;
      developer.log('Pressure critical alert sent for $uuid', name: 'PlantMonitor');

    } else if (!isCurrentlyCritical && wasNotified) {
      // Reset notification state when status improves
      _pressureNotified[key] = false;
      developer.log('Pressure status improved for $uuid', name: 'PlantMonitor');
    }
  }

  String _extractUuidFromTopic(String topic) {
    try {
      // Extract UUID from MQTT topic format
      final parts = topic.split('/');
      return parts.length > 1 ? parts[1] : '';
    } catch (e) {
      return '';
    }
  }

  String _getPlantName(String uuid) {
    // Just return last 6 chars of UUID for display
    return uuid.length > 6 ? uuid.substring(uuid.length - 6) : uuid;
  }

  // Clear notification states (for testing/reset)
  void clearNotificationStates() {
    _waterNotified.clear();
    _pressureNotified.clear();
    developer.log('Notification states cleared', name: 'PlantMonitor');
  }
}