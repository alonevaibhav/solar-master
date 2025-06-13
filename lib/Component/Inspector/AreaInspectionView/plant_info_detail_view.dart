import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solar_app/Component/Inspector/AreaInspectionView/panel_status_grid.dart';
import '../../../Controller/Inspector/area_inspection_controller.dart';
import 'cleaner_info_card.dart';
import 'inspection_card.dart';


class PlantInspectionDetailView extends StatelessWidget {
  final AreaInspectionController controller = Get.find<AreaInspectionController>();
  final String plantId;

  PlantInspectionDetailView({Key? key, required this.plantId}) : super(key: key) {
    // Load plant detail data when view is created
    controller.loadPlantDetail(plantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Inspection Plant Detail',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () => controller.fetchAreaData(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              'Error: ${controller.errorMessage.value}',
              style: TextStyle(color: Colors.red, fontSize: 16.sp),
            ),
          );
        }

        // Get plant data from controller
        final Map<String, dynamic>? plantData = controller.plantDetail.value;

        if (plantData == null) {
          return const Center(child: Text('Plant data not found'));
        }

        // Get panel data
        final int greenPanels = plantData['greenPanels'] ?? 20;
        final int redPanels = plantData['redPanels'] ?? 7;
        final int totalPanels = plantData['totalPanels'] ?? (greenPanels + redPanels);

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                // Status indicator row
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Online',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Panel count indicators
                Row(
                  children: [
                    SizedBox(width: 16.w),
                    // Total panel count
                    Container(
                      padding: EdgeInsets.only(left: 16.r, right: 16.r, top: 8.r, bottom: 8.r),
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Light grey background
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12.sp,
                            ),
                          ),
                          Text(
                            '$totalPanels Panels',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),
                    // Solar panel icon
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.solar_power,
                        size: 24.r,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Plant info card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Plant name
                      Text(
                        plantData['name'] ?? 'Unknown Plant',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Auto clean time
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14.sp,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Auto Clean: ',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            TextSpan(
                              text: plantData['time'] ?? 'hh:mm',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Status indicator
                      Row(
                        children: [
                          Text(
                            'Status: ',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            plantData['status'] ?? 'Inspection Pending',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      // Location info
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Light grey background
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    plantData['location'] ?? 'Unknown Location',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.near_me,
                                  color: Colors.blue,
                                  size: 20.r,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )

                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                CleanerInfoCard(
                  name: plantData['cleanerName'] ?? 'Cleaner Name',
                  phone: '+91 8001372561',
                ),
                SizedBox(height: 8.h),
                // Inspection form
                InspectionForm(
                  plantId: plantId,
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      }),
    );
  }
}