import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Controller/Inspector/automatic_controller.dart';

class ModbusParametersView extends StatelessWidget {
  const ModbusParametersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller =Get.put(ModbusParametersController());

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
              'Modbus Parameters',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Obx(() => Text(
              'IMEI: ${controller.currentImei.value}',
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
                case 'save':
                  controller.saveParameters();
                  break;
                case 'reset':
                  controller.resetParameters();
                  break;
                case 'refresh':
                  controller.loadInitialData();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'save',
                child: Row(
                  children: [
                    Icon(Icons.save, size: 18.w),
                    SizedBox(width: 8.w),
                    Text('Save Changes'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.refresh, size: 18.w),
                    SizedBox(width: 8.w),
                    Text('Reset All'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.sync, size: 18.w),
                    SizedBox(width: 8.w),
                    Text('Refresh Data'),
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
                  onPressed: controller.loadInitialData,
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
                    'Parameters 50-99',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Grid layout: 5 columns × 10 rows • Tap any cell to edit',
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
                  child: _buildParametersGrid(controller),
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

  Widget _buildParametersGrid(ModbusParametersController controller) {
    return Column(
      children: [
        // Build 10 rows
        for (int row = 0; row < 10; row++)
          Expanded(
            child: Row(
              children: [
                // Build 5 columns in each row
                for (int col = 0; col < 5; col++)
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(1.w),
                      child: _buildParameterCell(
                        controller,
                        50 + (row * 5) + col, // Calculate parameter index
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildParameterCell(ModbusParametersController controller, int paramIndex) {
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
                'P$paramIndex',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: isModified ? Colors.orange[800] : Colors.grey[600],
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

  void _showEditDialog(ModbusParametersController controller, int paramIndex) {
    final currentValue = controller.getParameterValue(paramIndex);
    final textController = TextEditingController(text: currentValue.toString());

    Get.dialog(
      AlertDialog(
        title: Text(
          'Edit Parameter $paramIndex',
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

  void _updateParameter(ModbusParametersController controller, int paramIndex, String newValueStr) {
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