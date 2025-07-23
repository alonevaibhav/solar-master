// // controllers/slot_controller.dart
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
//
// import '../../Controller/Inspector/manual_controller.dart';
//
// class SlotController extends GetxController {
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
//   // Helper function to convert seconds to HH:MM:SS format
//   String formatSeconds(dynamic secondsValue) {
//     final seconds = secondsValue is String
//         ? int.tryParse(secondsValue) ?? 0
//         : secondsValue is int
//         ? secondsValue
//         : 0;
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
//   }
//
//   // Save all changes
//   void saveChanges() {
//     // Here you would typically save to your backend or local storage
//     isEditMode.value = false;
//     Get.snackbar(
//       'Success',
//       'Slot timings updated successfully',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//       duration: Duration(seconds: 2),
//     );
//   }
//
//   // Cancel editing
//   void cancelEdit() {
//     // Here you would typically revert any unsaved changes
//     isEditMode.value = false;
//     Get.snackbar(
//       'Cancelled',
//       'Changes discarded',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.grey,
//       colorText: Colors.white,
//       duration: Duration(seconds: 2),
//     );
//   }
// }
//
// class InfoPage extends StatelessWidget {
//   final ManualController controller = Get.find<ManualController>();
//   final SlotController slotController = Get.put(SlotController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: Text(
//           'Slot Timings',
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         elevation: 0,
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(1),
//           child: Container(
//             height: 1,
//             color: Colors.grey[200],
//           ),
//         ),
//         actions: [
//           Obx(() => slotController.isEditMode.value
//               ? Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextButton(
//                 onPressed: slotController.cancelEdit,
//                 child: Text(
//                   'Cancel',
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//               ),
//               SizedBox(width: 8),
//               ElevatedButton(
//                 onPressed: slotController.saveChanges,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   foregroundColor: Colors.white,
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text('Save'),
//               ),
//               SizedBox(width: 16),
//             ],
//           )
//               : IconButton(
//             onPressed: slotController.toggleEditMode,
//             icon: Icon(Icons.edit),
//             tooltip: 'Edit Timings',
//           )),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'Loading slot timings...',
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         if (controller.errorMessage.value.isNotEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.error_outline,
//                   size: 48,
//                   color: Colors.red[300],
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'Error loading data',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.red[700],
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   controller.errorMessage.value,
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 14,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 24),
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     // Add retry logic here
//                   },
//                   icon: Icon(Icons.refresh),
//                   label: Text('Retry'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return Column(
//           children: [
//             // Header with edit mode indicator
//             if (slotController.isEditMode.value)
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(16),
//                 color: Colors.blue[50],
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.edit,
//                       size: 20,
//                       color: Colors.blue[700],
//                     ),
//                     SizedBox(width: 8),
//                     Text(
//                       'Edit Mode: Tap on time values to modify',
//                       style: TextStyle(
//                         color: Colors.blue[700],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//             Expanded(
//               child: ListView.builder(
//                 padding: EdgeInsets.all(16),
//                 itemCount: controller.slotTimingsForDisplay.length,
//                 itemBuilder: (context, index) {
//                   final slot = controller.slotTimingsForDisplay[index];
//                   final formattedTime = slotController.formatSeconds(slot['value']);
//                   final isOnTime = slot['description'].toString().toLowerCase().contains('on');
//
//                   return Card(
//                     margin: EdgeInsets.only(bottom: 16),
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       side: BorderSide(
//                         color: Colors.grey[200]!,
//                         width: 1,
//                       ),
//                     ),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         gradient: LinearGradient(
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                           colors: [
//                             Colors.white,
//                             isOnTime ? Colors.green[50]! : Colors.red[50]!,
//                           ],
//                         ),
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.all(20),
//                         child: Row(
//                           children: [
//                             // Slot Code Container
//                             Container(
//                               width: 70,
//                               height: 70,
//                               decoration: BoxDecoration(
//                                 color: isOnTime ? Colors.green[100] : Colors.red[100],
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                   color: isOnTime ? Colors.green[200]! : Colors.red[200]!,
//                                   width: 1,
//                                 ),
//                               ),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     '${slot['code']}',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: isOnTime ? Colors.green[800] : Colors.red[800],
//                                     ),
//                                   ),
//                                   Container(
//                                     margin: EdgeInsets.only(top: 4),
//                                     padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                                     decoration: BoxDecoration(
//                                       color: isOnTime ? Colors.green[200] : Colors.red[200],
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Text(
//                                       isOnTime ? 'ON' : 'OFF',
//                                       style: TextStyle(
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.w600,
//                                         color: isOnTime ? Colors.green[800] : Colors.red[800],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//
//                             SizedBox(width: 16),
//
//                             // Slot Information
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     slot['description'],
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.grey[800],
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//
//                                   // Time Display/Edit
//                                   InkWell(
//                                     onTap: slotController.isEditMode.value
//                                         ? () => _showTimePickerDialog(context, slot)
//                                         : null,
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: Container(
//                                       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                                       decoration: BoxDecoration(
//                                         color: slotController.isEditMode.value
//                                             ? Colors.blue[50]
//                                             : Colors.grey[100],
//                                         borderRadius: BorderRadius.circular(8),
//                                         border: Border.all(
//                                           color: slotController.isEditMode.value
//                                               ? Colors.blue[200]!
//                                               : Colors.transparent,
//                                           width: 1,
//                                         ),
//                                       ),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Icon(
//                                             Icons.access_time,
//                                             size: 16,
//                                             color: slotController.isEditMode.value
//                                                 ? Colors.blue[600]
//                                                 : Colors.grey[600],
//                                           ),
//                                           SizedBox(width: 6),
//                                           Text(
//                                             formattedTime,
//                                             style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w600,
//                                               color: slotController.isEditMode.value
//                                                   ? Colors.blue[700]
//                                                   : Colors.grey[700],
//                                               fontFamily: 'monospace',
//                                             ),
//                                           ),
//                                           if (slotController.isEditMode.value) ...[
//                                             SizedBox(width: 6),
//                                             Icon(
//                                               Icons.edit,
//                                               size: 14,
//                                               color: Colors.blue[600],
//                                             ),
//                                           ],
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
//
//   void _showTimePickerDialog(BuildContext context, Map<String, dynamic> slot) {
//     final currentTime = slotController.formatSeconds(slot['value']);
//     final timeParts = currentTime.split(':');
//
//     int selectedHours = int.parse(timeParts[0]);
//     int selectedMinutes = int.parse(timeParts[1]);
//     int selectedSeconds = int.parse(timeParts[2]);
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               title: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Edit Time',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     slot['description'],
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[600],
//                       fontWeight: FontWeight.normal,
//                     ),
//                   ),
//                 ],
//               ),
//               content: Container(
//                 width: double.maxFinite,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[50],
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           _buildTimeSelector(
//                             'Hours',
//                             selectedHours,
//                             0,
//                             23,
//                                 (value) => setState(() => selectedHours = value),
//                           ),
//                           Text(
//                             ':',
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           _buildTimeSelector(
//                             'Minutes',
//                             selectedMinutes,
//                             0,
//                             59,
//                                 (value) => setState(() => selectedMinutes = value),
//                           ),
//                           Text(
//                             ':',
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           _buildTimeSelector(
//                             'Seconds',
//                             selectedSeconds,
//                             0,
//                             59,
//                                 (value) => setState(() => selectedSeconds = value),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Container(
//                       padding: EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.blue[50],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.info_outline,
//                             size: 16,
//                             color: Colors.blue[600],
//                           ),
//                           SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               'New time: ${selectedHours.toString().padLeft(2, '0')}:${selectedMinutes.toString().padLeft(2, '0')}:${selectedSeconds.toString().padLeft(2, '0')}',
//                               style: TextStyle(
//                                 color: Colors.blue[700],
//                                 fontWeight: FontWeight.w500,
//                                 fontFamily: 'monospace',
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: Text(
//                     'Cancel',
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     final newSeconds = (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds;
//                     slot['value'] = newSeconds.toString();
//                     Navigator.of(context).pop();
//
//                     Get.snackbar(
//                       'Updated',
//                       'Time updated for ${slot['description']}',
//                       snackPosition: SnackPosition.BOTTOM,
//                       backgroundColor: Colors.green,
//                       colorText: Colors.white,
//                       duration: Duration(seconds: 2),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Text('Update'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildTimeSelector(String label, int value, int min, int max, ValueChanged<int> onChanged) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey[600],
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Colors.grey[300]!),
//           ),
//           child: Column(
//             children: [
//               InkWell(
//                 onTap: () {
//                   if (value < max) onChanged(value + 1);
//                 },
//                 child: Container(
//                   padding: EdgeInsets.all(8),
//                   child: Icon(
//                     Icons.keyboard_arrow_up,
//                     size: 20,
//                     color: value < max ? Colors.blue : Colors.grey[400],
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 child: Text(
//                   value.toString().padLeft(2, '0'),
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'monospace',
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   if (value > min) onChanged(value - 1);
//                 },
//                 child: Container(
//                   padding: EdgeInsets.all(8),
//                   child: Icon(
//                     Icons.keyboard_arrow_down,
//                     size: 20,
//                     color: value > min ? Colors.blue : Colors.grey[400],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// controllers/slot_controller.dart
// // ------------------------------------------
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../Controller/Inspector/manual_controller.dart';
//
// class SlotController extends GetxController {
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
//   // Helper function to convert seconds to HH:MM:SS format
//   String formatSeconds(dynamic secondsValue) {
//     final seconds = secondsValue is String
//         ? int.tryParse(secondsValue) ?? 0
//         : secondsValue is int
//         ? secondsValue
//         : 0;
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
//     }
//     // Trigger UI refresh
//     refreshTrigger.value++;
//   }
//
//   // Save all changes with API call
//   Future<void> saveChanges() async {
//     if (modifiedSlots.isEmpty) {
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
//
//       // Get authentication token
//       final token = await getToken();
//       if (token == null || token.isEmpty) {
//         throw Exception('Authentication token not found. Please login again.');
//       }
//
//       // Get all current slot values and convert to seconds
//       final ManualController manualController = Get.find<ManualController>();
//       String valueString = '';
//
//       // Create value string with all 8 slot values (codes 550-557)
//       for (int i = 0; i < manualController.slotTimingsForDisplay.length; i++) {
//         final slot = manualController.slotTimingsForDisplay[i];
//
//         // Safely convert value to int, handling both String and int types
//         int secondsValue = 0;
//         final rawValue = slot['value'];
//
//         if (rawValue is String) {
//           secondsValue = int.tryParse(rawValue) ?? 0;
//         } else if (rawValue is int) {
//           secondsValue = rawValue;
//         } else if (rawValue is double) {
//           secondsValue = rawValue.toInt();
//         }
//
//         // Format as 5 digits with leading zeros
//         valueString += secondsValue.toString().padLeft(5, '0');
//
//         // Add comma separator except for the last item
//         if (i < manualController.slotTimingsForDisplay.length - 1) {
//           valueString += ',';
//         }
//       }
//
//       // Prepare the request body
//       final requestBody = {
//         "type": "config",
//         "id": 1,
//         "key": "modbus", // You may need to adjust this key for slot timings
//         "value": valueString,
//       };
//
//       // Prepare headers with the token
//       final headers = {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       };
//
//       print('Sending slot timing data: $valueString'); // Debug log
//
//       // Make the POST request
//       final response = await http.post(
//         Uri.parse('https://smartsolarcleaner.com/api/api/mqtt/publish/862360073414729'),
//         headers: headers,
//         body: jsonEncode(requestBody),
//       ).timeout(const Duration(seconds: 30));
//
//       if (response.statusCode == 200) {
//         // Clear modified slots tracking
//         modifiedSlots.clear();
//         isEditMode.value = false;
//
//         Get.snackbar(
//           'Success',
//           'Slot timings updated successfully',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//           duration: Duration(seconds: 2),
//         );
//       } else {
//         // Handle different error status codes
//         String errorMessage = 'Failed to save slot timings';
//         if (response.statusCode == 401) {
//           errorMessage = 'Authentication failed: ${response.body}';
//         } else if (response.statusCode == 400) {
//           errorMessage = 'Invalid request: ${response.body}';
//         } else {
//           errorMessage = 'Error ${response.statusCode}: ${response.body}';
//         }
//         throw Exception(errorMessage);
//       }
//     } on TimeoutException {
//       throw Exception('Request timed out. Please try again.');
//     } catch (e) {
//       Get.snackbar(
//         'Save Error',
//         e.toString(),
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//       );
//     } finally {
//       isSaving.value = false;
//     }
//   }
//
//   // Get authentication token from SharedPreferences
//   static Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }
//
//   // Cancel editing
//   void cancelEdit() {
//     // Revert all changes to original values
//     final ManualController manualController = Get.find<ManualController>();
//
//     // You should call a method to reload original data here
//     // This is crucial for reverting changes
//     // manualController.fetchSlotTimings(); // Uncomment and implement this method
//
//     // Clear any unsaved changes and reset modified tracking
//     modifiedSlots.clear();
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
//     // Get the manual controller to update the actual data source
//     final ManualController manualController = Get.find<ManualController>();
//
//     // Find the index of this slot in the display list
//     final slotCode = slot['code'].toString();
//     final slotIndex = manualController.slotTimingsForDisplay.indexWhere(
//             (s) => s['code'].toString() == slotCode
//     );
//
//     if (slotIndex != -1) {
//       // Update the actual data source - this is the key fix!
//       manualController.slotTimingsForDisplay[slotIndex]['value'] = newSeconds.toString();
//
//       // Also update the passed slot reference (in case it's used elsewhere)
//       slot['value'] = newSeconds.toString();
//
//       // Track this slot as modified using the code as string
//       modifiedSlots.add(slotCode);
//
//       // Force UI update by triggering observables
//       refreshTrigger.value++; // This will trigger Obx rebuilds
//       update(); // This will rebuild GetBuilder widgets
//
//       print('Updated slot $slotCode with value: $newSeconds'); // Debug log
//
//       Get.snackbar(
//         'Updated',
//         'Time updated for ${slot['description']}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.blue,
//         colorText: Colors.white,
//         duration: Duration(seconds: 1),
//       );
//     } else {
//       print('ERROR: Could not find slot with code: $slotCode'); // Debug log
//     }
//   }
//
//   // Add method to refresh UI manually if needed
//   void forceRefresh() {
//     refreshTrigger.value++;
//     update();
//   }
// }
//
// class InfoPage extends StatelessWidget {
//   final ManualController controller = Get.find<ManualController>();
//   final SlotController slotController = Get.put(SlotController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: Text(
//           'Slot Timings',
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         elevation: 0,
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(1),
//           child: Container(
//             height: 1,
//             color: Colors.grey[200],
//           ),
//         ),
//         actions: [
//           Obx(() => slotController.isEditMode.value
//               ? Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextButton(
//                 onPressed: slotController.isSaving.value
//                     ? null
//                     : slotController.cancelEdit,
//                 child: Text(
//                   'Cancel',
//                   style: TextStyle(
//                       color: slotController.isSaving.value
//                           ? Colors.grey[400]
//                           : Colors.grey[600]
//                   ),
//                 ),
//               ),
//               SizedBox(width: 8),
//               ElevatedButton(
//                 onPressed: slotController.isSaving.value
//                     ? null
//                     : slotController.saveChanges,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: slotController.isSaving.value
//                       ? Colors.grey[400]
//                       : Colors.blue,
//                   foregroundColor: Colors.white,
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: slotController.isSaving.value
//                     ? SizedBox(
//                   width: 16,
//                   height: 16,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                 )
//                     : Text('Save'),
//               ),
//               SizedBox(width: 16),
//             ],
//           )
//               : IconButton(
//             onPressed: slotController.toggleEditMode,
//             icon: Icon(Icons.edit),
//             tooltip: 'Edit Timings',
//           )),
//         ],
//       ),
//       body: Obx(() {
//         // Listen to refresh trigger to force rebuilds
//         slotController.refreshTrigger.value;
//
//         if (controller.isLoading.value) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'Loading slot timings...',
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         if (controller.errorMessage.value.isNotEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.error_outline,
//                   size: 48,
//                   color: Colors.red[300],
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'Error loading data',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.red[700],
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   controller.errorMessage.value,
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 14,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 24),
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     // Add retry logic here
//                   },
//                   icon: Icon(Icons.refresh),
//                   label: Text('Retry'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return Column(
//           children: [
//             // Header with edit mode indicator
//             if (slotController.isEditMode.value)
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(16),
//                 color: Colors.blue[50],
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.edit,
//                       size: 20,
//                       color: Colors.blue[700],
//                     ),
//                     SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         'Edit Mode: Tap on time values to modify',
//                         style: TextStyle(
//                           color: Colors.blue[700],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                     Obx(() => slotController.modifiedSlots.isNotEmpty
//                         ? Container(
//                       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.orange[100],
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         '${slotController.modifiedSlots.length} modified',
//                         style: TextStyle(
//                           color: Colors.orange[800],
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     )
//                         : SizedBox()),
//                   ],
//                 ),
//               ),
//
//             Expanded(
//               child: GetBuilder<SlotController>(
//                 builder: (slotCtrl) => Obx(() {
//                   // Listen to both controllers
//                   slotController.refreshTrigger.value;
//
//                   return ListView.builder(
//                     padding: EdgeInsets.all(16),
//                     itemCount: controller.slotTimingsForDisplay.length,
//                     itemBuilder: (context, index) {
//                       final slot = controller.slotTimingsForDisplay[index];
//                       final formattedTime = slotController.formatSeconds(slot['value']);
//                       final isOnTime = slot['description'].toString().toLowerCase().contains('on');
//                       final slotCode = slot['code'].toString();
//
//                       return Card(
//                         margin: EdgeInsets.only(bottom: 16),
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           side: BorderSide(
//                             color: Colors.grey[200]!,
//                             width: 1,
//                           ),
//                         ),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             gradient: LinearGradient(
//                               begin: Alignment.centerLeft,
//                               end: Alignment.centerRight,
//                               colors: [
//                                 Colors.white,
//                                 isOnTime ? Colors.green[50]! : Colors.red[50]!,
//                               ],
//                             ),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.all(20),
//                             child: Row(
//                               children: [
//                                 // Slot Code Container
//                                 Container(
//                                   width: 70,
//                                   height: 70,
//                                   decoration: BoxDecoration(
//                                     color: isOnTime ? Colors.green[100] : Colors.red[100],
//                                     borderRadius: BorderRadius.circular(12),
//                                     border: Border.all(
//                                       color: isOnTime ? Colors.green[200]! : Colors.red[200]!,
//                                       width: 1,
//                                     ),
//                                   ),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         '${slot['code']}',
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                           color: isOnTime ? Colors.green[800] : Colors.red[800],
//                                         ),
//                                       ),
//                                       Container(
//                                         margin: EdgeInsets.only(top: 4),
//                                         padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                                         decoration: BoxDecoration(
//                                           color: isOnTime ? Colors.green[200] : Colors.red[200],
//                                           borderRadius: BorderRadius.circular(8),
//                                         ),
//                                         child: Text(
//                                           isOnTime ? 'ON' : 'OFF',
//                                           style: TextStyle(
//                                             fontSize: 10,
//                                             fontWeight: FontWeight.w600,
//                                             color: isOnTime ? Colors.green[800] : Colors.red[800],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//
//                                 SizedBox(width: 16),
//
//                                 // Slot Information
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         slot['description'],
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.grey[800],
//                                         ),
//                                       ),
//                                       SizedBox(height: 8),
//
//                                       // Time Display/Edit - FIXED: Proper reactive UI
//                                       Obx(() => InkWell(
//                                         onTap: slotController.isEditMode.value && !slotController.isSaving.value
//                                             ? () => _showTimePickerDialog(context, slot)
//                                             : null,
//                                         borderRadius: BorderRadius.circular(8),
//                                         child: Container(
//                                           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                                           decoration: BoxDecoration(
//                                             color: slotController.isEditMode.value
//                                                 ? (slotController.modifiedSlots.contains(slotCode)
//                                                 ? Colors.orange[50]
//                                                 : Colors.blue[50])
//                                                 : Colors.grey[100],
//                                             borderRadius: BorderRadius.circular(8),
//                                             border: Border.all(
//                                               color: slotController.isEditMode.value
//                                                   ? (slotController.modifiedSlots.contains(slotCode)
//                                                   ? Colors.orange[200]!
//                                                   : Colors.blue[200]!)
//                                                   : Colors.transparent,
//                                               width: 1,
//                                             ),
//                                           ),
//                                           child: Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Icon(
//                                                 Icons.access_time,
//                                                 size: 16,
//                                                 color: slotController.isEditMode.value
//                                                     ? (slotController.modifiedSlots.contains(slotCode)
//                                                     ? Colors.orange[600]
//                                                     : Colors.blue[600])
//                                                     : Colors.grey[600],
//                                               ),
//                                               SizedBox(width: 6),
//                                               Text(
//                                                 formattedTime,
//                                                 style: TextStyle(
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.w600,
//                                                   color: slotController.isEditMode.value
//                                                       ? (slotController.modifiedSlots.contains(slotCode)
//                                                       ? Colors.orange[700]
//                                                       : Colors.blue[700])
//                                                       : Colors.grey[700],
//                                                   fontFamily: 'monospace',
//                                                 ),
//                                               ),
//                                               if (slotController.isEditMode.value && !slotController.isSaving.value) ...[
//                                                 SizedBox(width: 6),
//                                                 Icon(
//                                                   slotController.modifiedSlots.contains(slotCode)
//                                                       ? Icons.edit_outlined
//                                                       : Icons.edit,
//                                                   size: 14,
//                                                   color: slotController.modifiedSlots.contains(slotCode)
//                                                       ? Colors.orange[600]
//                                                       : Colors.blue[600],
//                                                 ),
//                                               ],
//                                               if (slotController.modifiedSlots.contains(slotCode)) ...[
//                                                 SizedBox(width: 6),
//                                                 Container(
//                                                   width: 6,
//                                                   height: 6,
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.orange,
//                                                     shape: BoxShape.circle,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ],
//                                           ),
//                                         ),
//                                       )),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }),
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
//
//   void _showTimePickerDialog(BuildContext context, Map<String, dynamic> slot) {
//     final currentTime = slotController.formatSeconds(slot['value']);
//     final timeParts = currentTime.split(':');
//
//     int selectedHours = int.parse(timeParts[0]);
//     int selectedMinutes = int.parse(timeParts[1]);
//     int selectedSeconds = int.parse(timeParts[2]);
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               title: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Edit Time',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     slot['description'],
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[600],
//                       fontWeight: FontWeight.normal,
//                     ),
//                   ),
//                 ],
//               ),
//               content: Container(
//                 width: double.maxFinite,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[50],
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           _buildTimeSelector(
//                             'Hours',
//                             selectedHours,
//                             0,
//                             23,
//                                 (value) => setState(() => selectedHours = value),
//                           ),
//                           Text(
//                             ':',
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           _buildTimeSelector(
//                             'Minutes',
//                             selectedMinutes,
//                             0,
//                             59,
//                                 (value) => setState(() => selectedMinutes = value),
//                           ),
//                           Text(
//                             ':',
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           _buildTimeSelector(
//                             'Seconds',
//                             selectedSeconds,
//                             0,
//                             59,
//                                 (value) => setState(() => selectedSeconds = value),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Container(
//                       padding: EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.blue[50],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.info_outline,
//                             size: 16,
//                             color: Colors.blue[600],
//                           ),
//                           SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               'New time: ${selectedHours.toString().padLeft(2, '0')}:${selectedMinutes.toString().padLeft(2, '0')}:${selectedSeconds.toString().padLeft(2, '0')}',
//                               style: TextStyle(
//                                 color: Colors.blue[700],
//                                 fontWeight: FontWeight.w500,
//                                 fontFamily: 'monospace',
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: Text(
//                     'Cancel',
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     final newSeconds = (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds;
//                     slotController.updateSlotValue(slot, newSeconds);
//                     Navigator.of(context).pop();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Text('Update'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildTimeSelector(String label, int value, int min, int max, ValueChanged<int> onChanged) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey[600],
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Colors.grey[300]!),
//           ),
//           child: Column(
//             children: [
//               InkWell(
//                 onTap: () {
//                   if (value < max) onChanged(value + 1);
//                 },
//                 child: Container(
//                   padding: EdgeInsets.all(8),
//                   child: Icon(
//                     Icons.keyboard_arrow_up,
//                     size: 20,
//                     color: value < max ? Colors.blue : Colors.grey[400],
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 child: Text(
//                   value.toString().padLeft(2, '0'),
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'monospace',
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   if (value > min) onChanged(value - 1);
//                 },
//                 child: Container(
//                   padding: EdgeInsets.all(8),
//                   child: Icon(
//                     Icons.keyboard_arrow_down,
//                     size: 20,
//                     color: value > min ? Colors.blue : Colors.grey[400],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// controllers/slot_controller.dart



import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Controller/Inspector/manual_controller.dart';

class SlotController extends GetxController {
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

  // NEW: Store modified values locally (this is the key fix)
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

  // Helper function to convert seconds to HH:MM:SS format
  String formatSeconds(dynamic secondsValue) {
    final seconds = secondsValue is String
        ? int.tryParse(secondsValue) ?? 0
        : secondsValue is int
        ? secondsValue
        : 0;

    if (seconds < 0) return '00:00:00';

    final hours = (seconds / 3600).truncate();
    final minutes = ((seconds % 3600) / 60).truncate();
    final remainingSeconds = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Helper function to convert HH:MM:SS format to seconds
  int timeToSeconds(String timeString) {
    final parts = timeString.split(':');
    if (parts.length != 3) return 0;

    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    final seconds = int.tryParse(parts[2]) ?? 0;

    return (hours * 3600) + (minutes * 60) + seconds;
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

  // NEW: Get the current value for a slot (either modified or original)
  int getCurrentSlotValue(String slotCode) {
    // If we have a modified value, return that
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
    if (value is String) {
      return int.tryParse(value) ?? 0;
    } else if (value is int) {
      return value;
    } else if (value is double) {
      return value.toInt();
    }
    return 0;
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
      print('Retrieving authentication token');
      final token = await getToken();

      if (token == null || token.isEmpty) {
        print('Authentication token is null or empty');
        throw Exception('Authentication token not found. Please login again.');
      }

      print('Updating ${modifiedSlots.length} slot timings...');
      print('Modified values: $modifiedValues');

      Get.snackbar(
        'Saving',
        'Updating ${modifiedSlots.length} slot timing(s)...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      int successCount = 0;
      List<String> failedSlots = [];

      for (String slotCode in modifiedSlots) {
        try {
          print('Processing slot: $slotCode');

          // Use the locally stored modified value
          int secondsValue = modifiedValues[slotCode] ?? 0;

          print('Using modified value for slot $slotCode: $secondsValue');

          final commandPrefix = slotCommandMap[slotCode];

          if (commandPrefix == null) {
            throw Exception('Unknown slot code: $slotCode');
          }

          final paddedSeconds = secondsValue.toString().padLeft(5, '0');
          final modbusValue = '$commandPrefix,001,001,$paddedSeconds,600';

          print('Sending data for slot $slotCode: $modbusValue');

          final requestBody = {
            "type": "config",
            "id": 1,
            "key": "modbus",
            "value": modbusValue,
          };

          final headers = {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          };

          final response = await http.post(
            Uri.parse('https://smartsolarcleaner.com/api/api/mqtt/publish/862360073414729'),
            headers: headers,
            body: jsonEncode(requestBody),
          ).timeout(const Duration(seconds: 30));

          if (response.statusCode == 200) {
            successCount++;
            print('Successfully updated slot $slotCode');
          } else {
            failedSlots.add(slotCode);
            print('Failed to update slot $slotCode: ${response.statusCode} - ${response.body}');
          }

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
        throw Exception('Failed to update any slot timings. Failed slots: ${failedSlots.join(", ")}');
      }
    } on TimeoutException {
      print('Request timed out');
      throw Exception('Request timed out. Please try again.');
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

  // Get authentication token from SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
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

  // FIXED: Update slot value and track modification
  void updateSlotValue(Map<String, dynamic> slot, int newSeconds) {
    final slotCode = slot['code'].toString();

    print('=== UPDATE SLOT DEBUG ===');
    print('Updating slot: $slotCode with newSeconds: $newSeconds');

    // Store the modified value locally (this is the key fix)
    modifiedValues[slotCode] = newSeconds;

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
      'Time updated for ${slot['description']} to ${formatSeconds(newSeconds)}',
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

// Rest of your InfoPage widget code remains the same...
class InfoPage extends StatelessWidget {
  final ManualController controller = Get.find<ManualController>();
  final SlotController slotController = Get.put(SlotController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Slot Timings',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
        actions: [
          Obx(() => slotController.isEditMode.value
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: slotController.isSaving.value
                          ? null
                          : slotController.cancelEdit,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: slotController.isSaving.value
                                ? Colors.grey[400]
                                : Colors.grey[600]),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: slotController.isSaving.value
                          ? null
                          : slotController.saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: slotController.isSaving.value
                            ? Colors.grey[400]
                            : Colors.blue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: slotController.isSaving.value
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text('Save'),
                    ),
                    SizedBox(width: 16),
                  ],
                )
              : IconButton(
                  onPressed: slotController.toggleEditMode,
                  icon: Icon(Icons.edit),
                  tooltip: 'Edit Timings',
                )),
        ],
      ),
      body: Obx(() {
        // Listen to refresh trigger to force rebuilds
        slotController.refreshTrigger.value;

        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                SizedBox(height: 16),
                Text(
                  'Loading slot timings...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red[300],
                ),
                SizedBox(height: 16),
                Text(
                  'Error loading data',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.red[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add retry logic here
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Header with edit mode indicator
            if (slotController.isEditMode.value)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                color: Colors.blue[50],
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      size: 20,
                      color: Colors.blue[700],
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Edit Mode: Tap on time values to modify',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Obx(() => slotController.modifiedSlots.isNotEmpty
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${slotController.modifiedSlots.length} modified',
                              style: TextStyle(
                                color: Colors.orange[800],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : SizedBox()),
                  ],
                ),
              ),

            Expanded(
              child: GetBuilder<SlotController>(
                builder: (slotCtrl) => Obx(() {
                  // Listen to both controllers
                  slotController.refreshTrigger.value;

                  return ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: controller.slotTimingsForDisplay.length,
                    itemBuilder: (context, index) {
                      final slot = controller.slotTimingsForDisplay[index];
                      final slotCode = slot['code'].toString();

                      // CHANGED: Use getCurrentSlotValue instead of slot['value']
                      final currentValue = slotController.getCurrentSlotValue(slotCode);
                      final formattedTime = slotController.formatSeconds(currentValue);

                      final isOnTime = slot['description']
                          .toString()
                          .toLowerCase()
                          .contains('on');

                      return Card(
                        margin: EdgeInsets.only(bottom: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.white,
                                isOnTime ? Colors.green[50]! : Colors.red[50]!,
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                // Slot Code Container
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: isOnTime
                                        ? Colors.green[100]
                                        : Colors.red[100],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isOnTime
                                          ? Colors.green[200]!
                                          : Colors.red[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${slot['code']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isOnTime
                                              ? Colors.green[800]
                                              : Colors.red[800],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 4),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: isOnTime
                                              ? Colors.green[200]
                                              : Colors.red[200],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          isOnTime ? 'ON' : 'OFF',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: isOnTime
                                                ? Colors.green[800]
                                                : Colors.red[800],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(width: 16),

                                // Slot Information
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        slot['description'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                      SizedBox(height: 8),

                                      // Time Display/Edit
                                      Obx(() => InkWell(
                                            onTap: slotController
                                                        .isEditMode.value &&
                                                    !slotController
                                                        .isSaving.value
                                                ? () => _showTimePickerDialog(
                                                    context, slot)
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: slotController
                                                        .isEditMode.value
                                                    ? (slotController
                                                            .modifiedSlots
                                                            .contains(slotCode)
                                                        ? Colors.orange[50]
                                                        : Colors.blue[50])
                                                    : Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: slotController
                                                          .isEditMode.value
                                                      ? (slotController
                                                              .modifiedSlots
                                                              .contains(
                                                                  slotCode)
                                                          ? Colors.orange[200]!
                                                          : Colors.blue[200]!)
                                                      : Colors.transparent,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    size: 16,
                                                    color: slotController
                                                            .isEditMode.value
                                                        ? (slotController
                                                                .modifiedSlots
                                                                .contains(
                                                                    slotCode)
                                                            ? Colors.orange[600]
                                                            : Colors.blue[600])
                                                        : Colors.grey[600],
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    formattedTime,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: slotController
                                                              .isEditMode.value
                                                          ? (slotController
                                                                  .modifiedSlots
                                                                  .contains(
                                                                      slotCode)
                                                              ? Colors
                                                                  .orange[700]
                                                              : Colors
                                                                  .blue[700])
                                                          : Colors.grey[700],
                                                      fontFamily: 'monospace',
                                                    ),
                                                  ),
                                                  if (slotController
                                                          .isEditMode.value &&
                                                      !slotController
                                                          .isSaving.value) ...[
                                                    SizedBox(width: 6),
                                                    Icon(
                                                      slotController
                                                              .modifiedSlots
                                                              .contains(
                                                                  slotCode)
                                                          ? Icons.edit_outlined
                                                          : Icons.edit,
                                                      size: 14,
                                                      color: slotController
                                                              .modifiedSlots
                                                              .contains(
                                                                  slotCode)
                                                          ? Colors.orange[600]
                                                          : Colors.blue[600],
                                                    ),
                                                  ],
                                                  if (slotController
                                                      .modifiedSlots
                                                      .contains(slotCode)) ...[
                                                    SizedBox(width: 6),
                                                    Container(
                                                      width: 6,
                                                      height: 6,
                                                      decoration: BoxDecoration(
                                                        color: Colors.orange,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showTimePickerDialog(BuildContext context, Map<String, dynamic> slot) {
    final slotCode = slot['code'].toString();
    // CHANGED: Use getCurrentSlotValue instead of slot['value']
    final currentValue = slotController.getCurrentSlotValue(slotCode);
    final currentTime = slotController.formatSeconds(currentValue);
    final timeParts = currentTime.split(':');

    int selectedHours = int.parse(timeParts[0]);
    int selectedMinutes = int.parse(timeParts[1]);
    int selectedSeconds = int.parse(timeParts[2]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Time',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    slot['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTimeSelector(
                            'Hours',
                            selectedHours,
                            0,
                            23,
                            (value) => setState(() => selectedHours = value),
                          ),
                          Text(
                            ':',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          _buildTimeSelector(
                            'Minutes',
                            selectedMinutes,
                            0,
                            59,
                            (value) => setState(() => selectedMinutes = value),
                          ),
                          Text(
                            ':',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          _buildTimeSelector(
                            'Seconds',
                            selectedSeconds,
                            0,
                            59,
                            (value) => setState(() => selectedSeconds = value),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.blue[600],
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'New time: ${selectedHours.toString().padLeft(2, '0')}:${selectedMinutes.toString().padLeft(2, '0')}:${selectedSeconds.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w500,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newSeconds = (selectedHours * 3600) +
                        (selectedMinutes * 60) +
                        selectedSeconds;
                    slotController.updateSlotValue(slot, newSeconds);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTimeSelector(
      String label, int value, int min, int max, ValueChanged<int> onChanged) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  if (value < max) onChanged(value + 1);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    size: 20,
                    color: value < max ? Colors.blue : Colors.grey[400],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  value.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (value > min) onChanged(value - 1);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: value > min ? Colors.blue : Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
