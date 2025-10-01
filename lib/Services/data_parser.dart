// import 'dart:typed_data';
//
// /// A utility class for parsing Modbus data from binary payloads
// class ModbusDataParser {
//   /// Parses and prints MQTT message containing Modbus data
//   ///
//   /// [topic] - The MQTT topic from which the message was received
//   /// [payloadBytes] - The binary payload containing Modbus data
//   static void parseAndPrintMessage(String topic, Uint8List payloadBytes) {
//     try {
//       // Extract IMEI from topic (vidani/vm/862360073414729/data)
//       final parts = topic.split('/');
//       final imei = parts.length > 2 ? parts[2] : 'Unknown';
//
//       print('📨 Received message on $topic');
//       print('127.0.0.1 - Received MQTT message on topic: $topic, size: ${payloadBytes.length} bytes');
//       print('📊 Parsing data for IMEI: $imei, Buffer length: ${payloadBytes.length}');
//       print('🔧 Parsed Modbus Data:');
//       print('📱 IMEI: $imei');
//       print('⏰ Timestamp: ${DateTime.now().toIso8601String()}');
//       print('📊 Parameters:');
//
//       // Parse binary data with indexing
//       int varIndex = 0;
//
//       for (int index = 0; index < 1400 && index < payloadBytes.length - 1;) {
//         final f = payloadBytes[index];
//         final l = payloadBytes[++index];
//         final value = f * 256 + l;
//
//         final paramIndex = (++index ~/ 2);
//
//         // print('    $varIndex: Parameter $varIndex = $value');
//         varIndex++;
//
//         // Show first 10 parameters, then summarize
//         if (varIndex >= 1) {
//           final totalParams = (payloadBytes.length / 2).floor();
//           print('   ... and ${totalParams - 10} more parameters (total: $totalParams parameters)');
//           break;
//         }
//       }
//
//       print(''); // Empty line for readability
//
//     } catch (e) {
//       print('❌ Error parsing message: $e');
//     }
//   }
//
//   /// Extracts IMEI from MQTT topic
//   ///
//   /// [topic] - The MQTT topic in format: vidani/vm/{imei}/data
//   /// Returns the IMEI string or 'Unknown' if not found
//   static String extractImei(String topic) {
//     final parts = topic.split('/');
//     return parts.length > 2 ? parts[2] : 'Unknown';
//   }
//
//   /// Parses binary payload and returns a list of parameter values
//   ///
//   /// [payloadBytes] - The binary payload to parse
//   /// Returns a list of integer values parsed from the binary data
//   static List<int> parseParameters(Uint8List payloadBytes) {
//     final parameters = <int>[];
//
//     try {
//       for (int index = 0; index < 1400 && index < payloadBytes.length - 1;) {
//         final f = payloadBytes[index];
//         final l = payloadBytes[++index];
//         final value = f * 256 + l;
//         parameters.add(value);
//         index++;
//       }
//     } catch (e) {
//       print('❌ Error parsing parameters: $e');
//     }
//
//     return parameters;
//   }
// }

import 'dart:typed_data';
import 'dart:developer' as developer;

/// A utility class for parsing Modbus data from binary payloads
class ModbusDataParser {
  /// Parses and prints MQTT message containing Modbus data
  ///
  /// [topic] - The MQTT topic from which the message was received
  /// [payloadBytes] - The binary payload containing Modbus data
  static void parseAndPrintMessage(String topic, Uint8List payloadBytes) {
    try {
      // Extract IMEI from topic (vidani/vm/862360073414729/data)
      final parts = topic.split('/');
      final imei = parts.length > 2 ? parts[2] : 'Unknown';

      developer.log('Received message on $topic', name: 'ModbusParser');
      developer.log('127.0.0.1 - Received MQTT message on topic: $topic, size: ${payloadBytes.length} bytes',
        name: 'ModbusParser',
      );
      developer.log(
        'Parsing data for IMEI: $imei, Buffer length: ${payloadBytes.length}',
        name: 'ModbusParser',
      );
      developer.log('Parsed Modbus Data:', name: 'ModbusParser');
      developer.log('IMEI: $imei', name: 'ModbusParser');
      developer.log('Timestamp: ${DateTime.now().toIso8601String()}', name: 'ModbusParser');
      developer.log('Parameters:', name: 'ModbusParser');

      // Parse binary data with indexing
      int varIndex = 0;

      for (int index = 0; index < 1400 && index < payloadBytes.length - 1;) {
        final f = payloadBytes[index];
        final l = payloadBytes[++index];
        final value = f * 256 + l;

        final paramIndex = (++index ~/ 2);

        // developer.log('    $varIndex: Parameter $varIndex = $value', name: 'ModbusParser');
        varIndex++;

        // Show first 10 parameters, then summarize
        if (varIndex >= 1) {
          final totalParams = (payloadBytes.length / 2).floor();
          developer.log(
            '... and ${totalParams - 10} more parameters (total: $totalParams parameters)',
            name: 'ModbusParser',
          );
          break;
        }
      }

      developer.log('', name: 'ModbusParser'); // Empty line for readability

    } catch (e, stackTrace) {
      developer.log(
        'Error parsing message: $e',
        name: 'ModbusParser',
        error: e,
        stackTrace: stackTrace,
        level: 1000,
      );
    }
  }

  /// Extracts IMEI from MQTT topic
  ///
  /// [topic] - The MQTT topic in format: vidani/vm/{imei}/data
  /// Returns the IMEI string or 'Unknown' if not found
  static String extractImei(String topic) {
    final parts = topic.split('/');
    return parts.length > 2 ? parts[2] : 'Unknown';
  }

  /// Parses binary payload and returns a list of parameter values
  ///
  /// [payloadBytes] - The binary payload to parse
  /// Returns a list of integer values parsed from the binary data
  static List<int> parseParameters(Uint8List payloadBytes) {
    final parameters = <int>[];

    try {
      for (int index = 0; index < 1400 && index < payloadBytes.length - 1;) {
        final f = payloadBytes[index];
        final l = payloadBytes[++index];
        final value = f * 256 + l;
        parameters.add(value);
        index++;
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error parsing parameters: $e',
        name: 'ModbusParser',
        error: e,
        stackTrace: stackTrace,
        level: 1000,
      );
    }

    return parameters;
  }
}