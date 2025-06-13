
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solar_app/Controller/Cleaner/cleanup_schedule_controller.dart';
import '../../Component/Cleaner/TodayCleaning/schedule_card.dart';

class CleanerDashboardView extends StatelessWidget {
  const CleanerDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller =Get.put(CleanupScheduleController());

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
            color: isSelected ? Colors.black : backgroundColor,
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
              ...areaSchedules.map((schedule) => ScheduleCard(controller: controller, schedule: schedule)).toList(),
              SizedBox(height: 19.2.h),
            ],
          );
        },
      ),
    );
  }
}
