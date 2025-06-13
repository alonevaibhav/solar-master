import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solar_app/Component/Inspector/schedule_item.dart';
import '../../Controller/Inspector/plant_managment_controller.dart';
import 'alert_item.dart';
import 'auto_clean_schedule.dart';
import 'device_alert.dart';

class PlantDetailsView extends GetView<PlantManagementController> {
  const PlantDetailsView({Key? key}) : super(key: key);

  static const double scaleFactor = 0.9;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Obx(() => Text(
            controller.selectedPlant.value?['name'] ?? 'Abc Plant Name',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp * scaleFactor,
            ),
          )),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp * scaleFactor),
            onPressed: () => Get.back(),
          ),
        ),
        body: Obx(() {
          final plant = controller.selectedPlant.value;
          if (plant == null) {
            return Center(
              child: Text(
                'No plant selected',
                style: TextStyle(fontSize: 16.sp * scaleFactor),
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.w * scaleFactor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsCard(plant),
                  SizedBox(height: 16.h * scaleFactor),
                  AutoCleanSchedule(plant: plant, controller: controller),
                  SizedBox(height: 16.h * scaleFactor),
                  DeviceAlert(plant: plant, controller: controller),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatsCard(Map<String, dynamic> plant) {
    final stats = plant['stats'] as Map<String, dynamic>?;

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r * scaleFactor),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w * scaleFactor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 50.w * scaleFactor,
                  height: 50.h * scaleFactor,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8CD9B0),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6.r * scaleFactor),
                      bottomLeft: Radius.circular(6.r * scaleFactor),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '10',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp * scaleFactor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 50.w * scaleFactor,
                  height: 50.h * scaleFactor,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF98B8B),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(6.r * scaleFactor),
                      bottomRight: Radius.circular(6.r * scaleFactor),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '20',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp * scaleFactor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.grid_view, size: 24.sp * scaleFactor),
                SizedBox(width: 8.w * scaleFactor),
                Text(
                  '${plant['panels'] ?? 32}',
                  style: TextStyle(
                    fontSize: 16.sp * scaleFactor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' Panels',
                  style: TextStyle(
                    fontSize: 16.sp * scaleFactor,
                  ),
                ),
              ],
            ),
            if (stats != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w * scaleFactor),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r * scaleFactor),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w * scaleFactor,
                        vertical: 4.h * scaleFactor,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red[200],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6.r * scaleFactor),
                          topRight: Radius.circular(6.r * scaleFactor),
                        ),
                      ),
                      child: Text(
                        '${stats['value1'] ?? 10}',
                        style: TextStyle(
                          fontSize: 14.sp * scaleFactor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w * scaleFactor,
                        vertical: 4.h * scaleFactor,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[200],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(6.r * scaleFactor),
                          bottomRight: Radius.circular(6.r * scaleFactor),
                        ),
                      ),
                      child: Text(
                        '${stats['value2'] ?? 30}',
                        style: TextStyle(
                          fontSize: 14.sp * scaleFactor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
