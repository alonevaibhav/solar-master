import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressChart extends StatelessWidget {
  final double complete;
  final double cleaning;
  final double pending;
  final List<Color> colors;

  const ProgressChart({
    Key? key,
    required this.complete,
    required this.cleaning,
    required this.pending,
    this.colors = const [Colors.blue, Colors.orange, Colors.pink],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = complete + cleaning + pending;
    final percentage = total > 0 ? ((complete / total) * 100).toStringAsFixed(0) : '0';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 130.h,
              width: 150.w,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 5,
                  centerSpaceRadius: 50,
                  startDegreeOffset: -90,
                  sections: [
                    _buildPieChartSection(complete, colors[0], 0),
                    _buildPieChartSection(cleaning, colors[1], 1),
                    _buildPieChartSection(pending, colors[2], 2),
                  ],
                ),
              ),
            ),
            Text(
              '$percentage %',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(width: 20.w),
        Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLegendItem('Complete', colors[0]),
            SizedBox(height: 8.h),
            _buildLegendItem('Cleaning', colors[1]),
            SizedBox(height: 8.h),
            _buildLegendItem('Pending', colors[2]),
          ],
        ),
      ],
    );
  }


  PieChartSectionData _buildPieChartSection(double value, Color color, int index) {
    final total = complete + cleaning + pending;
    final percentage = total > 0 ? (value / total) * 100 : 0.0;

    return PieChartSectionData(
      color: color,
      value: value,
      title: '', // No title
      radius: 25.r,
      titlePositionPercentageOffset: 0.0, // Optional: doesn't matter now
      badgeWidget: _buildBadge(index + 1, color),
      badgePositionPercentageOffset: 1.6,
    );
  }


  Widget _buildBadge(int number, Color color) {
    return Text(
      '• 0$number',
      style: TextStyle(
        fontSize: 10.sp,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 8.sp,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}