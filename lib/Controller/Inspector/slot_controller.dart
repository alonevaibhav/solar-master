// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import '../../API Service/api_service.dart';
// import '../../Controller/Inspector/manual_controller.dart';
// import '../../utils/constants.dart';
//
// class SlotController extends GetxController {
//   String? uuid;
//
//   SlotController();
//
//   void setUuid(String? newUuid) {
//     uuid = newUuid;
//     print("UUID set to: $uuid");
//   }
//
//   void printUuidInfo() {
//     print("=== UUID Information In Slot ===");
//     print("UUID: ${uuid ?? 'NULL'}");
//     print("Is UUID null: ${uuid == null}");
//     print("Is UUID empty: ${uuid?.isEmpty ?? true}");
//     print("UUID length: ${uuid?.length ?? 0}");
//     print("========================");
//   }
//
//   final List<Map<String, String>> slots = [
//     {'code': '550', 'description': 'slot 1 on time'},
//     {'code': '554', 'description': 'slot 1 off time'},
//     {'code': '551', 'description': 'slot 2 on time'},
//     {'code': '555', 'description': 'slot 2 off time'},
//     {'code': '552', 'description': 'slot 3 on time'},
//     {'code': '556', 'description': 'slot 3 off time'},
//     {'code': '553', 'description': 'slot 4 on time'},
//     {'code': '557', 'description': 'slot 4 off time'},
//   ].obs;
//
//   // Observable for tracking edit mode
//   var isEditMode = false.obs;
//
//   // Observable for API loading state
//   var isSaving = false.obs;
//
//   // Track modified slots - Make this observable
//   var modifiedSlots = <String>{}.obs;
//
//   // Add refresh trigger for UI updates
//   var refreshTrigger = 0.obs;
//
//   // Store original values to revert if needed
//   var originalValues = <String, String>{};
//
//   // NEW: Store modified values locally (this is the key fix)
//   var modifiedValues = <String, int>{}.obs;
//
//   // Mapping of slot codes to their modbus command prefixes
//   final Map<String, String> slotCommandMap = {
//     '550': '100', // Slot 1 ON
//     '551': '101', // Slot 2 ON
//     '552': '102', // Slot 3 ON
//     '553': '103', // Slot 4 ON
//     '554': '104', // Slot 1 OFF
//     '555': '105', // Slot 2 OFF
//     '556': '106', // Slot 3 OFF
//     '557': '107', // Slot 4 OFF
//   };
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Store original values when controller initializes
//     _storeOriginalValues();
//   }
//
//   void _storeOriginalValues() {
//     final ManualController manualController = Get.find<ManualController>();
//     originalValues.clear();
//     for (var slot in manualController.slotTimingsForDisplay) {
//       originalValues[slot['code'].toString()] = slot['value'].toString();
//     }
//   }
//
//   // Helper function to convert seconds to HH:MM:SS format
//   String formatSeconds(dynamic secondsValue) {
//     final seconds = secondsValue is String
//         ? int.tryParse(secondsValue) ?? 0
//         : secondsValue is int
//             ? secondsValue
//             : 0;
//
//     if (seconds < 0) return '00:00:00';
//
//     final hours = (seconds / 3600).truncate();
//     final minutes = ((seconds % 3600) / 60).truncate();
//     final remainingSeconds = seconds % 60;
//
//     return '${hours.toString().padLeft(2, '0')}:'
//         '${minutes.toString().padLeft(2, '0')}:'
//         '${remainingSeconds.toString().padLeft(2, '0')}';
//   }
//
//   // Helper function to convert HH:MM:SS format to seconds
//   int timeToSeconds(String timeString) {
//     final parts = timeString.split(':');
//     if (parts.length != 3) return 0;
//
//     final hours = int.tryParse(parts[0]) ?? 0;
//     final minutes = int.tryParse(parts[1]) ?? 0;
//     final seconds = int.tryParse(parts[2]) ?? 0;
//
//     return (hours * 3600) + (minutes * 60) + seconds;
//   }
//
//   // Toggle edit mode
//   void toggleEditMode() {
//     isEditMode.value = !isEditMode.value;
//     if (!isEditMode.value) {
//       // If exiting edit mode, clear modifications
//       modifiedSlots.clear();
//       modifiedValues.clear(); // Clear local values too
//     } else {
//       // Store original values when entering edit mode
//       _storeOriginalValues();
//     }
//     // Trigger UI refresh
//     refreshTrigger.value++;
//   }
//
//   // NEW: Get the current value for a slot (either modified or original)
//   int getCurrentSlotValue(String slotCode) {
//     // If we have a modified value, return that
//     if (modifiedValues.containsKey(slotCode)) {
//       return modifiedValues[slotCode]!;
//     }
//
//     // Otherwise, get from the manual controller
//     final ManualController manualController = Get.find<ManualController>();
//     final slot = manualController.slotTimingsForDisplay.firstWhere(
//       (s) => s['code'].toString() == slotCode,
//       orElse: () => {'value': 0},
//     );
//
//     final value = slot['value'];
//     if (value is String) {
//       return int.tryParse(value) ?? 0;
//     } else if (value is int) {
//       return value;
//     } else if (value is double) {
//       return value.toInt();
//     }
//     return 0;
//   }
//
//   // Future<void> saveChanges() async {
//   //   print('Entering saveChanges function');
//   //
//   //   if (modifiedSlots.isEmpty) {
//   //     print('No modified slots to save');
//   //     Get.snackbar(
//   //       'No Changes',
//   //       'No slot timings have been modified',
//   //       snackPosition: SnackPosition.BOTTOM,
//   //       backgroundColor: Colors.orange,
//   //       colorText: Colors.white,
//   //     );
//   //     return;
//   //   }
//   //
//   //   try {
//   //     isSaving.value = true;
//   //     print('Retrieving authentication token');
//   //     final token = await getToken();
//   //
//   //     if (token == null || token.isEmpty) {
//   //       print('Authentication token is null or empty');
//   //       throw Exception('Authentication token not found. Please login again.');
//   //     }
//   //
//   //     int successCount = 0;
//   //     List<String> failedSlots = [];
//   //
//   //     for (String slotCode in modifiedSlots) {
//   //       try {
//   //         print('Processing slot: $slotCode');
//   //
//   //         // Use the locally stored modified value
//   //         int secondsValue = modifiedValues[slotCode] ?? 0;
//   //
//   //         print('Using modified value for slot $slotCode: $secondsValue');
//   //
//   //         final commandPrefix = slotCommandMap[slotCode];
//   //
//   //         if (commandPrefix == null) {
//   //           throw Exception('Unknown slot code: $slotCode');
//   //         }
//   //
//   //         final paddedSeconds = secondsValue.toString().padLeft(5, '0');
//   //         final modbusValue = '$commandPrefix,001,001,$paddedSeconds,600';
//   //
//   //         print('Sending data for slot $slotCode: $modbusValue');
//   //
//   //         final requestBody = {
//   //           "type": "config",
//   //           "id": 1,
//   //           "key": "modbus",
//   //           "value": modbusValue,
//   //         };
//   //
//   //         final headers = {
//   //           'Content-Type': 'application/json',
//   //           'Authorization': 'Bearer $token',
//   //         };
//   //
//   //         final response = await http
//   //             .post(
//   //               Uri.parse(
//   //                   'https://smartsolarcleaner.com/api/api/mqtt/publish/$uuid'),
//   //               headers: headers,
//   //               body: jsonEncode(requestBody),
//   //             )
//   //             .timeout(const Duration(seconds: 30));
//   //
//   //         if (response.statusCode == 200) {
//   //           successCount++;
//   //           print('Successfully updated slot $slotCode');
//   //         } else {
//   //           failedSlots.add(slotCode);
//   //           print(
//   //               'Failed to update slot $slotCode: ${response.statusCode} - ${response.body}');
//   //         }
//   //
//   //         await Future.delayed(Duration(milliseconds: 500));
//   //       } catch (e) {
//   //         failedSlots.add(slotCode);
//   //         print('Error updating slot $slotCode: $e');
//   //       }
//   //     }
//   //
//   //     // Handle success/failure
//   //     if (failedSlots.isEmpty) {
//   //       print('All slots updated successfully');
//   //       modifiedSlots.clear();
//   //       modifiedValues.clear(); // Clear local values after successful save
//   //       isEditMode.value = false;
//   //       Get.snackbar(
//   //         'Success',
//   //         'All $successCount slot timing(s) updated successfully',
//   //         snackPosition: SnackPosition.BOTTOM,
//   //         backgroundColor: Colors.green,
//   //         colorText: Colors.white,
//   //         duration: Duration(seconds: 3),
//   //       );
//   //     } else if (successCount > 0) {
//   //       print('Some slots failed to update');
//   //       // Only remove successfully updated slots from modified tracking
//   //       for (String slotCode in List.from(modifiedSlots)) {
//   //         if (!failedSlots.contains(slotCode)) {
//   //           modifiedSlots.remove(slotCode);
//   //           modifiedValues.remove(slotCode);
//   //         }
//   //       }
//   //       Get.snackbar(
//   //         'Partial Success',
//   //         '$successCount updated, ${failedSlots.length} failed. Failed slots: ${failedSlots.join(", ")}',
//   //         snackPosition: SnackPosition.BOTTOM,
//   //         backgroundColor: Colors.orange,
//   //         colorText: Colors.white,
//   //         duration: Duration(seconds: 4),
//   //       );
//   //     } else {
//   //       print('All slots failed to update');
//   //       throw Exception(
//   //           'Failed to update any slot timings. Failed slots: ${failedSlots.join(", ")}');
//   //     }
//   //   } on TimeoutException {
//   //     print('Request timed out');
//   //     throw Exception('Request timed out. Please try again.');
//   //   } catch (e) {
//   //     print('Exception in saveChanges: $e');
//   //     Get.snackbar(
//   //       'Save Error',
//   //       e.toString(),
//   //       snackPosition: SnackPosition.BOTTOM,
//   //       backgroundColor: Colors.red,
//   //       colorText: Colors.white,
//   //       duration: const Duration(seconds: 4),
//   //     );
//   //   } finally {
//   //     isSaving.value = false;
//   //     print('Exiting saveChanges function');
//   //   }
//   // }
//
//   // Get authentication token from SharedPreferences
//
//   Future<void> saveChanges() async {
//     print('Entering saveChanges function');
//
//     if (modifiedSlots.isEmpty) {
//       print('No modified slots to save');
//       Get.snackbar(
//         'No Changes',
//         'No slot timings have been modified',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     try {
//       isSaving.value = true;
//       print('Starting save process using ApiService');
//
//       int successCount = 0;
//       List<String> failedSlots = [];
//
//       for (String slotCode in modifiedSlots) {
//         try {
//           print('Processing slot: $slotCode');
//
//           // Use the locally stored modified value
//           int secondsValue = modifiedValues[slotCode] ?? 0;
//           print('Using modified value for slot $slotCode: $secondsValue');
//
//           final commandPrefix = slotCommandMap[slotCode];
//           if (commandPrefix == null) {
//             throw Exception('Unknown slot code: $slotCode');
//           }
//
//           final paddedSeconds = secondsValue.toString().padLeft(5, '0');
//           final modbusValue = '$commandPrefix,001,001,$paddedSeconds,600';
//
//           print('Sending data for slot $slotCode: $modbusValue');
//
//           final requestBody = {
//             "type": "config",
//             "id": 1,
//             "key": "modbus",
//             "value": modbusValue,
//           };
//
//           // Use ApiService instead of direct HTTP calls
//           final response = await ApiService.post<Map<String, dynamic>>(
//             endpoint: mqttSchedulePost(uuid!),
//             body: requestBody,
//             fromJson: (json) => json as Map<String, dynamic>,
//             includeToken: true,
//           );
//
//           if (response.success) {
//             successCount++;
//             print('Successfully updated slot $slotCode');
//           } else {
//             failedSlots.add(slotCode);
//             print(
//                 'Failed to update slot $slotCode: ${response.statusCode} - ${response.errorMessage}');
//           }
//
//           // Add delay between requests
//           await Future.delayed(Duration(milliseconds: 500));
//         } catch (e) {
//           failedSlots.add(slotCode);
//           print('Error updating slot $slotCode: $e');
//         }
//       }
//
//       // Handle success/failure
//       if (failedSlots.isEmpty) {
//         print('All slots updated successfully');
//         modifiedSlots.clear();
//         modifiedValues.clear(); // Clear local values after successful save
//         isEditMode.value = false;
//         Get.snackbar(
//           'Success',
//           'All $successCount slot timing(s) updated successfully',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//           duration: Duration(seconds: 3),
//         );
//       } else if (successCount > 0) {
//         print('Some slots failed to update');
//         // Only remove successfully updated slots from modified tracking
//         for (String slotCode in List.from(modifiedSlots)) {
//           if (!failedSlots.contains(slotCode)) {
//             modifiedSlots.remove(slotCode);
//             modifiedValues.remove(slotCode);
//           }
//         }
//         Get.snackbar(
//           'Partial Success',
//           '$successCount updated, ${failedSlots.length} failed. Failed slots: ${failedSlots.join(", ")}',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.orange,
//           colorText: Colors.white,
//           duration: Duration(seconds: 4),
//         );
//       } else {
//         print('All slots failed to update');
//         throw Exception(
//             'Failed to update any slot timings. Failed slots: ${failedSlots.join(", ")}');
//       }
//     } catch (e) {
//       print('Exception in saveChanges: $e');
//       Get.snackbar(
//         'Save Error',
//         e.toString(),
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 4),
//       );
//     } finally {
//       isSaving.value = false;
//       print('Exiting saveChanges function');
//     }
//   }
//
//   // Cancel editing - revert to original values
//   void cancelEdit() {
//     // Clear any unsaved changes and reset modified tracking
//     modifiedSlots.clear();
//     modifiedValues.clear(); // Clear local values
//     isEditMode.value = false;
//     refreshTrigger.value++; // Trigger UI refresh
//
//     Get.snackbar(
//       'Cancelled',
//       'Changes discarded',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.grey,
//       colorText: Colors.white,
//       duration: Duration(seconds: 2),
//     );
//   }
//
//   // FIXED: Update slot value and track modification
//   void updateSlotValue(Map<String, dynamic> slot, int newSeconds) {
//     final slotCode = slot['code'].toString();
//
//     print('=== UPDATE SLOT DEBUG ===');
//     print('Updating slot: $slotCode with newSeconds: $newSeconds');
//
//     // Store the modified value locally (this is the key fix)
//     modifiedValues[slotCode] = newSeconds;
//
//     // Track this slot as modified
//     modifiedSlots.add(slotCode);
//
//     // Force UI update by triggering observables
//     refreshTrigger.value++;
//     update();
//
//     print('Modified values now: $modifiedValues');
//     print('Modified slots now contains: ${modifiedSlots.toList()}');
//     print('=== END UPDATE SLOT DEBUG ===');
//
//     Get.snackbar(
//       'Updated',
//       'Time updated for ${slot['description']} to ${formatSeconds(newSeconds)}',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.blue,
//       colorText: Colors.white,
//       duration: Duration(seconds: 1),
//     );
//   }
//
//   // Add method to refresh UI manually if needed
//   void forceRefresh() {
//     refreshTrigger.value++;
//     update();
//   }
//
//   // Method to get slot description by code
//   String getSlotDescription(String code) {
//     final slot = slots.firstWhere(
//       (s) => s['code'] == code,
//       orElse: () => {'description': 'Unknown slot'},
//     );
//     return slot['description'] ?? 'Unknown slot';
//   }
// }

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../API Service/api_service.dart';
import '../../Controller/Inspector/manual_controller.dart';
import '../../utils/constants.dart';

