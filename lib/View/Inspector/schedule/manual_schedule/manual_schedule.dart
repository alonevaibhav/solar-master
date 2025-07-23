

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Controller/Inspector/manual_controller.dart';

class ManualSchedule extends StatelessWidget {
  const ManualSchedule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {



    final Map<String, dynamic>? plantData = Get.arguments;
    print('Received plant data: $plantData');
    final String? uuid = plantData?['uuid']?.toString();
    print('UUID: $uuid');

    final controller = Get.put(ManualController());

    // Set UUID after creation
    controller.setUuid(uuid);
    controller.printUuidInfo();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manual Schedule',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Obx(() => Text(
              'IMEI: ${controller.currentImei.value} | Boxes: ${controller.numberOfBoxes.value}',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            )),
          ],
        ),
        actions: [
          Obx(() => controller.modifiedCount > 0
              ? Container(
            margin: EdgeInsets.only(right: 8.w),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              '${controller.modifiedCount} modified',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.orange[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          )
              : SizedBox(),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'reset':
                  controller.resetParameters();
                  break;
                case 'setall':
                  _showSetAllDialog(controller);
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'setall',
                child: Row(
                  children: [
                    Icon(Icons.settings_applications, size: 18.w),
                    SizedBox(width: 8.w),
                    Text('Set All Boxes'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16.h),
                Text(
                  'Loading parameters...',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48.w,
                  color: Colors.red[400],
                ),
                SizedBox(height: 16.h),
                Text(
                  'Error loading data',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red[400],
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                ElevatedButton.icon(
                  onPressed: null,
                  icon: Icon(Icons.refresh, size: 18.w),
                  label: Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  ),
                ),
              ],
            ),
          );
        }

        // Check if no boxes to show
        if (controller.numberOfBoxes.value == 0) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 48.w,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16.h),
                Text(
                  'No boxes to display',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Parameter 561 value: ${controller.numberOfBoxes.value}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Info header
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(16.w),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
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
                    'Active Valve: ${controller.numberOfBoxes.value}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Parameters ${450} to ${449 + controller.numberOfBoxes.value} • Tap any cell to edit',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Parameters grid
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: _buildDynamicParametersGrid(controller),
                ),
              ),
            ),

            // Action buttons
            Container(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.modifiedCount > 0
                          ? controller.saveParameters
                          : null,
                      icon: Icon(Icons.save, size: 18.w),
                      label: Text('Save Changes'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: controller.resetParameters,
                      icon: Icon(Icons.refresh, size: 18.w),
                      label: Text('Reset All'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDynamicParametersGrid(ManualController controller) {
    final numberOfBoxes = controller.numberOfBoxes.value;

    // If no boxes, show empty state
    if (numberOfBoxes == 0) {
      return Center(
        child: Text(
          'No active boxes',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[500],
          ),
        ),
      );
    }

    // Calculate grid dimensions based on number of boxes
    const int columnsPerRow = 5;
    final int totalRows = (numberOfBoxes / columnsPerRow).ceil();

    return Column(
      children: [
        // Build only the required number of rows
        for (int row = 0; row < totalRows; row++)
          Expanded(
            child: Row(
              children: [
                // Build columns in each row
                for (int col = 0; col < columnsPerRow; col++)
                      () {
                    final paramIndex = 450 + (row * columnsPerRow) + col;
                    // Only show if this parameter index is within the active range
                    if (paramIndex < 450 + numberOfBoxes) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.all(1.w),
                          child: _buildParameterCell(controller, paramIndex),
                        ),
                      );
                    } else {
                      // Empty space for unused cells in the last row
                      return Expanded(child: SizedBox());
                    }
                  }(),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildParameterCell(ManualController controller, int paramIndex) {
    return Obx(() {
      final value = controller.getParameterValue(paramIndex);
      final isModified = controller.isParameterModified(paramIndex);

      return InkWell(
        onTap: () => _showEditDialog(controller, paramIndex),
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: isModified ? Colors.orange[50] : Colors.grey[100],
            border: Border.all(
              color: isModified ? Colors.orange[300]! : Colors.grey[300]!,
              width: isModified ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$paramIndex',
                style: TextStyle(
                  fontSize: 8.sp,
                  color: isModified ? Colors.orange[700] : Colors.grey[500],
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isModified ? Colors.orange[900] : Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (isModified)
                Container(
                  width: 4.w,
                  height: 4.w,
                  margin: EdgeInsets.only(top: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  void _showEditDialog(ManualController controller, int paramIndex) {
    final currentValue = controller.getParameterValue(paramIndex);
    final textController = TextEditingController(text: currentValue.toString());

    Get.dialog(
      AlertDialog(
        title: Text(
          'Edit Box ${paramIndex - 449} (Parameter $paramIndex)',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current value: $currentValue',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(5),
              ],
              decoration: InputDecoration(
                labelText: 'New Value',
                hintText: 'Enter value (0-65535)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 12.h,
                ),
              ),
              autofocus: true,
              onSubmitted: (value) {
                _updateParameter(controller, paramIndex, textController.text);
              },
            ),
            SizedBox(height: 8.h),
            Text(
              'Valid range: 0 to 65535',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _updateParameter(controller, paramIndex, textController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showSetAllDialog(ManualController controller) {
    final textController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text(
          'Set All Boxes',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set all ${controller.numberOfBoxes.value} active boxes to the same value',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(5),
              ],
              decoration: InputDecoration(
                labelText: 'Value',
                hintText: 'Enter value for all boxes',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              ),
              autofocus: true,
            ),
            SizedBox(height: 8.h),
            Text(
              'Valid range: 0 to 65535',
              style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(textController.text);
              if (value != null) {
                controller.setAllParametersTo(value);
                Get.back();
              } else {
                Get.snackbar('Invalid Input', 'Please enter a valid number');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text('Set All'),
          ),
        ],
      ),
    );
  }

  void _updateParameter(ManualController controller, int paramIndex, String newValueStr) {
    final newValue = int.tryParse(newValueStr);

    if (newValue == null) {
      Get.snackbar(
        'Invalid Input',
        'Please enter a valid number',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    controller.updateParameter(paramIndex, newValue);
    Get.back();
  }
}