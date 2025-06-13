import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PanelStatusGrid extends StatelessWidget {
  final int greenCount;
  final int redCount;

  const PanelStatusGrid({
    Key? key,
    required this.greenCount,
    required this.redCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate total panels
    final int totalPanels = greenCount + redCount;
    // Generate a grid of panels with appropriate colors
    List<Widget> panelWidgets = [];

    // Add green panels
    for (int i = 0; i < greenCount; i++) {
      panelWidgets.add(_buildPanelItem(isGreen: true));
    }

    // Add red panels
    for (int i = 0; i < redCount; i++) {
      panelWidgets.add(_buildPanelItem(isGreen: false));
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7, // 7 panels per row as shown in the screenshot
      mainAxisSpacing: 8.h,
      crossAxisSpacing: 8.w,
      children: panelWidgets,
    );
  }

  Widget _buildPanelItem({required bool isGreen}) {
    return Container(
      decoration: BoxDecoration(
        color: isGreen ? const Color(0xFFA5D6A7) : Colors.red[300],
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
}