class SlotController extends GetxController {
  String? uuid;

  SlotController();

  void setUuid(String? newUuid) {
    uuid = newUuid;
    print("UUID set to: $uuid");
  }

  void printUuidInfo() {
    print("=== UUID Information In Slot ===");
    print("UUID: ${uuid ?? 'NULL'}");
    print("Is UUID null: ${uuid == null}");
    print("Is UUID empty: ${uuid?.isEmpty ?? true}");
    print("UUID length: ${uuid?.length ?? 0}");
    print("========================");
  }

  final List<Map<String, String>> slots = [
    {'code': '550', 'description': 'slot 1 on time'},
    {'code': '554', 'description': 'slot 1 off time'},
    {'code': '551', 'description': 'slot 2 on time'},
    {'code': '555', 'description': 'slot 2 off time'},
    {'code': '552', 'description': 'slot 3 on time'},
    {'code': '556', 'description': 'slot 3 off time'},
    {'code': '553', 'description': 'slot 4 on time'},
    {'code': '557', 'description': 'slot 4 off time'},
  ].obs;

  // Observable for tracking edit mode
  var isEditMode = false.obs;

  // Observable for API loading state
  var isSaving = false.obs;

  // Track modified slots - Make this observable
  var modifiedSlots = <String>{}.obs;

