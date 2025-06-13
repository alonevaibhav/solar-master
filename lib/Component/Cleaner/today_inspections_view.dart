import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solar_app/Route%20Manager/app_routes.dart';
import '../../Controller/Cleaner/today_inspections_controller.dart';
import '../../Model/Cleaner/inspection_model.dart';

class TodayInspectionsView extends GetView<TodayInspectionsController> {
  const TodayInspectionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search Area...',
                  hintStyle: TextStyle(fontSize: 14.sp),
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onChanged: controller.updateSearchQuery,
              ),

              SizedBox(height: 16.h),

              // Segmented Control Tabs
              _buildSegmentedControl(),

              SizedBox(height: 16.h),

              // Area Label
              Text(
                'Area -1',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 16.h),

              // Inspections List
              Expanded(
                child: Obx(() {
                  final inspections = controller.selectedSegment.value == 0
                      ? controller.getFilteredPendingInspections()
                      : controller.getFilteredCompletedInspections();

                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (inspections.isEmpty) {
                    return Center(
                      child: Text(
                        controller.selectedSegment.value == 0
                            ? 'No Pending Clean-ups'
                            : 'No Completed Clean-ups',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: inspections.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final inspection = inspections[index];
                      return _buildInspectionCard(inspection);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Obx(() => Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.selectedSegment.value = 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: controller.selectedSegment.value == 0
                          ?  Colors.red
                          : const Color(0xFFFF6B6B),

                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.r),
                        bottomLeft: Radius.circular(10.r),
                      ),
                      boxShadow: controller.selectedSegment.value == 0
                          ? [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.7),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        "Today's Pending\n Clean-ups",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: controller.selectedSegment.value == 0
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.selectedSegment.value = 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: controller.selectedSegment.value == 1
                          ? Colors.green
                          : Colors.green.withOpacity(0.7),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.r),
                        bottomRight: Radius.circular(10.r),
                      ),
                      boxShadow: controller.selectedSegment.value == 1
                          ? [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.7),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        "Today's Completed\n Clean-ups",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: controller.selectedSegment.value == 1
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildInspectionCard(InspectionModel inspection) {
    final isCompleted = inspection.isCompleted;
    return Container(
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green : Color(0xFFFF6B6B),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(
              isCompleted ? Icons.check_circle : Icons.pending_actions,
              color: Colors.white,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    inspection.plantName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 12.sp),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          inspection.location,
                          style:
                              TextStyle(color: Colors.white, fontSize: 10.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 35.w,
              decoration: BoxDecoration(
                color: Colors.white, // Fill color
                shape: BoxShape.circle, // Circular shape
              ),
              child:// In _buildInspectionCard() method of TodayInspectionsView
              IconButton(
                icon: Icon(Icons.chevron_right, color: Colors.red, size: 24.sp),
                onPressed: () {
                  Get.toNamed(
                      AppRoutes.cleanerTaskDetailView,
                      arguments: {
                        'taskId': inspection.id,
                        'status': inspection.isCompleted ? 'completed' : 'pending'
                      }
                  );
                },
              )
            )

          ],
        ),
      ),
    );
  }
}
