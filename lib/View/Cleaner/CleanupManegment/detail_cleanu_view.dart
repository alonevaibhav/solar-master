//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'cleanup_controller.dart';
//
// class DetailsViewTask extends StatelessWidget {
//   const DetailsViewTask({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<CleaningManagementController>(
//       builder: (controller) {
//         return Scaffold(
//           backgroundColor: Colors.grey.shade100,
//           appBar: AppBar(
//             backgroundColor: Colors.white,
//             elevation: 0,
//             leading: IconButton(
//               icon: Container(
//                 padding: EdgeInsets.all(7.2.w),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade500,
//                   borderRadius: BorderRadius.circular(7.2.r),
//                 ),
//                 child: Icon(
//                   Icons.arrow_back,
//                   color: Colors.white,
//                   size: 16.2.w,
//                 ),
//               ),
//               onPressed: () => Get.back(),
//             ),
//             title: Text(
//               'Task Details',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 16.2.sp,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             centerTitle: true,
//             actions: [
//               IconButton(
//                 icon: Icon(
//                   Icons.notifications_outlined,
//                   color: Colors.black,
//                   size: 21.6.w,
//                 ),
//                 onPressed: () {},
//               ),
//             ],
//           ),
//           body: Obx(() {
//             if (controller.isTaskDetailsLoading.value) {
//               return const Center(
//                 child: CircularProgressIndicator(
//                   color: Colors.blue,
//                 ),
//               );
//             }
//
//             if (!controller.isTaskDataValid) {
//               return Center(
//                 child: Text(
//                   'No task data available',
//                   style: TextStyle(
//                     fontSize: 14.4.sp,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//               );
//             }
//
//             return SingleChildScrollView(
//               padding: EdgeInsets.all(14.4.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // ETA Timer Card (show only when timer is active)
//                   _buildEtaTimerCard(controller),
//
//                   // Panel Status Card
//                   _buildPanelStatusCard(controller),
//                   SizedBox(height: 14.4.h),
//
//                   // Task Info Card
//                   _buildTaskInfoCard(controller),
//                   SizedBox(height: 14.4.h),
//
//                   // Location Card
//                   _buildLocationCard(controller),
//                   SizedBox(height: 14.4.h),
//
//                   // Panel Valves List
//                   _buildPanelValvesList(controller),
//                   SizedBox(height: 21.6.h),
//
//                   // Maintenance Button
//                   _buildMaintenanceButton(controller),
//                   SizedBox(height: 14.4.h),
//                 ],
//               ),
//             );
//           }),
//         );
//       },
//     );
//   }
//
//   Widget _buildEtaTimerCard(CleaningManagementController controller) {
//     return Obx(() {
//       if (!controller.isEtaTimerActive.value ||
//           controller.taskStatus.value != 'cleaning') {
//         return const SizedBox.shrink();
//       }
//
//       return Container(
//         margin: EdgeInsets.only(bottom: 14.4.h),
//         padding: EdgeInsets.all(14.4.w),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Colors.blue, Color.fromARGB(255, 30, 132, 183)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(10.8.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.blue.withOpacity(0.3),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Timer Icon
//             Container(
//               padding: EdgeInsets.all(10.8.w),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//               child: const Icon(
//                 Icons.timer,
//                 color: Colors.white,
//                 size: 24,
//               ),
//             ),
//             SizedBox(width: 14.4.w),
//
//             // Timer Info
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Cleaning in Progress',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14.4.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     'Estimated Time Remaining',
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.8),
//                       fontSize: 11.sp,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // ETA Display
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//               child: Obx(() => Text(
//                 controller.formattedETA,
//                 style: TextStyle(
//                   color: Colors.blue.shade600,
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               )),
//             ),
//           ],
//         ),
//       );
//     });
//   }
//
//   Widget _buildPanelStatusCard(CleaningManagementController controller) {
//     return Container(
//       padding: EdgeInsets.all(14.4.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10.8.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 9,
//             offset: const Offset(0, 1.8),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Completed Panels
//           Container(
//             width: 45.w,
//             height: 45.h,
//             decoration: BoxDecoration(
//               color: Colors.green.shade400,
//               borderRadius: BorderRadius.circular(10.8.r),
//             ),
//             child: Center(
//               child: Obx(() {
//                 final counts = controller.getPanelCounts();
//                 return Text(
//                   '${counts['completed']}',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16.2.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 );
//               }),
//             ),
//           ),
//           SizedBox(width: 10.8.w),
//
//           // Pending Panels
//           Container(
//             width: 45.w,
//             height: 45.h,
//             decoration: BoxDecoration(
//               color: Colors.red.shade400,
//               borderRadius: BorderRadius.circular(10.8.r),
//             ),
//             child: Center(
//               child: Obx(() {
//                 final counts = controller.getPanelCounts();
//                 return Text(
//                   '${counts['pending']}',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16.2.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 );
//               }),
//             ),
//           ),
//           SizedBox(width: 14.4.w),
//
//           // Total Info
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Total',
//                   style: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: 12.6.sp,
//                   ),
//                 ),
//                 Obx(() {
//                   final total = controller.totalPanels;
//                   return Text(
//                     '$total Panels',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   );
//                 }),
//               ],
//             ),
//           ),
//           Icon(
//             Icons.more_vert,
//             color: Colors.grey.shade400,
//             size: 21.6.w,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTaskInfoCard(CleaningManagementController controller) {
//     return Container(
//       padding: EdgeInsets.all(14.4.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10.8.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 9,
//             offset: const Offset(0, 1.8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             controller.plantLocation,
//             style: TextStyle(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(height: 10.8.h),
//           Row(
//             children: [
//               Text(
//                 'Auto Clean: ',
//                 style: TextStyle(
//                   color: Colors.grey.shade600,
//                   fontSize: 12.6.sp,
//                 ),
//               ),
//               Text(
//                 controller.formatTime(controller.cleaningStartTime),
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 12.6.sp,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 7.2.h),
//           Row(
//             children: [
//               Text(
//                 'Status: ',
//                 style: TextStyle(
//                   color: Colors.grey.shade600,
//                   fontSize: 12.6.sp,
//                 ),
//               ),
//               Obx(() {
//                 final status = controller.taskStatus.value;
//                 return Container(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 7.2.w, vertical: 1.8.h),
//                   decoration: BoxDecoration(
//                     color: controller.getStatusColor(status).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(7.2.r),
//                   ),
//                   child: Text(
//                     status == 'pending'
//                         ? 'Cleaning Pending'
//                         : status.toUpperCase(),
//                     style: TextStyle(
//                       color: controller.getStatusColor(status),
//                       fontSize: 10.8.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 );
//               }),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLocationCard(CleaningManagementController controller) {
//     return Container(
//       padding: EdgeInsets.all(14.4.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10.8.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 9,
//             offset: const Offset(0, 1.8),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Location',
//                   style: TextStyle(
//                     fontSize: 14.4.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black,
//                   ),
//                 ),
//                 SizedBox(height: 7.2.h),
//                 Text(
//                   controller.plantLocation,
//                   style: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: 12.6.sp,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             width: 36.w,
//             height: 36.h,
//             decoration: BoxDecoration(
//               color: Colors.blue.shade500,
//               borderRadius: BorderRadius.circular(7.2.r),
//             ),
//             child: const Icon(
//               Icons.navigation,
//               color: Colors.white,
//               size: 18,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPanelValvesList(CleaningManagementController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Panel Valves',
//           style: TextStyle(
//             fontSize: 14.4.sp,
//             fontWeight: FontWeight.w600,
//             color: Colors.black,
//           ),
//         ),
//         SizedBox(height: 10.8.h),
//         Obx(() {
//           final totalPanels = controller.totalPanels;
//           final maxDisplay = totalPanels > 4 ? 4 : totalPanels;
//
//           return Column(
//             children: List.generate(maxDisplay, (index) {
//               final panelNumber = index + 1;
//               final isCompleted = controller.taskStatus.value == 'done';
//
//               return Container(
//                 margin: EdgeInsets.only(bottom: 10.8.h),
//                 padding: EdgeInsets.all(14.4.w),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10.8.r),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 9,
//                       offset: const Offset(0, 1.8),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         'Panel Valve - $panelNumber',
//                         style: TextStyle(
//                           fontSize: 12.6.sp,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: 21.6.w,
//                       height: 21.6.h,
//                       decoration: BoxDecoration(
//                         color: isCompleted
//                             ? Colors.green.shade400
//                             : Colors.grey.shade300,
//                         shape: BoxShape.circle,
//                       ),
//                       child: isCompleted
//                           ? const Icon(
//                         Icons.check,
//                         color: Colors.white,
//                         size: 14.4,
//                       )
//                           : null,
//                     ),
//                   ],
//                 ),
//               );
//             }),
//           );
//         }),
//         Obx(() {
//           final totalPanels = controller.totalPanels;
//           if (totalPanels > 4) {
//             return Container(
//               margin: EdgeInsets.only(top: 7.2.h),
//               child: Text(
//                 '... and ${totalPanels - 4} more panels',
//                 style: TextStyle(
//                   fontSize: 10.8.sp,
//                   color: Colors.grey.shade600,
//                   fontStyle: FontStyle.italic,
//                 ),
//               ),
//             );
//           }
//           return const SizedBox.shrink();
//         }),
//       ],
//     );
//   }
//
//   Widget _buildMaintenanceButton(CleaningManagementController controller) {
//     return Obx(() {
//       if (!controller.shouldShowMaintenanceButton) {
//         return const SizedBox.shrink();
//       }
//
//       return SizedBox(
//         width: double.infinity,
//         height: 45.h,
//         child: ElevatedButton(
//           onPressed: controller.isMaintenanceModeLoading.value
//               ? null
//               : controller.enableMaintenanceMode,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: controller.isMaintenanceModeEnabled.value
//                 ? Colors.green.shade500
//                 : Colors.black,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.8.r),
//             ),
//             elevation: 2,
//           ),
//           child: controller.isMaintenanceModeLoading.value
//               ? const SizedBox(
//             width: 18,
//             height: 18,
//             child: CircularProgressIndicator(
//               color: Colors.white,
//               strokeWidth: 2,
//             ),
//           )
//               : Text(
//             controller.maintenanceButtonText,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 14.4.sp,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'cleanup_controller.dart';

