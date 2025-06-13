import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CleanupCardWidget extends StatelessWidget {
  final String areaNumber;
  final String date;
  final String time;
  final int panelCount;
  final String plantName;
  final String plantId;
  final String location;
  final VoidCallback onSendRemarkTap;

  const CleanupCardWidget({
    Key? key,
    required this.areaNumber,
    required this.date,
    required this.time,
    required this.panelCount,
    required this.plantName,
    required this.plantId,
    required this.location,
    required this.onSendRemarkTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.3.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 6.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(14.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Right Arrow Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_outward,
                      color: Colors.blue,
                      size: 16.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),

              // Info Row
              Column(
                children: [
                  _buildInfoBlock(Icons.access_time, 'Time', '$date $time'),
                  SizedBox(height: 4.h),
                  _buildInfoBlock(Icons.grid_view, 'Total', '$panelCount Panels'),
                ],
              ),
              SizedBox(height: 14.h),

              // Plant Name
              Text(
                plantName,
                style: TextStyle(
                  fontSize: 16.5.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 3.h),

              // Plant ID and Location
              Text(
                '$plantId\n$location',
                style: TextStyle(
                  fontSize: 11.sp,
                  height: 1.4,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 14.h),

              // Send Remark Button
              GestureDetector(
                onTap: onSendRemarkTap,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(7.r),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Center(
                    child: Text(
                      'Send Remark',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBlock(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Icon(icon, size: 17.sp, color: Colors.grey.shade700),
        ),
        SizedBox(width: 7.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
