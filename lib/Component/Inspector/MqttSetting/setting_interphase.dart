// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../Route Manager/app_routes.dart';
//
// class SchedulePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final Map<String, dynamic>? plantData = Get.arguments;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Schedule Options'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildScheduleTile(
//               title: 'Automatic Schedule',
//               description: 'Let the system optimize your schedule',
//               icon: Icons.auto_awesome,
//               color: Colors.blue,
//               onTap: () {
//                 Get.toNamed(AppRoutes.automaticSchedule, arguments: plantData);
//               },
//             ),
//             SizedBox(height: 16),
//             _buildScheduleTile(
//               title: 'Manual Schedule',
//               description: 'Create your own custom schedule',
//               icon: Icons.edit_calendar,
//               color: Colors.green,
//               onTap: () {
//                 Get.toNamed(AppRoutes.manualSchedule, arguments: plantData);
//               },
//             ),
//             SizedBox(height: 16),
//             _buildScheduleTile(
//               title: 'Slot Timing',
//               description: 'View your Slot Timing details',
//               icon: Icons.timelapse_outlined,
//               color: Colors.orange,
//               onTap: () {
//                 Get.toNamed(AppRoutes.cleanerHelp, arguments: plantData);
//               },
//             ),
//             SizedBox(height: 16),
//             _buildScheduleTile(
//               title: 'History',
//               description: 'Check your past slot cleaning records',
//               icon: Icons.history, // more suitable for history
//               color: Colors.blueGrey, // more neutral color for history
//               onTap: () {
//                 Get.toNamed(AppRoutes.historyInspector, arguments: plantData);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildScheduleTile({
//     required String title,
//     required String description,
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(icon, color: color),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       description,
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(Icons.chevron_right, color: Colors.grey),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Route Manager/app_routes.dart';

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? plantData = Get.arguments;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF3B82F6),
              Color(0xFF60A5FA),
              Color(0xFFFBBF24),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              SizedBox(height: 5.h),

              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Row(
                      children: [
                        Icon(Icons.wb_sunny, color: Colors.amber[300], size: 28.r),
                        SizedBox(width: 8.w),
                        Text(
                          'Solar Schedule',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(width: 55.w),
                  ],
                ),
              ),
              SizedBox(height: 10.h),

              // Schedule Options
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 20.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Choose Your Schedule Type :',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        SizedBox(height: 24.h),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                _buildSolarScheduleTile(
                                  title: 'Automatic Schedule',
                                  description: 'Set it once and let the system manage everything for you',
                                  icon: Icons.auto_awesome,
                                  gradientColors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                                  accentColor: Color(0xFF60A5FA),
                                  onTap: () {
                                    Get.toNamed(AppRoutes.automaticSchedule, arguments: plantData);
                                  },
                                ),
                                SizedBox(height: 16.h),
                                _buildSolarScheduleTile(
                                  title: 'Manual Schedule',
                                  description: 'Create custom cleaning schedules based on your preferences',
                                  icon: Icons.edit_calendar,
                                  gradientColors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                                  accentColor: Color(0xFF60A5FA),
                                  onTap: () {
                                    Get.toNamed(AppRoutes.manualSchedule, arguments: plantData);
                                  },
                                ),
                                SizedBox(height: 16.h),
                                _buildSolarScheduleTile(
                                  title: 'Timing Slots',
                                  description: 'Configure and view your maintenance time slots',
                                  icon: Icons.schedule,
                                  gradientColors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                                  accentColor: Color(0xFF60A5FA),
                                  onTap: () {
                                    Get.toNamed(AppRoutes.cleanerHelp, arguments: plantData);
                                  },
                                ),
                                SizedBox(height: 16.h),
                                _buildSolarScheduleTile(
                                  title: 'Activity History',
                                  description: 'Review past cleaning sessions and performance metrics',
                                  icon: Icons.analytics,
                                  gradientColors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                                  accentColor: Color(0xFF60A5FA),
                                  onTap: () {
                                    Get.toNamed(AppRoutes.historyInspector, arguments: plantData);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildSolarScheduleTile({
    required String title,
    required String description,
    required IconData icon,
    required List<Color> gradientColors,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r), // 20.r * 0.8
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.3),
            blurRadius: 9.6.r, // 12.r * 0.8
            offset: Offset(0, 4.8.h), // 6.h * 0.8
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r), // 20.r * 0.8
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(16.r), // 20.r * 0.8
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
              borderRadius: BorderRadius.circular(16.r), // 20.r * 0.8
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.8.r), // 16.r * 0.8
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.6, // 2 * 0.8
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 22.4.r, // 28.r * 0.8
                  ),
                ),
                SizedBox(width: 16.w), // 20.w * 0.8
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.4.sp, // 18.sp * 0.8
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.8.h), // 6.h * 0.8
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 11.2.sp, // 14.sp * 0.8
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(6.4.r), // 8.r * 0.8
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(9.6.r), // 12.r * 0.8
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 12.8.r, // 16.r * 0.8
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
