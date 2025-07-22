import 'dart:io';
import 'dart:typed_data';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:typed_data/src/typed_buffer.dart';

import 'data_parser.dart';

/// Enhanced MQTT Service for Solar applications with terminal output
class SolarMQTTService {
  late MqttServerClient client;
  bool _isConnected = false;

  // Connection parameters
  static const String _host = 'mc.vidaniautomations.com';
  static const int _port = 20011;
  static const String _username = 'z';
  static const String _password = '2acc';
  static String get _clientId => 'solar_${DateTime.now().millisecondsSinceEpoch}';

  // Callback functions
  Function(bool isConnected)? onConnectionChanged;
  Function(String error)? onError;
  Function(String topic, Uint8List payload)? onDataReceived;

  SolarMQTTService({
    this.onConnectionChanged,
    this.onError,
    this.onDataReceived,
  });

  /// Initializes the MQTT client with connection settings
  Future<void> initialize() async {
    try {
      client = MqttServerClient.withPort(_host, _clientId, _port);

      client.secure = false;
      client.securityContext = SecurityContext.defaultContext;
      client.keepAlivePeriod = 60;
      client.autoReconnect = true;
      client.resubscribeOnAutoReconnect = true;

      client.connectionMessage = MqttConnectMessage()
          .withClientIdentifier(_clientId)
          .authenticateAs(_username, _password)
          .startClean()
          .withWillQos(MqttQos.atLeastOnce);

      client.logging(on: false); // Disable MQTT library logging for cleaner terminal output

      client.onConnected = _onConnected;
      client.onDisconnected = _onDisconnected;

      print('MQTT Client initialized successfully');
    } catch (e) {
      print('Failed to initialize MQTT client: $e');
      onError?.call('Initialization failed: $e');
      rethrow;
    }
  }

  Future<bool> connect() async {
    try {
      print('Connecting to MQTT broker at $_host:$_port...');
      await client.connect(_username, _password);

      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        print('✅ Connected successfully to MQTT broker');
        _isConnected = true;
        onConnectionChanged?.call(true);

        // Set up message listener for binary data
        client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
          _handleIncomingBinaryMessage(c);
        });

        return true;
      } else {
        print('❌ Connection failed: ${client.connectionStatus}');
        _isConnected = false;
        onConnectionChanged?.call(false);
        return false;
      }
    } catch (e) {
      print('❌ Connection error: $e');
      _isConnected = false;
      onConnectionChanged?.call(false);
      return false;
    }
  }


  Future<bool> subscribe(String topic) async {
    if (!_isConnected) {
      print('Cannot subscribe: Not connected to broker');
      return false;
    }

    try {
      client.subscribe(topic, MqttQos.atMostOnce);
      print('✅ Subscribed to topic: $topic');
      return true;
    } catch (e) {
      print('❌ Failed to subscribe to $topic: $e');
      return false;
    }
  }

  /// Unsubscribes from an MQTT topic
  /// 
  /// [topic] - The MQTT topic to unsubscribe from
  /// Returns true if unsubscription is successful, false otherwise
  Future<bool> unsubscribe(String topic) async {
    if (!_isConnected) {
      print('Cannot unsubscribe: Not connected to broker');
      return false;
    }

    try {
      client.unsubscribe(topic);
      print('Unsubscribed from topic: $topic');
      return true;
    } catch (e) {
      print('Failed to unsubscribe from $topic: $e');
      onError?.call('Failed to unsubscribe from $topic: $e');
      return false;
    }
  }


  Future<bool> publish(String topic, String message,
      {MqttQos qos = MqttQos.atMostOnce}) async {
    if (!_isConnected) {
      print('Cannot publish: Not connected to broker');
      onError?.call('Cannot publish: Not connected');
      return false;
    }

    try {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);

      client.publishMessage(topic, qos, builder.payload!);
      print('Published message to $topic: $message');
      return true;
    } catch (e) {
      print('Failed to publish to $topic: $e');
      onError?.call('Failed to publish to $topic: $e');
      return false;
    }
  }

  Future<bool> publishBinary(String topic, Uint8List data,
      {MqttQos qos = MqttQos.atMostOnce}) async {
    if (!_isConnected) {
      print('Cannot publish: Not connected to broker');
      onError?.call('Cannot publish: Not connected');
      return false;
    }

    try {
      final builder = MqttClientPayloadBuilder();
      builder.addBuffer(data as Uint8Buffer);

      client.publishMessage(topic, qos, builder.payload!);
      print('Published binary data to $topic (${data.length} bytes)');
      return true;
    } catch (e) {
      print('Failed to publish binary data to $topic: $e');
      onError?.call('Failed to publish binary data to $topic: $e');
      return false;
    }
  }

  void _onConnected() {
    print('MQTT client connected');
    _isConnected = true;
    onConnectionChanged?.call(true);
  }

  void _onDisconnected() {
    print('MQTT client disconnected');
    _isConnected = false;
    onConnectionChanged?.call(false);
  }

  void _handleIncomingBinaryMessage(List<MqttReceivedMessage<MqttMessage?>>? messages) {
    if (messages == null || messages.isEmpty) return;

    for (final message in messages) {
      final recMess = message.payload as MqttPublishMessage;
      final topic = message.topic;
      final payloadBytes = Uint8List.fromList(recMess.payload.message);

      // Call custom callback if provided
      onDataReceived?.call(topic, payloadBytes);

      // Parse and print to terminal using ModbusDataParser
      ModbusDataParser.parseAndPrintMessage(topic, payloadBytes);
    }
  }

  /// Disconnects from the MQTT broker
  void disconnect() {
    if (_isConnected) {
      client.disconnect();
      print('Disconnected from MQTT broker');
    }
  }

  /// Gets the current connection status
  bool get isConnected => _isConnected;

  /// Gets the current connection status as a string
  String get connectionStatus {
    if (_isConnected) {
      return 'Connected to $_host:$_port';
    } else {
      return client.connectionStatus?.toString() ?? 'Disconnected';
    }
  }

  /// Gets the current client ID
  String get clientId => _clientId;

  /// Gets the broker host
  String get host => _host;

  /// Gets the broker port
  int get port => _port;

  /// Disposes of the service and disconnects from the broker
  void dispose() {
    disconnect();
  }
}