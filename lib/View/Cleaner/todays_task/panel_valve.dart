import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Controller/Cleaner/cleanup_schedule_controller.dart';
// Panel Valve Section Widget
class PanelValveSection extends StatelessWidget {
  final Map<String, dynamic> taskData;
  final String status;

  const PanelValveSection({
    Key? key,
    required this.taskData,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildPanelInformation();
  }

  Widget _buildPanelInformation() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16 * 0.9.w),
      padding: EdgeInsets.all(20 * 0.9.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16 * 0.9.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10 * 0.9,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Panel Valve Information',
            style: TextStyle(
              fontSize: 16 * 0.9.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16 * 0.9.h),
          _buildPanelRow('Panel Valve - 1'),
          _buildPanelRow('Panel Valve - 2'),
          _buildPanelRow('Panel Valve - 3'),
          _buildPanelRow('Panel Valve - 4'),
        ],
      ),
    );
  }

  Widget _buildPanelRow(String panelName) {
    Color indicatorColor;
    IconData indicatorIcon;

    // Determine status based on task status
    switch (status) {
      case 'ongoing':
        indicatorColor = const Color(0xFFFF9500);
        indicatorIcon = Icons.sync;
        break;
      case 'completed':
        indicatorColor = const Color(0xFF4ECDC4);
        indicatorIcon = Icons.check_circle;
        break;
      default:
        indicatorColor = Colors.grey[300]!;
        indicatorIcon = Icons.radio_button_unchecked;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12 * 0.9.h),
      child: Row(
        children: [
          Text(
            panelName,
            style: TextStyle(
              fontSize: 14 * 0.9.sp,
              color: Colors.grey[800],
            ),
          ),
          const Spacer(),
          Container(
            width: 24 * 0.9.w,
            height: 24 * 0.9.w,
            decoration: BoxDecoration(
              color: indicatorColor,
              borderRadius: BorderRadius.circular(12 * 0.9.r),
            ),
            child: Icon(
              indicatorIcon,
              color: status == 'pending' ? Colors.grey[600] : Colors.white,
              size: 16 * 0.9.w,
            ),
          ),
        ],
      ),
    );
  }
}