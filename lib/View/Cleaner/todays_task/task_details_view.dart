import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Controller/Cleaner/cleanup_schedule_controller.dart';

class TaskDetailsView extends StatelessWidget {
  const TaskDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        final taskData = controller.selectedTaskData.value;
        if (taskData == null) {
          return const Center(child: Text('No task selected'));
        }

        final taskId = taskData['id'] as int;
        final status = controller.getTaskStatus(taskId);
        final eta = controller.getTaskETA(taskId);

        return SingleChildScrollView(
          child: Column(
            children: [
              // Status Header
              _buildStatusHeader(taskData, status, eta, controller),

              SizedBox(height: 16 * 0.9.h),

              // Owner Info Card
              _buildOwnerInfoCard(taskData),

              SizedBox(height: 16 * 0.9.h),

              // Plant Details Card
              _buildPlantDetailsCard(taskData),

              SizedBox(height: 16 * 0.9.h),

              // Panel Information
              _buildPanelInformation(),

              SizedBox(height: 100 * 0.9.h), // Space for bottom button
            ],
          ),
        );
      }),
      bottomNavigationBar: _buildBottomButton(controller),
    );
  }

  Widget _buildStatusHeader(Map<String, dynamic> taskData, String status, int? eta, CleanupScheduleController controller) {
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
          // Status Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12 * 0.9.w, vertical: 6 * 0.9.h),
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
            padding: EdgeInsets.symmetric(horizontal: 12 * 0.9.w, vertical: 6 * 0.9.h),
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

          // Solar Panel Icon
          Icon(
            Icons.solar_power,
            size: 32 * 0.9.w,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerInfoCard(Map<String, dynamic> taskData) {
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
              // Profile Avatar
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

              // Call Button
              GestureDetector(
                onTap: () => _makePhoneCall('+918903373561'),
                child: Container(
                  padding: EdgeInsets.all(12 * 0.9.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF),
                    borderRadius: BorderRadius.circular(12 * 0.9.r),
                  ),
                  child: Icon(
                    Icons.phone,
                    color: Colors.white,
                    size: 20 * 0.9.w,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlantDetailsCard(Map<String, dynamic> taskData) {
    final taskId = taskData['id'] as int;
    final controller = Get.find<CleanupScheduleController>();
    final status = controller.getTaskStatus(taskId);

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
            '${taskData['plant_location'] ?? 'Abc Plant Name'}',
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

          // Location Info
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
              GestureDetector(
                onTap: () => _openLocation(taskData),
                child: Container(
                  padding: EdgeInsets.all(8 * 0.9.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF),
                    borderRadius: BorderRadius.circular(8 * 0.9.r),
                  ),
                  child: Icon(
                    Icons.navigation,
                    color: Colors.white,
                    size: 16 * 0.9.w,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 4 * 0.9.h),

          Text(
            '${taskData['plant_location'] ?? 'A-2-1 Pune Mahanagar(411021)'}',
            style: TextStyle(
              fontSize: 12 * 0.9.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanelInformation() {
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
        children: [
          _buildPanelRow('Panel Valve - 1'),
          _buildPanelRow('Panel Valve - 2'),
          _buildPanelRow('Panel Valve - 3'),
          _buildPanelRow('Panel Valve - 4'),
        ],
      ),
    );
  }

  Widget _buildPanelRow(String panelName) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12 * 0.9.h),
      child: Row(
        children: [
          Text(
            panelName,
            style: TextStyle(
              fontSize: 14 * 0.9.sp,
              color: Colors.grey[800],
            ),
          ),
          const Spacer(),
          Container(
            width: 24 * 0.9.w,
            height: 24 * 0.9.w,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12 * 0.9.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(CleanupScheduleController controller) {
    return Obx(() {
      final taskData = controller.selectedTaskData.value;
      if (taskData == null) return const SizedBox.shrink();

      final taskId = taskData['id'] as int;
      final status = controller.getTaskStatus(taskId);
      final eta = controller.getTaskETA(taskId);

      if (status == 'ongoing' && eta != null) {
        // Show ETA countdown for ongoing tasks
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
                      onTap: () => controller.completeTask(taskId),
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

      // Enable Maintenance Mode button for pending tasks
      return Container(
        padding: EdgeInsets.all(16 * 0.9.w),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.startTask(taskId),
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
    });
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

  void _makePhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar(
        'Error',
        'Could not make phone call',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  void _openLocation(Map<String, dynamic> taskData) {
    // For now, just show a snackbar
    Get.snackbar(
      'Location',
      'Opening location: ${taskData['plant_location']}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.1),
      colorText: Colors.blue,
    );
  }
}
