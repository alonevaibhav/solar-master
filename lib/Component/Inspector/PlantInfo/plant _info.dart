// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:solar_app/Component/Inspector/PlantInfo/plant_info_card.dart';
// import '../../../Controller/Inspector/plant_info_controller.dart';
// import '../../../Services/init.dart';
//
// class PlantInfoView extends StatelessWidget {
//   const PlantInfoView({super.key});
//
//   Future<void> _handleBackPress() async {
//     try {
//       await AppInitializer.disconnectMQTT();
//       print('✅ MQTT disconnected on back press');
//     } catch (e) {
//       print('❌ Error disconnecting MQTT: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final PlantInfoController controller = Get.put(PlantInfoController());
//
//     return WillPopScope(
//       onWillPop: () async {
//         await _handleBackPress();
//         return true; // Allow the page to pop
//       },
//       child: Scaffold(
//         // backgroundColor: Colors.grey[100],
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           title: Center(
//             child: Text(
//               'All Solar Plants',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18.sp, // Responsive font
//               ),
//             ),
//           ),
//         ),
//         body: Obx(() {
//           if (controller.isLoading.value) {
//             return Center(
//               child: SizedBox(
//                 width: 40.w,
//                 height: 40.w,
//                 child: const CircularProgressIndicator(),
//               ),
//             );
//           }
//
//           if (controller.errorMessage.value.isNotEmpty) {
//             return Center(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Error: ${controller.errorMessage.value}',
//                       style: TextStyle(color: Colors.red, fontSize: 14.sp),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 16.h),
//                     SizedBox(
//                       width: 120.w,
//                       height: 40.h,
//                       child: ElevatedButton(
//                         onPressed: controller.fetchPlants,
//                         child: Text('Retry', style: TextStyle(fontSize: 14.sp)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//
//           if (controller.plants.isEmpty) {
//             return Center(
//               child: Text(
//                 'No plants assigned yet',
//                 style: TextStyle(fontSize: 16.sp),
//               ),
//             );
//           }
//
//           return RefreshIndicator(
//             onRefresh: controller.fetchPlants,
//             child: ListView.builder(
//               padding: EdgeInsets.all(16.w),
//               itemCount: controller.plants.length,
//               itemBuilder: (context, index) {
//                 final plant = controller.plants[index];
//                 return Obx(() => PlantInfoCard(
//                   plant: plant,
//                   isLoading: controller.loadingPlantId.value == plant['id'].toString(),
//                   onTap: controller.isNavigating.value
//                       ? null // Disable all taps when any plant is loading
//                       : () => controller.viewPlantDetails(plant['id']),
//                 ));
//               },
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_app/Component/Inspector/PlantInfo/plant_info_card.dart';
import '../../../Controller/Inspector/plant_info_controller.dart';
import '../../../Services/init.dart';

class PlantInfoView extends StatelessWidget {
  const PlantInfoView({super.key});

  Future<void> _handleBackPress() async {
    try {
      await AppInitializer.disconnectMQTT();
      print('✅ MQTT disconnected on back press');
    } catch (e) {
      print('❌ Error disconnecting MQTT: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final PlantInfoController controller = Get.put(PlantInfoController());

    return WillPopScope(
      onWillPop: () async {
        await _handleBackPress();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'All Solar Plants',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Search Bar Section
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
              child: Row(
                children: [
                  // Search Bar
                  Expanded(
                    child: TextField(
                      onChanged: controller.updateSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Search by plant name...',
                        hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.search, size: 20.sp, color: Colors.grey[600]),
                        suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                            ? IconButton(
                          icon: Icon(Icons.clear, size: 20.sp),
                          onPressed: controller.clearSearch,
                        )
                            : const SizedBox.shrink()),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Filter Button
                  Obx(() => GestureDetector(
                    onTap: controller.toggleFilterMenu,
                    child: Container(
                      height: 48.h,
                      width: 48.w,
                      decoration: BoxDecoration(
                        color: controller.activeFilter.value != 'active'
                            ? Colors.blue
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.filter_list,
                            color: controller.activeFilter.value != 'active'
                                ? Colors.white
                                : Colors.grey[700],
                            size: 24.sp,
                          ),
                          if (controller.activeFilter.value != 'active')
                            Positioned(
                              top: 8.h,
                              right: 8.w,
                              child: Container(
                                width: 8.w,
                                height: 8.h,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),

            // Filter Dropdown Menu
            Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: controller.showFilterMenu.value ? null : 0,
              child: controller.showFilterMenu.value
                  ? Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(height: 1.h, thickness: 1, color: Colors.grey[300]),
                    SizedBox(height: 8.h),
                    Text(
                      'Filter by Status',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Active Filter Option
                    _buildFilterOption(
                      controller: controller,
                      value: 'active',
                      title: 'Active Plants',
                      icon: Icons.check_circle,
                      iconColor: Colors.green,
                      count: controller.activePlantCount,
                    ),

                    // Inactive Filter Option
                    _buildFilterOption(
                      controller: controller,
                      value: 'inactive',
                      title: 'Inactive Plants',
                      icon: Icons.cancel,
                      iconColor: Colors.red,
                      count: controller.inactivePlantCount,
                    ),

                    // All Filter Option
                    _buildFilterOption(
                      controller: controller,
                      value: 'all',
                      title: 'All Plants',
                      icon: Icons.list,
                      iconColor: Colors.blue,
                      count: controller.plants.length,
                    ),

                    SizedBox(height: 8.h),
                  ],
                ),
              )
                  : const SizedBox.shrink(),
            )),

            // Divider
            Divider(height: 1.h, thickness: 1, color: Colors.grey[300]),

            // Plant Count Chip
            // Container(
            //   color: Colors.white,
            //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            //   child: Row(
            //     children: [
            //       Obx(() => Container(
            //         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            //         decoration: BoxDecoration(
            //           color: Colors.grey[200],
            //           borderRadius: BorderRadius.circular(20.r),
            //         ),
            //         child: Row(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Icon(
            //               controller.activeFilter.value == 'active'
            //                   ? Icons.check_circle
            //                   : controller.activeFilter.value == 'inactive'
            //                   ? Icons.cancel
            //                   : Icons.list,
            //               size: 14.sp,
            //               color: controller.activeFilter.value == 'active'
            //                   ? Colors.green
            //                   : controller.activeFilter.value == 'inactive'
            //                   ? Colors.red
            //                   : Colors.blue,
            //             ),
            //             SizedBox(width: 6.w),
            //             Text(
            //               '${controller.filteredPlants.length} plant${controller.filteredPlants.length != 1 ? 's' : ''}',
            //               style: TextStyle(
            //                 fontSize: 12.sp,
            //                 color: Colors.grey[700],
            //                 fontWeight: FontWeight.w600,
            //               ),
            //             ),
            //           ],
            //         ),
            //       )),
            //     ],
            //   ),
            // ),

            // Divider(height: 1.h, thickness: 1, color: Colors.grey[300]),

            // Plants List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: SizedBox(
                      width: 40.w,
                      height: 40.w,
                      child: const CircularProgressIndicator(),
                    ),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
                          SizedBox(height: 16.h),
                          Text(
                            'Error: ${controller.errorMessage.value}',
                            style: TextStyle(color: Colors.red, fontSize: 14.sp),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.h),
                          SizedBox(
                            width: 120.w,
                            height: 40.h,
                            child: ElevatedButton(
                              onPressed: controller.fetchPlants,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Text('Retry', style: TextStyle(fontSize: 14.sp)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (controller.filteredPlants.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          controller.searchQuery.value.isNotEmpty
                              ? Icons.search_off
                              : Icons.energy_savings_leaf_outlined,
                          size: 64.sp,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          controller.searchQuery.value.isNotEmpty
                              ? 'No plants found matching\n"${controller.searchQuery.value}"'
                              : controller.activeFilter.value == 'active'
                              ? 'No active plants found'
                              : controller.activeFilter.value == 'inactive'
                              ? 'No inactive plants found'
                              : 'No plants assigned yet',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (controller.searchQuery.value.isNotEmpty || controller.activeFilter.value != 'active') ...[
                          SizedBox(height: 12.h),
                          TextButton(
                            onPressed: () {
                              controller.clearSearch();
                              if (controller.activeFilter.value != 'active') {
                                controller.setActiveFilter('active');
                              }
                            },
                            child: Text(
                              'Clear filters',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchPlants,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: controller.filteredPlants.length,
                    itemBuilder: (context, index) {
                      final plant = controller.filteredPlants[index];
                      return Obx(() => PlantInfoCard(
                        plant: plant,
                        isLoading: controller.loadingPlantId.value == plant['id'].toString(),
                        onTap: controller.isNavigating.value
                            ? null
                            : () => controller.viewPlantDetails(plant['id']),
                      ));
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption({
    required PlantInfoController controller,
    required String value,
    required String title,
    required IconData icon,
    required Color iconColor,
    required int count,
  }) {
    return Obx(() => InkWell(
      onTap: () => controller.setActiveFilter(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        margin: EdgeInsets.only(bottom: 4.h),
        decoration: BoxDecoration(
          color: controller.activeFilter.value == value
              ? Colors.blue.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: controller.activeFilter.value == value
                ? Colors.blue
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: iconColor),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: controller.activeFilter.value == value
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: controller.activeFilter.value == value
                      ? Colors.blue
                      : Colors.grey[800],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: controller.activeFilter.value == value
                    ? Colors.blue
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: controller.activeFilter.value == value
                      ? Colors.white
                      : Colors.grey[700],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              controller.activeFilter.value == value
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 20.sp,
              color: controller.activeFilter.value == value
                  ? Colors.blue
                  : Colors.grey[400],
            ),
          ],
        ),
      ),
    ));
  }
}