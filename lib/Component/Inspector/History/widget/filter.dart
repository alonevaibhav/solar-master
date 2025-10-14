import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../history_controller.dart';


class MqttHistoryDateFilter extends StatelessWidget {
  final InspectorHistoryController controller;

  const MqttHistoryDateFilter({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Date Range',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildYearDropdown(),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildMonthDropdown(),
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: _buildFetchButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildYearDropdown() {
    return Obx(
          () => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: controller.selectedYear.value,
            isExpanded: true,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            items: _getYearList().map((year) {
              return DropdownMenuItem<int>(
                value: year,
                child: Text(year.toString()),
              );
            }).toList(),
            onChanged: (year) {
              if (year != null) {
                controller.updateYear(year);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMonthDropdown() {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    return Obx(
          () => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: controller.selectedMonth.value,
            isExpanded: true,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            items: List.generate(12, (index) {
              return DropdownMenuItem<int>(
                value: index + 1,
                child: Text(months[index]),
              );
            }).toList(),
            onChanged: (month) {
              if (month != null) {
                controller.updateMonth(month);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFetchButton() {
    return Obx(
          () => ElevatedButton.icon(
        onPressed: controller.isLoading.value
            ? null
            : () => controller.loadMqttHistoryByYearMonth(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[700],
          disabledBackgroundColor: Colors.grey[300],
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: controller.isLoading.value
            ? SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Icon(Icons.search),
        label: Text(
          controller.isLoading.value ? 'Fetching...' : 'Fetch History',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  List<int> _getYearList() {
    int currentYear = DateTime.now().year;
    return List.generate(5, (index) => currentYear - index);
  }
}