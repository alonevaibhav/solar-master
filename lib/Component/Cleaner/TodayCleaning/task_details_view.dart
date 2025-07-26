// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../../../Controller/Cleaner/cleanup_schedule_controller.dart';
//
// class TaskDetailsView extends StatelessWidget {
//   const TaskDetailsView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final Map<String, dynamic> taskData = Get.arguments;
//     if (taskData.isEmpty) {
//       return const Scaffold(
//         body: Center(child: Text('No task data available')),
//       );
//     }
//
//     final controller = Get.find<CleanupScheduleController>();
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Container(
//             padding: EdgeInsets.all(8 * 0.9.w),
//             decoration: BoxDecoration(
//               color: const Color(0xFF007AFF),
//               borderRadius: BorderRadius.circular(8 * 0.9.r),
//             ),
//             child: Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//               size: 18 * 0.9.w,
//             ),
//           ),
//           onPressed: () => Get.back(),
//         ),
//         title: Text(
//           'Task Details',
//           style: TextStyle(
//             fontSize: 18 * 0.9.sp,
//             fontWeight: FontWeight.w600,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.notifications_none,
//               color: Colors.grey[600],
//               size: 24 * 0.9.w,
//             ),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Obx(() {
//         final taskId = taskData['id'] as int;
//         final status = controller.getTaskStatus(taskId);
//         final eta = controller.getTaskETA(taskId);
//
//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               _buildStatusHeader(taskData, status, eta, controller),
//               SizedBox(height: 16 * 0.9.h),
//               // _buildOwnerInfoCard(taskData),
//               SizedBox(height: 16 * 0.9.h),
//               _buildPlantDetailsCard(taskData, status),
//               SizedBox(height: 16 * 0.9.h),
//               _buildPanelInformation(),
//               SizedBox(height: 100 * 0.9.h),
//             ],
//           ),
//         );
//       }),
//       bottomNavigationBar: Obx(() {
//         final taskId = taskData['id'] as int;
//         final status = controller.getTaskStatus(taskId);
//         final eta = controller.getTaskETA(taskId);
//         return _buildBottomButton(controller, taskData, status, eta);
//       }),
//     );
//   }
//
//   Widget _buildStatusHeader(Map<String, dynamic> taskData, String status,
//       int? eta, CleanupScheduleController controller) {
//     Color statusColor;
//     String statusText;
//
//     switch (status) {
//       case 'ongoing':
//         statusColor = const Color(0xFFFF9500);
//         statusText = 'Cleaning Ongoing';
//         break;
//       case 'completed':
//         statusColor = const Color(0xFF4ECDC4);
//         statusText = 'Cleaning Complete';
//         break;
//       default:
//         statusColor = const Color(0xFFFF6B6B);
//         statusText = 'Cleaning Pending';
//     }
//
//     return Container(
//       margin: EdgeInsets.all(16 * 0.9.w),
//       padding: EdgeInsets.all(20 * 0.9.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16 * 0.9.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10 * 0.9,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(
//                 horizontal: 12 * 0.9.w, vertical: 6 * 0.9.h),
//             decoration: BoxDecoration(
//               color: const Color(0xFF4ECDC4),
//               borderRadius: BorderRadius.circular(12 * 0.9.r),
//             ),
//             child: Text(
//               '20',
//               style: TextStyle(
//                 fontSize: 14 * 0.9.sp,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           SizedBox(width: 8 * 0.9.w),
//           Container(
//             padding: EdgeInsets.symmetric(
//                 horizontal: 12 * 0.9.w, vertical: 6 * 0.9.h),
//             decoration: BoxDecoration(
//               color: statusColor,
//               borderRadius: BorderRadius.circular(12 * 0.9.r),
//             ),
//             child: Text(
//               '7',
//               style: TextStyle(
//                 fontSize: 14 * 0.9.sp,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           SizedBox(width: 12 * 0.9.w),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Total',
//                 style: TextStyle(
//                   fontSize: 12 * 0.9.sp,
//                   color: Colors.grey[600],
//                 ),
//               ),
//               Text(
//                 '32 Panels',
//                 style: TextStyle(
//                   fontSize: 16 * 0.9.sp,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),
//             ],
//           ),
//           const Spacer(),
//           Icon(
//             Icons.solar_power,
//             size: 32 * 0.9.w,
//             color: Colors.grey[400],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOwnerInfoCard(Map<String, dynamic> taskData) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16 * 0.9.w),
//       padding: EdgeInsets.all(20 * 0.9.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16 * 0.9.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10 * 0.9,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Owner Info',
//             style: TextStyle(
//               fontSize: 16 * 0.9.sp,
//               fontWeight: FontWeight.w600,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(height: 16 * 0.9.h),
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 24 * 0.9.r,
//                 backgroundColor: Colors.grey[200],
//                 child: Icon(
//                   Icons.person,
//                   size: 24 * 0.9.w,
//                   color: Colors.grey[600],
//                 ),
//               ),
//               SizedBox(width: 12 * 0.9.w),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Phone: +91 8903373561',
//                       style: TextStyle(
//                         fontSize: 14 * 0.9.sp,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPlantDetailsCard(Map<String, dynamic> taskData, String status) {
//     Color statusColor;
//     String statusText;
//
//     switch (status) {
//       case 'ongoing':
//         statusColor = const Color(0xFFFF9500);
//         statusText = 'Cleaning Ongoing';
//         break;
//       case 'completed':
//         statusColor = const Color(0xFF4ECDC4);
//         statusText = 'Cleaning Complete';
//         break;
//       default:
//         statusColor = const Color(0xFFFF6B6B);
//         statusText = 'Cleaning Pending';
//     }
//
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16 * 0.9.w),
//       padding: EdgeInsets.all(20 * 0.9.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16 * 0.9.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10 * 0.9,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             taskData['plant_location'] ?? 'Abc Plant Name',
//             style: TextStyle(
//               fontSize: 18 * 0.9.sp,
//               fontWeight: FontWeight.w600,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(height: 8 * 0.9.h),
//           Text(
//             'Auto Clean: ${_formatTime(taskData['cleaning_start_time'])}',
//             style: TextStyle(
//               fontSize: 14 * 0.9.sp,
//               color: Colors.grey[600],
//             ),
//           ),
//           SizedBox(height: 4 * 0.9.h),
//           Row(
//             children: [
//               Text(
//                 'Status: ',
//                 style: TextStyle(
//                   fontSize: 14 * 0.9.sp,
//                   color: Colors.grey[600],
//                 ),
//               ),
//               Text(
//                 statusText,
//                 style: TextStyle(
//                   fontSize: 14 * 0.9.sp,
//                   fontWeight: FontWeight.w600,
//                   color: statusColor,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16 * 0.9.h),
//           Row(
//             children: [
//               Text(
//                 'Location',
//                 style: TextStyle(
//                   fontSize: 14 * 0.9.sp,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),
//               const Spacer(),
//             ],
//           ),
//           SizedBox(height: 4 * 0.9.h),
//           Text(
//             taskData['plant_location'] ?? 'A-2-1 Pune Mahanagar(411021)',
//             style: TextStyle(
//               fontSize: 12 * 0.9.sp,
//               color: Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPanelInformation() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16 * 0.9.w),
//       padding: EdgeInsets.all(20 * 0.9.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16 * 0.9.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10 * 0.9,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           _buildPanelRow('Panel Valve - 1'),
//           _buildPanelRow('Panel Valve - 2'),
//           _buildPanelRow('Panel Valve - 3'),
//           _buildPanelRow('Panel Valve - 4'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPanelRow(String panelName) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 12 * 0.9.h),
//       child: Row(
//         children: [
//           Text(
//             panelName,
//             style: TextStyle(
//               fontSize: 14 * 0.9.sp,
//               color: Colors.grey[800],
//             ),
//           ),
//           const Spacer(),
//           Container(
//             width: 24 * 0.9.w,
//             height: 24 * 0.9.w,
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(12 * 0.9.r),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBottomButton(CleanupScheduleController controller,
//       Map<String, dynamic> taskData, String status, int? eta) {
//     if (status == 'ongoing' && eta != null) {
//       return Container(
//         padding: EdgeInsets.all(16 * 0.9.w),
//         child: SafeArea(
//           child: SizedBox(
//             width: double.infinity,
//             child: Container(
//               padding: EdgeInsets.all(16 * 0.9.w),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF4ECDC4),
//                 borderRadius: BorderRadius.circular(12 * 0.9.r),
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.access_time,
//                     color: Colors.white,
//                     size: 20 * 0.9.w,
//                   ),
//                   SizedBox(width: 8 * 0.9.w),
//                   Text(
//                     'ETA: ${controller.formatETA(eta)}',
//                     style: TextStyle(
//                       fontSize: 16 * 0.9.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const Spacer(),
//                   GestureDetector(
//                     // onTap: () => controller.completeTask(taskId),
//                     child: Container(
//                       padding: EdgeInsets.all(8 * 0.9.w),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(8 * 0.9.r),
//                       ),
//                       child: Icon(
//                         Icons.close,
//                         color: Colors.white,
//                         size: 20 * 0.9.w,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//
//     if (status == 'completed') {
//       return const SizedBox.shrink();
//     }
//
//     return Container(
//       padding: EdgeInsets.all(16 * 0.9.w),
//       child: SafeArea(
//         child: SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             // onPressed: () => controller.startTask(taskId),
//             onPressed: () => null,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.black,
//               padding: EdgeInsets.symmetric(vertical: 16 * 0.9.h),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12 * 0.9.r),
//               ),
//             ),
//             child: Text(
//               'Enable Maintenance Mode',
//               style: TextStyle(
//                 fontSize: 16 * 0.9.sp,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _formatTime(String? timeString) {
//     if (timeString == null) return 'hh:mm';
//
//     try {
//       final parts = timeString.split(':');
//       if (parts.length >= 2) {
//         final hour = int.parse(parts[0]);
//         final minute = int.parse(parts[1]);
//
//         if (hour == 0 && minute == 0) {
//           return 'hh:mm';
//         }
//
//         final period = hour >= 12 ? 'PM' : 'AM';
//         final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
//
//         return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
//       }
//     } catch (e) {
//       // Return default format if parsing fails
//     }
//
//     return 'hh:mm';
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Controller/Cleaner/cleanup_schedule_controller.dart';

class TaskDetailsView extends StatelessWidget {
  const TaskDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> taskData = Get.arguments;
    if (taskData.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No task data available')),
      );
    }

    final controller = Get.find<CleanupScheduleController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8 * 0.9.w),
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF),
              borderRadius: BorderRadius.circular(8 * 0.9.r),
            ),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 18 * 0.9.w,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Task Details',
          style: TextStyle(
            fontSize: 18 * 0.9.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: Colors.grey[600],
              size: 24 * 0.9.w,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        final taskId = taskData['id'] as int;
        final status = controller.getTaskStatus(taskId);
        final eta = controller.getTaskETA(taskId);

        return SingleChildScrollView(
          child: Column(
            children: [
              // Main Task Details Section
              TaskMainSection(
                taskData: taskData,
                status: status,
                eta: eta,
                controller: controller,
              ),
              SizedBox(height: 16 * 0.9.h),
              // Panel Valve Section
              PanelValveSection(
                taskData: taskData,
                status: status,
              ),
              SizedBox(height: 100 * 0.9.h),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        final taskId = taskData['id'] as int;
        final status = controller.getTaskStatus(taskId);
        final eta = controller.getTaskETA(taskId);
        return _buildBottomButton(controller, taskData, status, eta);
      }),
    );
  }

  Widget _buildBottomButton(CleanupScheduleController controller,
      Map<String, dynamic> taskData, String status, int? eta) {
    if (status == 'ongoing' && eta != null) {
      return Container(
        padding: EdgeInsets.all(16 * 0.9.w),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              padding: EdgeInsets.all(16 * 0.9.w),
              decoration: BoxDecoration(
                color: const Color(0xFF4ECDC4),
                borderRadius: BorderRadius.circular(12 * 0.9.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: Colors.white,
                    size: 20 * 0.9.w,
                  ),
                  SizedBox(width: 8 * 0.9.w),
                  Text(
                    'ETA: ${controller.formatETA(eta)}',
                    style: TextStyle(
                      fontSize: 16 * 0.9.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    // onTap: () => controller.completeTask(taskId),
                    child: Container(
                      padding: EdgeInsets.all(8 * 0.9.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8 * 0.9.r),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20 * 0.9.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (status == 'completed') {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(16 * 0.9.w),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            // onPressed: () => controller.startTask(taskId),
            onPressed: () => null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 16 * 0.9.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12 * 0.9.r),
              ),
            ),
            child: Text(
              'Enable Maintenance Mode',
              style: TextStyle(
                fontSize: 16 * 0.9.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(String? timeString) {
    if (timeString == null) return 'hh:mm';

    try {
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);

        if (hour == 0 && minute == 0) {
          return 'hh:mm';
        }

        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

        return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
      }
    } catch (e) {
      // Return default format if parsing fails
    }

    return 'hh:mm';
  }
}

// Main Task Details Section Widget
class TaskMainSection extends StatelessWidget {
  final Map<String, dynamic> taskData;
  final String status;
  final int? eta;
  final CleanupScheduleController controller;

  const TaskMainSection({
    Key? key,
    required this.taskData,
    required this.status,
    required this.eta,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStatusHeader(),
        SizedBox(height: 16 * 0.9.h),
        // _buildOwnerInfoCard(),
        // SizedBox(height: 16 * 0.9.h),
        _buildPlantDetailsCard(),
      ],
    );
  }

  Widget _buildStatusHeader() {
    Color statusColor;
    String statusText;

    switch (status) {
      case 'ongoing':
        statusColor = const Color(0xFFFF9500);
        statusText = 'Cleaning Ongoing';
        break;
      case 'completed':
        statusColor = const Color(0xFF4ECDC4);
        statusText = 'Cleaning Complete';
        break;
      default:
        statusColor = const Color(0xFFFF6B6B);
        statusText = 'Cleaning Pending';
    }

    return Container(
      margin: EdgeInsets.all(16 * 0.9.w),
      padding: EdgeInsets.all(20 * 0.9.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16 * 0.9.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10 * 0.9,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 12 * 0.9.w, vertical: 6 * 0.9.h),
            decoration: BoxDecoration(
              color: const Color(0xFF4ECDC4),
              borderRadius: BorderRadius.circular(12 * 0.9.r),
            ),
            child: Text(
              '20',
              style: TextStyle(
                fontSize: 14 * 0.9.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8 * 0.9.w),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 12 * 0.9.w, vertical: 6 * 0.9.h),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(12 * 0.9.r),
            ),
            child: Text(
              '7',
              style: TextStyle(
                fontSize: 14 * 0.9.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 12 * 0.9.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 12 * 0.9.sp,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '32 Panels',
                style: TextStyle(
                  fontSize: 16 * 0.9.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(
            Icons.solar_power,
            size: 32 * 0.9.w,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerInfoCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16 * 0.9.w),
      padding: EdgeInsets.all(20 * 0.9.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16 * 0.9.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10 * 0.9,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Owner Info',
            style: TextStyle(
              fontSize: 16 * 0.9.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16 * 0.9.h),
          Row(
            children: [
              CircleAvatar(
                radius: 24 * 0.9.r,
                backgroundColor: Colors.grey[200],
                child: Icon(
                  Icons.person,
                  size: 24 * 0.9.w,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(width: 12 * 0.9.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone: +91 8903373561',
                      style: TextStyle(
                        fontSize: 14 * 0.9.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlantDetailsCard() {
    Color statusColor;
    String statusText;

    switch (status) {
      case 'ongoing':
        statusColor = const Color(0xFFFF9500);
        statusText = 'Cleaning Ongoing';
        break;
      case 'completed':
        statusColor = const Color(0xFF4ECDC4);
        statusText = 'Cleaning Complete';
        break;
      default:
        statusColor = const Color(0xFFFF6B6B);
        statusText = 'Cleaning Pending';
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16 * 0.9.w),
      padding: EdgeInsets.all(20 * 0.9.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16 * 0.9.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10 * 0.9,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            taskData['plant_location'] ?? 'Abc Plant Name',
            style: TextStyle(
              fontSize: 18 * 0.9.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8 * 0.9.h),
          Text(
            'Auto Clean: ${_formatTime(taskData['cleaning_start_time'])}',
            style: TextStyle(
              fontSize: 14 * 0.9.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4 * 0.9.h),
          Row(
            children: [
              Text(
                'Status: ',
                style: TextStyle(
                  fontSize: 14 * 0.9.sp,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                statusText,
                style: TextStyle(
                  fontSize: 14 * 0.9.sp,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16 * 0.9.h),
          Row(
            children: [
              Text(
                'Location',
                style: TextStyle(
                  fontSize: 14 * 0.9.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: 4 * 0.9.h),
          Text(
            taskData['plant_location'] ?? 'A-2-1 Pune Mahanagar(411021)',
            style: TextStyle(
              fontSize: 12 * 0.9.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String? timeString) {
    if (timeString == null) return 'hh:mm';

    try {
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);

        if (hour == 0 && minute == 0) {
          return 'hh:mm';
        }

        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

        return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
      }
    } catch (e) {
      // Return default format if parsing fails
    }

    return 'hh:mm';
  }
}
