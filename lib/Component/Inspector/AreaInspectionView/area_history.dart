import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Controller/Inspector/area_inspection_controller.dart';

class AreaHistoryView extends StatelessWidget {
  const AreaHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AreaInspectionController controller = Get.find<AreaInspectionController>();
    final today = DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 60.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade100,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black87, size: 20.r),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        title: Text(
          "Task History",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade100,
              child: IconButton(
                icon: Icon(Icons.filter_alt_outlined,
                    color: Colors.black54, size: 20.r),
                onPressed: () {
                  // filter action
                },
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
          ));
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48.r, color: Colors.redAccent),
                SizedBox(height: 16.h),
                Text(
                  'Error: ${controller.errorMessage.value}',
                  style: TextStyle(color: Colors.redAccent, fontSize: 14.sp),
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: controller.fetchAreaData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text('Retry', style: TextStyle(fontSize: 14.sp)),
                ),
              ],
            ),
          );
        }

        final plants = controller.allPlants;
        if (plants.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64.r, color: Colors.grey.shade400),
                SizedBox(height: 16.h),
                Text(
                  'No history available',
                  style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Completed tasks will appear here',
                  style:
                      TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: const Color(0xFF3B82F6),
          onRefresh: controller.fetchAreaData,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
            itemCount: plants.length,
            separatorBuilder: (_, __) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final plant = plants[index];
              final time = plant['time'] ?? '';
              final panels = plant['totalPanels'] ?? 0;
              final dateGroup = DateFormat('yyyy-MM-dd')
                  .format(today.subtract(Duration(days: index)));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index == 0 ||
                      (DateFormat('yyyy-MM-dd').format(
                              today.subtract(Duration(days: index - 1))) !=
                          dateGroup))
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.h, left: 8.w),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              DateFormat('EEE, MMM d').format(
                                  today.subtract(Duration(days: index))),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                              indent: 12.w,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Colors.white,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.r),
                        // onTap: () {
                        //   controller.loadPlantDetail(plant['id']);
                        //   Get.toNamed('/inspector/inspectorPlantDetails',
                        //       arguments: {'plant': plant});
                        // },
                        child: Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPlantAvatar(plant),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      plant['name'] ?? 'Unnamed Plant',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on,
                                            size: 14.r,
                                            color: Colors.grey[600]),
                                        SizedBox(width: 4.w),
                                        Expanded(
                                          child: Text(
                                            plant['location'] ??
                                                'Unknown Location',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.grey[600]),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 14.h),
                                    Row(
                                      children: [
                                        _InfoChip(
                                          icon:
                                              Icons.access_time_filled_rounded,
                                          label: time,
                                          color: const Color(0xFF3B82F6),
                                        ),
                                        SizedBox(width: 12.w),
                                        _InfoChip(
                                          icon: Icons.grid_view_rounded,
                                          label: '$panels Panels',
                                          color: const Color(0xFF10B981),
                                        ),
                                      ],
                                    ),
                                  ],
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
            },
          ),
        );
      }),
    );
  }

  Widget _buildPlantAvatar(Map<String, dynamic> plant) {
    // You can create different avatar styles based on plant type or status
    return Container(
      width: 56.w,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(Icons.solar_power_rounded, color: Colors.white, size: 30.r),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14.r, color: color),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
                fontSize: 12.sp, fontWeight: FontWeight.w500, color: color),
          ),
        ],
      ),
    );
  }
}
