import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InspectionCardWidget extends StatelessWidget {
  final Map<String, dynamic> inspection;
  final VoidCallback? onTap;

  const InspectionCardWidget({
    Key? key,
    required this.inspection,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    try {
      print('Rendering InspectionCard for: ${inspection['id']}');
      print('Inspection data keys: ${inspection.keys.toList()}');

      // Your existing build logic here...

    } catch (e) {
      print('Error in InspectionCardWidget: $e');
      print('Inspection data: $inspection');

      // Return a simple error card
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text('Error rendering card: $e'),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildInspectionHeader(),
            SizedBox(height: 12.h),
            _buildInspectionDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildInspectionHeader() {
    return Row(
      children: [
        _buildStatusIcon(),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Inspection ID: ${inspection['id']}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  _buildStatusBadge(),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                'Plant ID: ${inspection['plant_id']}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIcon() {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getStatusIcon(),
        color: _getStatusColor(),
        size: 20.sp,
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor(),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        _capitalizeStatus(),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInspectionDetails() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          _buildScheduleInfoRow(),
          SizedBox(height: 8.h),
          _buildWeekDayRow(),
          SizedBox(height: 8.h),
          _buildInspectorActiveRow(),
          if (inspection['notes'] != null && inspection['notes'].toString().isNotEmpty) ...[
            SizedBox(height: 8.h),
            _buildNotesSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildScheduleInfoRow() {
    return Row(
      children: [
        Expanded(
          child: _buildDetailItem(
            Icons.calendar_today_outlined,
            'Schedule',
            _formatScheduleDate(inspection['schedule_date']),
          ),
        ),
        Expanded(
          child: _buildDetailItem(
            Icons.access_time_outlined,
            'Time',
            _formatTime(inspection['time']),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekDayRow() {
    return Row(
      children: [
        Expanded(
          child: _buildDetailItem(
            Icons.view_week_outlined,
            'Week',
            'Week ${inspection['week']}',
          ),
        ),
        Expanded(
          child: _buildDetailItem(
            Icons.today_outlined,
            'Day',
            _getDayName(inspection['day']),
          ),
        ),
      ],
    );
  }

  Widget _buildInspectorActiveRow() {
    return Row(
      children: [
        Expanded(
          child: _buildDetailItem(
            Icons.person_outline,
            'Inspector',
            'ID: ${inspection['inspector_id']}',
          ),
        ),
        Expanded(
          child: _buildDetailItem(
            Icons.toggle_on_outlined,
            'Active',
            inspection['isActive'] == 1 ? 'Yes' : 'No',
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notes_outlined,
                size: 14.sp,
                color: Colors.blue[700],
              ),
              SizedBox(width: 4.w),
              Text(
                'Notes:',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            inspection['notes'].toString(),
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.blue[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14.sp,
          color: Colors.grey[600],
        ),
        SizedBox(width: 4.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper methods for status handling
  Color _getStatusColor() {
    String? status = inspection['status'];
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      case 'scheduled':
        return Colors.blue;
      case 'pending':
        return Colors.amber;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    String? status = inspection['status'];
    switch (status?.toLowerCase()) {
      case 'completed':
        return Icons.check_circle_outline;
      case 'in_progress':
        return Icons.hourglass_empty_outlined;
      case 'scheduled':
        return Icons.schedule_outlined;
      case 'pending':
        return Icons.pending_outlined;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }

  String _capitalizeStatus() {
    String? status = inspection['status'];
    if (status == null) return 'Unknown';
    return status.split('_').map((word) =>
    word[0].toUpperCase() + word.substring(1).toLowerCase()
    ).join(' ');
  }

  // Helper methods for date/time formatting
  String _formatScheduleDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      DateTime date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      print('Date parsing error: $e for date: $dateStr');
      return 'Invalid Date';
    }
  }

  String _formatTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return 'N/A';
    try {
      List<String> parts = timeStr.split(':');
      if (parts.length < 2) return timeStr; // Return original if not properly formatted

      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      String period = 'AM';
      if (hour >= 12) {
        period = 'PM';
        if (hour > 12) hour -= 12;
      }
      if (hour == 0) hour = 12;

      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      print('Time parsing error: $e for time: $timeStr');
      return timeStr ?? 'N/A';
    }
  }

  String _getDayName(String? day) {
    switch (day?.toLowerCase()) {
      case 'mo':
        return 'Monday';
      case 'tu':
        return 'Tuesday';
      case 'we':
        return 'Wednesday';
      case 'th':
        return 'Thursday';
      case 'fr':
        return 'Friday';
      case 'sa':
        return 'Saturday';
      case 'su':
        return 'Sunday';
      default:
        return day ?? 'N/A';
    }
  }
}