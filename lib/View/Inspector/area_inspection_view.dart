import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../API Service/Repository/fetch_cleaner_report.dart';
import '../../Component/Inspector/AreaInspectionView/plant_card.dart';
import '../../Component/Inspector/AreaInspectionView/search_bar_widget.dart';
import '../../Component/Inspector/AreaInspectionView/status_bar.dart';
import '../../Controller/Inspector/area_inspection_controller.dart';

class AreaInspectionView extends GetView<AreaInspectionController> {
  const AreaInspectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            SearchBarWidget(
              searchController: controller.searchController,
              onChanged: controller.updateSearchQuery,
              onHistoryTap: controller.showHistory,
            ),
            Obx(() => StatusTabsWidget(
                  currentTab: controller.currentTab.value,
                  onTabChanged: controller.changeTab,
                )),
            _buildAreaTitle(),
            Expanded(
              child: _buildPlantsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          Icon(Icons.location_on, size: 20.sp),
          SizedBox(width: 8.w),
          Obx(() => Text(
                controller.areaData.value?['areaName'] ?? 'Area',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPlantsList() {
    return Obx(() {
      if (controller.isLoading.value && controller.filteredPlants.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.filteredPlants.isEmpty) {
        return Center(
          child: Text(
            'No plants found',
            style: TextStyle(fontSize: 16.sp),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchAreaData,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemCount: controller.filteredPlants.length,
          itemBuilder: (context, index) {
            final plant = controller.filteredPlants[index];
            return PlantCardWidget(
              plant: plant,
              controller: controller,
            );
          },
        ),
      );
    });
  }
}
