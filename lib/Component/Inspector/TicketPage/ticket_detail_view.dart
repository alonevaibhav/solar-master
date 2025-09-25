// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:solar_app/Component/Inspector/TicketPage/priority_banner.dart';
// import '../../../API Service/api_service.dart';
// import '../../../Controller/Inspector/ticket_controller.dart';
// import '../../../Route Manager/app_routes.dart';
// import '../../../utils/drop_down.dart';
// import '../../../utils/gallary.dart';
// import 'info_section.dart';
//
// class TicketDetailView extends GetView<TicketController> {
//   const TicketDetailView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final Map<String, dynamic> ticketData = Get.arguments;
//     final Map<String, String> dateTime = _formatDateTime(ticketData['createdAt']);
//
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           'Issue Detail',
//           style: TextStyle(
//             fontSize: 16.2.sp,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           Padding(
//             padding: EdgeInsets.only(right: 16.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.blue, Colors.blueAccent],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(10.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.blue.withOpacity(0.4),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: TextButton(
//                 onPressed: () {
//                   Get.toNamed(
//                     AppRoutes.inspectorTicketChat,
//                     arguments: ticketData,
//                   );
//                 },
//                 style: TextButton.styleFrom(
//                   padding: EdgeInsets.symmetric(horizontal: 16.0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20.0),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.chat, color: Colors.white),
//                     SizedBox(width: 8.0),
//                     Text(
//                       'Chat',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (controller.errorMessage.value != null) {
//           return Center(child: Text(controller.errorMessage.value!));
//         }
//         return SingleChildScrollView(
//           padding: EdgeInsets.all(14.4.r),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (ticketData['attachments'] != null &&
//                   (ticketData['attachments'] as List).isNotEmpty) ...[
//                 SizedBox(height: 14.4.h),
//                 _buildImageSection(ticketData['attachments']),
//               ],
//               SizedBox(height: 14.4.h),
//               PriorityBanner(
//                 priority: _getPriorityLabel(ticketData['priority'] ?? '3'),
//                 status: ticketData['status'] ?? '',
//                 color: _getPriorityColor(ticketData['priority'] ?? '3'),
//               ),
//               SizedBox(height: 14.4.h),
//               _buildSection(
//                 'Title',
//                 SizedBox(
//                   width: double.infinity,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         ticketData['title'] ?? '',
//                         style: TextStyle(
//                           fontSize: 14.4.sp,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       SizedBox(height: 7.2.h),
//                       Text(
//                         'Description',
//                         style: TextStyle(
//                           fontSize: 12.6.sp,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                       Text(
//                         ticketData['description'] ?? '',
//                         style: TextStyle(fontSize: 12.6.sp),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 14.4.h),
//               InfoCard(
//                 title: 'Ticket Info',
//                 status: ticketData['status'] ?? '',
//                 children: [
//                   _buildInfoRow('Opened:', dateTime['date'] ?? ''),
//                   _buildInfoRow('Time:', dateTime['time'] ?? ''),
//                   _buildInfoRow('Department:', ticketData['department'] ?? ''),
//                   _buildInfoRow(
//                       'Creator Type:', ticketData['creator_type'] ?? ''),
//                   _buildInfoRow(
//                       'Ticket Type:', ticketData['ticket_type'] ?? ''),
//                   _buildInfoRow(
//                       'Assigned To:', ticketData['assigned_to'] ?? ''),
//                   _buildInfoRow(
//                       'Creator Name:', ticketData['creator_name'] ?? ''),
//                   _buildInfoRow('Inspector Assigned:',
//                       ticketData['inspector_assigned'] ?? ''),
//                   if (ticketData['status'] == 'closed')
//                     _buildInfoRow('Closed:', ticketData['closed'] ?? ''),
//                 ],
//               ),
//               SizedBox(height: 14.4.h),
//               _buildDropdownSection(ticketData),
//               SizedBox(height: 14.4.h),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () => controller.updateTicketDetails(ticketData,context),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                     padding: EdgeInsets.symmetric(vertical: 14.4.h),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.8.r),
//                     ),
//                     elevation: 3,
//                   ),
//                   child: Text(
//                     'Update Ticket',
//                     style: TextStyle(
//                       fontSize: 14.4.sp,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   Map<String, String> _formatDateTime(String? dateTimeStr) {
//     if (dateTimeStr == null || dateTimeStr.isEmpty) {
//       return {'date': 'N/A', 'time': 'N/A'};
//     }
//
//     try {
//       DateTime dateTime = DateTime.parse(dateTimeStr);
//       String formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);
//       String formattedTime = DateFormat('h:mm a').format(dateTime);
//
//       return {'date': formattedDate, 'time': formattedTime};
//     } catch (e) {
//       return {'date': 'N/A', 'time': 'N/A'};
//     }
//   }
//
//   Widget _buildSection(String title, Widget content) {
//     return Container(
//       padding: EdgeInsets.all(14.4.r),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10.8.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 4.5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 14.4.sp,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 7.2.h),
//           content,
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String label, dynamic value) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 3.6.h),
//       child: Row(
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12.6.sp,
//               color: Colors.grey[600],
//             ),
//           ),
//           SizedBox(width: 3.6.w),
//           Text(
//             value.toString(),
//             style: TextStyle(
//               fontSize: 12.6.sp,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color _getPriorityColor(String priority) {
//     switch (priority) {
//       case '1':
//         return const Color(0xFFDC2626);
//       case '2':
//         return const Color(0xFFEA580C);
//       case '3':
//         return const Color(0xFFCA8A04);
//       case '4':
//         return const Color(0xFF059669);
//       case '5':
//         return const Color(0xFF0284C7);
//       default:
//         return const Color(0xFFCA8A04);
//     }
//   }
//
//   String _getPriorityLabel(String priority) {
//     switch (priority) {
//       case '1':
//         return 'Critical';
//       case '2':
//         return 'High';
//       case '3':
//         return 'Medium';
//       case '4':
//         return 'Low';
//       case '5':
//         return 'Very Low';
//       default:
//         return 'Medium';
//     }
//   }
//
//   Widget _buildImageSection(List<dynamic> attachments) {
//     if (attachments.isEmpty) {
//       return SizedBox.shrink();
//     }
//
//     return Container(
//       padding: EdgeInsets.all(14.4.r),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10.8.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 4.5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Attachments (${attachments.length})',
//             style: TextStyle(
//               fontSize: 14.4.sp,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 10.8.h),
//           Container(
//             height: 100.h,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: attachments.length,
//               itemBuilder: (context, index) {
//                 final attachment = attachments[index];
//                 final imagePath = attachment.path ?? '';
//
//                 return GestureDetector(
//                   onTap: () => _openImageGallery(attachments, index),
//                   child: Container(
//                     width: 100.w,
//                     height: 100.h,
//                     margin: EdgeInsets.only(right: 10.8.w),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8.r),
//                       border: Border.all(color: Colors.grey[300]!),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(8.r),
//                       child: imagePath.isNotEmpty
//                           ? Image.network(
//                               imagePath,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) {
//                                 return Container(
//                                   color: Colors.grey[200],
//                                   child: Icon(
//                                     Icons.image_not_supported,
//                                     color: Colors.grey[400],
//                                     size: 32.r,
//                                   ),
//                                 );
//                               },
//                               loadingBuilder:
//                                   (context, child, loadingProgress) {
//                                 if (loadingProgress == null) return child;
//                                 return Container(
//                                   color: Colors.grey[200],
//                                   child: Center(
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       value:
//                                           loadingProgress.expectedTotalBytes !=
//                                                   null
//                                               ? loadingProgress
//                                                       .cumulativeBytesLoaded /
//                                                   loadingProgress
//                                                       .expectedTotalBytes!
//                                               : null,
//                                     ),
//                                   ),
//                                 );
//                               },
//                             )
//                           : Container(
//                               color: Colors.grey[200],
//                               child: Icon(
//                                 Icons.image,
//                                 color: Colors.grey[400],
//                                 size: 32.r,
//                               ),
//                             ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _openImageGallery(List<dynamic> attachments, int initialIndex) {
//     Get.to(() => ImageGalleryView(
//           attachments: attachments,
//           initialIndex: initialIndex,
//         ));
//   }
//
//   Widget _buildDropdownSection(Map<String, dynamic> ticketData) {
//     controller.initializeDropdownValues(ticketData);
//
//     return Container(
//       padding: EdgeInsets.all(14.4.r),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10.8.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 4.5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Update Ticket Details',
//             style: TextStyle(
//               fontSize: 14.4.sp,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 14.4.h),
//           Obx(() => CustomDropdownField<String>(
//                 value: controller.selectedPriority.value,
//                 labelText: 'Priority',
//                 items: controller.priorities,
//                 itemLabelBuilder: (priority) =>
//                     controller.getPriorityLabel(priority),
//                 onChanged: (value) {
//                   if (value != null) {
//                     controller.selectedPriority.value = value;
//                   }
//                 },
//                 prefixIcon: Icons.priority_high,
//               )),
//           SizedBox(height: 12.h),
//           Obx(() => CustomDropdownField<String>(
//                 value: controller.selectedStatus.value,
//                 labelText: 'Status',
//                 items: controller.statusOptions,
//                 itemLabelBuilder: (status) => status.toUpperCase(),
//                 onChanged: (value) {
//                   if (value != null) {
//                     controller.selectedStatus.value = value;
//                   }
//                 },
//                 prefixIcon: Icons.info_outline,
//               )),
//           SizedBox(height: 12.h),
//           Obx(() => CustomDropdownField<String>(
//                 value: controller.selectedDepartment.value,
//                 labelText: 'Department',
//                 items: controller.departments,
//                 itemLabelBuilder: (dept) => dept.toUpperCase(),
//                 onChanged: (value) {
//                   if (value != null) {
//                     controller.selectedDepartment.value = value;
//                   }
//                 },
//                 prefixIcon: Icons.business,
//               )),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solar_app/Component/Inspector/TicketPage/priority_banner.dart';
import '../../../API Service/api_service.dart';
import '../../../Controller/Inspector/ticket_controller.dart';
import '../../../Route Manager/app_routes.dart';
import '../../../utils/drop_down.dart';
import '../../../utils/gallary.dart';
import 'info_section.dart';

