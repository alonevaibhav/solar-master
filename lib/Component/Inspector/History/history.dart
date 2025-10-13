// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:intl/intl.dart';
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
//     final String? uuid = plantData?['id']?.toString();
//     print('id of plant : $uuid');
//
//     // Set UUID and load data immediately
//     controller.setUuid(uuid);
//     controller.printUuidInfo();
//
//     // Call the method properly with parentheses and only if UUID is not null
//     if (uuid != null && uuid.isNotEmpty) {
//       controller.loadMqttHistory();
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: Text('Cleaning Cycles'),
//         backgroundColor: Colors.blue[700],
//         foregroundColor: Colors.white,
//         elevation: 2,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () {
//               if (uuid != null && uuid.isNotEmpty) {
//                 controller.refreshMqttHistory();
//               } else {
//                 print('UUID is null or empty, cannot refresh');
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
//                   'Loading cleaning cycles...',
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
//                       if (uuid != null && uuid.isNotEmpty) {
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
//                     'No Cleaning Cycles',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'No cleaning cycles found for this device',
//                     style: TextStyle(color: Colors.grey[500]),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 24),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       if (uuid != null && uuid.isNotEmpty) {
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
//         // Group data by cycle number
//         Map<String, List<Map<String, dynamic>>> groupedCycles =
//             _groupByCycle(controller.historyData);
//         List<String> sortedCycleKeys = groupedCycles.keys.toList()
//           ..sort(
//               (a, b) => int.tryParse(b)?.compareTo(int.tryParse(a) ?? 0) ?? 0);
//
//         return RefreshIndicator(
//           onRefresh: () async {
//             if (uuid != null && uuid.isNotEmpty) {
//               await controller.refreshMqttHistory();
//             }
//           },
//           child: ListView.builder(
//             padding: EdgeInsets.all(16),
//             itemCount: sortedCycleKeys.length,
//             itemBuilder: (context, index) {
//               String cycleNumber = sortedCycleKeys[index];
//               List<Map<String, dynamic>> cycleData =
//                   groupedCycles[cycleNumber]!;
//
//               // Sort logs within each cycle by timestamp (newest first)
//               cycleData.sort((a, b) {
//                 try {
//                   DateTime aTime = DateTime.parse(a['timestamp'] ?? '');
//                   DateTime bTime = DateTime.parse(b['timestamp'] ?? '');
//                   return bTime.compareTo(aTime);
//                 } catch (e) {
//                   return 0;
//                 }
//               });
//
//               return _buildCycleGroup(
//                   cycleNumber, cycleData, index == sortedCycleKeys.length - 1);
//             },
//           ),
//         );
//       }),
//     );
//   }
//
//   Map<String, List<Map<String, dynamic>>> _groupByCycle(List<dynamic> data) {
//     Map<String, List<Map<String, dynamic>>> grouped = {};
//
//     for (var item in data) {
//       String cycle = item['cycle']?.toString() ?? 'Unknown';
//       if (!grouped.containsKey(cycle)) {
//         grouped[cycle] = [];
//       }
//       grouped[cycle]!.add(item as Map<String, dynamic>);
//     }
//
//     return grouped;
//   }
//
//   Widget _buildCycleGroup(String cycleNumber,
//       List<Map<String, dynamic>> cycleData, bool isLastGroup) {
//     // Determine overall cycle status
//     bool isCompleted = cycleData.any((item) =>
//         item['complete'] == 1 ||
//         (item['status']?.toString().toLowerCase().contains('cycle complete') ??
//             false));
//
//     bool hasFault = cycleData.any((item) =>
//         item['status']?.toString().toLowerCase().contains('fault') ?? false);
//
//     Color headerColor = isCompleted
//         ? Colors.green[700]!
//         : hasFault
//             ? Colors.red[700]!
//             : Colors.blue[700]!;
//
//     Color headerBgColor = isCompleted
//         ? Colors.green[50]!
//         : hasFault
//             ? Colors.red[50]!
//             : Colors.blue[50]!;
//
//     return Container(
//       margin: EdgeInsets.only(bottom: isLastGroup ? 0 : 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Cycle Header
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: headerBgColor,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: headerColor.withOpacity(0.3)),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: headerColor,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     isCompleted
//                         ? Icons.check_circle
//                         : hasFault
//                             ? Icons.error
//                             : Icons.refresh,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Cleaning Cycle #$cycleNumber',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: headerColor,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         isCompleted
//                             ? 'Completed Successfully'
//                             : hasFault
//                                 ? 'Completed with Issues'
//                                 : 'In Progress/Stopped',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: headerColor.withOpacity(0.8),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: headerColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: headerColor.withOpacity(0.3)),
//                   ),
//                   child: Text(
//                     '${cycleData.length} log${cycleData.length != 1 ? 's' : ''}',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: headerColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           SizedBox(height: 12),
//
//           // Timeline for this cycle
//           Container(
//             padding: EdgeInsets.only(left: 16),
//             child: Column(
//               children: cycleData.asMap().entries.map((entry) {
//                 int index = entry.key;
//                 Map<String, dynamic> item = entry.value;
//                 bool isLastInCycle = index == cycleData.length - 1;
//
//                 return _buildTimelineItem(item, isLastInCycle, true);
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTimelineItem(
//       Map<String, dynamic> item, bool isLast, bool isInGroup) {
//     // Format the timestamp for display
//     String timeAgo = 'Unknown time';
//     String fullDate = 'Unknown date';
//
//     if (item['timestamp'] != null) {
//       try {
//         DateTime dateTime = DateTime.parse(item['timestamp']);
//         DateTime now = DateTime.now();
//         Duration difference = now.difference(dateTime);
//
//         // Calculate time ago
//         if (difference.inMinutes < 1) {
//           timeAgo = 'Just now';
//         } else if (difference.inMinutes < 60) {
//           timeAgo = '${difference.inMinutes}m ago';
//         } else if (difference.inHours < 24) {
//           timeAgo = '${difference.inHours}h ago';
//         } else {
//           timeAgo = '${difference.inDays}d ago';
//         }
//
//         fullDate =
//             DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime.toLocal());
//       } catch (e) {
//         timeAgo = 'Unknown';
//         fullDate = item['timestamp'].toString();
//       }
//     }
//
//     // Extract cleaning cycle details
//     String time = item['time']?.toString() ?? 'Unknown time';
//     int complete = item['complete'] ?? 0;
//     String status = item['status']?.toString() ?? 'Unknown status';
//     String solenoid = item['solenoid']?.toString() ?? 'Unknown';
//
//     // Determine colors and icons based on status
//     Color circleColor = Colors.grey[400]!;
//     Color textColor = Colors.grey[700]!;
//     IconData statusIcon = Icons.circle;
//     String statusText = status;
//
//     if (complete == 1 || status.toLowerCase().contains('cycle complete')) {
//       circleColor = Colors.green[500]!;
//       textColor = Colors.green[700]!;
//       statusIcon = Icons.check_circle;
//     } else if (status.toLowerCase().contains('fault') ||
//         status.toLowerCase().contains('error')) {
//       circleColor = Colors.red[500]!;
//       textColor = Colors.red[700]!;
//       statusIcon = Icons.error;
//     } else if (status.toLowerCase().contains('started')) {
//       circleColor = Colors.blue[500]!;
//       textColor = Colors.blue[700]!;
//       statusIcon = Icons.play_circle;
//     } else if (status.toLowerCase().contains('stopped')) {
//       circleColor = Colors.orange[500]!;
//       textColor = Colors.orange[700]!;
//       statusIcon = Icons.pause_circle;
//     } else if (status.toLowerCase().contains('warning')) {
//       circleColor = Colors.amber[500]!;
//       textColor = Colors.amber[700]!;
//       statusIcon = Icons.warning;
//     }
//
//     return IntrinsicHeight(
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Timeline indicator
//           Column(
//             children: [
//               Container(
//                 width: 32,
//                 height: 32,
//                 decoration: BoxDecoration(
//                   color: circleColor,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: circleColor.withOpacity(0.3),
//                       blurRadius: 4,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   statusIcon,
//                   color: Colors.white,
//                   size: 16,
//                 ),
//               ),
//               if (!isLast)
//                 Container(
//                   width: 2,
//                   height: 50,
//                   color: Colors.grey[300],
//                   margin: EdgeInsets.symmetric(vertical: 4),
//                 ),
//             ],
//           ),
//
//           SizedBox(width: 12),
//
//           // Content
//           Expanded(
//             child: Container(
//               margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Header with time ago
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         timeAgo,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[500],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       if (solenoid != 'Unknown' && solenoid != '0')
//                         Container(
//                           padding:
//                               EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: Colors.purple[50],
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(color: Colors.purple[200]!),
//                           ),
//                           child: Text(
//                             'Solenoid: $solenoid',
//                             style: TextStyle(
//                               fontSize: 10,
//                               color: Colors.purple[700],
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//
//                   SizedBox(height: 4),
//
//                   // Status message
//                   Text(
//                     statusText,
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: textColor,
//                     ),
//                   ),
//
//                   SizedBox(height: 6),
//
//                   // Details
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(6),
//                       border: Border.all(color: Colors.grey[200]!),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildDetailItem(
//                           icon: Icons.access_time,
//                           label: 'Device Time',
//                           value: time,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailItem({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           size: 12,
//           color: Colors.grey[500],
//         ),
//         SizedBox(width: 4),
//         Text(
//           '$label: ',
//           style: TextStyle(
//             fontSize: 11,
//             color: Colors.grey[600],
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             style: TextStyle(
//               fontSize: 11,
//               color: Colors.grey[800],
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../../../Model/Inspector/history_model.dart';
import 'history_controller.dart';


class HistoryInspector extends StatelessWidget {
  HistoryInspector({super.key});

  final InspectorHistoryController controller = Get.put(InspectorHistoryController());

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? plantData = Get.arguments;
    print('Received plant data: $plantData');
    final String? plantID = plantData?['id']?.toString();
    print('id of plant : $plantID');

    controller.setUuid(plantID);
    controller.printUuidInfo();

    if (plantID != null && plantID.isNotEmpty) {
      controller.loadMqttHistory();
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Cleaning Cycles'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              if (plantID != null && plantID.isNotEmpty) {
                controller.refreshMqttHistory();
              } else {
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
                  'Loading cleaning cycles...',
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
                      if (plantID != null && plantID.isNotEmpty) {
                        controller.loadMqttHistory();
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

        if (controller.cycles.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'No Cleaning Cycles',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No cleaning cycles found for this device',
                    style: TextStyle(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (plantID != null && plantID.isNotEmpty) {
                        controller.loadMqttHistory();
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
            if (plantID != null && plantID.isNotEmpty) {
              await controller.refreshMqttHistory();
            }
          },
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.cycles.length,
            itemBuilder: (context, index) {
              final cycle = controller.cycles[index];
              final isLastCycle = index == controller.cycles.length - 1;

              return _buildCycleGroup(cycle, isLastCycle);
            },
          ),
        );
      }),
    );
  }

  Widget _buildCycleGroup(CycleData cycle, bool isLastGroup) {
    final summary = cycle.summary;
    final isCompleted = summary.isCompleted;
    final hasFault = summary.faultCount > 0;

    Color headerColor = isCompleted
        ? Colors.green[700]!
        : hasFault
        ? Colors.red[700]!
        : Colors.blue[700]!;

    Color headerBgColor = isCompleted
        ? Colors.green[50]!
        : hasFault
        ? Colors.red[50]!
        : Colors.blue[50]!;

    return Container(
      margin: EdgeInsets.only(bottom: isLastGroup ? 0 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cycle Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: headerBgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: headerColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: headerColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.check_circle
                        : hasFault
                        ? Icons.error
                        : Icons.refresh,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cleaning Cycle #${cycle.cycleNumber}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: headerColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        isCompleted
                            ? 'Completed Successfully'
                            : hasFault
                            ? 'Completed with ${summary.faultCount} Fault(s)'
                            : 'In Progress/Stopped',
                        style: TextStyle(
                          fontSize: 14,
                          color: headerColor.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: headerColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: headerColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    '${summary.totalEvents} event${summary.totalEvents != 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: headerColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          // Cycle Summary Info
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryItem('Started', summary.startedAt, Icons.play_arrow),
                if (summary.completedAt != null) ...[
                  SizedBox(height: 8),
                  _buildSummaryItem(
                      'Completed', summary.completedAt!, Icons.check),
                ],
                SizedBox(height: 8),
                _buildSummaryItem('Start Method', summary.startMethod, Icons.touch_app),
                SizedBox(height: 8),
                _buildSummaryItem(
                    'Stop Method', summary.stopMethod, Icons.stop_circle),
                SizedBox(height: 8),
                _buildSummaryItem(
                    'Solenoid Range',
                    '${summary.solenoidRange.min} - ${summary.solenoidRange.max}',
                    Icons.info),
              ],
            ),
          ),

          SizedBox(height: 12),

          // Timeline for events
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              children: cycle.events.asMap().entries.map((entry) {
                int index = entry.key;
                CycleEvent event = entry.value;
                bool isLastEvent = index == cycle.events.length - 1;

                return _buildTimelineItem(event, isLastEvent);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(CycleEvent event, bool isLast) {
    String timeAgo = 'Unknown time';
    String fullDate = 'Unknown date';

    if (event.timestamp.isNotEmpty) {
      try {
        DateTime dateTime = DateTime.parse(event.timestamp);
        DateTime now = DateTime.now();
        Duration difference = now.difference(dateTime);

        if (difference.inMinutes < 1) {
          timeAgo = 'Just now';
        } else if (difference.inMinutes < 60) {
          timeAgo = '${difference.inMinutes}m ago';
        } else if (difference.inHours < 24) {
          timeAgo = '${difference.inHours}h ago';
        } else {
          timeAgo = '${difference.inDays}d ago';
        }

        fullDate =
            DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime.toLocal());
      } catch (e) {
        timeAgo = 'Unknown';
        fullDate = event.timestamp;
      }
    }

    Color circleColor = Colors.grey[400]!;
    Color textColor = Colors.grey[700]!;
    IconData statusIcon = Icons.circle;
    String statusText = event.status;

    if (event.complete == 1 ||
        event.status.toLowerCase().contains('cycle complete')) {
      circleColor = Colors.green[500]!;
      textColor = Colors.green[700]!;
      statusIcon = Icons.check_circle;
    } else if (event.status.toLowerCase().contains('fault') ||
        event.status.toLowerCase().contains('error')) {
      circleColor = Colors.red[500]!;
      textColor = Colors.red[700]!;
      statusIcon = Icons.error;
    } else if (event.status.toLowerCase().contains('started')) {
      circleColor = Colors.blue[500]!;
      textColor = Colors.blue[700]!;
      statusIcon = Icons.play_circle;
    } else if (event.status.toLowerCase().contains('stopped')) {
      circleColor = Colors.orange[500]!;
      textColor = Colors.orange[700]!;
      statusIcon = Icons.pause_circle;
    } else if (event.status.toLowerCase().contains('warning')) {
      circleColor = Colors.amber[500]!;
      textColor = Colors.amber[700]!;
      statusIcon = Icons.warning;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: circleColor.withOpacity(0.3),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  statusIcon,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 50,
                  color: Colors.grey[300],
                  margin: EdgeInsets.symmetric(vertical: 4),
                ),
            ],
          ),

          SizedBox(width: 12),

          // Content
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (event.solenoid != 0)
                        Container(
                          padding:
                          EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.purple[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.purple[200]!),
                          ),
                          child: Text(
                            'Solenoid: ${event.solenoid}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.purple[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 4),

                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),

                  SizedBox(height: 6),

                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Device Time: ',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            event.time,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}