//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:intl/intl.dart'; // Add this import for date formatting
//
// import 'history_controller.dart';
//
// class HistoryInspector extends StatelessWidget {
//   HistoryInspector({super.key});
//
//   final InspectorHistoryController controller = Get.put(InspectorHistoryController());
//
//   @override
//   Widget build(BuildContext context) {
//     // Move argument parsing inside build method
//     final Map<String, dynamic>? plantData = Get.arguments;
//     print('Received plant data: $plantData');
//     final String? uuid = plantData?['uuid']?.toString();
//     print('UUID: $uuid');
//     controller.loadMqttHistory;
//
//
//     // Set UUID after creation
//     controller.setUuid(uuid);
//     controller.printUuidInfo();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Inspector History'),
//         backgroundColor: Colors.blue[700],
//         foregroundColor: Colors.white,
//         elevation: 2,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () {
//               if (uuid != null) {
//                 controller.refreshMqttHistory();
//               } else {
//                 print('UUID is null, cannot refresh');
//                 Get.snackbar(
//                   'Error',
//                   'No valid UUID provided',
//                   backgroundColor: Colors.red[100],
//                   colorText: Colors.red[800],
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'Loading history...',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         if (controller.hasError.value) {
//           return Center(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
//                   SizedBox(height: 16),
//                   Text(
//                     'Something went wrong',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.red[700],
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     controller.errorMessage.value,
//                     style: TextStyle(color: Colors.red[600]),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 24),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       if (uuid != null) {
//                         controller.loadMqttHistory();
//                       } else {
//                         Get.snackbar(
//                           'Error',
//                           'No valid UUID provided',
//                           backgroundColor: Colors.red[100],
//                           colorText: Colors.red[800],
//                         );
//                       }
//                     },
//                     icon: Icon(Icons.refresh),
//                     label: Text('Retry'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue[700],
//                       foregroundColor: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//
//         if (controller.historyData.isEmpty) {
//           return Center(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.history, size: 64, color: Colors.grey[400]),
//                   SizedBox(height: 16),
//                   Text(
//                     'No History Available',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'No notification history found for this device',
//                     style: TextStyle(color: Colors.grey[500]),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 24),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       if (uuid != null) {
//                         controller.loadMqttHistory();
//                       } else {
//                         Get.snackbar(
//                           'Error',
//                           'No valid UUID provided',
//                           backgroundColor: Colors.red[100],
//                           colorText: Colors.red[800],
//                         );
//                       }
//                     },
//                     icon: Icon(Icons.refresh),
//                     label: Text('Load Data'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue[700],
//                       foregroundColor: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//
//         return RefreshIndicator(
//           onRefresh: () async {
//             if (uuid != null) {
//               await controller.refreshMqttHistory();
//             }
//           },
//           child: ListView.separated(
//             padding: EdgeInsets.all(16),
//             itemCount: controller.historyData.length,
//             separatorBuilder: (context, index) => SizedBox(height: 12),
//             itemBuilder: (context, index) {
//               final item = controller.historyData[index];
//               return _buildHistoryCard(item);
//             },
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildHistoryCard(Map<String, dynamic> item) {
//     // Format the timestamp
//     String formattedDate = 'Unknown date';
//     if (item['created_at'] != null) {
//       try {
//         DateTime dateTime = DateTime.parse(item['created_at']);
//         formattedDate = DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime.toLocal());
//       } catch (e) {
//         formattedDate = item['created_at'].toString();
//       }
//     }
//
//     // Get the message from parsed notification data
//     String message = item['parsed_message'] ?? 'No message';
//
//     // Determine card color based on message type
//     Color cardColor = Colors.white;
//     Color borderColor = Colors.grey[300]!;
//     IconData messageIcon = Icons.info_outline;
//     Color iconColor = Colors.blue[700]!;
//
//     if (message.toLowerCase().contains('completed')) {
//       borderColor = Colors.green[300]!;
//       iconColor = Colors.green[700]!;
//       messageIcon = Icons.check_circle_outline;
//     } else if (message.toLowerCase().contains('not responding') ||
//         message.toLowerCase().contains('error')) {
//       borderColor = Colors.red[300]!;
//       iconColor = Colors.red[700]!;
//       messageIcon = Icons.error_outline;
//     } else if (message.toLowerCase().contains('warning')) {
//       borderColor = Colors.orange[300]!;
//       iconColor = Colors.orange[700]!;
//       messageIcon = Icons.warning_amber_outlined;
//     }
//
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: borderColor, width: 1),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   messageIcon,
//                   color: iconColor,
//                   size: 24,
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     message,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey[800],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12),
//             Row(
//               children: [
//                 Icon(
//                   Icons.access_time,
//                   size: 16,
//                   color: Colors.grey[500],
//                 ),
//                 SizedBox(width: 6),
//                 Text(
//                   formattedDate,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ],
//             ),
//             if (item['id'] != null) ...[
//               SizedBox(height: 8),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.tag,
//                     size: 16,
//                     color: Colors.grey[500],
//                   ),
//                   SizedBox(width: 6),
//                   Text(
//                     'ID: ${item['id']}',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey[500],
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

