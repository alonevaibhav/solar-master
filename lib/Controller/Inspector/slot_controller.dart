//
//
//
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
//     SlotController();
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
//   // NEW: Store modified values locally (now in minutes)
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
//   // NEW: Define slot pairs for overlap validation
//   final Map<String, String> slotPairs = {
//     '550': '554', // Slot 1 ON -> Slot 1 OFF
//     '551': '555', // Slot 2 ON -> Slot 2 OFF
//     '552': '556', // Slot 3 ON -> Slot 3 OFF
//     '553': '557', // Slot 4 ON -> Slot 4 OFF
//     '554': '550', // Slot 1 OFF -> Slot 1 ON (reverse mapping)
//     '555': '551', // Slot 2 OFF -> Slot 2 ON
//     '556': '552', // Slot 3 OFF -> Slot 3 ON
//     '557': '553', // Slot 4 OFF -> Slot 4 ON
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
//   String formatSeconds(dynamic minutesValue) {
//     final minutes = minutesValue is String
//         ? int.tryParse(minutesValue) ?? 0
//         : minutesValue is int
//         ? minutesValue
//         : 0;
//
//     if (minutes < 0) return '00:00';
//
//     final hours = (minutes / 60).truncate();
//     final remainingMinutes = minutes % 60;
//
//     return '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}';
//   }
//
//   // Helper function to convert HH:MM:SS format to minutes
//   int timeToMinutes(String timeString) {
//     final parts = timeString.split(':');
//     if (parts.length < 2) return 0;
//
//     final hours = int.tryParse(parts[0]) ?? 0;
//     final minutes = int.tryParse(parts[1]) ?? 0;
//
//     return (hours * 60) + minutes;
//   }
//
//   // Helper function to convert minutes to seconds (for API calls)
//   int minutesToSeconds(int minutes) {
//     return minutes * 60;
//   }
//
//   // Helper function to convert seconds to minutes (for incoming data)
//   int secondsToMinutes(int seconds) {
//     return (seconds / 60).round();
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
//   // Get the current value for a slot (now returns minutes)
//   int getCurrentSlotValue(String slotCode) {
//     // If we have a modified value, return that (already in minutes)
//     if (modifiedValues.containsKey(slotCode)) {
//       return modifiedValues[slotCode]!;
//     }
//
//     // Otherwise, get from the manual controller
//     final ManualController manualController = Get.find<ManualController>();
//     final slot = manualController.slotTimingsForDisplay.firstWhere(
//           (s) => s['code'].toString() == slotCode,
//       orElse: () => {'value': 0},
//     );
//
//     final value = slot['value'];
//     int minutesValue = 0;
//
//     if (value is String) {
//       minutesValue = int.tryParse(value) ?? 0;
//     } else if (value is int) {
//       minutesValue = value;
//     } else if (value is double) {
//       minutesValue = value.toInt();
//     }
//
//     return minutesValue;
//   }
//
//   // NEW: Comprehensive slot timing validation with overlap detection
//   Map<String, dynamic> validateSlotTiming(Map<String, dynamic> slot, int newMinutes) {
//     final slotCode = slot['code'].toString();
//     final isOnSlot = slot['description'].toString().toLowerCase().contains('on');
//
//     print('=== VALIDATION DEBUG ===');
//     print('Validating slot: $slotCode, isOnSlot: $isOnSlot, newMinutes: $newMinutes');
//
//     // Basic validation - 24 hour limit
//     if (newMinutes > 1440) {
//       return {
//         'isValid': false,
//         'message': 'Time cannot exceed 24 hours (1440 minutes). Current: $newMinutes minutes'
//       };
//     }
//
//     // Get the paired slot (ON/OFF counterpart)
//     final pairedSlotCode = slotPairs[slotCode];
//     if (pairedSlotCode == null) {
//       return {
//         'isValid': false,
//         'message': 'Invalid slot configuration'
//       };
//     }
//
//     final pairedSlotMinutes = getCurrentSlotValue(pairedSlotCode);
//     print('Paired slot: $pairedSlotCode, pairedSlotMinutes: $pairedSlotMinutes');
//
//     // Validate ON/OFF slot relationship within the same slot group
//     if (isOnSlot) {
//       // This is an ON slot - must be less than its corresponding OFF slot
//       if (newMinutes >= pairedSlotMinutes) {
//         return {
//           'isValid': false,
//           'message': 'ON time (${formatSeconds(newMinutes)}) must be earlier than OFF time (${formatSeconds(pairedSlotMinutes)})'
//         };
//       }
//     } else {
//       // This is an OFF slot - must be greater than its corresponding ON slot
//       if (newMinutes <= pairedSlotMinutes) {
//         return {
//           'isValid': false,
//           'message': 'OFF time (${formatSeconds(newMinutes)}) must be later than ON time (${formatSeconds(pairedSlotMinutes)})'
//         };
//       }
//     }
//
//     // Get all current slot timings for overlap validation
//     List<Map<String, int>> allSlotTimings = [];
//
//     // Process all slots and group them by pairs
//     for (int i = 0; i < slots.length; i += 2) {
//       final onSlot = slots[i];
//       final offSlot = slots[i + 1];
//
//       final onCode = onSlot['code']!;
//       final offCode = offSlot['code']!;
//
//       int onTime, offTime;
//
//       // Use new value if this is the slot being updated, otherwise use current value
//       if (onCode == slotCode) {
//         onTime = newMinutes;
//         offTime = getCurrentSlotValue(offCode);
//       } else if (offCode == slotCode) {
//         onTime = getCurrentSlotValue(onCode);
//         offTime = newMinutes;
//       } else {
//         onTime = getCurrentSlotValue(onCode);
//         offTime = getCurrentSlotValue(offCode);
//       }
//
//       // Only add valid time ranges (where ON < OFF)
//       if (onTime < offTime) {
//         allSlotTimings.add({
//           'slotNumber': (i ~/ 2) + 1,
//           'onTime': onTime,
//           'offTime': offTime,
//           // 'onCode': onCode,
//           // 'offCode': offCode,
//         });
//       }
//     }
//
//     print('All slot timings for validation: $allSlotTimings');
//
//     // Check for overlaps with other slots
//     final currentSlotNumber = _getSlotNumber(slotCode);
//
//     for (var otherSlot in allSlotTimings) {
//       if (otherSlot['slotNumber'] != currentSlotNumber) {
//         final otherOnTime = otherSlot['onTime'] as int;
//         final otherOffTime = otherSlot['offTime'] as int;
//
//         // Get the current slot's complete time range
//         int currentOnTime, currentOffTime;
//         if (isOnSlot) {
//           currentOnTime = newMinutes;
//           currentOffTime = pairedSlotMinutes;
//         } else {
//           currentOnTime = pairedSlotMinutes;
//           currentOffTime = newMinutes;
//         }
//
//         // Skip validation if current slot doesn't have valid time range
//         if (currentOnTime >= currentOffTime) continue;
//
//         // Check for overlap
//         bool hasOverlap = !(currentOffTime <= otherOnTime || currentOnTime >= otherOffTime);
//
//         if (hasOverlap) {
//           return {
//             'isValid': false,
//             'message': 'Time range ${formatSeconds(currentOnTime)}-${formatSeconds(currentOffTime)} overlaps with Slot ${otherSlot['slotNumber']} (${formatSeconds(otherOnTime)}-${formatSeconds(otherOffTime)})'
//           };
//         }
//       }
//     }
//
//     print('Validation passed for slot: $slotCode');
//     return {'isValid': true, 'message': 'Valid timing'};
//   }
//
//   // Helper function to get slot number from slot code
//   int _getSlotNumber(String slotCode) {
//     switch (slotCode) {
//       case '550':
//       case '554':
//         return 1;
//       case '551':
//       case '555':
//         return 2;
//       case '552':
//       case '556':
//         return 3;
//       case '553':
//       case '557':
//         return 4;
//       default:
//         return 0;
//     }
//   }
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
//           // Use the locally stored modified value (in minutes)
//           int minutesValue = modifiedValues[slotCode] ?? 0;
//
//           // Validate that minutes don't exceed 1440 (24 hours)
//           if (minutesValue > 1440) {
//             failedSlots.add(slotCode);
//             print(
//                 'Slot $slotCode exceeds 1440 minutes limit: $minutesValue minutes');
//             continue;
//           }
//
//           // Send minutes directly instead of converting to seconds
//           print(
//               'Using modified value for slot $slotCode: $minutesValue minutes');
//
//           final commandPrefix = slotCommandMap[slotCode];
//           if (commandPrefix == null) {
//             throw Exception('Unknown slot code: $slotCode');
//           }
//
//           // Use minutes directly instead of seconds
//           final paddedMinutes = minutesValue.toString().padLeft(5, '0');
//           final modbusValue = '$commandPrefix,001,001,$paddedMinutes,600';
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
//   // MODIFIED: Update slot value with validation (now works with minutes)
//   void updateSlotValue(Map<String, dynamic> slot, int newMinutes) {
//     final slotCode = slot['code'].toString();
//
//     print('=== UPDATE SLOT DEBUG ===');
//     print('Updating slot: $slotCode with newMinutes: $newMinutes');
//
//     // Validate the new timing with overlap detection
//     final validationResult = validateSlotTiming(slot, newMinutes);
//     if (!validationResult['isValid']) {
//       print('Validation failed: ${validationResult['message']}');
//       // Error already shown by validation method, just return
//       return;
//     }
//
//     // Store the modified value locally (in minutes)
//     modifiedValues[slotCode] = newMinutes;
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
//       'Time updated for ${slot['description']} to ${formatSeconds(newMinutes)}',
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
//           (s) => s['code'] == code,
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

  // Track modified slots
  var modifiedSlots = <String>{}.obs;

  // NEW: Track overlapping slots for visual warnings
  var overlappingSlots = <String>{}.obs;
  var overlapDetails = <String, List<String>>{}.obs; // slotCode -> list of conflicting slots

  // Add refresh trigger for UI updates
  var refreshTrigger = 0.obs;

  // Store original values to revert if needed
  var originalValues = <String, String>{};

  // Store modified values locally (in minutes)
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

  // Define slot pairs for overlap validation
  final Map<String, String> slotPairs = {
    '550': '554', // Slot 1 ON -> Slot 1 OFF
    '551': '555', // Slot 2 ON -> Slot 2 OFF
    '552': '556', // Slot 3 ON -> Slot 3 OFF
    '553': '557', // Slot 4 ON -> Slot 4 OFF
    '554': '550', // Slot 1 OFF -> Slot 1 ON (reverse mapping)
    '555': '551', // Slot 2 OFF -> Slot 2 ON
    '556': '552', // Slot 3 OFF -> Slot 3 ON
    '557': '553', // Slot 4 OFF -> Slot 4 ON
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

  // Helper function to convert HH:MM:SS format to minutes
  int timeToMinutes(String timeString) {
    final parts = timeString.split(':');
    if (parts.length < 2) return 0;

    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;

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
      modifiedValues.clear();
      overlappingSlots.clear();
      overlapDetails.clear();
    } else {
      // Store original values when entering edit mode
      _storeOriginalValues();
    }
    // Trigger UI refresh
    refreshTrigger.value++;
  }

  // Get the current value for a slot (returns minutes)
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

  // NEW: Non-blocking validation - checks but doesn't prevent action
  Map<String, dynamic> checkSlotOverlap(String slotCode, int newMinutes) {
    print('=== CHECK OVERLAP ===');
    print('Checking slot: $slotCode, newMinutes: $newMinutes');

    final slotNumber = _getSlotNumberFromCode(slotCode);
    final isOnSlot = _isOnSlot(slotCode);
    final pairedSlotCode = slotPairs[slotCode];

    if (pairedSlotCode == null) {
      return {
        'hasHardError': true,
        'canSave': false,
        'hasWarning': false,
        'message': 'Invalid slot configuration',
        'conflicts': []
      };
    }

    final pairedSlotMinutes = getCurrentSlotValue(pairedSlotCode);

    List<String> conflicts = [];
    String warningMessage = '';

    // Check 24-hour limit (hard limit - blocks save)
    if (newMinutes > 1440) {
      return {
        'hasHardError': true,
        'canSave': false,
        'hasWarning': false,
        'message': 'Cannot exceed 24 hours (1440 minutes)',
        'conflicts': []
      };
    }

    // Get the complete time range for current slot
    int currentSlotOnTime, currentSlotOffTime;
    if (isOnSlot) {
      currentSlotOnTime = newMinutes;
      currentSlotOffTime = pairedSlotMinutes;

      if (newMinutes >= pairedSlotMinutes) {
        warningMessage = 'ON time should be before OFF time (${formatSeconds(pairedSlotMinutes)})';
      }
    } else {
      currentSlotOnTime = pairedSlotMinutes;
      currentSlotOffTime = newMinutes;

      if (newMinutes <= pairedSlotMinutes) {
        warningMessage = 'OFF time should be after ON time (${formatSeconds(pairedSlotMinutes)})';
      }
    }

    // Skip overlap check if current slot doesn't have valid range
    if (currentSlotOnTime >= currentSlotOffTime) {
      print('Current slot has invalid range, skipping overlap check');
      return {
        'hasHardError': false,
        'canSave': true,
        'hasWarning': warningMessage.isNotEmpty,
        'message': warningMessage,
        'conflicts': []
      };
    }

    // Check for overlaps with other slots
    for (int i = 1; i <= 4; i++) {
      if (i == slotNumber) continue; // Skip current slot

      final otherOnCode = _getSlotCode(i, true);
      final otherOffCode = _getSlotCode(i, false);

      final otherOnTime = getCurrentSlotValue(otherOnCode);
      final otherOffTime = getCurrentSlotValue(otherOffCode);

      // Skip if other slot doesn't have valid range
      if (otherOnTime >= otherOffTime) continue;

      // Check for overlap: Two ranges overlap if start1 < end2 AND start2 < end1
      bool hasOverlap = (currentSlotOnTime < otherOffTime &&
          otherOnTime < currentSlotOffTime);

      if (hasOverlap) {
        conflicts.add(
            'Slot $i (${formatSeconds(otherOnTime)} - ${formatSeconds(otherOffTime)})');
      }
    }

    if (conflicts.isNotEmpty) {
      warningMessage = 'Overlaps with: ${conflicts.join(", ")}';
    }

    print('Check result - hasWarning: ${conflicts.isNotEmpty || warningMessage.isNotEmpty}');
    print('Conflicts: $conflicts');

    return {
      'hasHardError': false,
      'canSave': true, // Always allow saving with overlaps
      'hasWarning': conflicts.isNotEmpty || warningMessage.isNotEmpty,
      'message': warningMessage,
      'conflicts': conflicts
    };
  }

  // Re-check all modified slots for overlaps
  void _recheckAllOverlaps() {
    print('=== RECHECKING ALL OVERLAPS ===');
    overlappingSlots.clear();
    overlapDetails.clear();

    for (String slotCode in modifiedSlots) {
      if (!modifiedValues.containsKey(slotCode)) continue;

      final checkResult = checkSlotOverlap(slotCode, modifiedValues[slotCode]!);
      if (checkResult['hasWarning'] == true) {
        overlappingSlots.add(slotCode);
        overlapDetails[slotCode] = List<String>.from(checkResult['conflicts']);
        print('Slot $slotCode has overlaps: ${checkResult['conflicts']}');
      }
    }

    print('Total overlapping slots: ${overlappingSlots.length}');
  }

  // Update slot value - ALWAYS ALLOWS UPDATE (only blocks if exceeds 24 hours)
  void updateSlotValue(Map<String, dynamic> slot, int newMinutes) {
    final slotCode = slot['code'].toString();

    print('=== UPDATE SLOT VALUE ===');
    print('Updating slot: $slotCode with newMinutes: $newMinutes');

    // Check for issues but don't block (except hard errors)
    final checkResult = checkSlotOverlap(slotCode, newMinutes);

    // Only block if hard error (like exceeding 24 hours)
    if (checkResult['hasHardError'] == true) {
      Get.snackbar(
        'Invalid Input',
        checkResult['message'],
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      return;
    }

    // Store the modified value (in minutes)
    modifiedValues[slotCode] = newMinutes;
    modifiedSlots.add(slotCode);

    // Update overlap tracking for visual warnings
    if (checkResult['hasWarning'] == true) {
      overlappingSlots.add(slotCode);
      overlapDetails[slotCode] = List<String>.from(checkResult['conflicts']);
    } else {
      overlappingSlots.remove(slotCode);
      overlapDetails.remove(slotCode);
    }

    // Re-check all modified slots for overlaps (since changing one affects others)
    _recheckAllOverlaps();

    // Force UI update
    refreshTrigger.value++;
    update();

    print('Modified values: $modifiedValues');
    print('Overlapping slots: ${overlappingSlots.toList()}');

    // Show appropriate message
    if (checkResult['hasWarning'] == true) {
      Get.snackbar(
        '⚠️ Warning',
        'Time updated to ${formatSeconds(newMinutes)} but ${checkResult['message']}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } else {
      Get.snackbar(
        '✓ Updated',
        'Time updated to ${formatSeconds(newMinutes)}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 1),
      );
    }
  }

  // Save with warning dialog if overlaps exist
  Future<void> saveChanges() async {
    print('=== SAVE CHANGES ===');

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

    // Check if there are any overlaps
    if (overlappingSlots.isNotEmpty) {
      print('Overlaps detected, showing warning dialog');
      // Show warning dialog but allow user to proceed
      bool? shouldContinue = await Get.dialog<bool>(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange, size: 28),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Overlap Warning',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The following slots have overlapping times:',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              SizedBox(height: 12),
              Container(
                constraints: BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: overlappingSlots.map((slotCode) {
                      final conflicts = overlapDetails[slotCode] ?? [];
                      final slotNum = _getSlotNumberFromCode(slotCode);
                      final isOn = _isOnSlot(slotCode);
                      final time = formatSeconds(modifiedValues[slotCode] ?? 0);
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• Slot $slotNum ${isOn ? "ON" : "OFF"} ($time)',
                              style: TextStyle(
                                color: Colors.orange[900],
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (conflicts.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(left: 16, top: 2),
                                child: Text(
                                  'Conflicts: ${conflicts.join(", ")}',
                                  style: TextStyle(
                                    color: Colors.orange[700],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 18, color: Colors.orange[800]),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Do you want to save these overlapping timings?',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.orange[900],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600], fontSize: 15),
              ),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Save Anyway',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        barrierDismissible: false,
      );

      if (shouldContinue != true) {
        print('User cancelled save due to overlaps');
        return; // User cancelled
      }
      print('User chose to save despite overlaps');
    }

    // Proceed with save
    await _performSave();
  }

  // Actual save operation
  Future<void> _performSave() async {
    print('=== PERFORMING SAVE ===');

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

          // Validate that minutes don't exceed 1440 (24 hours)
          if (minutesValue > 1440) {
            failedSlots.add(slotCode);
            print(
                'Slot $slotCode exceeds 1440 minutes limit: $minutesValue minutes');
            continue;
          }

          // Send minutes directly instead of converting to seconds
          print(
              'Using modified value for slot $slotCode: $minutesValue minutes');

          final commandPrefix = slotCommandMap[slotCode];
          if (commandPrefix == null) {
            throw Exception('Unknown slot code: $slotCode');
          }

          // Use minutes directly instead of seconds
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
        modifiedValues.clear();
        overlappingSlots.clear();
        overlapDetails.clear();
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
            overlappingSlots.remove(slotCode);
            overlapDetails.remove(slotCode);
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
      print('=== SAVE COMPLETE ===');
    }
  }

  // Cancel editing - revert to original values
  void cancelEdit() {
    // Clear any unsaved changes and reset modified tracking
    modifiedSlots.clear();
    modifiedValues.clear();
    overlappingSlots.clear();
    overlapDetails.clear();
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

  // Helper methods
  int _getSlotNumberFromCode(String slotCode) {
    switch (slotCode) {
      case '550':
      case '554':
        return 1;
      case '551':
      case '555':
        return 2;
      case '552':
      case '556':
        return 3;
      case '553':
      case '557':
        return 4;
      default:
        return 0;
    }
  }

  bool _isOnSlot(String slotCode) {
    return ['550', '551', '552', '553'].contains(slotCode);
  }

  String _getSlotCode(int slotNumber, bool isOn) {
    const slotCodes = {
      1: {'on': '550', 'off': '554'},
      2: {'on': '551', 'off': '555'},
      3: {'on': '552', 'off': '556'},
      4: {'on': '553', 'off': '557'},
    };
    return slotCodes[slotNumber]?[isOn ? 'on' : 'off'] ?? '';
  }

  String _getPairedSlotCode(String slotCode) {
    return slotPairs[slotCode] ?? '';
  }
}