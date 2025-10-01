

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class CleanerBottomNavigation extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;
//
//   const CleanerBottomNavigation({
//     Key? key,
//     required this.currentIndex,
//     required this.onTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         // Add background and padding to prevent overlap
//         padding: EdgeInsets.only(
//           left: 45.w,
//           right: 45.w,
//           bottom: 10.h,
//           top: 15.h, // Important: Space above the navigation
//         ),
//         child: Container(
//           height: 50.h,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.black,
//             borderRadius: BorderRadius.circular(30.r),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.15),
//                 blurRadius: 15.r,
//                 offset: Offset(0, 5.h),
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildNavItem(
//                 icon: Icons.home_outlined,
//                 selectedIcon: Icons.home,
//                 index: 0,
//                 label: 'Home',
//               ),
//               _buildNavItem(
//                 icon: Icons.person_outline,
//                 selectedIcon: Icons.person,
//                 index: 1,
//                 label: 'Profile',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
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
//         behavior: HitTestBehavior.opaque,
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
//




import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

class CleanerBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CleanerBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 50.w,
        right: 50.w,
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          _buildNavItem(
            icon: Icons.local_florist_outlined,
            selectedIcon: Icons.local_florist,
            index: 2,
            label: 'plant',
            color: const Color(0xFFA7C8DA),
          ),
          _buildNavItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            index: 0,
            label: 'Home',
            color: Colors.blueAccent,

          ),
          _buildNavItem(
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
            index: 1,
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

