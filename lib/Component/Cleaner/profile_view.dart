import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Controller/Cleaner/profile_controller.dart';
import '../../Controller/login_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileCard(),

            SizedBox(height: 14.4.h),

            Padding(
              padding: EdgeInsets.only(left: 14.4.w, bottom: 7.2.h),
              child: Text(
                'General Information',
                style: TextStyle(
                  fontSize: 12.6.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),

            _buildMenuOption(
              icon: Icons.list_alt,
              title: 'Assigned Plants',
              onTap: controller.goToAssignedPlants,
            ),

            _buildMenuOption(
              icon: Icons.info_outline,
              title: 'Plant Info',
              onTap: controller.goToPlantInfo,
            ),

            _buildMenuOption(
              icon: Icons.headset_mic,
              title: 'Help & Support',
              onTap: controller.goToHelpAndSupport,
            ),

            _buildMenuOption(
              icon: Icons.history,
              title: 'Clean-up History',
              onTap: controller.goToCleanupHistory,
            ),

            SizedBox(height: 14.4.h),

            Padding(
              padding: EdgeInsets.only(left: 14.4.w, bottom: 7.2.h),
              child: Text(
                'Account ',
                style: TextStyle(
                  fontSize: 12.6.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),

            _buildActionButton(
              icon: Icons.logout,
              title: 'Logout',
              color: Colors.orange,
              onTap: controller.logout,
            ),

            SizedBox(height: 5.4.h),

            _buildActionButton(
              icon: Icons.delete_outline,
              title: 'Delete Account',
              color: Colors.red,
              onTap: controller.showDeleteConfirmation,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    final LoginController loginController = Get.find<LoginController>();

    return Container(
      margin: EdgeInsets.all(14.4.w),
      padding: EdgeInsets.all(14.4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 9,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 63.w,
            height: 90.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 0.9.w,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.person, // Dummy profile icon
                size: 40, // Adjust size as needed
                color: Colors.grey,
              ),
            ),
          ),

          SizedBox(width: 14.4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Name:',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 3.6.w),
                    Obx(() => Text(
                      loginController.currentUserName.isNotEmpty
                          ? loginController.userName
                          : 'Loading...',
                      style: TextStyle(fontSize: 11.sp),
                    )),
                  ],
                ),
                SizedBox(height: 9.6.h),
                Row(
                  children: [
                    Text(
                      'userName:',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 3.6.w),
                    Obx(() => Text(
                      loginController.currentUsername.isNotEmpty
                          ? loginController.username
                          : 'Loading...',
                      style: TextStyle(fontSize: 11.sp),
                    )),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Distributor Name:',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 3.6.w),
                    Obx(() => Text(
                      loginController.currentDistributorName.isNotEmpty
                          ? loginController.username
                          : 'Loading...',
                      style: TextStyle(fontSize: 11.sp),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.4.w, vertical: 3.6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4.5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.4.w, vertical: 14.4.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(7.2.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 18.sp,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 14.4.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.4.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  size: 18.sp,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildThemeToggle() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 14.4.w, vertical: 3.6.h),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(10.8.r),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.03),
  //           blurRadius: 4.5,
  //           offset: const Offset(0, 1),
  //         ),
  //       ],
  //     ),
  //     child: Padding(
  //       padding: EdgeInsets.symmetric(horizontal: 14.4.w, vertical: 10.8.h),
  //       child: Row(
  //         children: [
  //           Container(
  //             padding: EdgeInsets.all(7.2.w),
  //             decoration: BoxDecoration(
  //               color: Colors.grey.shade100,
  //               shape: BoxShape.circle,
  //             ),
  //             child: Icon(
  //               Icons.dark_mode,
  //               size: 18.sp,
  //               color: Colors.black87,
  //             ),
  //           ),
  //           SizedBox(width: 14.4.w),
  //           Text(
  //             'Toggle Theme',
  //             style: TextStyle(
  //               fontSize: 14.4.sp,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //           const Spacer(),
  //           Obx(() => Switch(
  //             value: controller.isDarkMode.value,
  //             onChanged: controller.toggleTheme,
  //             activeColor: Colors.blue,
  //           )),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.4.w),
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: color,
          size: 18.sp,
        ),
        label: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 14.4.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(vertical: 10.8.h, horizontal: 14.4.w),
        ),
      ),
    );
  }
}
