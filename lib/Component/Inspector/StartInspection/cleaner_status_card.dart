// widgets/cleaner_status_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CleanerStatusCard extends StatelessWidget {
  final Map<String, dynamic> inspectionData;

  const CleanerStatusCard({
    super.key,
    required this.inspectionData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(),
        SizedBox(height: 15 * 0.9.h),
        _buildCleanerCard(),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      'Cleaner Status',
      style: TextStyle(
        fontSize: 18 * 0.9.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCleanerCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16 * 0.9.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12 * 0.9.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8 * 0.9.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildCleanerAvatar(),
          SizedBox(width: 16 * 0.9.w),
          _buildCleanerInfo(),
        ],
      ),
    );
  }

  Widget _buildCleanerAvatar() {
    return CircleAvatar(
      radius: 24 * 0.9.r,
      backgroundColor: Colors.blue[100],
      child: Icon(
        Icons.cleaning_services,
        color: Colors.blue,
        size: 24 * 0.9.r,
      ),
    );
  }

  Widget _buildCleanerInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            inspectionData['cleaner_name'] ?? 'Cleaner Name',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16 * 0.9.sp,
            ),
          ),
        ],
      ),
    );
  }
}