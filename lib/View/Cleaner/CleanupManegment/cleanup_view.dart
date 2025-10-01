// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'cleanup_controller.dart';
//
// class CleaningManagementView extends StatelessWidget {
//   const CleaningManagementView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(CleaningManagementController());
//     controller.fetchTodaysSchedules();
//
//     return GetBuilder<CleaningManagementController>(
//       builder: (controller) {
//         return RefreshIndicator(
//           onRefresh: controller.refreshData,
//           child: Scaffold(
//             backgroundColor: Colors.grey.shade100,
//             body: RefreshIndicator(
//               onRefresh: controller.refreshData,
//               child: SafeArea(
//                 child: Padding(
//                   padding: EdgeInsets.all(12.8.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // _buildSearchBar(),
//                       SizedBox(height: 19.2.h),
//                       _buildStatusCards(controller),
//                       SizedBox(height: 19.2.h),
//                       // _buildAreaSection(controller),
//                       // SizedBox(height: 12.8.h),
//                       Expanded(
//                         child: _buildTaskList(controller),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
//
//   // Widget _buildSearchBar() {
//   //   return Container(
//   //     height: 38.4.h,
//   //     decoration: BoxDecoration(
//   //       color: Colors.white,
//   //       borderRadius: BorderRadius.circular(9.6.r),
//   //       boxShadow: [
//   //         BoxShadow(
//   //           color: Colors.black.withOpacity(0.05),
//   //           blurRadius: 8,
//   //           offset: Offset(0, 1.6),
//   //         ),
//   //       ],
//   //     ),
//   //     child: TextField(
//   //       decoration: InputDecoration(
//   //         hintText: 'no search...',
//   //         hintStyle: TextStyle(
//   //           color: Colors.grey.shade500,
//   //           fontSize: 12.8.sp,
//   //         ),
//   //         prefixIcon: Icon(
//   //           Icons.search,
//   //           color: Colors.grey.shade500,
//   //           size: 16.w,
//   //         ),
//   //         border: InputBorder.none,
//   //         contentPadding: EdgeInsets.symmetric(horizontal: 12.8.w, vertical: 9.6.h),
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   Widget _buildStatusCards(CleaningManagementController controller) {
//     return Obx(() {
//       final pendingCount = controller.pendingCleanups.length;
//       final completedCount = controller.completedCleanups.length;
//
//       return Row(
//         children: [
//           Expanded(
//             child: GestureDetector(
//               onTap: () => _showPendingCleanups(controller),
//               child: Container(
//                 height: 64.h,
//                 decoration: BoxDecoration(
//                   color: Colors.red.shade400,
//                   borderRadius: BorderRadius.circular(12.8.r),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.red.shade200,
//                       blurRadius: 6.4,
//                       offset: Offset(0, 3.2),
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Today\'s Pending',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 11.2.sp,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       SizedBox(height: 3.2.h),
//                       Text(
//                         'Clean-ups ($pendingCount)',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 11.2.sp,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 12.8.w),
//           Expanded(
//             child: GestureDetector(
//               onTap: () => _showCompletedCleanups(controller),
//               child: Container(
//                 height: 64.h,
//                 decoration: BoxDecoration(
//                   color: Colors.green.shade300,
//                   borderRadius: BorderRadius.circular(12.8.r),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.green.shade200,
//                       blurRadius: 6.4,
//                       offset: Offset(0, 3.2),
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Today\'s Completed',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 11.2.sp,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       SizedBox(height: 3.2.h),
//                       Text(
//                         'Clean-ups ($completedCount)',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 11.2.sp,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     });
//   }
//
//   Widget _buildAreaSection(CleaningManagementController controller) {
//     return Obx(() {
//       final areaName = controller.todaysSchedules.value?.isNotEmpty == true
//           ? controller.todaysSchedules.value!.first['area_name'] ??
//               'Unknown Area'
//           : 'No Area';
//
//       Color statusColor;
//       switch (controller.taskStatus.value) {
//         case 'pending':
//           statusColor = Colors.orange;
//           break;
//         case 'cleaning':
//           statusColor = Colors.blue;
//           break;
//         case 'done':
//           statusColor = Colors.green;
//           break;
//         default:
//           statusColor = Colors.grey;
//       }
//
//       return Container(
//         padding: EdgeInsets.all(12.8.w),
//         decoration: BoxDecoration(
//           color: statusColor.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(12.8.r),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               Icons.location_on,
//               color: statusColor,
//               size: 16.w,
//             ),
//             SizedBox(width: 6.4.w),
//             Text(
//               areaName,
//               style: TextStyle(
//                 fontSize: 14.4.sp,
//                 fontWeight: FontWeight.w600,
//                 color: statusColor,
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
//
//   Widget _buildTaskList(CleaningManagementController controller) {
//     return Obx(() {
//       if (controller.isLoading.value) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       }
//
//       if (controller.todaysSchedules.value == null ) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.cleaning_services_outlined,
//                 size: 51.2.w,
//                 color: Colors.grey.shade400,
//               ),
//               SizedBox(height: 12.8.h),
//               Text(
//                 'No cleaning tasks scheduled for today',
//                 style: TextStyle(
//                   fontSize: 12.8.sp,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }
//
//       return ListView.builder(
//         itemCount: controller.todaysSchedules.value!.length,
//         itemBuilder: (context, index) {
//           final task = controller.todaysSchedules.value![index];
//           return _buildTaskCard(controller, task);
//         },
//       );
//     });
//   }
//
//   Widget _buildTaskCard(
//       CleaningManagementController controller, Map<String, dynamic> task) {
//     return Obx(() {
//       // Get the current status from reportData
//       // Get the task ID
//       final taskId = task['id'];
//
//       // Find the matching task in todaysSchedules
//       final matchingTask = controller.todaysSchedules.value
//           ?.firstWhere((item) => item['id'] == taskId, orElse: () => {});
//
//       // Get status or default
//       final status = matchingTask?['status'] ?? 'pending';
//       // Determine card background color based on status
//       Color cardBackgroundColor;
//       Color statusBadgeColor;
//       Color borderColor;
//
//       switch (status.toLowerCase()) {
//         case 'pending':
//           cardBackgroundColor = Colors.orange.shade50;
//           statusBadgeColor = Colors.orange.shade100;
//           borderColor = Colors.orange.shade200;
//           break;
//         case 'cleaning':
//           cardBackgroundColor = Colors.blue.shade50;
//           statusBadgeColor = Colors.blue.shade100;
//           borderColor = Colors.blue.shade200;
//           break;
//         case 'done':
//           cardBackgroundColor = Colors.green.shade50;
//           statusBadgeColor = Colors.green.shade100;
//           borderColor = Colors.green.shade200;
//           break;
//         default:
//           cardBackgroundColor = Colors.white;
//           statusBadgeColor = Colors.grey.shade200;
//           borderColor = Colors.grey.shade300;
//       }
//
//       return Container(
//         margin: EdgeInsets.only(bottom: 12.8.h),
//         decoration: BoxDecoration(
//           color: cardBackgroundColor,
//           borderRadius: BorderRadius.circular(12.8.r),
//           border: Border.all(color: borderColor, width: 1),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 6.4,
//               offset: const Offset(0, 3.2),
//             ),
//           ],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: () {
//               controller.fetchReportData(task['id']);
//               controller.navigateToTaskDetails(task);
//             },
//             borderRadius: BorderRadius.circular(12.8.r),
//             child: Stack(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(16.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.access_time,
//                                 color: controller.getStatusColor(status),
//                                 size: 16.w,
//                               ),
//                               SizedBox(width: 6.4.w),
//                               Text(
//                                 controller.formatTime(
//                                     task['cleaning_start_time'] ?? '08:00:00'),
//                                 style: TextStyle(
//                                   color: controller.getStatusColor(status),
//                                   fontSize: 12.8.sp,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 9.6.w, vertical: 3.2.h),
//                             decoration: BoxDecoration(
//                               color: statusBadgeColor,
//                               borderRadius: BorderRadius.circular(9.6.r),
//                               border: Border.all(
//                                   color: controller.getStatusColor(status),
//                                   width: 0.5),
//                             ),
//                             child: Text(
//                               status == 'pending'
//                                   ? 'Cleaning Pending'
//                                   : status == 'ongoing'
//                                       ? 'In Progress'
//                                       : status == 'done'
//                                           ? 'Completed'
//                                           : status.toUpperCase(),
//                               style: TextStyle(
//                                 color: controller.getStatusColor(status),
//                                 fontSize: 9.6.sp,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 12.8.h),
//                       Text(
//                         task['plant_location'] ?? 'Unknown Location',
//                         style: TextStyle(
//                           color: Colors.black87,
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(height: 6.4.h),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.location_on_outlined,
//                             color: Colors.grey.shade600,
//                             size: 12.w,
//                           ),
//                           SizedBox(width: 4.w),
//                           Expanded(
//                             child: Text(
//                               '${task['area_name'] ?? 'Unknown Area'}, ${task['taluka_name'] ?? 'Unknown Taluka'}',
//                               style: TextStyle(
//                                 color: Colors.grey.shade600,
//                                 fontSize: 11.2.sp,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 3.2.h),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.solar_power_outlined,
//                             color: Colors.grey.shade600,
//                             size: 12.w,
//                           ),
//                           SizedBox(width: 4.w),
//                           Text(
//                             'Panels: ${task['plant_total_panels'] ?? 0} | ${task['plant_capacity_w'] ?? 0}kW',
//                             style: TextStyle(
//                               color: Colors.grey.shade600,
//                               fontSize: 11.2.sp,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
//
//   void _showPendingCleanups(CleaningManagementController controller) {
//     Get.bottomSheet(
//       Container(
//         padding: EdgeInsets.all(16.w),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(16.r),
//             topRight: Radius.circular(16.r),
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Pending Cleanups',
//               style: TextStyle(
//                 fontSize: 14.4.sp,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: 12.8.h),
//             Obx(() {
//               final pendingTasks = controller.pendingCleanups;
//               if (pendingTasks.isEmpty) {
//                 return Text(
//                   'No pending cleanups',
//                   style: TextStyle(
//                     fontSize: 11.2.sp,
//                     color: Colors.grey.shade600,
//                   ),
//                 );
//               }
//               return Column(
//                 children: pendingTasks.map((task) {
//                   return ListTile(
//                     leading: Icon(Icons.cleaning_services,
//                         color: Colors.red.shade400, size: 16.w),
//                     title: Text(task['plant_location'] ?? 'Unknown',
//                         style: TextStyle(fontSize: 12.8.sp)),
//                     subtitle: Text('${task['plant_total_panels']} panels',
//                         style: TextStyle(fontSize: 11.2.sp)),
//                     onTap: () {
//                       Get.back();
//                       controller.navigateToTaskDetails(task);
//                     },
//                   );
//                 }).toList(),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showCompletedCleanups(CleaningManagementController controller) {
//     Get.bottomSheet(
//       Container(
//         padding: EdgeInsets.all(16.w),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(16.r),
//             topRight: Radius.circular(16.r),
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Completed Cleanups',
//               style: TextStyle(
//                 fontSize: 14.4.sp,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: 12.8.h),
//             Obx(() {
//               final completedTasks = controller.completedCleanups;
//               if (completedTasks.isEmpty) {
//                 return Text(
//                   'No completed cleanups',
//                   style: TextStyle(
//                     fontSize: 11.2.sp,
//                     color: Colors.grey.shade600,
//                   ),
//                 );
//               }
//               return Column(
//                 children: completedTasks.map((task) {
//                   return ListTile(
//                     leading: Icon(Icons.check_circle,
//                         color: Colors.green.shade400, size: 16.w),
//                     title: Text(task['plant_location'] ?? 'Unknown',
//                         style: TextStyle(fontSize: 12.8.sp)),
//                     subtitle: Text('${task['plant_total_panels']} panels',
//                         style: TextStyle(fontSize: 11.2.sp)),
//                     onTap: () {
//                       Get.back();
//                       controller.navigateToTaskDetails(task);
//                     },
//                   );
//                 }).toList(),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
//


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'cleanup_controller.dart';


class CleaningManagementView extends StatelessWidget {
  const CleaningManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CleaningManagementController());

    // Only fetch if data is null or empty
    if (controller.todaysSchedules.value == null ||
        controller.todaysSchedules.value!.isEmpty) {
      controller.fetchTodaysSchedules();
    }

    return GetBuilder<CleaningManagementController>(
      builder: (controller) {
        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: Scaffold(
            backgroundColor: Colors.grey.shade100,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(12.8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 19.2.h),
                    _buildStatusCards(controller,context),
                    SizedBox(height: 19.2.h),
                    Expanded(
                      child: _buildTaskList(controller),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusCards(CleaningManagementController controller,context) {
    return Obx(() {
      final pendingCount = controller.pendingCleanups.length;
      final completedCount = controller.completedCleanups.length;

      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _showPendingCleanups(controller,context),
              child: Container(
                height: 64.h,
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(12.8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.shade200,
                      blurRadius: 6.4,
                      offset: Offset(0, 3.2),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Today\'s Pending',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.2.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 3.2.h),
                      Text(
                        'Clean-ups ($pendingCount)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.2.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.8.w),
          Expanded(
            child: GestureDetector(
              onTap: () => _showCompletedCleanups(controller,context),
              child: Container(
                height: 64.h,
                decoration: BoxDecoration(
                  color: Colors.green.shade300,
                  borderRadius: BorderRadius.circular(12.8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.shade200,
                      blurRadius: 6.4,
                      offset: Offset(0, 3.2),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Today\'s Completed',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.2.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 3.2.h),
                      Text(
                        'Clean-ups ($completedCount)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.2.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTaskList(CleaningManagementController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      // Fixed condition - check for both null AND empty
      if (controller.todaysSchedules.value == null ||
          controller.todaysSchedules.value!.isEmpty) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(Get.context!).size.height * 0.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cleaning_services_outlined,
                    size: 51.2.w,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 12.8.h),
                  Text(
                    'No cleaning tasks scheduled for today',
                    style: TextStyle(
                      fontSize: 12.8.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return ListView.builder(
        itemCount: controller.todaysSchedules.value!.length,
        itemBuilder: (context, index) {
          final task = controller.todaysSchedules.value![index];
          return _buildTaskCard(controller, task);
        },
      );
    });
  }


  Widget _buildTaskCard(
      CleaningManagementController controller, Map<String, dynamic> task) {
    return Obx(() {
      final taskId = task['id'];

      final matchingTask = controller.todaysSchedules.value
          ?.firstWhere((item) => item['id'] == taskId, orElse: () => {});

      final status = matchingTask?['status'] ?? 'pending';

      Color cardBackgroundColor;
      Color statusBadgeColor;
      Color borderColor;

      switch (status.toLowerCase()) {
        case 'pending':
          cardBackgroundColor = Colors.orange.shade50;
          statusBadgeColor = Colors.orange.shade100;
          borderColor = Colors.orange.shade200;
          break;
        case 'cleaning':
          cardBackgroundColor = Colors.blue.shade50;
          statusBadgeColor = Colors.blue.shade100;
          borderColor = Colors.blue.shade200;
          break;
        case 'done':
          cardBackgroundColor = Colors.green.shade50;
          statusBadgeColor = Colors.green.shade100;
          borderColor = Colors.green.shade200;
          break;
        default:
          cardBackgroundColor = Colors.white;
          statusBadgeColor = Colors.grey.shade200;
          borderColor = Colors.grey.shade300;
      }

      return Container(
        margin: EdgeInsets.only(bottom: 12.8.h),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(12.8.r),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6.4,
              offset: const Offset(0, 3.2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              controller.fetchReportData(task['id']);
              controller.navigateToTaskDetails(task);
            },
            borderRadius: BorderRadius.circular(12.8.r),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: controller.getStatusColor(status),
                            size: 16.w,
                          ),
                          SizedBox(width: 6.4.w),
                          Text(
                            controller.formatTime(
                                task['cleaning_start_time'] ?? '08:00:00'),
                            style: TextStyle(
                              color: controller.getStatusColor(status),
                              fontSize: 12.8.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 9.6.w, vertical: 3.2.h),
                        decoration: BoxDecoration(
                          color: statusBadgeColor,
                          borderRadius: BorderRadius.circular(9.6.r),
                          border: Border.all(
                              color: controller.getStatusColor(status),
                              width: 0.5),
                        ),
                        child: Text(
                          status == 'pending'
                              ? 'Cleaning Pending'
                              : status == 'ongoing'
                              ? 'In Progress'
                              : status == 'done'
                              ? 'Completed'
                              : status.toUpperCase(),
                          style: TextStyle(
                            color: controller.getStatusColor(status),
                            fontSize: 9.6.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.8.h),
                  Text(
                    task['plant_location'] ?? 'Unknown Location',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey.shade600,
                        size: 12.w,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          '${task['area_name'] ?? 'Unknown Area'}, ${task['taluka_name'] ?? 'Unknown Taluka'}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11.2.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.2.h),
                  Row(
                    children: [
                      Icon(
                        Icons.solar_power_outlined,
                        color: Colors.grey.shade600,
                        size: 12.w,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Panels: ${task['plant_total_panels'] ?? 0} | ${task['plant_capacity_w'] ?? 0}kW',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11.2.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _showPendingCleanups(CleaningManagementController controller,context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pending Cleanups',
              style: TextStyle(
                fontSize: 14.4.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.8.h),
            Obx(() {
              final pendingTasks = controller.pendingCleanups;
              if (pendingTasks.isEmpty) {
                return Text(
                  'No pending cleanups',
                  style: TextStyle(
                    fontSize: 11.2.sp,
                    color: Colors.grey.shade600,
                  ),
                );
              }
              return Column(
                children: pendingTasks.map((task) {
                  return ListTile(
                    leading: Icon(Icons.cleaning_services,
                        color: Colors.red.shade400, size: 16.w),
                    title: Text(task['plant_location'] ?? 'Unknown',
                        style: TextStyle(fontSize: 12.8.sp)),
                    subtitle: Text('${task['plant_total_panels']} panels',
                        style: TextStyle(fontSize: 11.2.sp)),
                    onTap: () {
                      Navigator.of(context).pop();
                      controller.navigateToTaskDetails(task);
                    },
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showCompletedCleanups(CleaningManagementController controller,context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Completed Cleanups',
              style: TextStyle(
                fontSize: 14.4.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.8.h),
            Obx(() {
              final completedTasks = controller.completedCleanups;
              if (completedTasks.isEmpty) {
                return Text(
                  'No completed cleanups',
                  style: TextStyle(
                    fontSize: 11.2.sp,
                    color: Colors.grey.shade600,
                  ),
                );
              }
              return Column(
                children: completedTasks.map((task) {
                  return ListTile(
                    leading: Icon(Icons.check_circle,
                        color: Colors.green.shade400, size: 16.w),
                    title: Text(task['plant_location'] ?? 'Unknown',
                        style: TextStyle(fontSize: 12.8.sp)),
                    subtitle: Text('${task['plant_total_panels']} panels',
                        style: TextStyle(fontSize: 11.2.sp)),
                    onTap: () {
                      Navigator.of(context).pop();
                      controller.navigateToTaskDetails(task);
                    },
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}