  // Add refresh trigger for UI updates
  var refreshTrigger = 0.obs;

  // Store original values to revert if needed
  var originalValues = <String, String>{};

  // NEW: Store modified values locally (now in minutes)
  var modifiedValues = <String, int>{}.obs;

  // Mapping of slot codes to their modbus command prefixes
  final Map<String, String> slotCommandMap = {
    '550': '100', // Slot 1 ON
    '551': '101', // Slot 2 ON
    '552': '102', // Slot 3 ON
    '553': '103', // Slot 4 ON
    '554': '104', // Slot 1 OFF
    '555': '105', // Slot 2 OFF
    '556': '106', // Slot 3 OFF
    '557': '107', // Slot 4 OFF
  };

  @override
  void onInit() {
    super.onInit();
    // Store original values when controller initializes
    _storeOriginalValues();
  }

  void _storeOriginalValues() {
    final ManualController manualController = Get.find<ManualController>();
    originalValues.clear();
    for (var slot in manualController.slotTimingsForDisplay) {
      originalValues[slot['code'].toString()] = slot['value'].toString();
    }
  }

  // MODIFIED: Helper function to convert minutes to HH:MM:SS format
  // String formatSeconds(dynamic minutesValue) {
  //   final minutes = minutesValue is String
  //       ? int.tryParse(minutesValue) ?? 0
  //       : minutesValue is int
  //       ? minutesValue
  //       : 0;
  //
  //   if (minutes < 0) return '00:00:00';
  //
  //   final hours = (minutes / 60).truncate();
  //   final remainingMinutes = minutes % 60;
  //   // final seconds = 0; // Since we're working with minutes, seconds are always 0
  //
  //   return '${hours.toString().padLeft(2, '0')}:'
  //       '${remainingMinutes.toString().padLeft(2, '0')}';
  //       // '${seconds.toString().padLeft(2, '0')}';
  // }
  String formatSeconds(dynamic minutesValue) {
    final minutes = minutesValue is String
        ? int.tryParse(minutesValue) ?? 0
        : minutesValue is int
        ? minutesValue
        : 0;

    if (minutes < 0) return '00:00';

    final hours = (minutes / 60).truncate();
    final remainingMinutes = minutes % 60;

    return '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}';
  }

