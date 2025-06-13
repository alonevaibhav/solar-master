import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CleanerInfoCard extends StatelessWidget {
  final String name;
  final String phone;
  final List<bool> ratings;

  const CleanerInfoCard({
    Key? key,
    required this.name,
    required this.phone,
    this.ratings = const [
      true,
      true,
      true,
      true,
      true
    ], // Default 5-star rating
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cleaner info heading
          Text(
            'Cleaner Info',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 12.h),

          // Cleaner details row
          Row(
            children: [
              // Cleaner avatar
              CircleAvatar(
                radius: 24.r,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  size: 32.r,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(width: 16.w),

              // Cleaner details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name row
                    Row(
                      children: [
                        Text(
                          'Name: ',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // Phone row
                    Row(
                      children: [
                        Text(
                          'Phone: ',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          phone,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Call button
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.call,
                    color: Colors.white,
                    size: 20.r,
                  ),
                  onPressed: () {
                    // Handle call action
                    Get.snackbar(
                      'Call',
                      'Calling $name...',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Star rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                color: Colors.amber,
                size: 28.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