class TicketDetailView extends GetView<TicketController> {
  const TicketDetailView({Key? key}) : super(key: key);

  final double _scaleFactor = 0.8;

  double _scale(double value) => value * _scaleFactor;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> ticketData = Get.arguments;
    final Map<String, String> dateTime = _formatDateTime(ticketData['createdAt']);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: _scale(120.h),
            floating: false,
            pinned: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1E40AF),
                    Color(0xFF3B82F6),
                    Color(0xFF60A5FA),
                  ],
                ),
              ),
              child: FlexibleSpaceBar(
                title: Text(
                  ticketData['title'] ?? '',
                  style: TextStyle(
                    fontSize: _scale(18.sp),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
              ),
            ),
            leading: Container(
              margin: EdgeInsets.all(_scale(8.r)),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(_scale(12.r)),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: _scale(16.w),
                  vertical: _scale(8.h),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(_scale(25.r)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: _scale(8),
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextButton.icon(
                  onPressed: () {
                    Get.toNamed(
                      AppRoutes.inspectorTicketChat,
                      arguments: ticketData,
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: _scale(16.w),
                      vertical: _scale(8.h),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_scale(25.r)),
                    ),
                  ),
                  icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF3B82F6)),
                  label: Text(
                    'Chat',
                    style: TextStyle(
                      color: const Color(0xFF3B82F6),
                      fontWeight: FontWeight.w600,
                      fontSize: _scale(14.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.isLoading.value) {
                return SizedBox(
                  height: _scale(400.h),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                    ),
                  ),
                );
              }
              if (controller.errorMessage.value != null) {
                return Container(
                  margin: EdgeInsets.all(_scale(16.r)),
                  padding: EdgeInsets.all(_scale(20.r)),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(_scale(16.r)),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red[400],
                        size: _scale(48.r),
                      ),
                      SizedBox(height: _scale(12.h)),
                      Text(
                        controller.errorMessage.value!,
                        style: TextStyle(
                          color: Colors.red[700],
                          fontSize: _scale(14.sp),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  _scale(16.w),
                  0,
                  _scale(16.w),
                  _scale(100.h),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: _scale(16.h)),
                    _buildStatusCard(ticketData),
                    SizedBox(height: _scale(20.h)),
                    if (ticketData['attachments'] != null && (ticketData['attachments'] as List).isNotEmpty) ...[
                      _buildImageSection(ticketData['attachments']),
                      SizedBox(height: _scale(20.h)),
                    ],
                    _buildTitleDescriptionCard(ticketData),
                    SizedBox(height: _scale(20.h)),
                    _buildTicketInfoCard(ticketData, dateTime),
                    SizedBox(height: _scale(20.h)),
                    _buildUpdateSection(ticketData),
                    SizedBox(height: _scale(20.h)),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(_scale(28.r)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withOpacity(0.3),
              blurRadius: _scale(12),
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => controller.updateTicketDetails(ticketData, context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.update, color: Colors.white),
          label: Text(
            'Update Ticket',
            style: TextStyle(
              fontSize: _scale(16.sp),
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(Map<String, dynamic> ticketData) {
    return Container(
      padding: EdgeInsets.all(_scale(20.r)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.blue[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(_scale(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: _scale(15),
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.blue[100]!, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: _scale(20.w),
              vertical: _scale(11.h),
            ),
            decoration: BoxDecoration(
              color: _getPriorityColor(ticketData['priority'] ?? '3'),
              borderRadius: BorderRadius.circular(_scale(10.r)),
              boxShadow: [
                BoxShadow(
                  color: _getPriorityColor(ticketData['priority'] ?? '3').withOpacity(0.3),
                  blurRadius: _scale(8),
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              _getPriorityLabel(ticketData['priority'] ?? '3'),
              style: TextStyle(
                color: Colors.white,
                fontSize: _scale(12.sp),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: _scale(12.w)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: _scale(20.w),
              vertical: _scale(11.h),
            ),
            decoration: BoxDecoration(
              color: _getStatusColor(ticketData['status'] ?? ''),
              borderRadius: BorderRadius.circular(_scale(10.r)),
              boxShadow: [
                BoxShadow(
                  color: _getStatusColor(ticketData['status'] ?? '').withOpacity(0.3),
                  blurRadius: _scale(8),
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              (ticketData['status'] ?? '').toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: _scale(12.sp),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleDescriptionCard(Map<String, dynamic> ticketData) {
    return Container(
      padding: EdgeInsets.all(_scale(20.r)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_scale(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: _scale(20),
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.blue[50]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(_scale(8.r)),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(_scale(12.r)),
                ),
                child: Icon(
                  Icons.title,
                  color: const Color(0xFF3B82F6),
                  size: _scale(20.r),
                ),
              ),
              SizedBox(width: _scale(12.w)),
              Text(
                'Issue Details',
                style: TextStyle(
                  fontSize: _scale(18.sp),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          SizedBox(height: _scale(16.h)),
          Text(
            'Title',
            style: TextStyle(
              fontSize: _scale(14.sp),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: _scale(8.h)),
          Text(
            ticketData['title'] ?? '',
            style: TextStyle(
              fontSize: _scale(16.sp),
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1E293B),
              height: 1.4,
            ),
          ),
          SizedBox(height: _scale(16.h)),
          Text(
            'Description',
            style: TextStyle(
              fontSize: _scale(14.sp),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: _scale(8.h)),
          Text(
            ticketData['description'] ?? '',
            style: TextStyle(
              fontSize: _scale(14.sp),
              color: const Color(0xFF475569),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketInfoCard(Map<String, dynamic> ticketData, Map<String, String> dateTime) {
    return Container(
      padding: EdgeInsets.all(_scale(20.r)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_scale(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: _scale(20),
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.blue[50]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(_scale(8.r)),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(_scale(12.r)),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: const Color(0xFF3B82F6),
                  size: _scale(20.r),
                ),
              ),
              SizedBox(width: _scale(12.w)),
              Text(
                'Ticket Information',
                style: TextStyle(
                  fontSize: _scale(18.sp),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          SizedBox(height: _scale(20.h)),
          _buildInfoGrid([
            {'label': 'Opened', 'value': dateTime['date'] ?? '', 'icon': Icons.calendar_today},
            {'label': 'Time', 'value': dateTime['time'] ?? '', 'icon': Icons.access_time},
            {'label': 'Department', 'value': ticketData['department'] ?? '', 'icon': Icons.business},
            {'label': 'Creator Type', 'value': ticketData['creator_type'] ?? '', 'icon': Icons.person_outline},
            {'label': 'Ticket Type', 'value': ticketData['ticket_type'] ?? '', 'icon': Icons.category},
            {'label': 'Assigned To', 'value': ticketData['assigned_to'] ?? '', 'icon': Icons.person},
            {'label': 'Creator Name', 'value': ticketData['creator_name'] ?? '', 'icon': Icons.account_circle},
            {'label': 'Inspector', 'value': ticketData['inspector_assigned'] ?? '', 'icon': Icons.supervisor_account},
          ]),
          if (ticketData['status'] == 'closed')
            Padding(
              padding: EdgeInsets.only(top: _scale(16.h)),
              child: Container(
                padding: EdgeInsets.all(_scale(12.r)),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(_scale(12.r)),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[600], size: _scale(20.r)),
                    SizedBox(width: _scale(8.w)),
                    Text(
                      'Closed: ${ticketData['closed'] ?? ''}',
                      style: TextStyle(
                        fontSize: _scale(14.sp),
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
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

  Widget _buildInfoGrid(List<Map<String, dynamic>> infoItems) {
    return Column(
      children: [
        for (int i = 0; i < infoItems.length; i += 2)
          Padding(
            padding: EdgeInsets.only(bottom: _scale(12.h)),
            child: Row(
              children: [
                Expanded(child: _buildInfoItem(infoItems[i])),
                if (i + 1 < infoItems.length) ...[
                  SizedBox(width: _scale(12.w)),
                  Expanded(child: _buildInfoItem(infoItems[i + 1])),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildInfoItem(Map<String, dynamic> info) {
    return Container(
      padding: EdgeInsets.all(_scale(12.r)),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(_scale(12.r)),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                info['icon'],
                size: _scale(16.r),
                color: const Color(0xFF64748B),
              ),
              SizedBox(width: _scale(6.w)),
              Text(
                info['label'],
                style: TextStyle(
                  fontSize: _scale(15.sp),
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: _scale(6.h)),
          Text(
            info['value'].toString().isEmpty ? 'N/A' : info['value'].toString(),
            style: TextStyle(
              fontSize: _scale(15.sp),
              color: const Color(0xFF1E293B),
              fontWeight: FontWeight.w800,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateSection(Map<String, dynamic> ticketData) {
    controller.initializeDropdownValues(ticketData);
    return Container(
      padding: EdgeInsets.all(_scale(20.r)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_scale(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: _scale(20),
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.blue[50]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(_scale(8.r)),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(_scale(12.r)),
                ),
                child: Icon(
                  Icons.edit,
                  color: const Color(0xFF3B82F6),
                  size: _scale(20.r),
                ),
              ),
              SizedBox(width: _scale(12.w)),
              Text(
                'Update Ticket Details',
                style: TextStyle(
                  fontSize: _scale(18.sp),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          SizedBox(height: _scale(20.h)),
          Obx(() => CustomDropdownField<String>(
            value: controller.selectedPriority.value,
            labelText: 'Priority',
            items: controller.priorities,
            itemLabelBuilder: (priority) =>
                controller.getPriorityLabel(priority),
            onChanged: (value) {
              if (value != null) {
                controller.selectedPriority.value = value;
              }
            },
            prefixIcon: Icons.priority_high,
          )),
          SizedBox(height: _scale(16.h)),
          Obx(() => CustomDropdownField<String>(
            value: controller.selectedStatus.value,
            labelText: 'Status',
            items: controller.statusOptions,
            itemLabelBuilder: (status) => status.toUpperCase(),
            onChanged: (value) {
              if (value != null) {
                controller.selectedStatus.value = value;
              }
            },
            prefixIcon: Icons.info_outline,
          )),
          SizedBox(height: _scale(16.h)),
          Obx(() => CustomDropdownField<String>(
            value: controller.selectedDepartment.value,
            labelText: 'Department',
            items: controller.departments,
            itemLabelBuilder: (dept) => dept.toUpperCase(),
            onChanged: (value) {
              if (value != null) {
                controller.selectedDepartment.value = value;
              }
            },
            prefixIcon: Icons.business,
          )),
        ],
      ),
    );
  }

  Widget _buildImageSection(List<dynamic> attachments) {
    if (attachments.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: EdgeInsets.all(_scale(20.r)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_scale(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: _scale(20),
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.blue[50]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(_scale(8.r)),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(_scale(12.r)),
                ),
                child: Icon(
                  Icons.attachment,
                  color: const Color(0xFF3B82F6),
                  size: _scale(20.r),
                ),
              ),
              SizedBox(width: _scale(12.w)),
              Text(
                'Attachments (${attachments.length})',
                style: TextStyle(
                  fontSize: _scale(18.sp),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          SizedBox(height: _scale(16.h)),
          SizedBox(
            height: _scale(120.h),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: attachments.length,
              itemBuilder: (context, index) {
                final attachment = attachments[index];
                final imagePath = attachment.path ?? '';
                return GestureDetector(
                  onTap: () => _openImageGallery(attachments, index),
                  child: Container(
                    width: _scale(120.w),
                    height: _scale(120.h),
                    margin: EdgeInsets.only(right: _scale(12.w)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(_scale(16.r)),
                      border: Border.all(color: Colors.blue[100]!, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          blurRadius: _scale(8),
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_scale(14.r)),
                      child: imagePath.isNotEmpty
                          ? Image.network(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[100],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey[400],
                                  size: _scale(32.r),
                                ),
                                SizedBox(height: _scale(8.h)),
                                Text(
                                  'Failed to load',
                                  style: TextStyle(
                                    fontSize: _scale(10.sp),
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[50],
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      )
                          : Container(
                        color: Colors.grey[50],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              color: Colors.grey[400],
                              size: _scale(32.r),
                            ),
                            SizedBox(height: _scale(8.h)),
                            Text(
                              'No image',
                              style: TextStyle(
                                fontSize: _scale(10.sp),
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return const Color(0xFF059669);
      case 'in_progress':
        return const Color(0xFFEA580C);
      case 'closed':
        return const Color(0xFF6B7280);
      case 'pending':
        return const Color(0xFFCA8A04);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  Map<String, String> _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) {
      return {'date': 'N/A', 'time': 'N/A'};
    }
    try {
      DateTime dateTime = DateTime.parse(dateTimeStr);
      String formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);
      String formattedTime = DateFormat('h:mm a').format(dateTime);
      return {'date': formattedDate, 'time': formattedTime};
    } catch (e) {
      return {'date': 'N/A', 'time': 'N/A'};
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case '1':
        return const Color(0xFFDC2626);
      case '2':
        return const Color(0xFFEA580C);
      case '3':
        return const Color(0xFFCA8A04);
      case '4':
        return const Color(0xFF059669);
      case '5':
        return const Color(0xFF0284C7);
      default:
        return const Color(0xFFCA8A04);
    }
  }

  String _getPriorityLabel(String priority) {
    switch (priority) {
      case '1':
        return 'Critical';
      case '2':
        return 'High';
      case '3':
        return 'Medium';
      case '4':
        return 'Low';
      case '5':
        return 'Very Low';
      default:
        return 'Medium';
    }
  }

  void _openImageGallery(List<dynamic> attachments, int initialIndex) {
    Get.to(() => ImageGalleryView(
      attachments: attachments,
      initialIndex: initialIndex,
    ));
  }
}
