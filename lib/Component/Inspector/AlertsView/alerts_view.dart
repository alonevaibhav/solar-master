import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Controller/Inspector/alerts_controller.dart';
import 'alert_card.dart';

class AlertsView extends StatelessWidget {
  const AlertsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the controller using GetX
    final controller = Get.find<AlertsController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 16.h),

              // Search Bar
              _buildSearchBar(controller,context),

              SizedBox(height: 16.h),

              // Priority Legend
              _buildPriorityLegend(),

              SizedBox(height: 16.h),

              // Area Heading
              _buildAreaHeading(controller),

              SizedBox(height: 16.h),

              // Alerts List
              Expanded(
                child: _buildAlertsList(controller),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(AlertsController controller,context) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: controller.updateSearch,
              decoration: InputDecoration(
                hintText: 'Search Area...',
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality handled by onChanged
              FocusScope.of(context).unfocus();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityLegend() {
    final controller = Get.find<AlertsController>();

    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          // High Priority Section - Red
          Expanded(
            child: Obx(() => GestureDetector(
              onTap: () => controller.setFilter('high'),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5252), // Red for high priority
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    bottomLeft: Radius.circular(20.r),
                  ),
                  // Add highlight when selected
                  border: controller.activeFilter.value == 'high'
                      ? Border.all(color: Colors.white, width: 2)
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  'High Priority\nAlert',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )),
          ),
          // Low Priority Section - Yellow
          Expanded(
            child: Obx(() => GestureDetector(
              onTap: () => controller.setFilter('low'),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA726), // Yellow/Orange for low priority
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                  // Add highlight when selected
                  border: controller.activeFilter.value == 'low'
                      ? Border.all(color: Colors.white, width: 2)
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  'Low Priority\nAlert',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaHeading(AlertsController controller) {
    return Row(
      children: [
        Icon(Icons.navigation, size: 24.sp),
        SizedBox(width: 8.w),
        Obx(() => Text(
          controller.selectedArea.value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        )),
        const Spacer(),
        // Show all alerts button
        TextButton(
          onPressed: () => controller.setFilter('all'),
          child: Obx(() => Text(
            'All Alerts',
            style: TextStyle(
              color: controller.activeFilter.value == 'all'
                  ? Colors.blue
                  : Colors.grey,
              fontWeight: controller.activeFilter.value == 'all'
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildAlertsList(AlertsController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.value != null) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.errorMessage.value ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: controller.refreshAlerts,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      final filteredAlerts = controller.filteredAlertsList.value ?? [];

      if (filteredAlerts.isEmpty) {
        return RefreshIndicator(
          onRefresh: controller.refreshAlerts,
          child: ListView(
            children: [
              SizedBox(height: 150.h),
              Center(
                child: Text(
                  'No alerts found',
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshAlerts,
        child: ListView.builder(
          itemCount: filteredAlerts.length,
          itemBuilder: (context, index) {
            final alert = filteredAlerts[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: AlertCard(
                alertData: alert,
                onTap: () => controller.viewAlertDetails(alert['id']),
                onMapTap: () => controller.viewLocationOnMap(alert['coordinates'] as Map<String, dynamic>),
              ),
            );
          },
        ),
      );
    });
  }

}