  // MODIFIED: Helper function to convert HH:MM:SS format to minutes
  int timeToMinutes(String timeString) {
    final parts = timeString.split(':');
    if (parts.length != 3) return 0;

    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    // Ignore seconds since we're working with minutes
    // final seconds = int.tryParse(parts[2]) ?? 0;

    return (hours * 60) + minutes;
  }

  // Helper function to convert minutes to seconds (for API calls)
  int minutesToSeconds(int minutes) {
    return minutes * 60;
  }

  // Helper function to convert seconds to minutes (for incoming data)
  int secondsToMinutes(int seconds) {
    return (seconds / 60).round();
  }

  // Toggle edit mode
  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
    if (!isEditMode.value) {
      // If exiting edit mode, clear modifications
      modifiedSlots.clear();
      modifiedValues.clear(); // Clear local values too
    } else {
      // Store original values when entering edit mode
      _storeOriginalValues();
    }
    // Trigger UI refresh
    refreshTrigger.value++;
  }

  // MODIFIED: Get the current value for a slot (now returns minutes)
  int getCurrentSlotValue(String slotCode) {
    // If we have a modified value, return that (already in minutes)
    if (modifiedValues.containsKey(slotCode)) {
      return modifiedValues[slotCode]!;
    }

    // Otherwise, get from the manual controller
    final ManualController manualController = Get.find<ManualController>();
    final slot = manualController.slotTimingsForDisplay.firstWhere(
          (s) => s['code'].toString() == slotCode,
      orElse: () => {'value': 0},
    );

    final value = slot['value'];
    int minutesValue = 0;

    if (value is String) {
      minutesValue = int.tryParse(value) ?? 0;
    } else if (value is int) {
      minutesValue = value;
    } else if (value is double) {
      minutesValue = value.toInt();
    }

    return minutesValue;
  }

  Future<void> saveChanges() async {
    print('Entering saveChanges function');

    if (modifiedSlots.isEmpty) {
      print('No modified slots to save');
      Get.snackbar(
        'No Changes',
        'No slot timings have been modified',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isSaving.value = true;
      print('Starting save process using ApiService');

      int successCount = 0;
      List<String> failedSlots = [];

      for (String slotCode in modifiedSlots) {
        try {
          print('Processing slot: $slotCode');

          // Use the locally stored modified value (in minutes)
          int minutesValue = modifiedValues[slotCode] ?? 0;

          // MODIFIED: Validate that minutes don't exceed 1440 (24 hours)
          if (minutesValue > 1440) {
            failedSlots.add(slotCode);
            print('Slot $slotCode exceeds 1440 minutes limit: $minutesValue minutes');
            continue;
          }

          // MODIFIED: Send minutes directly instead of converting to seconds
          print('Using modified value for slot $slotCode: $minutesValue minutes');

          final commandPrefix = slotCommandMap[slotCode];
          if (commandPrefix == null) {
            throw Exception('Unknown slot code: $slotCode');
          }

          // MODIFIED: Use minutes directly instead of seconds
          final paddedMinutes = minutesValue.toString().padLeft(5, '0');
          final modbusValue = '$commandPrefix,001,001,$paddedMinutes,600';

          print('Sending data for slot $slotCode: $modbusValue');

          final requestBody = {
            "type": "config",
            "id": 1,
            "key": "modbus",
            "value": modbusValue,
          };

          // Use ApiService instead of direct HTTP calls
          final response = await ApiService.post<Map<String, dynamic>>(
            endpoint: mqttSchedulePost(uuid!),
            body: requestBody,
            fromJson: (json) => json as Map<String, dynamic>,
            includeToken: true,
          );

          if (response.success) {
            successCount++;
            print('Successfully updated slot $slotCode');
          } else {
            failedSlots.add(slotCode);
            print(
                'Failed to update slot $slotCode: ${response.statusCode} - ${response.errorMessage}');
          }

          // Add delay between requests
          await Future.delayed(Duration(milliseconds: 500));
        } catch (e) {
          failedSlots.add(slotCode);
          print('Error updating slot $slotCode: $e');
        }
      }

      // Handle success/failure
      if (failedSlots.isEmpty) {
        print('All slots updated successfully');
        modifiedSlots.clear();
        modifiedValues.clear(); // Clear local values after successful save
        isEditMode.value = false;
        Get.snackbar(
          'Success',
          'All $successCount slot timing(s) updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      } else if (successCount > 0) {
        print('Some slots failed to update');
        // Only remove successfully updated slots from modified tracking
        for (String slotCode in List.from(modifiedSlots)) {
          if (!failedSlots.contains(slotCode)) {
            modifiedSlots.remove(slotCode);
            modifiedValues.remove(slotCode);
          }
        }
        Get.snackbar(
          'Partial Success',
          '$successCount updated, ${failedSlots.length} failed. Failed slots: ${failedSlots.join(", ")}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 4),
        );
      } else {
        print('All slots failed to update');
        throw Exception(
            'Failed to update any slot timings. Failed slots: ${failedSlots.join(", ")}');
      }
    } catch (e) {
      print('Exception in saveChanges: $e');
      Get.snackbar(
        'Save Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isSaving.value = false;
      print('Exiting saveChanges function');
    }
  }

  // Cancel editing - revert to original values
  void cancelEdit() {
    // Clear any unsaved changes and reset modified tracking
    modifiedSlots.clear();
    modifiedValues.clear(); // Clear local values
    isEditMode.value = false;
    refreshTrigger.value++; // Trigger UI refresh

    Get.snackbar(
      'Cancelled',
      'Changes discarded',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  // MODIFIED: Update slot value and track modification (now works with minutes)
  void updateSlotValue(Map<String, dynamic> slot, int newMinutes) {
    final slotCode = slot['code'].toString();

    print('=== UPDATE SLOT DEBUG ===');
    print('Updating slot: $slotCode with newMinutes: $newMinutes');

    // MODIFIED: Add validation for 1440 minutes limit
    if (newMinutes > 1440) {
      Get.snackbar(
        'Invalid Time',
        'Time cannot exceed 24 hours (1440 minutes). Current value: $newMinutes minutes',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      return;
    }

    // Store the modified value locally (in minutes)
    modifiedValues[slotCode] = newMinutes;

    // Track this slot as modified
    modifiedSlots.add(slotCode);

    // Force UI update by triggering observables
    refreshTrigger.value++;
    update();

    print('Modified values now: $modifiedValues');
    print('Modified slots now contains: ${modifiedSlots.toList()}');
    print('=== END UPDATE SLOT DEBUG ===');

    Get.snackbar(
      'Updated',
      'Time updated for ${slot['description']} to ${formatSeconds(newMinutes)}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: Duration(seconds: 1),
    );
  }

  // Add method to refresh UI manually if needed
  void forceRefresh() {
    refreshTrigger.value++;
    update();
  }

  // Method to get slot description by code
  String getSlotDescription(String code) {
    final slot = slots.firstWhere(
          (s) => s['code'] == code,
      orElse: () => {'description': 'Unknown slot'},
    );
    return slot['description'] ?? 'Unknown slot';
  }
}