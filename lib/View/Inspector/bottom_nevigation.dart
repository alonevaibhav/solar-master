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
//
//       // Remove outer Padding since Scaffold handles the positioning
//       margin: const EdgeInsets.only(
//         left: 20.0,
//         right: 20.0,
//         bottom: 20.0,
//       ),
//       height: 45.h,
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(30),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           // _buildNavItem(
//           //   icon: Icons.description,
//           //   index: 0,
//           //   label: 'Reports',
//           // ),
//           _buildNavItem(
//             icon: Icons.assignment,
//             index: 1,
//             label: 'Tasks',
//           ),
//           _buildNavItem(
//             icon: Icons.home,
//             index: 2,
//             label: 'Home',
//           ),
//           _buildNavItem(
//             icon: Icons.warning,
//             index: 3,
//             label: 'Alerts',
//           ),
//           _buildNavItem(
//             icon: Icons.person,
//             index: 4,
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNavItem({
//     required IconData icon,
//     required int index,
//     required String label,
//   }) {
//     final isSelected = currentIndex == index;
//
//     return GestureDetector(
//       onTap: () => onTap(index),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
//               size: 35,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Updated InspectorBottomNavigation widget
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
      // Remove outer Padding since Scaffold handles the positioning
      margin: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 20.0,
      ),
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            icon: Icons.assignment_outlined,
            selectedIcon: Icons.assignment,
            index: 1,
            label: 'Tasks',
          ),
          _buildNavItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            index: 2,
            label: 'Home',
          ),
          _buildNavItem(
            icon: Icons.warning_amber_outlined,
            selectedIcon: Icons.warning_amber,
            index: 3,
            label: 'Alerts',
          ),
          _buildNavItem(
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
            index: 4,
            label: 'Profile',
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
  }) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque, // Better touch detection
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 8.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isSelected ? (selectedIcon ?? icon) : icon,
                  key: ValueKey(isSelected),
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                  size: isSelected ? 28.sp : 26.sp,
                ),
              ),
              SizedBox(height: 2.h),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(top: 2.h),
                height: 2.h,
                width: isSelected ? 20.w : 0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}