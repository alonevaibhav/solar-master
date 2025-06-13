// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../Component/Inspector/plantInspectionView/inspection_item.dart';
// import '../../Controller/Inspector/plant_inspection_controller.dart';
// import '../../Controller/Inspector/ticket_controller.dart';
//
// class PlantInspectionView extends GetView<PlantInspectionController> {
//   const PlantInspectionView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     Get.put(TicketController());
//     return Scaffold(
//       backgroundColor:
//       const Color(0xFFF8F9FA), // Professional light grey background
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         title: Text(
//           'Plant Inspection Dashboard',
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 16.2.sp,
//             color: const Color(0xFF2D3748), // Dark grey text
//           ),
//         ),
//       ),
//       body: Obx(() => controller.isLoadingDashboard.value
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(
//               valueColor:
//               AlwaysStoppedAnimation<Color>(const Color(0xFF718096)),
//             ),
//             SizedBox(height: 14.4.h),
//             Text(
//               'Loading inspection data...',
//               style: TextStyle(
//                 fontSize: 14.4.sp,
//                 color: const Color(0xFF718096),
//               ),
//             ),
//           ],
//         ),
//       )
//           : controller.errorMessageDashboard.value != null
//           ? Center(
//         child: Container(
//           margin: EdgeInsets.all(18.0.w),
//           padding: EdgeInsets.all(21.6.w),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(14.4.r),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFFE2E8F0),
//                 blurRadius: 9.0,
//                 offset: const Offset(0, 3.6),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 Icons.error_outline,
//                 size: 57.6.sp,
//                 color: const Color(0xFFF56565), // Professional red
//               ),
//               SizedBox(height: 14.4.h),
//               Text(
//                 'Something went wrong',
//                 style: TextStyle(
//                   fontSize: 16.2.sp,
//                   fontWeight: FontWeight.w600,
//                   color: const Color(0xFF2D3748),
//                 ),
//               ),
//               SizedBox(height: 7.2.h),
//               Text(
//                 controller.errorMessageDashboard.value.toString(),
//                 style: TextStyle(
//                   fontSize: 12.6.sp,
//                   color: const Color(0xFF718096),
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 21.6.h),
//               ElevatedButton.icon(
//                 onPressed: controller.refreshDashboard,
//                 icon: Icon(Icons.refresh),
//                 label: Text('Try Again'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF718096),
//                   foregroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 21.6.w,
//                     vertical: 10.8.h,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.8.r),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       )
//           : RefreshIndicator(
//         onRefresh: controller.refreshDashboard,
//         color: const Color(0xFF718096),
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Padding(
//             padding: EdgeInsets.all(18.0.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildStatsSection(),
//                 SizedBox(height: 15.6.h),
//                 _buildAllTicketsSection(), // Add this new all tickets dashboard
//                 SizedBox(height: 15.6.h),
//                 _buildInspectionTabs(),
//               ],
//             ),
//           ),
//         ),
//       )),
//     );
//   }
//
//   Widget _buildStatsSection() {
//     return Container(
//       padding: EdgeInsets.all(16.0.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.0.r),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFFE2E8F0).withOpacity(0.6),
//             blurRadius: 8.0,
//             offset: const Offset(0, 2.0),
//             spreadRadius: 0.5,
//           ),
//         ],
//         border: Border.all(
//           color: const Color(0xFFF7FAFC),
//           width: 1.0,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Compact header section
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(8.0.w),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF7FAFC),
//                         borderRadius: BorderRadius.circular(8.0.r),
//                       ),
//                       child: Icon(
//                         Icons.assessment,
//                         color: const Color(0xFF4A5568),
//                         size: 20.0.sp,
//                       ),
//                     ),
//                     SizedBox(width: 12.0.w),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Today's Inspections",
//                             style: TextStyle(
//                               fontSize: 14.0.sp,
//                               fontWeight: FontWeight.w600,
//                               color: const Color(0xFF2D3748),
//                             ),
//                           ),
//                           SizedBox(height: 2.0.h),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text(
//                                 controller.todaysInspections.value?['count']?.toString() ?? '0',
//                                 style: TextStyle(
//                                   fontSize: 24.0.sp,
//                                   fontWeight: FontWeight.bold,
//                                   color: const Color(0xFF1A202C),
//                                 ),
//                               ),
//                               SizedBox(width: 4.0.w),
//                               Padding(
//                                 padding: EdgeInsets.only(bottom: 2.0.h),
//                                 child: Text(
//                                   'Total',
//                                   style: TextStyle(
//                                     fontSize: 12.0.sp,
//                                     color: const Color(0xFF718096),
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//
//           // Status cards section - more compact
//           if (controller.todaysInspections.value?['status'] != null) ...[
//             SizedBox(height: 12.0.h),
//             _buildCompactStatusCards(),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCompactStatusCards() {
//     final status = controller.todaysInspections.value!['status'] as Map<String, dynamic>;
//
//     return Container(
//       padding: EdgeInsets.all(12.0.w),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFAFBFC),
//         borderRadius: BorderRadius.circular(12.0.r),
//         border: Border.all(
//           color: const Color(0xFFEDF2F7),
//           width: 1.0,
//         ),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: _buildCompactStatusItem(
//               'Complete',
//               status['complete']?.toString() ?? '0',
//               const Color(0xFF48BB78),
//               Icons.check_circle_outline,
//             ),
//           ),
//           Container(
//             width: 1,
//             height: 30.h,
//             color: const Color(0xFFE2E8F0),
//             margin: EdgeInsets.symmetric(horizontal: 8.0.w),
//           ),
//           Expanded(
//             child: _buildCompactStatusItem(
//               'Pending',
//               status['pending']?.toString() ?? '0',
//               const Color(0xFF718096),
//               Icons.schedule_outlined,
//             ),
//           ),
//           Container(
//             width: 1,
//             height: 30.h,
//             color: const Color(0xFFE2E8F0),
//             margin: EdgeInsets.symmetric(horizontal: 8.0.w),
//           ),
//           Expanded(
//             child: _buildCompactStatusItem(
//               'Cleaning',
//               status['cleaning']?.toString() ?? '0',
//               const Color(0xFF3182CE),
//               Icons.cleaning_services_outlined,
//             ),
//           ),
//           Container(
//             width: 1,
//             height: 30.h,
//             color: const Color(0xFFE2E8F0),
//             margin: EdgeInsets.symmetric(horizontal: 8.0.w),
//           ),
//           Expanded(
//             child: _buildCompactStatusItem(
//               'Failed',
//               status['failed']?.toString() ?? '0',
//               const Color(0xFFE53E3E),
//               Icons.error_outline,
//             ),
//           ),
//           Container(
//             width: 1,
//             height: 30.h,
//             color: const Color(0xFFE2E8F0),
//             margin: EdgeInsets.symmetric(horizontal: 8.0.w),
//           ),
//           Expanded(
//             child: _buildCompactStatusItem(
//               'Success',
//               status['success']?.toString() ?? '0',
//               const Color(0xFFE53E3E),
//               Icons.ac_unit_outlined,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCompactStatusItem(String title, String count, Color color, IconData icon) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(
//           icon,
//           color: color,
//           size: 16.0.sp,
//         ),
//         SizedBox(height: 4.0.h),
//         Text(
//           count,
//           style: TextStyle(
//             fontSize: 16.0.sp,
//             fontWeight: FontWeight.bold,
//             color: const Color(0xFF2D3748),
//           ),
//         ),
//         SizedBox(height: 2.0.h),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 8.2.sp,
//             color: const Color(0xFF718096),
//             fontWeight: FontWeight.w500,
//           ),
//           textAlign: TextAlign.center,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//       ],
//     );
//   }
//
//
//   // Add this widget to your PlantInspectionView or create a separate widget file
//   Widget _buildAllTicketsSection() {
//     return GetBuilder<TicketController>(
//       init: Get.find<TicketController>(),
//       builder: (ticketController) {
//         return Container(
//           padding: EdgeInsets.all(16.0.w),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16.0.r),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFFE2E8F0).withOpacity(0.6),
//                 blurRadius: 8.0,
//                 offset: const Offset(0, 2.0),
//                 spreadRadius: 0.5,
//               ),
//             ],
//             border: Border.all(
//               color: const Color(0xFFF7FAFC),
//               width: 1.0,
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header section
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(8.0.w),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFF7FAFC),
//                             borderRadius: BorderRadius.circular(8.0.r),
//                           ),
//                           child: Icon(
//                             Icons.support_agent,
//                             color: const Color(0xFF4A5568),
//                             size: 20.0.sp,
//                           ),
//                         ),
//                         SizedBox(width: 12.0.w),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "All Tickets",
//                                 style: TextStyle(
//                                   fontSize: 14.0.sp,
//                                   fontWeight: FontWeight.w600,
//                                   color: const Color(0xFF2D3748),
//                                 ),
//                               ),
//                               SizedBox(height: 2.0.h),
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Obx(() => Text(
//                                     ticketController.allTicketsStats.value?['count']?.toString() ?? '0',
//                                     style: TextStyle(
//                                       fontSize: 24.0.sp,
//                                       fontWeight: FontWeight.bold,
//                                       color: const Color(0xFF1A202C),
//                                     ),
//                                   )),
//                                   SizedBox(width: 4.0.w),
//                                   Padding(
//                                     padding: EdgeInsets.only(bottom: 2.0.h),
//                                     child: Text(
//                                       'Total',
//                                       style: TextStyle(
//                                         fontSize: 12.0.sp,
//                                         color: const Color(0xFF718096),
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//
//               // Priority cards section
//               Obx(() {
//                 if (ticketController.allTicketsStats.value?['priority'] != null) {
//                   return Column(
//                     children: [
//                       SizedBox(height: 12.0.h),
//                       _buildTicketPriorityCards(ticketController),
//                     ],
//                   );
//                 }
//                 return const SizedBox.shrink();
//               }),
//
//               // Status cards section
//               Obx(() {
//                 if (ticketController.allTicketsStats.value?['status'] != null) {
//                   return Column(
//                     children: [
//                       SizedBox(height: 8.0.h),
//                       _buildTicketStatusCards(ticketController),
//                     ],
//                   );
//                 }
//                 return const SizedBox.shrink();
//               }),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildTicketPriorityCards(TicketController ticketController) {
//     final priority = ticketController.allTicketsStats.value!['priority'] as Map<String, dynamic>;
//
//     return Container(
//       padding: EdgeInsets.all(12.0.w),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFAFBFC),
//         borderRadius: BorderRadius.circular(12.0.r),
//         border: Border.all(
//           color: const Color(0xFFEDF2F7),
//           width: 1.0,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Priority Breakdown',
//             style: TextStyle(
//               fontSize: 12.0.sp,
//               fontWeight: FontWeight.w600,
//               color: const Color(0xFF4A5568),
//             ),
//           ),
//           SizedBox(height: 8.0.h),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildCompactTicketItem(
//                   'Critical',
//                   priority['critical']?.toString() ?? '0',
//                   const Color(0xFFDC2626),
//                   Icons.priority_high,
//                 ),
//               ),
//               Container(
//                 width: 1,
//                 height: 30.h,
//                 color: const Color(0xFFE2E8F0),
//                 margin: EdgeInsets.symmetric(horizontal: 6.0.w),
//               ),
//               Expanded(
//                 child: _buildCompactTicketItem(
//                   'High',
//                   priority['high']?.toString() ?? '0',
//                   const Color(0xFFEA580C),
//                   Icons.auto_fix_high_sharp,
//                 ),
//               ),
//               Container(
//                 width: 1,
//                 height: 30.h,
//                 color: const Color(0xFFE2E8F0),
//                 margin: EdgeInsets.symmetric(horizontal: 6.0.w),
//               ),
//               Expanded(
//                 child: _buildCompactTicketItem(
//                   'Medium',
//                   priority['medium']?.toString() ?? '0',
//                   const Color(0xFFCA8A04),
//                   Icons.brightness_medium,
//                 ),
//               ),
//               Container(
//                 width: 1,
//                 height: 30.h,
//                 color: const Color(0xFFE2E8F0),
//                 margin: EdgeInsets.symmetric(horizontal: 6.0.w),
//               ),
//               Expanded(
//                 child: _buildCompactTicketItem(
//                   'Low',
//                   priority['low']?.toString() ?? '0',
//                   const Color(0xFF059669),
//                   Icons.backup_table_sharp,
//                 ),
//               ),
//               Container(
//                 width: 1,
//                 height: 30.h,
//                 color: const Color(0xFFE2E8F0),
//                 margin: EdgeInsets.symmetric(horizontal: 6.0.w),
//               ),
//               Expanded(
//                 child: _buildCompactTicketItem(
//                   'V.Low',
//                   priority['veryLow']?.toString() ?? '0',
//                   const Color(0xFF0284C7),
//                   Icons.low_priority,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTicketStatusCards(TicketController ticketController) {
//     final status = ticketController.allTicketsStats.value!['status'] as Map<String, dynamic>;
//
//     return Container(
//       padding: EdgeInsets.all(12.0.w),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF0F9FF),
//         borderRadius: BorderRadius.circular(12.0.r),
//         border: Border.all(
//           color: const Color(0xFFE0F2FE),
//           width: 1.0,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Status Overview',
//             style: TextStyle(
//               fontSize: 12.0.sp,
//               fontWeight: FontWeight.w600,
//               color: const Color(0xFF4A5568),
//             ),
//           ),
//           SizedBox(height: 8.0.h),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildCompactTicketItem(
//                   'Open',
//                   status['open']?.toString() ?? '0',
//                   const Color(0xFF059669),
//                   Icons.assignment_outlined,
//                 ),
//               ),
//               Container(
//                 width: 1,
//                 height: 30.h,
//                 color: const Color(0xFFE2E8F0),
//                 margin: EdgeInsets.symmetric(horizontal: 12.0.w),
//               ),
//               Expanded(
//                 child: _buildCompactTicketItem(
//                   'Closed',
//                   status['closed']?.toString() ?? '0',
//                   const Color(0xFF718096),
//                   Icons.assignment_turned_in_outlined,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCompactTicketItem(String title, String count, Color color, IconData icon) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(
//           icon,
//           color: color,
//           size: 16.0.sp,
//         ),
//         SizedBox(height: 4.0.h),
//         Text(
//           count,
//           style: TextStyle(
//             fontSize: 16.0.sp,
//             fontWeight: FontWeight.bold,
//             color: const Color(0xFF2D3748),
//           ),
//         ),
//         SizedBox(height: 2.0.h),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 9.0.sp,
//             color: const Color(0xFF718096),
//             fontWeight: FontWeight.w500,
//           ),
//           textAlign: TextAlign.center,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildInspectionTabs() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Scheduled Inspections',
//           style: TextStyle(
//             fontSize: 14.0.sp,
//             fontWeight: FontWeight.w600,
//             color: const Color(0xFF2D3748),
//           ),
//         ),
//         SizedBox(height: 14.4.h),
//         // Independent inspection items - no longer inside the white container
//         _buildInspectionItems(),
//       ],
//     );
//   }
//
//   Widget _buildInspectionItems() {
//     if (controller.inspectionItems.isEmpty) {
//       return Center(
//         child: Container(
//           padding: EdgeInsets.all(36.0.w),
//           child: Column(
//             children: [
//               Icon(
//                 Icons.assignment_outlined,
//                 size: 57.6.sp,
//                 color: const Color(0xFFE2E8F0),
//               ),
//               SizedBox(height: 14.4.h),
//               Text(
//                 'No inspections scheduled',
//                 style: TextStyle(
//                   fontSize: 14.4.sp,
//                   fontWeight: FontWeight.w500,
//                   color: const Color(0xFF718096),
//                 ),
//               ),
//               SizedBox(height: 7.2.h),
//               Text(
//                 'Pull down to refresh',
//                 style: TextStyle(
//                   fontSize: 12.6.sp,
//                   color: const Color(0xFFA0AEC0),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return Column(
//       children: [
//         for (int i = 0; i < controller.inspectionItems.length; i++)
//           InspectionItem(
//             inspectionData: controller.inspectionItems[i],
//             onTap: () async {
//               // Get the specific item's ID
//               int specificItemId = controller.inspectionItems[i]['id'];
//
//               // Fetch inspection data for the specific item
//               await controller.fetchInspectorData(specificItemId);
//
//               // Navigate to inspection details after fetching data
//               controller.navigateToInspectionDetails(controller.inspectionItems[i]);
//             },
//           ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Component/Inspector/plantInspectionView/inspection_item.dart';
import '../../Controller/Inspector/plant_inspection_controller.dart';
import '../../Controller/Inspector/ticket_controller.dart';

class PlantInspectionView extends GetView<PlantInspectionController> {
  const PlantInspectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(TicketController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Obx(() {
        if (controller.isLoadingDashboard.value) {
          return _buildLoadingState();
        } else if (controller.errorMessageDashboard.value != null) {
          return _buildErrorState();
        } else {
          return _buildMainContent();
        }
      }),
    );
  }
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF718096)),
          ),
          SizedBox(height: 14.4.h),
          Text(
            'Loading inspection data...',
            style: TextStyle(
              fontSize: 14.4.sp,
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildErrorState() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(18.0.w),
        padding: EdgeInsets.all(21.6.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.4.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE2E8F0),
              blurRadius: 9.0,
              offset: const Offset(0, 3.6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 57.6.sp,
              color: const Color(0xFFF56565),
            ),
            SizedBox(height: 14.4.h),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 16.2.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 7.2.h),
            Text(
              controller.errorMessageDashboard.value.toString(),
              style: TextStyle(
                fontSize: 12.6.sp,
                color: const Color(0xFF718096),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 21.6.h),
            ElevatedButton.icon(
              onPressed: controller.refreshDashboard,
              icon: Icon(Icons.refresh),
              label: Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF718096),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 21.6.w,
                  vertical: 10.8.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.8.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return RefreshIndicator(
      onRefresh: controller.refreshDashboard,
      color: const Color(0xFF718096),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Collapsible AppBar
          SliverAppBar(
            expandedHeight: 90.h, // Height when fully expanded
            floating: true,
            snap: true,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 4,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Plant Inspection Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.2.sp,
                  color: const Color(0xFF2D3748),
                ),
              ),
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
            ),
          ),

          // Main content
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: 18.0.w,
              vertical: 12.0.h,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildStatsSection(),
                SizedBox(height: 15.6.h),
                _buildAllTicketsSection(),
                SizedBox(height: 15.6.h),
                _buildInspectionTabs(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: EdgeInsets.all(16.0.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE2E8F0).withOpacity(0.6),
            blurRadius: 8.0,
            offset: const Offset(0, 2.0),
            spreadRadius: 0.5,
          ),
        ],
        border: Border.all(
          color: const Color(0xFFF7FAFC),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7FAFC),
                        borderRadius: BorderRadius.circular(8.0.r),
                      ),
                      child: Icon(
                        Icons.assessment,
                        color: const Color(0xFF4A5568),
                        size: 20.0.sp,
                      ),
                    ),
                    SizedBox(width: 12.0.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today's Inspections",
                            style: TextStyle(
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D3748),
                            ),
                          ),
                          SizedBox(height: 2.0.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                controller.todaysInspections.value?['count']?.toString() ?? '0',
                                style: TextStyle(
                                  fontSize: 24.0.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1A202C),
                                ),
                              ),
                              SizedBox(width: 4.0.w),
                              Padding(
                                padding: EdgeInsets.only(bottom: 2.0.h),
                                child: Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 12.0.sp,
                                    color: const Color(0xFF718096),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (controller.todaysInspections.value?['status'] != null) ...[
            SizedBox(height: 12.0.h),
            _buildCompactStatusCards(),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactStatusCards() {
    final status = controller.todaysInspections.value!['status'] as Map<String, dynamic>;

    return Container(
      padding: EdgeInsets.all(12.0.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFC),
        borderRadius: BorderRadius.circular(12.0.r),
        border: Border.all(
          color: const Color(0xFFEDF2F7),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildCompactStatusItem(
              'Complete',
              status['complete']?.toString() ?? '0',
              const Color(0xFF48BB78),
              Icons.check_circle_outline,
            ),
          ),
          Container(
            width: 1,
            height: 30.h,
            color: const Color(0xFFE2E8F0),
            margin: EdgeInsets.symmetric(horizontal: 8.0.w),
          ),
          Expanded(
            child: _buildCompactStatusItem(
              'Pending',
              status['pending']?.toString() ?? '0',
              const Color(0xFF718096),
              Icons.schedule_outlined,
            ),
          ),
          Container(
            width: 1,
            height: 30.h,
            color: const Color(0xFFE2E8F0),
            margin: EdgeInsets.symmetric(horizontal: 8.0.w),
          ),
          Expanded(
            child: _buildCompactStatusItem(
              'Cleaning',
              status['cleaning']?.toString() ?? '0',
              const Color(0xFF3182CE),
              Icons.cleaning_services_outlined,
            ),
          ),
          Container(
            width: 1,
            height: 30.h,
            color: const Color(0xFFE2E8F0),
            margin: EdgeInsets.symmetric(horizontal: 8.0.w),
          ),
          Expanded(
            child: _buildCompactStatusItem(
              'Failed',
              status['failed']?.toString() ?? '0',
              const Color(0xFFE53E3E),
              Icons.error_outline,
            ),
          ),
          Container(
            width: 1,
            height: 30.h,
            color: const Color(0xFFE2E8F0),
            margin: EdgeInsets.symmetric(horizontal: 8.0.w),
          ),
          Expanded(
            child: _buildCompactStatusItem(
              'Success',
              status['success']?.toString() ?? '0',
              const Color(0xFFE53E3E),
              Icons.ac_unit_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatusItem(String title, String count, Color color, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 16.0.sp,
        ),
        SizedBox(height: 4.0.h),
        Text(
          count,
          style: TextStyle(
            fontSize: 16.0.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 2.0.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 8.2.sp,
            color: const Color(0xFF718096),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildAllTicketsSection() {
    return GetBuilder<TicketController>(
      init: Get.find<TicketController>(),
      builder: (ticketController) {
        return Container(
          padding: EdgeInsets.all(16.0.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE2E8F0).withOpacity(0.6),
                blurRadius: 8.0,
                offset: const Offset(0, 2.0),
                spreadRadius: 0.5,
              ),
            ],
            border: Border.all(
              color: const Color(0xFFF7FAFC),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7FAFC),
                            borderRadius: BorderRadius.circular(8.0.r),
                          ),
                          child: Icon(
                            Icons.support_agent,
                            color: const Color(0xFF4A5568),
                            size: 20.0.sp,
                          ),
                        ),
                        SizedBox(width: 12.0.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "All Tickets",
                                style: TextStyle(
                                  fontSize: 14.0.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2D3748),
                                ),
                              ),
                              SizedBox(height: 2.0.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Obx(() => Text(
                                    ticketController.allTicketsStats.value?['count']?.toString() ?? '0',
                                    style: TextStyle(
                                      fontSize: 24.0.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1A202C),
                                    ),
                                  )),
                                  SizedBox(width: 4.0.w),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 2.0.h),
                                    child: Text(
                                      'Total',
                                      style: TextStyle(
                                        fontSize: 12.0.sp,
                                        color: const Color(0xFF718096),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Obx(() {
                if (ticketController.allTicketsStats.value?['priority'] != null) {
                  return Column(
                    children: [
                      SizedBox(height: 12.0.h),
                      _buildTicketPriorityCards(ticketController),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),

              Obx(() {
                if (ticketController.allTicketsStats.value?['status'] != null) {
                  return Column(
                    children: [
                      SizedBox(height: 8.0.h),
                      _buildTicketStatusCards(ticketController),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTicketPriorityCards(TicketController ticketController) {
    final priority = ticketController.allTicketsStats.value!['priority'] as Map<String, dynamic>;

    return Container(
      padding: EdgeInsets.all(12.0.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFC),
        borderRadius: BorderRadius.circular(12.0.r),
        border: Border.all(
          color: const Color(0xFFEDF2F7),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Priority Breakdown',
            style: TextStyle(
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4A5568),
            ),
          ),
          SizedBox(height: 8.0.h),
          Row(
            children: [
              Expanded(
                child: _buildCompactTicketItem(
                  'Critical',
                  priority['critical']?.toString() ?? '0',
                  const Color(0xFFDC2626),
                  Icons.priority_high,
                ),
              ),
              Container(
                width: 1,
                height: 30.h,
                color: const Color(0xFFE2E8F0),
                margin: EdgeInsets.symmetric(horizontal: 6.0.w),
              ),
              Expanded(
                child: _buildCompactTicketItem(
                  'High',
                  priority['high']?.toString() ?? '0',
                  const Color(0xFFEA580C),
                  Icons.auto_fix_high_sharp,
                ),
              ),
              Container(
                width: 1,
                height: 30.h,
                color: const Color(0xFFE2E8F0),
                margin: EdgeInsets.symmetric(horizontal: 6.0.w),
              ),
              Expanded(
                child: _buildCompactTicketItem(
                  'Medium',
                  priority['medium']?.toString() ?? '0',
                  const Color(0xFFCA8A04),
                  Icons.brightness_medium,
                ),
              ),
              Container(
                width: 1,
                height: 30.h,
                color: const Color(0xFFE2E8F0),
                margin: EdgeInsets.symmetric(horizontal: 6.0.w),
              ),
              Expanded(
                child: _buildCompactTicketItem(
                  'Low',
                  priority['low']?.toString() ?? '0',
                  const Color(0xFF059669),
                  Icons.backup_table_sharp,
                ),
              ),
              Container(
                width: 1,
                height: 30.h,
                color: const Color(0xFFE2E8F0),
                margin: EdgeInsets.symmetric(horizontal: 6.0.w),
              ),
              Expanded(
                child: _buildCompactTicketItem(
                  'V.Low',
                  priority['veryLow']?.toString() ?? '0',
                  const Color(0xFF0284C7),
                  Icons.low_priority,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTicketStatusCards(TicketController ticketController) {
    final status = ticketController.allTicketsStats.value!['status'] as Map<String, dynamic>;

    return Container(
      padding: EdgeInsets.all(12.0.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(12.0.r),
        border: Border.all(
          color: const Color(0xFFE0F2FE),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Overview',
            style: TextStyle(
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4A5568),
            ),
          ),
          SizedBox(height: 8.0.h),
          Row(
            children: [
              Expanded(
                child: _buildCompactTicketItem(
                  'Open',
                  status['open']?.toString() ?? '0',
                  const Color(0xFF059669),
                  Icons.assignment_outlined,
                ),
              ),
              Container(
                width: 1,
                height: 30.h,
                color: const Color(0xFFE2E8F0),
                margin: EdgeInsets.symmetric(horizontal: 12.0.w),
              ),
              Expanded(
                child: _buildCompactTicketItem(
                  'Closed',
                  status['closed']?.toString() ?? '0',
                  const Color(0xFF718096),
                  Icons.assignment_turned_in_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactTicketItem(String title, String count, Color color, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 16.0.sp,
        ),
        SizedBox(height: 4.0.h),
        Text(
          count,
          style: TextStyle(
            fontSize: 16.0.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 2.0.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 9.0.sp,
            color: const Color(0xFF718096),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildInspectionTabs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scheduled Inspections',
          style: TextStyle(
            fontSize: 14.0.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 14.4.h),
        _buildInspectionItems(),
      ],
    );
  }

  Widget _buildInspectionItems() {
    if (controller.inspectionItems.isEmpty) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(36.0.w),
          child: Column(
            children: [
              Icon(
                Icons.assignment_outlined,
                size: 57.6.sp,
                color: const Color(0xFFE2E8F0),
              ),
              SizedBox(height: 14.4.h),
              Text(
                'No inspections scheduled',
                style: TextStyle(
                  fontSize: 14.4.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF718096),
                ),
              ),
              SizedBox(height: 7.2.h),
              Text(
                'Pull down to refresh',
                style: TextStyle(
                  fontSize: 12.6.sp,
                  color: const Color(0xFFA0AEC0),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < controller.inspectionItems.length; i++)
          InspectionItem(
            inspectionData: controller.inspectionItems[i],
            onTap: () async {
              int specificItemId = controller.inspectionItems[i]['id'];
              await controller.fetchInspectorData(specificItemId);
              controller.navigateToInspectionDetails(controller.inspectionItems[i]);
            },
          ),
      ],
    );
  }
}