class DetailsViewTask extends StatelessWidget {
  const DetailsViewTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CleaningManagementController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(7.2.w), // Reduced from 8.w
                decoration: BoxDecoration(
                  color: Colors.blue.shade500,
                  borderRadius:
                  BorderRadius.circular(7.2.r), // Reduced from 8.r
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 16.2.w, // Reduced from 18.w
                ),
              ),
              onPressed: () => Get.back(),
            ),
            title: Text(
              'Task Details',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.2.sp, // Reduced from 18.sp
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                  size: 21.6.w, // Reduced from 24.w
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: Obx(() {
            if (controller.isTaskDetailsLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blue.shade500,
                ),
              );
            }

            if (!controller.isTaskDataValid) {
              return Center(
                child: Text(
                  'No task data available',
                  style: TextStyle(
                    fontSize: 14.4.sp, // Reduced from 16.sp
                    color: Colors.grey.shade600,
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(14.4.w), // Reduced from 16.w
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Panel Status Card
                  _buildPanelStatusCard(controller),
                  SizedBox(height: 14.4.h), // Reduced from 16.h

                  // Task Info Card
                  _buildTaskInfoCard(controller),
                  SizedBox(height: 14.4.h), // Reduced from 16.h

                  // Location Card
                  _buildLocationCard(controller),
                  SizedBox(height: 14.4.h), // Reduced from 16.h

                  // Panel Valves List
                  _buildPanelValvesList(controller),
                  SizedBox(height: 21.6.h), // Reduced from 24.h

                  // Maintenance Button
                  _buildMaintenanceButton(controller),
                  SizedBox(height: 14.4.h), // Reduced from 16.h
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildPanelStatusCard(CleaningManagementController controller) {
    return Container(
      padding: EdgeInsets.all(14.4.w), // Reduced from 16.w
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.8.r), // Reduced from 12.r
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 9, // Reduced from 10
            offset: Offset(0, 1.8), // Reduced from 2
          ),
        ],
      ),
      child: Row(
        children: [
          // Completed Panels
          Container(
            width: 45.w, // Reduced from 50.w
            height: 45.h, // Reduced from 50.h
            decoration: BoxDecoration(
              color: Colors.green.shade400,
              borderRadius: BorderRadius.circular(10.8.r), // Reduced from 12.r
            ),
            child: Center(
              child: Obx(() {
                final counts = controller.getPanelCounts();
                return Text(
                  '${counts['completed']}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.2.sp, // Reduced from 18.sp
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),
            ),
          ),
          SizedBox(width: 10.8.w), // Reduced from 12.w

          // Pending Panels
          Container(
            width: 45.w, // Reduced from 50.w
            height: 45.h, // Reduced from 50.h
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              borderRadius: BorderRadius.circular(10.8.r), // Reduced from 12.r
            ),
            child: Center(
              child: Obx(() {
                final counts = controller.getPanelCounts();
                return Text(
                  '${counts['pending']}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.2.sp, // Reduced from 18.sp
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),
            ),
          ),
          SizedBox(width: 14.4.w), // Reduced from 16.w

          // Total Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12.6.sp, // Reduced from 14.sp
                  ),
                ),
                Obx(() {
                  final total = controller.totalPanels;
                  return Text(
                    '$total Panels',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp, // Reduced from 20.sp
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ],
            ),
          ),

          // Options Icon
          Icon(
            Icons.more_vert,
            color: Colors.grey.shade400,
            size: 21.6.w, // Reduced from 24.w
          ),
        ],
      ),
    );
  }

  Widget _buildTaskInfoCard(CleaningManagementController controller) {
    return Container(
      padding: EdgeInsets.all(14.4.w), // Reduced from 16.w
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.8.r), // Reduced from 12.r
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 9, // Reduced from 10
            offset: Offset(0, 1.8), // Reduced from 2
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Building Title
          Text(
            controller.plantLocation,
            style: TextStyle(
              fontSize: 18.sp, // Reduced from 20.sp
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10.8.h), // Reduced from 12.h

          // Auto Clean Time
          Row(
            children: [
              Text(
                'Auto Clean: ',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12.6.sp, // Reduced from 14.sp
                ),
              ),
              Text(
                controller.formatTime(controller.cleaningStartTime),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.6.sp, // Reduced from 14.sp
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 7.2.h), // Reduced from 8.h

          // Status
          Row(
            children: [
              Text(
                'Status: ',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12.6.sp, // Reduced from 14.sp
                ),
              ),
              Obx(() {
                final status = controller.taskStatus.value;
                return Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 7.2.w,
                      vertical: 1.8.h), // Reduced from 8.w and 2.h
                  decoration: BoxDecoration(
                    color: controller.getStatusColor(status).withOpacity(0.1),
                    borderRadius:
                    BorderRadius.circular(7.2.r), // Reduced from 8.r
                  ),
                  child: Text(
                    status == 'pending'
                        ? 'Cleaning Pending'
                        : status.toUpperCase(),
                    style: TextStyle(
                      color: controller.getStatusColor(status),
                      fontSize: 10.8.sp, // Reduced from 12.sp
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(CleaningManagementController controller) {
    return Container(
      padding: EdgeInsets.all(14.4.w), // Reduced from 16.w
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.8.r), // Reduced from 12.r
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 9, // Reduced from 10
            offset: Offset(0, 1.8), // Reduced from 2
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 14.4.sp, // Reduced from 16.sp
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 7.2.h), // Reduced from 8.h
                Text(
                  controller.plantLocation,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12.6.sp, // Reduced from 14.sp
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 36.w, // Reduced from 40.w
            height: 36.h, // Reduced from 40.h
            decoration: BoxDecoration(
              color: Colors.blue.shade500,
              borderRadius: BorderRadius.circular(7.2.r), // Reduced from 8.r
            ),
            child: Icon(
              Icons.navigation,
              color: Colors.white,
              size: 18.w, // Reduced from 20.w
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanelValvesList(CleaningManagementController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Panel Valves',
          style: TextStyle(
            fontSize: 14.4.sp, // Reduced from 16.sp
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10.8.h), // Reduced from 12.h

        // Generate panel valve items based on total panels
        Obx(() {
          final totalPanels = controller.totalPanels;
          final maxDisplay = totalPanels > 4 ? 4 : totalPanels;

          return Column(
            children: List.generate(maxDisplay, (index) {
              final panelNumber = index + 1;
              final isCompleted = controller.taskStatus.value == 'done';

              return Container(
                margin: EdgeInsets.only(bottom: 10.8.h), // Reduced from 12.h
                padding: EdgeInsets.all(14.4.w), // Reduced from 16.w
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(10.8.r), // Reduced from 12.r
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 9, // Reduced from 10
                      offset: Offset(0, 1.8), // Reduced from 2
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Panel Valve - $panelNumber',
                        style: TextStyle(
                          fontSize: 12.6.sp, // Reduced from 14.sp
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      width: 21.6.w, // Reduced from 24.w
                      height: 21.6.h, // Reduced from 24.h
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Colors.green.shade400
                            : Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: isCompleted
                          ? Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14.4.w, // Reduced from 16.w
                      )
                          : null,
                    ),
                  ],
                ),
              );
            }),
          );
        }),

        // Show more panels indicator if needed
        Obx(() {
          final totalPanels = controller.totalPanels;
          if (totalPanels > 4) {
            return Container(
              margin: EdgeInsets.only(top: 7.2.h), // Reduced from 8.h
              child: Text(
                '... and ${totalPanels - 4} more panels',
                style: TextStyle(
                  fontSize: 10.8.sp, // Reduced from 12.sp
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          }
          return SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildMaintenanceButton(CleaningManagementController controller) {
    return Obx(() {
      if (!controller.shouldShowMaintenanceButton) {
        return SizedBox.shrink();
      }

      return SizedBox(
        width: double.infinity,
        height: 45.h, // Reduced from 50.h
        child: ElevatedButton(
          onPressed: controller.isMaintenanceModeLoading.value
              ? null
              : controller.enableMaintenanceMode,
          style: ElevatedButton.styleFrom(
            backgroundColor: controller.isMaintenanceModeEnabled.value
                ? Colors.green.shade500
                : Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.8.r), // Reduced from 12.r
            ),
            elevation: 2,
          ),
          child: controller.isMaintenanceModeLoading.value
              ? SizedBox(
            width: 18.w, // Reduced from 20.w
            height: 18.h, // Reduced from 20.h
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : Text(
            controller.maintenanceButtonText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.4.sp, // Reduced from 16.sp
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    });
  }
}