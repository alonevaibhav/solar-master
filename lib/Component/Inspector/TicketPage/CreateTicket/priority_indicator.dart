import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriorityIndicator extends StatelessWidget {
  final String priority;

  const PriorityIndicator({
    Key? key,
    required this.priority,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final priorityData = _getPriorityData(priority);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: priorityData['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: priorityData['color'].withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: priorityData['color'],
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            priorityData['icon'],
            size: 16.sp,
            color: priorityData['color'],
          ),
          SizedBox(width: 6.w),
          Text(
            priorityData['label'],
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: priorityData['color'],
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            priorityData['description'],
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: priorityData['color'].withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getPriorityData(String priority) {
    switch (priority) {
      case '1':
        return {
          'label': 'Critical',
          'description': 'Urgent attention required',
          'color': const Color(0xFFDC2626), // Red
          'icon': Icons.error,
        };
      case '2':
        return {
          'label': 'High',
          'description': 'High priority issue',
          'color': const Color(0xFFEA580C), // Orange
          'icon': Icons.warning,
        };
      case '3':
        return {
          'label': 'Medium',
          'description': 'Normal priority',
          'color': const Color(0xFFCA8A04), // Amber
          'icon': Icons.info,
        };
      case '4':
        return {
          'label': 'Low',
          'description': 'Low priority issue',
          'color': const Color(0xFF059669), // Green
          'icon': Icons.schedule,
        };
      case '5':
        return {
          'label': 'Very Low',
          'description': 'Minimal impact',
          'color': const Color(0xFF0284C7), // Blue
          'icon': Icons.remove,
        };
      default:
        return {
          'label': 'Medium',
          'description': 'Normal priority',
          'color': const Color(0xFFCA8A04),
          'icon': Icons.info,
        };
    }
  }
}