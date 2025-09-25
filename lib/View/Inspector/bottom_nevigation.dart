// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// // Updated InspectorBottomNavigation widget
// class InspectorBottomNavigation extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;
//
//   const InspectorBottomNavigation({
//     Key? key,
//     required this.currentIndex,
//     required this.onTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // Remove outer Padding since Scaffold handles the positioning
//       margin: const EdgeInsets.only(
//         left: 20.0,
//         right: 20.0,
//         bottom: 20.0,
//       ),
//       height: 50.h,
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(30),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.15),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _buildNavItem(
//             icon: Icons.assignment_outlined,
//             selectedIcon: Icons.assignment,
//             index: 1,
//             label: 'Tasks',
//           ),
//           _buildNavItem(
//             icon: Icons.home_outlined,
//             selectedIcon: Icons.home,
//             index: 2,
//             label: 'Home',
//           ),
//           _buildNavItem(
//             icon: Icons.warning_amber_outlined,
//             selectedIcon: Icons.warning_amber,
//             index: 3,
//             label: 'Alerts',
//           ),
//           _buildNavItem(
//             icon: Icons.person_outline,
//             selectedIcon: Icons.person,
//             index: 4,
//             label: 'Profile',
//           ),
//           _buildNavItem(
//             icon: Icons.local_florist_outlined,
//             selectedIcon: Icons.local_florist,
//             index: 5,
//             label: 'Plants',
//           ),
//         ],
//       ),
//     );
//   }
//   Widget _buildNavItem({
//     required IconData icon,
//     IconData? selectedIcon,
//     required int index,
//     required String label,
//   }) {
//     final isSelected = currentIndex == index;
//
//     return Expanded(
//       child: GestureDetector(
//         onTap: () => onTap(index),
//         behavior: HitTestBehavior.opaque, // Better touch detection
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           curve: Curves.easeInOut,
//           padding: EdgeInsets.symmetric(
//             horizontal: 20.w,
//             vertical: 8.h,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 200),
//                 child: Icon(
//                   isSelected ? (selectedIcon ?? icon) : icon,
//                   key: ValueKey(isSelected),
//                   color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
//                   size: isSelected ? 28.sp : 26.sp,
//                 ),
//               ),
//               SizedBox(height: 2.h),
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 margin: EdgeInsets.only(top: 2.h),
//                 height: 2.h,
//                 width: isSelected ? 20.w : 0,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(2.r),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

class InspectorBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const InspectorBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 10.w,
        right: 10.w,
        bottom: 10.h,
      ),
      height: 55.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavItem(
            icon: Icons.info_outline,
            selectedIcon: Icons.info,
            index: 1,
            label: 'Tasks',
            color: const Color(0xFFA7C8DA),
          ),

          _buildNavItem(
            icon: Icons.scale_outlined,
            selectedIcon: Icons.scale,
            index: 3,
            label: 'Alerts',
            color: const Color(0xFFA7C8DA),
          ),
          _buildNavItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            index: 2,
            label: 'Home',
            color: const Color(0xFF00BFA6),
          ),

          _buildNavItem(
            icon: Icons.local_florist_outlined,
            selectedIcon: Icons.local_florist,
            index: 5,
            label: 'Plants',
            color: const Color(0xFFA7C8DA),
          ),
          _buildNavItem(
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
            index: 4,
            label: 'Profile',
            color: const Color(0xFFA7C8DA),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    IconData? selectedIcon,
    required int index,
    required String label,
    required Color color,
  }) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 5.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with animated container background
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                width: isSelected ? 45.w : 35.w,
                height: isSelected ? 45.w : 35.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(isSelected ? 15.r : 12.r),
                  border: isSelected
                      ? Border.all(color: color.withOpacity(0.3), width: 1.5)
                      : null,
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: Icon(
                      isSelected ? (selectedIcon ?? icon) : icon,
                      key: ValueKey('${isSelected}_$index'),
                      color: isSelected ? color : Colors.white.withOpacity(0.6),
                      size: isSelected ? 28.sp : 22.sp,
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
}

