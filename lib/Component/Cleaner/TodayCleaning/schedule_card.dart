import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Controller/Cleaner/cleanup_schedule_controller.dart';

class ScheduleCard extends StatelessWidget {
  final CleanupScheduleController controller;
  final Map<String, dynamic> schedule;

  const ScheduleCard({
    Key? key,
    required this.controller,
    required this.schedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskId = schedule['id'] as int;
    final status = controller.getTaskStatus(taskId);
    final eta = controller.getTaskETA(taskId);

    Color statusColor;
    String statusText;

    switch (status) {
      case 'ongoing':
        statusColor = const Color(0xFF427FBD);
        statusText = 'Cleaning Ongoing';
        break;
      case 'completed':
        statusColor = const Color(0xFF4DE049);
        statusText = 'Cleaning Complete';
        break;
      default:
        statusColor = const Color(0xFFFF6B6B);
        statusText = 'Cleaning Pending';
    }

    return Container(
      height: 100.h,
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () => controller.selectTask(schedule),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Icon(
                        status == 'completed'
                            ? Icons.check_circle
                            : status == 'ongoing'
                            ? Icons.cleaning_services
                            : Icons.schedule,
                        color: Colors.white,
                        size: 20.w,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${schedule['plant_location'] ?? 'Plant Location'}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Location: ${schedule['plant_location'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            'Panels: ${schedule['plant_total_panels'] ?? 'N/A'} | ${schedule['plant_capacity_w'] ?? 'N/A'}kW',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (eta != null)
                Positioned(
                  bottom: 8.h,
                  right: 8.w,
                  child: Text(
                    'ETA: ${controller.formatETA(eta)}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
