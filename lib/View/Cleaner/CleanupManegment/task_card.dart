import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'cleanup_controller.dart';

class TaskCard extends StatelessWidget {
  final CleaningManagementController controller;
  final Map<String, dynamic> task;
  final String status;

  const TaskCard({
    Key? key,
    required this.controller,
    required this.task,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color cardBackgroundColor;
    Color statusBadgeColor;
    Color borderColor;
    Color accentColor;

    switch (status.toLowerCase()) {
      case 'pending':
        cardBackgroundColor = Colors.orange.shade50;
        statusBadgeColor = Colors.orange.shade100;
        borderColor = Colors.orange.shade300;
        accentColor = Colors.orange.shade700;
        break;
      case 'cleaning':
      case 'ongoing':
        cardBackgroundColor = Colors.blue.shade50;
        statusBadgeColor = Colors.blue.shade100;
        borderColor = Colors.blue.shade300;
        accentColor = Colors.blue.shade700;
        break;
      case 'done':
        cardBackgroundColor = Colors.green.shade50;
        statusBadgeColor = Colors.green.shade100;
        borderColor = Colors.green.shade300;
        accentColor = Colors.green.shade700;
        break;
      default:
        cardBackgroundColor = Colors.white;
        statusBadgeColor = Colors.grey.shade200;
        borderColor = Colors.grey.shade300;
        accentColor = Colors.grey.shade700;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            controller.fetchReportData(task['id']);
            controller.navigateToTaskDetails(task);
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row - Time and Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: accentColor,
                            size: 12.w,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            controller.formatTime(
                                task['cleaning_start_time'] ?? '08:00:00'),
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: statusBadgeColor,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: accentColor, width: 1),
                      ),
                      child: Text(
                        status == 'pending'
                            ? 'Pending'
                            : status == 'ongoing' || status == 'cleaning'
                            ? 'In Progress'
                            : status == 'done'
                            ? 'Completed'
                            : status.toUpperCase(),
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                // Plant Name
                Text(
                  task['plant_name'] ?? 'Unknown Plant',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),

                SizedBox(height: 6.h),

                // Complete Address
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: accentColor,
                      size: 12.w,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        _buildFullAddress(),
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 10.sp,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8.h),

                // Divider
                Divider(
                  color: borderColor,
                  thickness: 0.8,
                  height: 1,
                ),

                SizedBox(height: 8.h),

                // Plant Specifications
                Row(
                  children: [
                    Expanded(
                      child: _buildSpecItem(
                        icon: Icons.solar_power_rounded,
                        label: 'Panels',
                        value: '${task['plant_total_panels'] ?? 0}',
                        accentColor: accentColor,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 28.h,
                      color: borderColor,
                    ),
                    Expanded(
                      child: _buildSpecItem(
                        icon: Icons.square_foot_rounded,
                        label: 'Area',
                        value: '${task['plant_area_squrM'] ?? 0}m²',
                        accentColor: accentColor,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 28.h,
                      color: borderColor,
                    ),
                    Expanded(
                      child: _buildSpecItem(
                        icon: Icons.flash_on_rounded,
                        label: 'Capacity',
                        value: '${task['plant_capacity_w'] ?? 0}kW',
                        accentColor: accentColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _buildFullAddress() {
    List<String> addressParts = [];

    if (task['plant_address'] != null && task['plant_address'].toString().isNotEmpty) {
      addressParts.add(task['plant_address']);
    }
    if (task['plant_location'] != null && task['plant_location'].toString().isNotEmpty) {
      addressParts.add(task['plant_location']);
    }
    if (task['area_name'] != null && task['area_name'].toString().isNotEmpty) {
      addressParts.add(task['area_name']);
    }
    if (task['taluka_name'] != null && task['taluka_name'].toString().isNotEmpty) {
      addressParts.add(task['taluka_name']);
    }

    return addressParts.isNotEmpty ? addressParts.join(', ') : 'Unknown Address';
  }

  Widget _buildSpecItem({
    required IconData icon,
    required String label,
    required String value,
    required Color accentColor,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: accentColor,
          size: 16.w,
        ),
        SizedBox(height: 3.h),
        Text(
          value,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 8.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}