import 'history_controller.dart';

class HistoryInspector extends StatelessWidget {
  HistoryInspector({super.key});

  final InspectorHistoryController controller = Get.put(InspectorHistoryController());

  @override
  Widget build(BuildContext context) {
    // Move argument parsing inside build method
    final Map<String, dynamic>? plantData = Get.arguments;
    print('Received plant data: $plantData');
    final String? uuid = plantData?['uuid']?.toString();
    print('UUID: $uuid');

    // Set UUID and load data immediately
    controller.setUuid(uuid);
    controller.printUuidInfo();

    // Call the method properly with parentheses and only if UUID is not null
    if (uuid != null && uuid.isNotEmpty) {
      controller.loadMqttHistory();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Inspector History'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              if (uuid != null && uuid.isNotEmpty) {
                controller.refreshMqttHistory();
              } else {
                print('UUID is null or empty, cannot refresh');
                Get.snackbar(
                  'Error',
                  'No valid UUID provided',
                  backgroundColor: Colors.red[100],
                  colorText: Colors.red[800],
                );
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
                ),
                SizedBox(height: 16),
                Text(
                  'Loading history...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.hasError.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                  SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    controller.errorMessage.value,
                    style: TextStyle(color: Colors.red[600]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (uuid != null && uuid.isNotEmpty) {
                        controller.loadMqttHistory();
                      } else {
                        Get.snackbar(
                          'Error',
                          'No valid UUID provided',
                          backgroundColor: Colors.red[100],
                          colorText: Colors.red[800],
                        );
                      }
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.historyData.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'No History Available',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No notification history found for this device',
                    style: TextStyle(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (uuid != null && uuid.isNotEmpty) {
                        controller.loadMqttHistory();
                      } else {
                        Get.snackbar(
                          'Error',
                          'No valid UUID provided',
                          backgroundColor: Colors.red[100],
                          colorText: Colors.red[800],
                        );
                      }
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Load Data'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            if (uuid != null && uuid.isNotEmpty) {
              await controller.refreshMqttHistory();
            }
          },
          child: ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: controller.historyData.length,
            separatorBuilder: (context, index) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = controller.historyData[index];
              return _buildHistoryCard(item);
            },
          ),
        );
      }),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item) {
    // Format the timestamp
    String formattedDate = 'Unknown date';
    if (item['created_at'] != null) {
      try {
        DateTime dateTime = DateTime.parse(item['created_at']);
        formattedDate = DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime.toLocal());
      } catch (e) {
        formattedDate = item['created_at'].toString();
      }
    }

    // Get the message from parsed notification data
    String message = item['parsed_message'] ?? 'No message';

    // Determine card color based on message type
    Color cardColor = Colors.white;
    Color borderColor = Colors.grey[300]!;
    IconData messageIcon = Icons.info_outline;
    Color iconColor = Colors.blue[700]!;

    if (message.toLowerCase().contains('completed')) {
      borderColor = Colors.green[300]!;
      iconColor = Colors.green[700]!;
      messageIcon = Icons.check_circle_outline;
    } else if (message.toLowerCase().contains('not responding') ||
        message.toLowerCase().contains('error')) {
      borderColor = Colors.red[300]!;
      iconColor = Colors.red[700]!;
      messageIcon = Icons.error_outline;
    } else if (message.toLowerCase().contains('warning')) {
      borderColor = Colors.orange[300]!;
      iconColor = Colors.orange[700]!;
      messageIcon = Icons.warning_amber_outlined;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  messageIcon,
                  color: iconColor,
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey[500],
                ),
                SizedBox(width: 6),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            if (item['id'] != null) ...[
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.tag,
                    size: 16,
                    color: Colors.grey[500],
                  ),
                  SizedBox(width: 6),
                  Text(
                    'ID: ${item['id']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}