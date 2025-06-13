// widgets/schedule_card_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_app/API%20Service/Model/Request/shedule_model.dart';

class ScheduleCardWidget extends StatelessWidget {
  final Schedule schedule;
  final VoidCallback? onTap;

  const ScheduleCardWidget({
    Key? key,
    required this.schedule,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      return _buildCard(context);
    } catch (e) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text('Error rendering schedule card: $e'),
      );
    }
  }

  Widget _buildCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
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
            _buildScheduleHeader(),
            SizedBox(height: 12.h),
            _buildScheduleDetails(),
          ],
        ),
      ),
    );
  }


  Widget _buildScheduleHeader() {
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
                    'Schedule ID: ${schedule.id}',
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
                'Plant ID: ${schedule.plantId}',
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

  Widget _buildScheduleDetails() {
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
          if (schedule.notes != null && schedule.notes!.isNotEmpty && schedule.notes != 'null') ...[
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
            _formatScheduleDate(schedule.scheduleDate),
          ),
        ),
        Expanded(
          child: _buildDetailItem(
            Icons.access_time_outlined,
            'Time',
            _formatTime(schedule.time),
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
            'Week ${schedule.week}',
          ),
        ),
        Expanded(
          child: _buildDetailItem(
            Icons.today_outlined,
            'Day',
            _getDayName(schedule.day),
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
            'ID: ${schedule.inspectorId}',
          ),
        ),
        Expanded(
          child: _buildDetailItem(
            Icons.assignment_ind_outlined,
            'Assigned By',
            'ID: ${schedule.assignedBy}',
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
            schedule.notes!,
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
        Expanded(
          child: Column(
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
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper methods for status handling
  Color _getStatusColor() {
    String status = schedule.status.toLowerCase();
    switch (status) {
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
    String status = schedule.status.toLowerCase();
    switch (status) {
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
    if (schedule.status.isEmpty) return 'Pending';
    return schedule.status.split('_').map((word) =>
    word[0].toUpperCase() + word.substring(1).toLowerCase()
    ).join(' ');
  }

  // Helper methods for date/time formatting
  String _formatScheduleDate(String dateStr) {
    if (dateStr.isEmpty) return 'N/A';
    try {
      DateTime date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      print('Date parsing error: $e for date: $dateStr');
      return 'Invalid Date';
    }
  }

  String _formatTime(String timeStr) {
    if (timeStr.isEmpty) return 'N/A';
    try {
      List<String> parts = timeStr.split(':');
      if (parts.length < 2) return timeStr;

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
      return timeStr;
    }
  }

  String _getDayName(String day) {
    switch (day.toLowerCase()) {
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
        return day.isNotEmpty ? day : 'N/A';
    }
  }
}