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
//     // Use Get.put to instantiate the controller if it hasn't been already
//     final CleaningManagementController controller = Get.put(CleaningManagementController());
//
//     final Map<String, dynamic>? plantData = Get.arguments;
//     print('Received plant data: $plantData');
//     final String? uuid = plantData?['plant_uuid']?.toString();
//     print('UUID: $uuid');
//
//     // Set UUID after creation
//     controller.setUuid(uuid);
//     controller.printUuidInfo();
//     // Set UUID after creation
//
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Container(
//             padding: EdgeInsets.all(7.2.w),
//             decoration: BoxDecoration(
//               color: Colors.blue.shade500,
//               borderRadius: BorderRadius.circular(7.2.r),
//             ),
//             child: Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//               size: 16.2.w,
//             ),
//           ),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           'Task Details',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 16.2.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.notifications_outlined,
//               color: Colors.black,
//               size: 21.6.w,
//             ),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isTaskDetailsLoading.value) {
//           return Center(
//             child: CircularProgressIndicator(
//               color: Colors.blue.shade500,
//             ),
//           );
//         }
//         if (!controller.isTaskDataValid) {
//           return Center(
//             child: Text(
//               'No task data available',
//               style: TextStyle(
//                 fontSize: 14.4.sp,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           );
//         }
//         return SingleChildScrollView(
//           padding: EdgeInsets.all(14.4.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ETA Container
//               _buildETAContainer(controller),
//               // Panel Status Card
//               _buildPanelStatusCard(controller),
//               SizedBox(height: 14.4.h),
//               // Task Info Card
//               _buildTaskInfoCard(controller),
//               SizedBox(height: 14.4.h),
//               // Location Card
//               _buildLocationCard(controller),
//               SizedBox(height: 14.4.h),
//               // Panel Valves List
//               _buildPanelValvesList(controller),
//               SizedBox(height: 21.6.h),
//               // Maintenance Button
//               _buildMaintenanceButton(controller,context),
//               SizedBox(height: 14.4.h),
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildETAContainer(CleaningManagementController controller) {
//     return Obx(() {
//       if (controller.taskStatus.value != 'cleaning' && !controller.isETAActive.value) {
//         return SizedBox.shrink();
//       }
//
//       return Container(
//         margin: EdgeInsets.only(bottom: 14.4.h),
//         padding: EdgeInsets.all(16.w),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blue.shade500, Colors.blue.shade600],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(12.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.blue.withOpacity(0.3),
//               blurRadius: 12,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Cleaning in Progress',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(8.r),
//                   ),
//                   child: Text(
//                     'ACTIVE',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 10.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16.h),
//
//             // ETA Timer Display - CHANGED TO ELAPSED TIME
//             Container(
//               padding: EdgeInsets.all(20.w),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(16.r),
//                 border: Border.all(
//                   color: Colors.white.withOpacity(0.3),
//                   width: 1,
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Text(
//                     'Time Elapsed', // CHANGED FROM "Estimated Time Remaining"
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.9),
//                       fontSize: 12.sp,
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   Text(
//                     controller.formattedElapsedTime, // CHANGED FROM formattedRemainingTime
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 32.sp,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'monospace',
//                     ),
//                   ),
//                   Text(
//                     'HH:MM:SS', // CHANGED FROM 'MM:SS'
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.7),
//                       fontSize: 10.sp,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             SizedBox(height: 12.h),
//
//             // Progress indicator - CHANGED TO SHOW ELAPSED PROGRESS
//             Row(
//               children: [
//                 Icon(
//                   Icons.access_time,
//                   color: Colors.white.withOpacity(0.8),
//                   size: 16.w,
//                 ),
//                 SizedBox(width: 8.w),
//                 Expanded(
//                   child: LinearProgressIndicator(
//                     backgroundColor: Colors.white.withOpacity(0.3),
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     // CHANGED: Show how much time has elapsed vs estimated time
//                     value: (controller.elapsedETA.value / (controller.maintenanceETA.value * 60))
//                         .clamp(0.0, 1.0), // Clamp to prevent overflow
//                   ),
//                 ),
//               ],
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
//             offset: Offset(0, 1.8),
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
//
//           // Options Icon
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
//             offset: Offset(0, 1.8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Building Title
//           Text(
//             controller.plantLocation,
//             style: TextStyle(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(height: 10.8.h),
//
//           // Auto Clean Time
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
//
//           // Status
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
//                   padding:
//                   EdgeInsets.symmetric(horizontal: 7.2.w, vertical: 1.8.h),
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
//             offset: Offset(0, 1.8),
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
//             child: Icon(
//               Icons.navigation,
//               color: Colors.white,
//               size: 18.w,
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
//
//         // Show total panel valves count
//         Obx(() {
//           final totalPanels = controller.numberOfBoxes.value;
//           final isCompleted = controller.taskStatus.value == 'done';
//
//           return Container(
//             padding: EdgeInsets.all(14.4.w),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10.8.r),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 9,
//                   offset: Offset(0, 1.8),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     'Total Panel Valves: $totalPanels',
//                     style: TextStyle(
//                       fontSize: 12.6.sp,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: 21.6.w,
//                   height: 21.6.h,
//                   decoration: BoxDecoration(
//                     color: isCompleted
//                         ? Colors.green.shade400
//                         : Colors.grey.shade300,
//                     shape: BoxShape.circle,
//                   ),
//                   child: isCompleted
//                       ? Icon(
//                     Icons.check,
//                     color: Colors.white,
//                     size: 14.4.w,
//                   )
//                       : null,
//                 ),
//               ],
//             ),
//           );
//         }),
//       ],
//     );
//   }
//
//   // / Updated maintenance button method - Fixed version
//   Widget _buildMaintenanceButton(CleaningManagementController controller,context) {
//     return Obx(() {
//       if (!controller.shouldShowMaintenanceButton) {
//         return SizedBox.shrink();
//       }
//
//       return SizedBox(
//         width: double.infinity,
//         height: 45.h,
//         child: ElevatedButton(
//           onPressed: controller.isMaintenanceModeLoading.value
//               ? null
//               : () {
//             // Check task status before deciding what to do
//             if (controller.taskStatus.value == 'pending') {
//               // Show confirmation dialog only for starting cleaning
//               _showCleaningConfirmationDialog(controller,context);
//             } else if (controller.taskStatus.value == 'cleaning') {
//               // Directly call updateCleaningStatus for completing cleaning
//               controller.updateCleaningStatus(context);
//             }
//           },
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
//               ? SizedBox(
//             width: 18.w,
//             height: 18.h,
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
//
// // Updated confirmation dialog - only for starting cleaning
//   void _showCleaningConfirmationDialog(
//       CleaningManagementController controller,context) {
//     Get.dialog(
//       AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         title: Text(
//           'Start Cleaning?',
//           style: TextStyle(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         content: Text(
//           'Are you sure you want to start the cleaning process? This will begin the automated cleaning cycle.',
//           style: TextStyle(
//             fontSize: 14.sp,
//             color: Colors.grey.shade700,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () =>  Navigator.of(context).pop(),
//             child: Text(
//               'Cancel',
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               controller.updateCleaningStatus(context); // Start cleaning
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue.shade500,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//             ),
//             child: Text(
//               'Start Cleaning',
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//       barrierDismissible: false, // Prevent closing by tapping outside
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'cleanup_controller.dart';

class DetailsViewTask extends StatelessWidget {
  const DetailsViewTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CleaningManagementController controller = Get.put(CleaningManagementController());
    final Map<String, dynamic>? plantData = Get.arguments;
    final String? uuid = plantData?['plant_uuid']?.toString();
    controller.setUuid(uuid);
    controller.printUuidInfo();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(6.4.w),
            decoration: BoxDecoration(
              color: Colors.blue.shade500,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 12.8.w,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Task Details',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14.4.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isTaskDetailsLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blue.shade500,
              strokeWidth: 2.4,
            ),
          );
        }
        if (!controller.isTaskDataValid) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 51.2.w,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 12.8.h),
                Text(
                  'No task data available',
                  style: TextStyle(
                    fontSize: 12.8.sp,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(12.8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildETAContainer(controller),
              SizedBox(height: 12.8.h),
              _buildTaskInfoCard(controller),
              SizedBox(height: 12.8.h),
              // _buildLocationCard(controller),
              SizedBox(height: 12.8.h),
              _buildPanelValvesList(controller),
              SizedBox(height: 19.2.h),
              _buildMaintenanceButton(controller, context),
              SizedBox(height: 12.8.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildETAContainer(CleaningManagementController controller) {
    return Obx(() {
      if (controller.taskStatus.value != 'cleaning' && !controller.isETAActive.value) {
        return SizedBox.shrink();
      }
      return Container(
        margin: EdgeInsets.only(bottom: 12.8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade500, Colors.blue.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 9.6,
              offset: Offset(0, 4.8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.4.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6.4.r),
                      ),
                      child: Icon(
                        Icons.cleaning_services_rounded,
                        color: Colors.white,
                        size: 16.w,
                      ),
                    ),
                    SizedBox(width: 9.6.w),
                    Text(
                      'Cleaning in Progress',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.8.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.2.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4.8.w,
                        height: 4.8.h,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4.8.w),
                      Text(
                        'ACTIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(19.2.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12.8.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Time Elapsed',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 10.4.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 9.6.h),
                  Text(
                    controller.formattedElapsedTime,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.8.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 3.2.h),
                  Text(
                    'HH:MM:SS',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 8.8.sp,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.8.h),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  color: Colors.white.withOpacity(0.8),
                  size: 14.4.w,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      value: (controller.elapsedETA.value / (controller.maintenanceETA.value * 60))
                          .clamp(0.0, 1.0),
                      minHeight: 6.4.h,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }



  Widget _buildTaskInfoCard(CleaningManagementController controller) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.blue.shade50.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade600],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.solar_power_rounded,
                  color: Colors.white,
                  size: 20.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.plantName ?? 'N/A',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Obx(() {
                      final status = controller.taskStatus.value;
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: controller.getStatusColor(status).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: controller.getStatusColor(status).withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          status == 'pending'
                              ? 'Pending'
                              : status == 'cleaning'
                              ? 'In Progress'
                              : status == 'done'
                              ? 'Completed'
                              : status.toUpperCase(),
                          style: TextStyle(
                            color: controller.getStatusColor(status),
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.grey.shade300,
                  Colors.transparent,
                ],
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Plant Address Section
          _buildInfoRow(
            icon: Icons.location_on_rounded,
            label: 'Address',
            value: '${controller.plantAddress ?? 'N/A'}',
            iconColor: Colors.red.shade400,
          ),
          SizedBox(height: 10.h),

          _buildInfoRow(
            icon: Icons.location_city_rounded,
            label: 'Area',
            value: '${controller.talukaName ?? 'N/A'}, ${controller.areaName ?? 'N/A'}',
            iconColor: Colors.orange.shade400,
          ),
          SizedBox(height: 10.h),

          _buildInfoRow(
            icon: Icons.business_rounded,
            label: 'Location',
            value: controller.plantLocation ?? 'N/A',
            iconColor: Colors.purple.shade400,
          ),

          SizedBox(height: 10.h),

          _buildInfoRow(
            icon: Icons.play_circle_outline_rounded,
            label: 'UUID',
            value: controller.plantuuid ?? 'N/A',
            iconColor: Colors.blueAccent,
          ),

          SizedBox(height: 14.h),

          // Plant Specifications
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.blue.shade50.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.blue.shade100,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.settings_input_component_rounded,
                      size: 16.w,
                      color: Colors.blue.shade700,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Plant Specifications',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildSpecCard(
                        icon: Icons.solar_power,
                        label: 'Panels',
                        value: '${controller.plantTotalPanels ?? 0}',
                        color: Colors.amber,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _buildSpecCard(
                        icon: Icons.square_foot_rounded,
                        label: 'Area',
                        value: '${controller.plantAreaSqM ?? 0} m²',
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _buildSpecCard(
                        icon: Icons.bolt_rounded,
                        label: 'Capacity',
                        value: '${controller.plantCapacityW ?? 0} kW',
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 14.h),

          // Cleaning Time
          _buildInfoRow(
            icon: Icons.access_time_rounded,
            label: 'Cleaning Time',
            value: controller.formatTime(controller.cleaningStartTime),
            iconColor: Colors.green.shade400,
          ),
        ],
      ),
    );
  }







  Widget _buildLocationCard(CleaningManagementController controller) {
    return Container(
      padding: EdgeInsets.all(12.8.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 3.2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(9.6.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(9.6.r),
            ),
            child: Icon(
              Icons.location_on_rounded,
              color: Colors.white,
              size: 19.2.w,
            ),
          ),
          SizedBox(width: 12.8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plant Location',
                  style: TextStyle(
                    fontSize: 9.6.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 3.2.h),
                Text(
                  controller.plantLocation,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.navigation_rounded,
              color: Colors.blue.shade600,
              size: 16.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanelValvesList(CleaningManagementController controller) {
    return Obx(() {
      final totalPanels = controller.numberOfBoxes.value;
      final isCompleted = controller.taskStatus.value == 'done';
      return Container(
        padding: EdgeInsets.all(12.8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: Offset(0, 3.2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green.shade50 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(9.6.r),
              ),
              child: Icon(
                Icons.widgets_rounded,
                color: isCompleted ? Colors.green.shade600 : Colors.grey.shade600,
                size: 19.2.w,
              ),
            ),
            SizedBox(width: 12.8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Panel Valves',
                    style: TextStyle(
                      fontSize: 10.4.sp,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.6.h),
                  Text(
                    '$totalPanels Total',
                    style: TextStyle(
                      fontSize: 14.4.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 22.4.w,
              height: 22.4.h,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green.shade400 : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: isCompleted
                  ? Icon(
                Icons.check,
                color: Colors.white,
                size: 14.4.w,
              )
                  : null,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMaintenanceButton(CleaningManagementController controller, BuildContext context) {
    return Obx(() {
      if (!controller.shouldShowMaintenanceButton) {
        return SizedBox.shrink();
      }
      final isLoading = controller.isMaintenanceModeLoading.value;
      final isPending = controller.taskStatus.value == 'pending';
      return SizedBox(
        width: double.infinity,
        height: 41.6.h,
        child: ElevatedButton(
          onPressed: isLoading
              ? null
              : () {
            if (isPending) {
              _showCleaningConfirmationDialog(controller, context);
            } else {
              controller.updateCleaningStatus(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isPending ? Colors.blue.shade500 : Colors.green.shade500,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11.2.r),
            ),
            elevation: 3.2,
            shadowColor: (isPending ? Colors.blue : Colors.green).withOpacity(0.3),
          ),
          child: isLoading
              ? SizedBox(
            width: 19.2.w,
            height: 19.2.h,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPending ? Icons.play_arrow_rounded : Icons.check_circle_rounded,
                color: Colors.white,
                size: 17.6.w,
              ),
              SizedBox(width: 6.4.w),
              Text(
                controller.maintenanceButtonText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.8.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showCleaningConfirmationDialog(CleaningManagementController controller, BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        contentPadding: EdgeInsets.all(19.2.w),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(9.6.r),
              ),
              child: Icon(
                Icons.cleaning_services_rounded,
                color: Colors.blue.shade600,
                size: 19.2.w,
              ),
            ),
            SizedBox(width: 9.6.w),
            Text(
              'Start Cleaning?',
              style: TextStyle(
                fontSize: 14.4.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        content: Text(
          'This will begin the automated cleaning cycle. Make sure all preparations are complete.',
          style: TextStyle(
            fontSize: 11.2.sp,
            color: Colors.grey.shade700,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.6.h),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 11.2.sp,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.updateCleaningStatus(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade500,
              padding: EdgeInsets.symmetric(horizontal: 19.2.w, vertical: 9.6.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 1.6,
            ),
            child: Text(
              'Start Now',
              style: TextStyle(
                fontSize: 11.2.sp,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }




  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: (iconColor ?? Colors.blue.shade400).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 16.w,
            color: iconColor ?? Colors.blue.shade600,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20.w,
            // color: color.shade800,
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 8.5.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

}
