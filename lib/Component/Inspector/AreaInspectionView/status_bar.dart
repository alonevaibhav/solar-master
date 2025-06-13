import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusTabsWidget extends StatelessWidget {
  final String currentTab;
  final Function(String) onTabChanged;

  const StatusTabsWidget({
    Key? key,
    required this.currentTab,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabs = [
      'Ongoing Cleaning',
      'Pending Inspection',
      'Inspection Complete',
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: tabs.map((tab) => _buildTabItem(tab)).toList(),
        ),
      ),
    );
  }

  Widget _buildTabItem(String tabName) {
    final isSelected = currentTab == tabName;

    Color bgColor;
    Color textColor = Colors.black87;

    switch (tabName) {
      case 'Ongoing Cleaning':
        bgColor = const Color(0xFFFFB74D); // Softer Orange
        break;
      case 'Pending Inspection':
        bgColor = const Color(0xFF90CAF9); // Light Blue
        break;
      case 'Inspection Complete':
        bgColor = const Color(0xFF81C784); // Green
        break;
      default:
        bgColor = Colors.grey;
    }

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(tabName),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          height: 40.h,
          decoration: BoxDecoration(
            color: isSelected ? bgColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.center,
          child: Text(
            tabName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : textColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
