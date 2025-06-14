import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Controller/Cleaner/cleanup_schedule_controller.dart';

class CleanupScheduleView extends StatelessWidget {
  const CleanupScheduleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CleanupScheduleController>();
    // log(  controller.errorMessage.value as num);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: EdgeInsets.all(15.36.w),
              color: Colors.white,
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.updateSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search Area...',
                  hintStyle: TextStyle(
                    fontSize: 13.44.sp,
                    color: Colors.grey[600],
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                    size: 19.2.w,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8F8F8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.68.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15.36.w,
                    vertical: 11.52.h,
                  ),
                ),
              ),
            ),

            // Tab Buttons
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.36.w, vertical: 11.52.h),
              color: Colors.white,
              child: Obx(() => Row(
                children: [
                  Expanded(
                    child: _buildTabButton(
                      controller: controller,
                      title: "Today's Pending\nClean-ups",
                      isSelected: controller.selectedTab.value == 0,
                      onTap: () => controller.switchTab(0),
                      backgroundColor: const Color(0xFFFF6B6B),
                    ),
                  ),
                  SizedBox(width: 11.52.w),
                  Expanded(
                    child: _buildTabButton(
                      controller: controller,
                      title: "Today's Completed\nClean-ups",
                      isSelected: controller.selectedTab.value == 1,
                      onTap: () => controller.switchTab(1),
                      backgroundColor: const Color(0xFF5EDE60),
                    ),
                  ),
                ],
              )),
            ),

            // Content Area
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  print('Error: ${controller.errorMessage.value}');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 46.08.w,
                          color: Colors.red,
                        ),
                        SizedBox(height: 15.36.h),

                        Text(
                          controller.errorMessage.value,
                          style: TextStyle(
                            fontSize: 13.44.sp,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 15.36.h),
                        ElevatedButton(
                          onPressed: controller.refreshSchedules,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return _buildSchedulesList(controller);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required CleanupScheduleController controller,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required Color backgroundColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 11.52.h, horizontal: 15.36.w),
        decoration: BoxDecoration(
          color: isSelected ? backgroundColor : backgroundColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(7.68.r),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11.52.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : backgroundColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSchedulesList(CleanupScheduleController controller) {
    final schedulesByArea = controller.getSchedulesByArea();

    if (schedulesByArea.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cleaning_services_outlined,
              size: 46.08.w,
              color: Colors.grey[400],
            ),
            SizedBox(height: 15.36.h),
            Text(
              controller.selectedTab.value == 0
                  ? 'No pending clean-ups found'
                  : 'No completed clean-ups found',
              style: TextStyle(
                fontSize: 15.36.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refreshSchedules,
      child: ListView.builder(
        padding: EdgeInsets.all(15.36.w),
        itemCount: schedulesByArea.length,
        itemBuilder: (context, index) {
          final areaName = schedulesByArea.keys.elementAt(index);
          final areaSchedules = schedulesByArea[areaName]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 11.52.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 17.28.w,
                      color: Colors.grey[700],
                    ),
                    SizedBox(width: 3.84.w),
                    Text(
                      areaName,
                      style: TextStyle(
                        fontSize: 15.36.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              ...areaSchedules.map((schedule) => _buildScheduleCard(controller, schedule)).toList(),
              SizedBox(height: 19.2.h),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScheduleCard(CleanupScheduleController controller, Map<String, dynamic> schedule) {


    // Access the status from reportController
    var reportStatus = controller.todayReport.isNotEmpty
        ? controller.todayReport[0]['id'] ?? '1'
        : '1';

    final taskId = schedule['id'] as int;
    final status = controller.getTaskStatus(taskId);
    final eta = controller.getTaskETA(taskId);




    Color statusColor;
    String statusText;

    switch (status) {
      case 'ongoing':
        statusColor = const Color(0xFF427FBD);
        statusText = 'Cleaning Ongoing';
        break;
      case 'completed':
        statusColor = const Color(0xFF4DE049);
        statusText = 'Cleaning Complete';
        break;
      default:
        statusColor = const Color(0xFFFF6B6B);
        statusText = 'Cleaning Pending';
    }

    return Container(
      height: 100.h,
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
            onTap: () async {
              controller.selectTask(schedule); // this stores the selected task
              final scheduleId = schedule['id']; // or get from wherever it's stored
              await controller.fetchTodayReport(scheduleId); // call your async method
            },

            child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Icon(
                        status == 'completed'
                            ? Icons.check_circle
                            : status == 'ongoing'
                            ? Icons.cleaning_services
                            : Icons.schedule,
                        color: Colors.white,
                        size: 20.w,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${schedule['plant_location'] ?? 'Plant Location'}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Location: ${schedule['plant_location'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            'Panels: ${schedule['plant_total_panels'] ?? 'N/A'} | ${schedule['plant_capacity_w'] ?? 'N/A'}kW',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (eta != null)
                Positioned(
                  bottom: 8.h,
                  right: 8.w,
                  child: Text(
                    'ETA: ${controller.formatETA(eta)}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

}
