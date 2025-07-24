// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../../../../Controller/Inspector/automatic_controller.dart';
//
// class ModbusParametersView extends StatelessWidget {
//   const ModbusParametersView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     final Map<String, dynamic>? plantData = Get.arguments;
//     print('Received plant data: $plantData');
//     final String? uuid = plantData?['uuid']?.toString();
//     print('UUID: $uuid');
//
//     final controller = Get.put(ModbusParametersController());
//
//     // Set UUID after creation
//     controller.setUuid(uuid);
//     controller.printUuidInfo();
//
//
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         elevation: 2,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Automatic Schedule',
//               style: TextStyle(
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//             ),
//             Obx(() => Text(
//                   'IMEI: ${controller.currentImei.value} | Boxes: ${controller.numberOfBoxes.value}',
//                   style: TextStyle(
//                     fontSize: 12.sp,
//                     fontWeight: FontWeight.w400,
//                     color: Colors.grey[600],
//                   ),
//                 )),
//           ],
//         ),
//         actions: [
//           Obx(
//             () => controller.modifiedCount > 0
//                 ? Container(
//                     margin: EdgeInsets.only(right: 8.w),
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//                     decoration: BoxDecoration(
//                       color: Colors.orange[100],
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                     child: Text(
//                       '${controller.modifiedCount} modified',
//                       style: TextStyle(
//                         fontSize: 11.sp,
//                         color: Colors.orange[800],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   )
//                 : SizedBox(),
//           ),
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               switch (value) {
//                 case 'reset':
//                   controller.resetParameters();
//                   break;
//                 case 'setall':
//                   _showSetAllDialog(controller);
//                   break;
//               }
//             },
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 value: 'setall',
//                 child: Row(
//                   children: [
//                     Icon(Icons.settings_applications, size: 18.w),
//                     SizedBox(width: 8.w),
//                     Text('Set All Boxes'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(),
//                 SizedBox(height: 16.h),
//                 Text(
//                   'Loading parameters...',
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         if (controller.errorMessage.value.isNotEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.error_outline,
//                   size: 48.w,
//                   color: Colors.red[400],
//                 ),
//                 SizedBox(height: 16.h),
//                 Text(
//                   'Error loading data',
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.red[400],
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 32.w),
//                   child: Text(
//                     controller.errorMessage.value,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 24.h),
//                 ElevatedButton.icon(
//                   onPressed: null,
//                   icon: Icon(Icons.refresh, size: 18.w),
//                   label: Text('Retry'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         // Check if no boxes to show
//         if (controller.numberOfBoxes.value == 0) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.inbox_outlined,
//                   size: 48.w,
//                   color: Colors.grey[400],
//                 ),
//                 SizedBox(height: 16.h),
//                 Text(
//                   'No boxes to display',
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 Text(
//                   'Parameter 561 value: ${controller.numberOfBoxes.value}',
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     color: Colors.grey[500],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return Column(
//           children: [
//             // Info header
//             Container(
//               width: double.infinity,
//               margin: EdgeInsets.all(16.w),
//               padding: EdgeInsets.all(16.w),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12.r),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 4,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Active Valve: ${controller.numberOfBoxes.value}',
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     'Parameters ${50} to ${49 + controller.numberOfBoxes.value} • Tap any Valve to edit',
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Parameters grid
//             Expanded(
//               child: Container(
//                 margin: EdgeInsets.symmetric(horizontal: 16.w),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12.r),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 4,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(16.w),
//                   child: _buildDynamicParametersGrid(controller),
//                 ),
//               ),
//             ),
//
//             // Action buttons
//             Container(
//               padding: EdgeInsets.all(16.w),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: controller.modifiedCount > 0
//                           ?  () => _saveWithCustomLoader(context, controller)
//                           : null,
//                       icon: Icon(Icons.save, size: 18.w),
//                       label: Text('Save Changes'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         foregroundColor: Colors.white,
//                         padding: EdgeInsets.symmetric(vertical: 14.h),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.r),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 12.w),
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: controller.resetParameters,
//                       icon: Icon(Icons.refresh, size: 18.w),
//                       label: Text('Reset All'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.grey[700],
//                         padding: EdgeInsets.symmetric(vertical: 14.h),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.r),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
//
//   Widget _buildDynamicParametersGrid(ModbusParametersController controller) {
//     final numberOfBoxes = controller.numberOfBoxes.value;
//
//     // If no boxes, show empty state
//     if (numberOfBoxes == 0) {
//       return Center(
//         child: Text(
//           'No active boxes',
//           style: TextStyle(
//             fontSize: 14.sp,
//             color: Colors.grey[500],
//           ),
//         ),
//       );
//     }
//
//     // Calculate grid dimensions based on number of boxes
//     const int columnsPerRow = 5;
//     final int totalRows = (numberOfBoxes / columnsPerRow).ceil();
//
//     return Column(
//       children: [
//         // Build only the required number of rows
//         for (int row = 0; row < totalRows; row++)
//           Expanded(
//             child: Row(
//               children: [
//                 // Build columns in each row
//                 for (int col = 0; col < columnsPerRow; col++)
//                   () {
//                     final paramIndex = 50 + (row * columnsPerRow) + col;
//                     // Only show if this parameter index is within the active range
//                     if (paramIndex < 50 + numberOfBoxes) {
//                       return Expanded(
//                         child: Container(
//                           margin: EdgeInsets.all(1.w),
//                           child: _buildParameterCell(controller, paramIndex),
//                         ),
//                       );
//                     } else {
//                       // Empty space for unused cells in the last row
//                       return Expanded(child: SizedBox());
//                     }
//                   }(),
//               ],
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildParameterCell(
//       ModbusParametersController controller, int paramIndex) {
//     return Obx(() {
//       final value = controller.getParameterValue(paramIndex);
//       final isModified = controller.isParameterModified(paramIndex);
//
//       return InkWell(
//         onTap: () => _showEditDialog(controller, paramIndex),
//         borderRadius: BorderRadius.circular(8.r),
//         child: Container(
//           height: double.infinity,
//           decoration: BoxDecoration(
//             color: isModified ? Colors.orange[50] : Colors.grey[100],
//             border: Border.all(
//               color: isModified ? Colors.orange[300]! : Colors.grey[300]!,
//               width: isModified ? 2 : 1,
//             ),
//             borderRadius: BorderRadius.circular(8.r),
//           ),
//           padding: EdgeInsets.all(4.w),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 '$paramIndex',
//                 style: TextStyle(
//                   fontSize: 8.sp,
//                   color: isModified ? Colors.orange[700] : Colors.grey[500],
//                 ),
//               ),
//               SizedBox(height: 2.h),
//               Text(
//                 value.toString(),
//                 style: TextStyle(
//                   fontSize: 12.sp,
//                   fontWeight: FontWeight.w600,
//                   color: isModified ? Colors.orange[900] : Colors.black87,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               if (isModified)
//                 Container(
//                   width: 4.w,
//                   height: 4.w,
//                   margin: EdgeInsets.only(top: 2.h),
//                   decoration: BoxDecoration(
//                     color: Colors.orange,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
//
//   void _showEditDialog(ModbusParametersController controller, int paramIndex) {
//     final currentValue = controller.getParameterValue(paramIndex);
//     final textController = TextEditingController(text: currentValue.toString());
//
//     Get.dialog(
//       AlertDialog(
//         title: Text(
//           'Edit Box ${paramIndex - 49} (Parameter $paramIndex)',
//           style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Current value: $currentValue',
//               style: TextStyle(
//                 fontSize: 12.sp,
//                 color: Colors.grey[600],
//               ),
//             ),
//             SizedBox(height: 12.h),
//             TextField(
//               controller: textController,
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//                 LengthLimitingTextInputFormatter(5),
//               ],
//               decoration: InputDecoration(
//                 labelText: 'New Value',
//                 hintText: 'Enter value (0-65535)',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.r),
//                 ),
//                 contentPadding: EdgeInsets.symmetric(
//                   horizontal: 12.w,
//                   vertical: 12.h,
//                 ),
//               ),
//               autofocus: true,
//               onSubmitted: (value) {
//                 _updateParameter(controller, paramIndex, textController.text);
//               },
//             ),
//             SizedBox(height: 8.h),
//             Text(
//               'Valid range: 0 to 65535',
//               style: TextStyle(
//                 fontSize: 11.sp,
//                 color: Colors.grey[500],
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               _updateParameter(controller, paramIndex, textController.text);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue,
//               foregroundColor: Colors.white,
//             ),
//             child: Text('Update'),
//           ),
//         ],
//       ),
//     );
//   }
//   void _showSetAllDialog(ModbusParametersController controller) {
//     final textController = TextEditingController();
//
//     Get.dialog(
//       AlertDialog(
//         title: Text(
//           'Set All Boxes',
//           style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Set all ${controller.numberOfBoxes.value} active boxes to the same value',
//               style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
//             ),
//             SizedBox(height: 16.h),
//             TextField(
//               controller: textController,
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//                 LengthLimitingTextInputFormatter(5),
//               ],
//               decoration: InputDecoration(
//                 labelText: 'Value',
//                 hintText: 'Enter value for all boxes',
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
//               ),
//               autofocus: true,
//             ),
//             SizedBox(height: 8.h),
//             Text(
//               'Valid range: 0 to 65535',
//               style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Get.back();
//               final value = int.tryParse(textController.text);
//               if (value != null) {
//                 controller.setAllParametersTo(value);
//                 Get.back();
//               } else {
//                 Get.snackbar('Invalid Input', 'Please enter a valid number');
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.orange,
//               foregroundColor: Colors.white,
//             ),
//             child: Text('Set All'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // 2. Add these methods to your ModbusParametersView class:
//   void _saveWithCustomLoader(BuildContext context, ModbusParametersController controller) async {
//     try {
//       // Call the original save method
//       await controller.saveParameters();
//
//       // Show custom loader only after successful save
//       _showCustomSuccessLoader(context);
//     } catch (e) {
//       // Handle error if save fails
//       Get.snackbar(
//         'Error',
//         'Failed to save parameters: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red[100],
//         colorText: Colors.red[800],
//       );
//     }
//   }
//
//   void _showCustomSuccessLoader(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         // Auto dismiss after 12 seconds
//         Future.delayed(Duration(seconds: 12), () {
//           if (Navigator.of(context).canPop()) {
//             Navigator.of(context).pop();
//           }
//         });
//
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             padding: EdgeInsets.all(24.w),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16.r),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Success Animation
//                 Container(
//                   width: 80.w,
//                   height: 80.w,
//                   decoration: BoxDecoration(
//                     color: Colors.green[100],
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.check,
//                     size: 50.w,
//                     color: Colors.green[600],
//                   ),
//                 ),
//
//                 SizedBox(height: 24.h),
//
//                 Text(
//                   'Success!',
//                   style: TextStyle(
//                     fontSize: 24.sp,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//
//                 SizedBox(height: 12.h),
//
//                 Text(
//                   'Parameters updated successfully',
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     color: Colors.grey[600],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//
//                 SizedBox(height: 24.h),
//
//                 // Loading indicator
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: 20.w,
//                       height: 20.w,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.green[600]!),
//                       ),
//                     ),
//                     SizedBox(width: 12.w),
//                     Text(
//                       'Refreshing data...',
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void _updateParameter(ModbusParametersController controller, int paramIndex,
//       String newValueStr) {
//     final newValue = int.tryParse(newValueStr);
//
//     if (newValue == null) {
//       Get.snackbar(
//         'Invalid Input',
//         'Please enter a valid number',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     controller.updateParameter(paramIndex, newValue);
//     Get.back();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Controller/Inspector/automatic_controller.dart';

class ModbusParametersView extends StatelessWidget {
  const ModbusParametersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? plantData = Get.arguments;
    print('Received plant data: $plantData');
    final String? uuid = plantData?['uuid']?.toString();
    print('UUID: $uuid');

    final controller = Get.put(ModbusParametersController());

    // Set UUID after creation
    controller.setUuid(uuid);
    controller.printUuidInfo();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Automatic Schedule',
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
          Obx(
                () => controller.modifiedCount > 0
                ? Container(
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.orange[300]!, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit, size: 14.w, color: Colors.orange[700]),
                  SizedBox(width: 4.w),
                  Text(
                    '${controller.modifiedCount}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.orange[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
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
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
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
                  size: 64.w,
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
            // Info header with better design
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[50]!, Colors.blue[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.blue[200]!, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.developer_board,
                      color: Colors.white,
                      size: 20.w,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Active Valves: ${controller.numberOfBoxes.value}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[800],
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Parameters ${50} to ${49 + controller.numberOfBoxes.value} • Tap any valve to edit',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.blue[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Parameters grid with scroll
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: _buildImprovedParametersGrid(controller),
                  ),
                ),
              ),
            ),

            // Action buttons with better design
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.modifiedCount > 0
                          ? () => _saveWithCustomLoader(context, controller)
                          : null,
                      icon: Icon(Icons.save, size: 18.w),
                      label: Text('Save Changes (${controller.modifiedCount})'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.modifiedCount > 0
                            ? Colors.green
                            : Colors.grey[300],
                        foregroundColor: controller.modifiedCount > 0
                            ? Colors.white
                            : Colors.grey[500],
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: controller.modifiedCount > 0 ? 2 : 0,
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
                        side: BorderSide(color: Colors.grey[300]!),
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

  Widget _buildImprovedParametersGrid(ModbusParametersController controller) {
    final numberOfBoxes = controller.numberOfBoxes.value;

    if (numberOfBoxes == 0) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Text(
            'No active boxes',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
          ),
        ),
      );
    }

    // Responsive grid with better spacing
    final screenWidth = Get.width - 64.w; // Account for margins and padding
    final cellWidth = (screenWidth / 6).clamp(60.0, 80.0); // 6 columns max, min 60, max 80
    final columnsPerRow = (screenWidth / cellWidth).floor().clamp(3, 6);
    final totalRows = (numberOfBoxes / columnsPerRow).ceil();

    return Column(
      children: [
        for (int row = 0; row < totalRows; row++)
          Container(
            margin: EdgeInsets.only(bottom: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int col = 0; col < columnsPerRow; col++)
                      () {
                    final paramIndex = 50 + (row * columnsPerRow) + col;
                    if (paramIndex < 50 + numberOfBoxes) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 3.w),
                          child: _buildImprovedParameterCell(controller, paramIndex),
                        ),
                      );
                    } else {
                      return Expanded(child: SizedBox());
                    }
                  }(),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildImprovedParameterCell(
      ModbusParametersController controller, int paramIndex) {
    return Obx(() {
      final value = controller.getParameterValue(paramIndex);
      final isModified = controller.isParameterModified(paramIndex);
      final boxNumber = paramIndex - 49;

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showEditDialog(controller, paramIndex),
          borderRadius: BorderRadius.circular(12.r),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: 70.h,
            decoration: BoxDecoration(
              gradient: isModified
                  ? LinearGradient(
                colors: [Colors.orange[50]!, Colors.orange[100]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
                  : LinearGradient(
                colors: [Colors.grey[50]!, Colors.grey[100]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: isModified ? Colors.orange[400]! : Colors.grey[300]!,
                width: isModified ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: isModified
                  ? [BoxShadow(
                color: Colors.orange.withOpacity(0.2),
                blurRadius: 4,
                offset: Offset(0, 2),
              )]
                  : [BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
                offset: Offset(0, 1),
              )],
            ),
            child: Stack(
              children: [
                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$paramIndex',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: isModified ? Colors.orange[700] : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        value.toString(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: isModified ? Colors.orange[900] : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Modified indicator
                if (isModified)
                  Positioned(
                    top: 4.h,
                    right: 4.w,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: Colors.orange[600],
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _showEditDialog(ModbusParametersController controller, int paramIndex) {
    final currentValue = controller.getParameterValue(paramIndex);
    final textController = TextEditingController(text: currentValue.toString());
    final boxNumber = paramIndex - 49;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.edit,
                size: 20.w,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Valve $boxNumber',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Parameter $paramIndex',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16.w, color: Colors.blue[700]),
                  SizedBox(width: 8.w),
                  Text(
                    'Current value: $currentValue',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
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
                labelText: 'New Value',
                hintText: 'Enter value (0-65535)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 12.h,
                ),
                prefixIcon: Icon(Icons.numbers),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showSetAllDialog(ModbusParametersController controller) {
    final textController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.settings_applications,
                size: 20.w,
                color: Colors.orange[700],
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Set All Valves',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Text(
                'Set all ${controller.numberOfBoxes.value} active valves to the same value',
                style: TextStyle(fontSize: 14.sp, color: Colors.orange[700]),
              ),
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
                labelText: 'Value for All Valves',
                hintText: 'Enter value for all valves',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                prefixIcon: Icon(Icons.numbers),
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
              if (value != null && value >= 0 && value <= 65535) {
                controller.setAllParametersTo(value);
                Get.back();
                Get.snackbar(
                  'Success',
                  'All valves set to $value',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green[100],
                  colorText: Colors.green[800],
                );
              } else {
                Get.snackbar(
                  'Invalid Input',
                  'Please enter a valid number between 0 and 65535',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red[100],
                  colorText: Colors.red[800],
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text('Set All'),
          ),
        ],
      ),
    );
  }

  void _saveWithCustomLoader(BuildContext context, ModbusParametersController controller) async {
    try {
      await controller.saveParameters();
      _showCustomSuccessLoader(context);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save parameters: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  void _showCustomSuccessLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Auto dismiss after 12 seconds
        Future.delayed(Duration(seconds: 12), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Animation
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 50.w,
                    color: Colors.green[600],
                  ),
                ),

                SizedBox(height: 24.h),

                Text(
                  'Success!',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),

                SizedBox(height: 12.h),

                Text(
                  'Parameters updated successfully',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24.h),

                // Loading indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.green[600]!),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Refreshing data...',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

        void _updateParameter(ModbusParametersController controller, int paramIndex, String newValueStr) {
      final newValue = int.tryParse(newValueStr);

      if (newValue == null || newValue < 0 || newValue > 65535) {
        Get.snackbar(
          'Invalid Input',
          'Please enter a valid number between 0 and 65535',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
        return;
      }

      controller.updateParameter(paramIndex, newValue);
      Get.back();
    }
  }