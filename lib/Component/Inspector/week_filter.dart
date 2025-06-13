import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WeekFilterWidget extends StatelessWidget {
  final Function(String?)? onWeekSelected;
  final String? selectedWeek;

  const WeekFilterWidget({
    Key? key,
    this.onWeekSelected,
    this.selectedWeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        children: [
          Text(
            'Filter by Week:',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 16.w),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _buildFilterButton(
                      label: 'All',
                      value: null,
                      isSelected: selectedWeek == null,
                    ),
                    SizedBox(width: 12.w),
                    _buildFilterButton(
                      label: 'Week 1',
                      value: '1',
                      isSelected: selectedWeek == '1',
                    ),
                    SizedBox(width: 12.w),
                    _buildFilterButton(
                      label: 'Week 2',
                      value: '2',
                      isSelected: selectedWeek == '2',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required String? value,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onWeekSelected?.call(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.grey[100],
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey[300]!,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }
}

// Alternative compact filter widget
class CompactWeekFilterWidget extends StatelessWidget {
  final Function(String?)? onWeekSelected;
  final String? selectedWeek;

  const CompactWeekFilterWidget({
    Key? key,
    this.onWeekSelected,
    this.selectedWeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCompactFilterChip(
            label: 'All',
            value: null,
            isSelected: selectedWeek == null,
          ),
          _buildCompactFilterChip(
            label: 'Week 1',
            value: '1',
            isSelected: selectedWeek == '1',
          ),
          _buildCompactFilterChip(
            label: 'Week 2',
            value: '2',
            isSelected: selectedWeek == '2',
          ),
        ],
      ),
    );
  }

  Widget _buildCompactFilterChip({
    required String label,
    required String? value,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onWeekSelected?.call(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[400]!,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
