// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../../Controller/Inspector/automatic_controller.dart';
// import '../../Controller/Inspector/user_profile_controller.dart';
// import '../../Controller/login_controller.dart';
//
// class UserProfile extends GetView<IUserProfile> {
//   const UserProfile({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               _buildProfileCard(),
//               SizedBox(height: 14.4.h),
//               Padding(
//                 padding: EdgeInsets.only(left: 14.4.w, bottom: 7.2.h),
//                 child: Text(
//                   'General Information',
//                   style: TextStyle(
//                     fontSize: 12.6.sp,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//               _buildMenuOption(
//                 icon: Icons.info,
//                 title: ' Plants Information',
//                 onTap: controller.goToPlantInfo,
//               ),
//               SizedBox(height: 14.4.h),
//               Padding(
//                 padding: EdgeInsets.only(left: 14.4.w, bottom: 7.2.h),
//                 child: Text(
//                   'Account ',
//                   style: TextStyle(
//                     fontSize: 12.6.sp,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//               _buildActionButton(
//                 icon: Icons.logout,
//                 title: 'Logout',
//                 color: Colors.orange,
//                 onTap: controller.logout,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileCard() {
//     final LoginController loginController = Get.find<LoginController>();
//     return Container(
//       margin: EdgeInsets.all(14.4.w),
//       padding: EdgeInsets.all(14.4.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10.8.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 9,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 63.w,
//             height: 90.w,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: Colors.grey.shade300,
//                 width: 0.9.w,
//               ),
//             ),
//             child: const Center(
//               child: Icon(
//                 Icons.person, // Dummy profile icon
//                 size: 40, // Adjust size as needed
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           SizedBox(width: 14.4.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       'Name:',
//                       style: TextStyle(
//                         fontSize: 11.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(width: 3.6.w),
//                     Obx(() => Text(
//                           loginController.userName,
//                           style: TextStyle(fontSize: 11.sp),
//                         )),
//                   ],
//                 ),
//                 SizedBox(height: 9.6.h),
//                 Row(
//                   children: [
//                     Text(
//                       'userName:',
//                       style: TextStyle(
//                         fontSize: 11.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(width: 3.6.w),
//                     Obx(() => Text(
//                           loginController.username,
//                           style: TextStyle(fontSize: 11.sp),
//                         )),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       'Distributor Name:',
//                       style: TextStyle(
//                         fontSize: 11.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(width: 3.6.w),
//                     Obx(() => Text(
//                           loginController.currentDistributorName.string,
//                           style: TextStyle(fontSize: 11.sp),
//                         )),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMenuOption({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 14.4.w, vertical: 3.6.h),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10.8.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 4.5,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(10.8.r),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 14.4.w, vertical: 14.4.h),
//             child: Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(7.2.w),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade100,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     icon,
//                     size: 18.sp,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 SizedBox(width: 14.4.w),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 14.4.sp,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const Spacer(),
//                 Icon(
//                   Icons.chevron_right,
//                   size: 18.sp,
//                   color: Colors.grey,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButton({
//     required IconData icon,
//     required String title,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 14.4.w),
//       child: TextButton.icon(
//         onPressed: onTap,
//         icon: Icon(
//           icon,
//           color: color,
//           size: 18.sp,
//         ),
//         label: Text(
//           title,
//           style: TextStyle(
//             color: color,
//             fontSize: 14.4.sp,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         style: TextButton.styleFrom(
//           alignment: Alignment.centerLeft,
//           padding: EdgeInsets.symmetric(vertical: 10.8.h, horizontal: 14.4.w),
//         ),
//       ),
//     );
//   }
// }

//
// // -----------------------------------------
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../../Controller/Inspector/user_profile_controller.dart';
// import '../../Controller/login_controller.dart';
//
// class UserProfile extends GetView<IUserProfile> {
//   const UserProfile({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: SafeArea(
//         child: CustomScrollView(
//           slivers: [
//             SliverToBoxAdapter(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   SizedBox(height: 20.h),
//                   _buildProfileCard(),
//                   SizedBox(height: 32.h),
//                   _buildSectionHeader('General Information'),
//                   SizedBox(height: 12.h),
//                   _buildMenuOption(
//                     icon: Icons.eco,
//                     title: 'Plants Information',
//                     subtitle: 'Manage and view plant data',
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
//                     ),
//                     onTap: controller.goToPlantInfo,
//                   ),
//                   SizedBox(height: 32.h),
//                   _buildSectionHeader('Account Settings'),
//                   SizedBox(height: 12.h),
//                   _buildActionButton(
//                     icon: Icons.logout_rounded,
//                     title: 'Logout',
//                     subtitle: 'Sign out of your account',
//                     color: const Color(0xFFE53E3E),
//                     onTap: controller.logout,
//                   ),
//                   SizedBox(height: 40.h),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Widget _buildProfileCard() {
//     final LoginController loginController = Get.find<LoginController>();
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 20.w),
//       padding: EdgeInsets.all(24.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20.r),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF667EEA).withOpacity(0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Profile Avatar
//           Container(
//             width: 80.w,
//             height: 80.w,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF667EEA).withOpacity(0.3),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Icon(
//               Icons.person_rounded,
//               size: 40.sp,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 20.h),
//
//           // User Information
//           _buildInfoRow(
//             label: 'Name',
//             value: Obx(() => Text(loginController.userName)),
//             icon: Icons.person_outline_rounded,
//           ),
//           SizedBox(height: 16.h),
//           _buildInfoRow(
//             label: 'Username',
//             value: Obx(() => Text(loginController.username)),
//             icon: Icons.alternate_email_rounded,
//           ),
//           SizedBox(height: 16.h),
//           _buildInfoRow(
//             label: 'Distributor',
//             value: Obx(() => Text(loginController.currentDistributorName.string)),
//             icon: Icons.business_rounded,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoRow({
//     required String label,
//     required Widget value,
//     required IconData icon,
//   }) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8FAFC),
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(
//           color: const Color(0xFFE2E8F0),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(8.w),
//             decoration: BoxDecoration(
//               color: const Color(0xFF667EEA).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8.r),
//             ),
//             child: Icon(
//               icon,
//               size: 16.sp,
//               color: const Color(0xFF667EEA),
//             ),
//           ),
//           SizedBox(width: 12.w),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 11.sp,
//                   fontWeight: FontWeight.w500,
//                   color: const Color(0xFF64748B),
//                 ),
//               ),
//               SizedBox(height: 2.h),
//               DefaultTextStyle(
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                   color: const Color(0xFF1E293B),
//                 ),
//                 child: value,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20.w),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 18.sp,
//           fontWeight: FontWeight.w600,
//           color: const Color(0xFF1E293B),
//           letterSpacing: -0.5,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMenuOption({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Gradient gradient,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 20.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16.r),
//           child: Padding(
//             padding: EdgeInsets.all(20.w),
//             child: Row(
//               children: [
//                 Container(
//                   width: 48.w,
//                   height: 48.w,
//                   decoration: BoxDecoration(
//                     gradient: gradient,
//                     borderRadius: BorderRadius.circular(12.r),
//                     boxShadow: [
//                       BoxShadow(
//                         color: gradient.colors.first.withOpacity(0.3),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Icon(
//                     icon,
//                     size: 24.sp,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(width: 16.w),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w600,
//                           color: const Color(0xFF1E293B),
//                         ),
//                       ),
//                       SizedBox(height: 4.h),
//                       Text(
//                         subtitle,
//                         style: TextStyle(
//                           fontSize: 12.sp,
//                           color: const Color(0xFF64748B),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(6.w),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF1F5F9),
//                     borderRadius: BorderRadius.circular(8.r),
//                   ),
//                   child: Icon(
//                     Icons.arrow_forward_ios_rounded,
//                     size: 14.sp,
//                     color: const Color(0xFF64748B),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButton({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 20.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(
//           color: color.withOpacity(0.2),
//           width: 1.5,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16.r),
//           splashColor: color.withOpacity(0.1),
//           highlightColor: color.withOpacity(0.05),
//           child: Padding(
//             padding: EdgeInsets.all(20.w),
//             child: Row(
//               children: [
//                 Container(
//                   width: 48.w,
//                   height: 48.w,
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   child: Icon(
//                     icon,
//                     size: 24.sp,
//                     color: color,
//                   ),
//                 ),
//                 SizedBox(width: 16.w),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w600,
//                           color: color,
//                         ),
//                       ),
//                       SizedBox(height: 4.h),
//                       Text(
//                         subtitle,
//                         style: TextStyle(
//                           fontSize: 12.sp,
//                           color: const Color(0xFF64748B),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Icon(
//                   Icons.arrow_forward_ios_rounded,
//                   size: 14.sp,
//                   color: color.withOpacity(0.7),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Controller/Inspector/user_profile_controller.dart';
import '../../Controller/login_controller.dart';

class UserProfile extends GetView<IUserProfile> {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Compact Profile Header
              _buildCompactProfileHeader(),

              SizedBox(height: 24.h),

              // Main Content Area
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Menu Options
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Quick Actions',
                        //   style: TextStyle(
                        //     fontSize: 16.sp,
                        //     fontWeight: FontWeight.w600,
                        //     color: const Color(0xFF1E293B),
                        //   ),
                        // ),
                        SizedBox(height: 12.h),
                        // _buildCompactMenuOption(
                        //   icon: Icons.eco,
                        //   title: 'Plants Information',
                        //   gradient: const LinearGradient(
                        //     colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                        //   ),
                        //   onTap: controller.goToPlantInfo,
                        // ),
                      ],
                    ),

                    // Bottom Action
                    _buildCompactActionButton(
                      icon: Icons.logout_rounded,
                      title: 'Logout',
                      color: const Color(0xFFE53E3E),
                      onTap: controller.logout,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactProfileHeader() {
    final LoginController loginController = Get.find<LoginController>();
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Avatar - Smaller
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667EEA).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.person_rounded,
              size: 30.sp,
              color: Colors.white,
            ),
          ),

          SizedBox(width: 16.w),

          // User Info - Horizontal Layout
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                  loginController.currentUserName.value,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                )),
                SizedBox(height: 4.h),
                Obx(() => Text(
                  '@${loginController.currentUsername.value}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xFF64748B),
                  ),
                )),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF667EEA).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.business_rounded,
                        size: 12.sp,
                        color: const Color(0xFF667EEA),
                      ),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Obx(() => Text(
                          loginController.currentDistributorName.string,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF667EEA),
                          ),
                          overflow: TextOverflow.ellipsis,
                        )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactMenuOption({
    required IconData icon,
    required String title,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    icon,
                    size: 20.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12.sp,
                  color: const Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactActionButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          splashColor: color.withOpacity(0.1),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18.sp,
                  color: color,
                ),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: color,
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