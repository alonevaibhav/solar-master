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

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> ticketData = Get.arguments;
    final Map<String, String> dateTime =
        _formatDateTime(ticketData['createdAt']);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Issue Detail',
          style: TextStyle(
            fontSize: 16.2.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  Get.toNamed(
                    AppRoutes.inspectorTicketChat,
                    arguments: ticketData,
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.chat, color: Colors.white),
                    SizedBox(width: 8.0),
                    Text(
                      'Chat',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value != null) {
          return Center(child: Text(controller.errorMessage.value!));
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(14.4.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ticketData['attachments'] != null &&
                  (ticketData['attachments'] as List).isNotEmpty) ...[
                SizedBox(height: 14.4.h),
                _buildImageSection(ticketData['attachments']),
              ],
              SizedBox(height: 14.4.h),
              PriorityBanner(
                priority: _getPriorityLabel(ticketData['priority'] ?? '3'),
                status: ticketData['status'] ?? '',
                color: _getPriorityColor(ticketData['priority'] ?? '3'),
              ),
              SizedBox(height: 14.4.h),
              _buildSection(
                'Title',
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticketData['title'] ?? '',
                        style: TextStyle(
                          fontSize: 14.4.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 7.2.h),
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 12.6.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        ticketData['description'] ?? '',
                        style: TextStyle(fontSize: 12.6.sp),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 14.4.h),
              InfoCard(
                title: 'Ticket Info',
                status: ticketData['status'] ?? '',
                children: [
                  _buildInfoRow('Opened:', dateTime['date'] ?? ''),
                  _buildInfoRow('Time:', dateTime['time'] ?? ''),
                  _buildInfoRow('Department:', ticketData['department'] ?? ''),
                  _buildInfoRow(
                      'Creator Type:', ticketData['creator_type'] ?? ''),
                  _buildInfoRow(
                      'Ticket Type:', ticketData['ticket_type'] ?? ''),
                  _buildInfoRow(
                      'Assigned To:', ticketData['assigned_to'] ?? ''),
                  _buildInfoRow(
                      'Creator Name:', ticketData['creator_name'] ?? ''),
                  _buildInfoRow('Inspector Assigned:',
                      ticketData['inspector_assigned'] ?? ''),
                  if (ticketData['status'] == 'closed')
                    _buildInfoRow('Closed:', ticketData['closed'] ?? ''),
                ],
              ),
              SizedBox(height: 14.4.h),
              _buildDropdownSection(ticketData),
              SizedBox(height: 14.4.h),
              Container(
                padding: EdgeInsets.all(14.4.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4.5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 14.4.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10.8.r),
                      ),
                      padding: EdgeInsets.all(14.4.r),
                      height: 200.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(21.6.r),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: TextField(
                              controller: controller.messageController,
                              decoration: InputDecoration(
                                hintText: 'Send message...',
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14.4.w,
                                  vertical: 7.2.h,
                                ),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.send, color: Colors.black),
                                  onPressed: controller.sendMessage,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.4.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.8.r),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 14.4.w),
                      child: TextField(
                        controller: controller.remarkController,
                        decoration: InputDecoration(
                          hintText: 'Add remark...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 21.6.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.updateTicketDetails(ticketData),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 14.4.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.8.r),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    'Update Ticket',
                    style: TextStyle(
                      fontSize: 14.4.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
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

  Widget _buildSection(String title, Widget content) {
    return Container(
      padding: EdgeInsets.all(14.4.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4.5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.4.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 7.2.h),
          content,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.6.h),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.6.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 3.6.w),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 12.6.sp,
            ),
          ),
        ],
      ),
    );
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

  Widget _buildImageSection(List<dynamic> attachments) {
    if (attachments.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(14.4.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4.5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attachments (${attachments.length})',
            style: TextStyle(
              fontSize: 14.4.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.8.h),
          Container(
            height: 100.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: attachments.length,
              itemBuilder: (context, index) {
                final attachment = attachments[index];
                final imagePath = attachment.path ?? '';

                return GestureDetector(
                  onTap: () => _openImageGallery(attachments, index),
                  child: Container(
                    width: 100.w,
                    height: 100.h,
                    margin: EdgeInsets.only(right: 10.8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: imagePath.isNotEmpty
                          ? Image.network(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey[400],
                                    size: 32.r,
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.image,
                                color: Colors.grey[400],
                                size: 32.r,
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

  void _openImageGallery(List<dynamic> attachments, int initialIndex) {
    Get.to(() => ImageGalleryView(
          attachments: attachments,
          initialIndex: initialIndex,
        ));
  }

  Widget _buildDropdownSection(Map<String, dynamic> ticketData) {
    controller.initializeDropdownValues(ticketData);

    return Container(
      padding: EdgeInsets.all(14.4.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4.5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Update Ticket Details',
            style: TextStyle(
              fontSize: 14.4.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 14.4.h),
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
          SizedBox(height: 12.h),
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
          SizedBox(height: 12.h),
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
}
