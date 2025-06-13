import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlantListItem extends StatelessWidget {
  final Map<String, dynamic> plant;
  final VoidCallback onTap;

  const PlantListItem({
    Key? key,
    required this.plant,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double scale = 0.8; // 20% smaller
    final isOnline = plant['isOnline'] == true;
    final statusColor = isOnline ? Colors.green : Colors.grey;
    final statusText = isOnline ? 'Online' : 'Offline';

    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10.h * scale, horizontal: 9.w * scale),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r * scale)),
      color: Colors.grey[50],
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r * scale),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top bar with slight grey gradient
            Container(
              padding: EdgeInsets.all(16.w * scale),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey.shade200, Colors.grey.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(14.r * scale)),
              ),
              child: Row(
                children: [
                  // Icon with grey circle
                  Container(
                    width: 44.w * scale,
                    height: 44.h * scale,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.villa_outlined,
                      size: 24.sp * scale,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(width: 12.w * scale),
                  // Name + status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plant['name'] ?? 'Unnamed Plant',
                          style: TextStyle(
                            fontSize: 17.sp * scale,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        SizedBox(height: 4.h * scale),
                        Row(
                          children: [
                            Container(
                              width: 8.w * scale,
                              height: 8.h * scale,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6.w * scale),
                            Text(
                              statusText,
                              style: TextStyle(
                                fontSize: 12.sp * scale,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Auto Clean section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w * scale, vertical: 12.h * scale),
              child: Row(
                children: [
                  Icon(Icons.schedule, size: 20.sp * scale, color: Colors.grey.shade600),
                  SizedBox(width: 8.w * scale),
                  Expanded(
                    child: Text(
                      'Auto Clean: ${plant['autoCleanTime'] ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 14.sp * scale,
                        color: Colors.grey.shade700,

                      ),
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: 1.h * scale, indent: 16.w * scale, endIndent: 16.w * scale),

            // Location section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w * scale, vertical: 12.h * scale),
              child: Row(
                children: [
                  Icon(Icons.location_on, size: 20.sp * scale, color: Colors.grey.shade600),
                  SizedBox(width: 8.w * scale),
                  Expanded(
                    child: Text(
                      plant['location'] ?? 'Unknown location',
                      style: TextStyle(
                        fontSize: 14.sp * scale,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8.w * scale),
                  Container(
                    padding: EdgeInsets.all(6.w * scale),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.navigation, size: 16.sp * scale, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            // View Details button
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.r * scale)),
              ),
              child: TextButton(
                onPressed: onTap,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h * scale),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.r * scale)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View Details',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp * scale,
                      ),
                    ),
                    SizedBox(width: 6.w * scale),
                    Icon(Icons.arrow_forward_ios, size: 14.sp * scale, color: Colors.grey.shade600),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
