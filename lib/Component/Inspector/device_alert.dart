import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solar_app/Controller/Inspector/plant_managment_controller.dart';
import 'alert_item.dart';

class DeviceAlert extends StatelessWidget {
  final Map<String, dynamic> plant;
  final PlantManagementController controller;

  const DeviceAlert({Key? key, required this.plant, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildAlertsSection(plant);
  }

  Widget _buildAlertsSection(Map<String, dynamic> plant) {
    final alerts = plant['alerts'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with dropdown
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Device Alerts',
              style: TextStyle(
                fontSize: 14.4.sp, // 10% smaller than 16.sp
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Obx(() => GestureDetector(
                  onTap: () => _showAlertLevelSelector(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.4.w, vertical: 7.2.h), // 10% smaller than 16.w and 8.h
                    decoration: BoxDecoration(
                      color: _getAlertLevelColor(controller.alertLevel.value),
                      borderRadius: BorderRadius.circular(7.2.r), // 10% smaller than 8.r
                    ),
                    child: Row(
                      children: [
                        Text(
                          controller.alertLevel.value,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.6.sp, // 10% smaller than 14.sp
                          ),
                        ),
                        SizedBox(width: 3.6.w), // 10% smaller than 4.w
                        Icon(Icons.arrow_drop_down, size: 18.sp), // 10% smaller than 20.sp
                      ],
                    ),
                  ),
                )),
                SizedBox(width: 7.2.w), // 10% smaller than 8.w
                IconButton(
                  icon: Icon(Icons.calendar_today, size: 18.sp), // 10% smaller than 20.sp
                  onPressed: () {
                    // Show calendar for alerts
                  },
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 14.4.h), // 10% smaller than 16.h

        // Alert list
        if (alerts.isEmpty)
          Padding(
            padding: EdgeInsets.all(14.4.w), // 10% smaller than 16.w
            child: Text('No alerts', style: TextStyle(fontSize: 12.6.sp)), // 10% smaller than 14.sp
          )
        else
          SizedBox(
            height: 180.h, // 10% smaller than 200.h
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index] as Map<String, dynamic>;
                return AlertItem(alert: alert);
              },
            ),
          ),
      ],
    );
  }

  // Helper method to get color based on alert level
  Color _getAlertLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'high':
        return Colors.red[100]!;
      case 'medium':
        return Colors.orange[100]!;
      case 'low':
        return Colors.yellow[100]!;
      default:
        return Colors.red[100]!;
    }
  }

  // Alert level selector dialog
  void _showAlertLevelSelector() {
    final List<String> levels = ['High', 'Medium', 'Low'];

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.4.r)), // 10% smaller than 16.r
        child: Container(
          padding: EdgeInsets.all(18.w), // 10% smaller than 20.w
          width: 270.w, // 10% smaller than 300.w
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Alert Level',
                style: TextStyle(
                  fontSize: 16.2.sp, // 10% smaller than 18.sp
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 18.h), // 10% smaller than 20.h

              ...levels.map((level) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 21.6.w, // 10% smaller than 24.w
                  height: 21.6.h, // 10% smaller than 24.h
                  decoration: BoxDecoration(
                    color: _getAlertLevelColor(level),
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(level, style: TextStyle(fontSize: 14.4.sp)), // 10% smaller than 16.sp
                onTap: () {
                  controller.alertLevel.value = level;
                  Get.back();
                },
              )).toList()
            ],
          ),
        ),
      ),
    );
  }
}
