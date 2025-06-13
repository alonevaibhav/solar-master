import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlertCard extends StatelessWidget {
  final Map<String, dynamic> alertData;
  final VoidCallback onTap;
  final VoidCallback onMapTap;

  const AlertCard({
    Key? key,
    required this.alertData,
    required this.onTap,
    required this.onMapTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get priority color
    final bool isHighPriority = alertData['priority'] == 'high';
    final Color cardColor = isHighPriority
        ? const Color(0xFFFF5252)  // Red for high priority
        : const Color(0xFFFFA726); // Yellow/Orange for low priority

    // Get tags
    final List<String> tags = List<String>.from(alertData['tags'] ?? []);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            // Alert Icon
            Container(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 32.sp,
              ),
            ),

            SizedBox(width: 12.w),

            // Content Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row
                  Row(
                    children: [
                      // Plant Name
                      Text(
                        alertData['location'] ?? '',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(width: 12.w),

                      // DateTime
                      Text(
                        alertData['dateTime'] ?? '',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Tags Row
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: tags.map((tag) {
                      // Use tag data directly from backend
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Map Button
            GestureDetector(
              onTap: onMapTap,
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 24.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}