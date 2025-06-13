import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Controller/Cleaner/today_inspections_controller.dart';
import '../../Model/Cleaner/inspection_model.dart';

class TaskDetailView extends GetView<TodayInspectionsController> {
  const TaskDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller with the task ID from arguments
    if (Get.arguments != null) {
      final args = Get.arguments as Map<String, dynamic>;
      if (args.containsKey('taskId')) {controller.currentTaskId.value = args['taskId'];
      }
      if (args.containsKey('status')) {controller.taskStatus.value = args['status'];
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final inspection = controller.getCurrentInspection();

          if (controller.isLoading.value || inspection == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Header
              _buildHeader(),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats Section
                        _buildStatsSection(inspection),

                        SizedBox(height: 16.h),

                        // Owner Information
                        _buildOwnerInfoCard(inspection),

                        SizedBox(height: 16.h),

                        // Plant Information
                        _buildPlantInfoCard(inspection),

                        SizedBox(height: 16.h),

                        // Panel Valves
                        _buildPanelValves(inspection),

                        SizedBox(height: 16.h),

                        // Action Button - Now includes the timer functionality
                        _buildActionButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          IconButton(
            icon: Icon(Icons.arrow_back, size: 24.sp),
            onPressed: () => Get.back(),
          ),

          // Page Title
          Text(
            'Task Details',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Refresh Button
          IconButton(
            icon: Icon(Icons.headphones, size: 30.sp),
            onPressed: null,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(InspectionModel inspection) {
    return Row(
      children: [
        // Clean panels (green)
        Container(
          width: 80.w,
          height: 43.h,
          decoration: BoxDecoration(
            color: const Color(0xFF8CD9B0),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6.r),
              bottomLeft: Radius.circular(6.r),
            ),
          ),
          child: Center(
            child: Text(
              '10',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Dirty panels (red)
        Container(
          width: 80.w,
          height: 43.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF98B8B),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(6.r),
              bottomRight: Radius.circular(6.r),
            ),
          ),
          child: Center(
            child: Text(
              '20',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        SizedBox(width: 10.w),

        // Total panels
        Container(
          height: 43.h,
          padding: EdgeInsets.symmetric(horizontal: 13.w),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 10.sp,
                ),
              ),
              Text(
                '30 Panels',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOwnerInfoCard(InspectionModel inspection) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Owner Avatar
          CircleAvatar(
            radius: 20.r,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.grey[600], size: 24.sp),
          ),

          SizedBox(width: 12.w),

          // Owner Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Owner Info',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Phone: ${inspection.ownerPhone}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Call Button
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.call, color: Colors.white, size: 18.sp),
              onPressed: () => controller.callOwner(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantInfoCard(InspectionModel inspection) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plant Info Row
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: Colors.grey[100],
                child: Icon(Icons.home, color: Colors.grey[400], size: 24.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inspection.plantName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Auto Clean: ${inspection.autoCleanTime}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Obx(() {
                      Color statusColor;
                      String statusText;
                      switch (controller.taskStatus.value) {
                        case 'pending':
                          statusColor = Colors.red;
                          statusText = 'Cleaning Pending';
                          break;
                        case 'inProgress':
                          statusColor = Colors.orange;
                          statusText = 'Cleaning Ongoing';
                          break;
                        case 'completed':
                          statusColor = Colors.green;
                          statusText = 'Cleaning Complete';
                          break;
                        default:
                          statusColor = Colors.grey;
                          statusText = 'Unknown Status';
                      }
                      return Row(
                        children: [
                          Text(
                            'Status: ',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Injected Location Container (original sizing)
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.grey[200], // was Colors.white
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        inspection.location,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Container(
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.location_on,
                            color: Colors.white, size: 18.sp),
                        onPressed: () => controller.openLocation(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanelValves(InspectionModel inspection) {
    return Column(
      children:
          inspection.valves.map((valve) => _buildValveItem(valve)).toList(),
    );
  }

  Widget _buildValveItem(String valveName) {
    // Use a local reactive state to track the switch state
    final isActive = false.obs;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            valveName,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),

          // Only show switch if not completed
          if (controller.taskStatus.value != 'completed')
            Obx(() => Switch(
                  value: isActive.value,
                  onChanged: (newValue) {
                    isActive.value = newValue;
                    controller.toggleValve(valveName, newValue);
                  },
                  activeColor: Colors.green,
                  activeTrackColor: Colors.green.withOpacity(0.5),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey.shade300,
                )),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    // Only show button for pending or in progress tasks
    if (controller.taskStatus.value == 'completed') {
      return SizedBox.shrink();
    }

    return Obx(() {
      // If task is in progress, show timer button
      if (controller.taskStatus.value == 'inProgress') {
        return Container(
          width: double.infinity,
          height: 50.h,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: () {
                // Show confirmation dialog
                Get.dialog(
                  AlertDialog(
                    title: Text(
                      'End Task',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      'Are you sure you want to end the task?',
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(), // Close dialog
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back(); // Close dialog
                          controller.completeTask(); // Complete the task
                        },
                        child: Text(
                          'End Task',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.timer, color: Colors.white, size: 18.sp),
                        SizedBox(width: 8.w),
                        Text(
                          '${controller.remainingMinutes.value} Minutes Remaining',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.cancel, // the cancel icon
                      size: 30.sp, // adjust size as needed
                      color: Colors.white, // keep the white color
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      // If task is pending, show enable maintenance mode button
      else {
        return Container(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: () => controller.enableMaintenanceMode(),
            child: Text(
              'Enable Maintenance Mode',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    });
  }
}
