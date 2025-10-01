// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:solar_app/Controller/Inspector/plant_inspection_controller.dart';
// import '../../../utils/drop_down.dart';
//
// class StartInspection extends StatefulWidget {
//   const StartInspection({super.key});
//
//   @override
//   State<StartInspection> createState() => _StartInspectionState();
// }
//
// class _StartInspectionState extends State<StartInspection> {
//   PlantInspectionController? controller;
//   final Map<String, dynamic> inspectionData = Get.arguments ?? {};
//   String? controllerTag;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Create unique controller tag for this inspection
//     controllerTag =
//         "inspection_${inspectionData['id'] ?? DateTime.now().millisecondsSinceEpoch}";
//
//     // Initialize controller with unique tag
//     // controller = Get.put(PlantInspectionController(), tag: controllerTag!);
//     controller = Get.put(PlantInspectionController(),
//         tag: controllerTag!, permanent: true);
//
//     // Use addPostFrameCallback to ensure the widget tree is fully built
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _initializeFormData();
//
//       // Set unique inspection ID for SharedPreferences
//       String inspectionId = inspectionData['id']?.toString() ??
//           DateTime.now().millisecondsSinceEpoch.toString();
//
//       // IMPORTANT: Set inspection ID before calling getCheckList
//       controller!.setInspectionId(inspectionId);
//
//       // Fetch inspector data if inspection ID exists
//       if (inspectionData['id'] != null) {
//         controller!.fetchInspectorData(inspectionData['id']);
//       }
//
//       // Load checklist data (this will now work with proper inspection ID)
//       controller!.getCheckList();
//     });
//   }
//
//   void _initializeFormData() {
//     controller!.dateController.text = DateTime.now().toString().split(' ')[0];
//     controller!.timeController.text = TimeOfDay.now().format(context);
//     controller!.selectedStatus.value = 'pending';
//     controller!.uploadedImagePath.value = null;
//     controller!.inspectorReviewController.clear();
//     controller!.clientReviewController.clear();
//   }
//
//   @override
//   void dispose() {
//     if (controllerTag != null) {
//       Get.delete<PlantInspectionController>(tag: controllerTag!);
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (controller == null) {
//       return const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           'Start Inspection',
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.w500,
//             fontSize: 18 * 0.9.sp,
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black, size: 24 * 0.9.sp),
//           onPressed: () =>Navigator.of(context).pop(),
//         ),
//       ),
//       body: Obx(() {
//         if (!controller!.isDataLoaded.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         return SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16 * 0.9.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 16 * 0.9.h),
//                 Row(
//                   children: [
//                     Container(
//                       width: 8 * 0.9.w,
//                       height: 8 * 0.9.h,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.blue,
//                       ),
//                     ),
//                     SizedBox(width: 8 * 0.9.w),
//                     Text(
//                       'Ready for Inspection',
//                       style: TextStyle(
//                         color: Colors.blue,
//                         fontSize: 12 * 0.9.sp,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16 * 0.9.h),
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.all(16 * 0.9.r),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12 * 0.9.r),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 8 * 0.9.r,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         inspectionData['plant_name'] ?? 'Unknown Plant',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18 * 0.9.sp,
//                         ),
//                       ),
//                       SizedBox(height: 8 * 0.9.h),
//                       RichText(
//                         text: TextSpan(
//                           style: TextStyle(
//                             color: Colors.black87,
//                             fontSize: 14 * 0.9.sp,
//                           ),
//                           children: [
//                             const TextSpan(
//                               text: 'Scheduled: ',
//                               style: TextStyle(fontWeight: FontWeight.w500),
//                             ),
//                             TextSpan(
//                               text: inspectionData['time'] ?? 'Not set',
//                               style:
//                                   const TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 4 * 0.9.h),
//                       Row(
//                         children: [
//                           Text(
//                             'Inspector: ',
//                             style: TextStyle(
//                               fontSize: 14 * 0.9.sp,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           Text(
//                             inspectionData['inspector_name'] ?? 'Not assigned',
//                             style: TextStyle(
//                               color: Colors.blue,
//                               fontSize: 14 * 0.9.sp,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 16 * 0.9.h),
//                       Container(
//                         padding: EdgeInsets.all(8 * 0.9.r),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(8 * 0.9.r),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Location',
//                               style: TextStyle(
//                                 fontSize: 11 * 0.9.sp,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.grey[700],
//                               ),
//                             ),
//                             SizedBox(height: 4 * 0.9.h),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     inspectionData['plant_address'] ??
//                                         'Unknown Location',
//                                     style: TextStyle(
//                                       fontSize: 12 * 0.9.sp,
//                                       color: Colors.grey[600],
//                                     ),
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                                 Icon(
//                                   Icons.near_me,
//                                   color: Colors.blue,
//                                   size: 20 * 0.9.r,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 24 * 0.9.h),
//                 Form(
//                   key: controller!.formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Cleaner Status',
//                         style: TextStyle(
//                           fontSize: 18 * 0.9.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 15 * 0.9.h),
//                       Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.all(16 * 0.9.r),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12 * 0.9.r),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//                               blurRadius: 8 * 0.9.r,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             CircleAvatar(
//                               radius: 24 * 0.9.r,
//                               backgroundColor: Colors.blue[100],
//                               child: Icon(
//                                 Icons.cleaning_services,
//                                 color: Colors.blue,
//                                 size: 24 * 0.9.r,
//                               ),
//                             ),
//                             SizedBox(width: 16 * 0.9.w),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     inspectionData['cleaner_name'] ??
//                                         'Cleaner Name',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16 * 0.9.sp,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 24 * 0.9.h),
//                       TextFormField(
//                         controller: controller!.dateController,
//                         readOnly: true,
//                         decoration: InputDecoration(
//                           labelText: 'Date',
//                           prefixIcon:
//                               Icon(Icons.calendar_today, size: 20 * 0.9.sp),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12 * 0.9.r),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 16 * 0.9.h),
//                       TextFormField(
//                         controller: controller!.timeController,
//                         readOnly: true,
//                         decoration: InputDecoration(
//                           labelText: 'Time',
//                           prefixIcon:
//                               Icon(Icons.access_time, size: 20 * 0.9.sp),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12 * 0.9.r),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 16 * 0.9.h),
//                       Obx(() => CustomDropdownField<String>(
//                             value: controller!.selectedStatus.value.isEmpty
//                                 ? null
//                                 : controller!.selectedStatus.value,
//                             labelText: 'Status',
//                             prefixIcon: Icons.flag,
//                             items: controller!.statusOptions,
//                             itemLabelBuilder: (status) => status,
//                             isRequired: true,
//                             onChanged: (value) {
//                               if (value != null) {
//                                 controller!.selectedStatus.value = value;
//                               }
//                             },
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please select status';
//                               }
//                               return null;
//                             },
//                           )),
//                       SizedBox(height: 16 * 0.9.h),
//
//                       buildChecklistSection(controller!),
//
//                       //------------I Need Checklist Here --------------------//
//
//                       Text(
//                         'Upload Inspection Photos',
//                         style: TextStyle(
//                           fontSize: 16 * 0.9.sp,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       SizedBox(height: 8 * 0.9.h),
//                       Obx(() {
//                         final imagePaths = controller!.uploadedImagePaths;
//                         final isUploading = controller!.isUploadingImage.value;
//
//                         if (imagePaths.isEmpty && !isUploading) {
//                           return GestureDetector(
//                             onTap: controller!.uploadImage,
//                             child: Container(
//                               width: double.infinity,
//                               height: 120 * 0.9.h,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[200],
//                                 borderRadius: BorderRadius.circular(12 * 0.9.r),
//                                 border: Border.all(color: Colors.grey[300]!),
//                               ),
//                               child: Center(
//                                 child: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Container(
//                                       padding: EdgeInsets.all(12 * 0.9.r),
//                                       decoration: BoxDecoration(
//                                         color: Colors.blue.withOpacity(0.1),
//                                         borderRadius:
//                                             BorderRadius.circular(12 * 0.9.r),
//                                       ),
//                                       child: Icon(
//                                         Icons.add_a_photo,
//                                         color: Colors.blue,
//                                         size: 32 * 0.9.r,
//                                       ),
//                                     ),
//                                     SizedBox(height: 8 * 0.9.h),
//                                     Text(
//                                       'Add Inspection Photos',
//                                       style: TextStyle(
//                                         fontSize: 14 * 0.9.sp,
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.grey[700],
//                                       ),
//                                     ),
//                                     SizedBox(height: 4 * 0.9.h),
//                                     Text(
//                                       'Camera • Gallery • Multiple',
//                                       style: TextStyle(
//                                         fontSize: 12 * 0.9.sp,
//                                         color: Colors.grey[500],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         }
//
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   '${imagePaths.length} Photo${imagePaths.length == 1 ? '' : 's'} Added',
//                                   style: TextStyle(
//                                     fontSize: 14 * 0.9.sp,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.grey[700],
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: isUploading
//                                       ? null
//                                       : controller!.uploadImage,
//                                   child: Container(
//                                     padding: EdgeInsets.symmetric(
//                                       horizontal: 12 * 0.9.w,
//                                       vertical: 6 * 0.9.h,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: Colors.blue,
//                                       borderRadius:
//                                           BorderRadius.circular(20 * 0.9.r),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Icon(
//                                           Icons.add,
//                                           color: Colors.white,
//                                           size: 16 * 0.9.r,
//                                         ),
//                                         SizedBox(width: 4 * 0.9.w),
//                                         Text(
//                                           'Add More',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 12 * 0.9.sp,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 12 * 0.9.h),
//                             GridView.builder(
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 3,
//                                 crossAxisSpacing: 8 * 0.9.w,
//                                 mainAxisSpacing: 8 * 0.9.h,
//                                 childAspectRatio: 1,
//                               ),
//                               itemCount:
//                                   imagePaths.length + (isUploading ? 1 : 0),
//                               itemBuilder: (context, index) {
//                                 if (isUploading && index == imagePaths.length) {
//                                   return Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey[200],
//                                       borderRadius:
//                                           BorderRadius.circular(12 * 0.9.r),
//                                       border:
//                                           Border.all(color: Colors.grey[300]!),
//                                     ),
//                                     child: const Center(
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2,
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                                 Colors.blue),
//                                       ),
//                                     ),
//                                   );
//                                 }
//
//                                 final imagePath = imagePaths[index];
//                                 return GestureDetector(
//                                   onTap: () => controller!
//                                       .viewImageFullScreen(imagePath),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       borderRadius:
//                                           BorderRadius.circular(12 * 0.9.r),
//                                       border:
//                                           Border.all(color: Colors.grey[300]!),
//                                     ),
//                                     child: Stack(
//                                       children: [
//                                         ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(12 * 0.9.r),
//                                           child: Image.file(
//                                             File(imagePath),
//                                             fit: BoxFit.cover,
//                                             width: double.infinity,
//                                             height: double.infinity,
//                                           ),
//                                         ),
//                                         Positioned(
//                                           top: 4 * 0.9.h,
//                                           right: 4 * 0.9.w,
//                                           child: GestureDetector(
//                                             onTap: () =>
//                                                 controller!.removeImage(index),
//                                             child: Container(
//                                               padding:
//                                                   EdgeInsets.all(4 * 0.9.r),
//                                               decoration: BoxDecoration(
//                                                 color:
//                                                     Colors.red.withOpacity(0.8),
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                         12 * 0.9.r),
//                                               ),
//                                               child: Icon(
//                                                 Icons.close,
//                                                 color: Colors.white,
//                                                 size: 12 * 0.9.r,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Positioned(
//                                           bottom: 4 * 0.9.h,
//                                           right: 4 * 0.9.w,
//                                           child: Container(
//                                             padding: EdgeInsets.all(4 * 0.9.r),
//                                             decoration: BoxDecoration(
//                                               color:
//                                                   Colors.black.withOpacity(0.6),
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                       12 * 0.9.r),
//                                             ),
//                                             child: Icon(
//                                               Icons.zoom_in,
//                                               color: Colors.white,
//                                               size: 12 * 0.9.r,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         );
//                       }),
//                       SizedBox(height: 16 * 0.9.h),
//                       TextFormField(
//                         controller: controller!.inspectorReviewController,
//                         maxLines: 4,
//                         maxLength: 255,
//                         decoration: InputDecoration(
//                           labelText: 'Inspector Review *',
//                           hintText: 'Describe inspection findings...',
//                           hintStyle: TextStyle(
//                               color: Colors.grey[400], fontSize: 14 * 0.9.sp),
//                           prefixIcon:
//                               Icon(Icons.rate_review, size: 20 * 0.9.sp),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12 * 0.9.r),
//                           ),
//                           alignLabelWithHint: true,
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please provide inspector review';
//                           }
//                           if (value.length > 255) {
//                             return 'Review cannot exceed 255 characters';
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: 16 * 0.9.h),
//                       TextFormField(
//                         controller: controller!.clientReviewController,
//                         maxLines: 3,
//                         maxLength: 255,
//                         decoration: InputDecoration(
//                           labelText: 'Client Review (Optional)',
//                           hintText: 'Add client feedback...',
//                           hintStyle: TextStyle(
//                               color: Colors.grey[400], fontSize: 14 * 0.9.sp),
//                           prefixIcon: Icon(Icons.comment, size: 20 * 0.9.sp),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12 * 0.9.r),
//                           ),
//                           alignLabelWithHint: true,
//                         ),
//                         validator: (value) {
//                           if (value != null && value.length > 255) {
//                             return 'Review cannot exceed 255 characters';
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: 24 * 0.9.h),
//                       SizedBox(
//                         width: double.infinity,
//                         height: 50 * 0.9.h,
//                         child: Obx(() => ElevatedButton(
//                               onPressed: controller!.isSubmitting.value
//                                   ? null
//                                   : () => controller!.updateInspectionReport(),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.black,
//                                 foregroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.circular(12 * 0.9.r),
//                                 ),
//                                 disabledBackgroundColor: Colors.grey,
//                               ),
//                               child: controller!.isSubmitting.value
//                                   ? const CircularProgressIndicator(
//                                       color: Colors.white)
//                                   : Text(
//                                       'Submit Inspection Report',
//                                       style: TextStyle(
//                                         fontSize: 16 * 0.9.sp,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                             )),
//                       ),
//                       SizedBox(height: 24 * 0.9.h),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget buildChecklistSection(
//       PlantInspectionController plantInspectionController) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text(
//               'Inspection Checklist',
//               style: TextStyle(
//                 fontSize: 18 * 0.9.sp,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Spacer(),
//             Obx(() => Text(
//                   '${plantInspectionController.checklistItems.where((item) => item['checked'] == 1).length}/${plantInspectionController.checklistItems.length} Complete',
//                   style: TextStyle(
//                     fontSize: 14 * 0.9.sp,
//                     color: Colors.blue,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 )),
//           ],
//         ),
//         SizedBox(height: 12 * 0.9.h),
//         Obx(() {
//           if (plantInspectionController.isLoadingChecklist.value) {
//             return Container(
//               height: 100 * 0.9.h,
//               child: Center(child: CircularProgressIndicator()),
//             );
//           }
//
//           if (plantInspectionController.checklistItems.isEmpty) {
//             return Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(20 * 0.9.r),
//               decoration: BoxDecoration(
//                 color: Colors.grey[50],
//                 borderRadius: BorderRadius.circular(12 * 0.9.r),
//                 border: Border.all(color: Colors.grey[200]!),
//               ),
//               child: Column(
//                 children: [
//                   Icon(
//                     Icons.checklist_outlined,
//                     size: 48 * 0.9.r,
//                     color: Colors.grey[400],
//                   ),
//                   SizedBox(height: 8 * 0.9.h),
//                   Text(
//                     'No Checklist Items',
//                     style: TextStyle(
//                       fontSize: 16 * 0.9.sp,
//                       color: Colors.grey[600],
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   Text(
//                     'Checklist items will appear here',
//                     style: TextStyle(
//                       fontSize: 12 * 0.9.sp,
//                       color: Colors.grey[500],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           return Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12 * 0.9.r),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 8 * 0.9.r,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 // Progress Bar
//                 Container(
//                   margin: EdgeInsets.all(16 * 0.9.r),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Progress',
//                             style: TextStyle(
//                               fontSize: 12 * 0.9.sp,
//                               color: Colors.grey[600],
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           Text(
//                             '${((plantInspectionController.checklistItems.where((item) => item['checked'] == 1).length / plantInspectionController.checklistItems.length) * 100).toInt()}%',
//                             style: TextStyle(
//                               fontSize: 12 * 0.9.sp,
//                               color: Colors.blue,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 8 * 0.9.h),
//                       LinearProgressIndicator(
//                         value: plantInspectionController.checklistItems
//                                 .where((item) => item['checked'] == 1)
//                                 .length /
//                             plantInspectionController.checklistItems.length,
//                         backgroundColor: Colors.grey[200],
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//                         minHeight: 6 * 0.9.h,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Divider(height: 1, color: Colors.grey[200]),
//                 // Checklist Items
//                 ListView.separated(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: plantInspectionController.checklistItems.length,
//                   separatorBuilder: (context, index) => Divider(
//                     height: 1,
//                     color: Colors.grey[100],
//                     indent: 16 * 0.9.w,
//                     endIndent: 16 * 0.9.w,
//                   ),
//                   itemBuilder: (context, index) {
//                     final item =
//                         plantInspectionController.checklistItems[index];
//                     final isChecked = item['checked'] == 1;
//
//                     return InkWell(
//                       onTap: () =>
//                           plantInspectionController.toggleChecklistItem(index),
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 16 * 0.9.w,
//                           vertical: 12 * 0.9.h,
//                         ),
//                         child: Row(
//                           children: [
//                             // Custom Checkbox
//                             AnimatedContainer(
//                               duration: Duration(milliseconds: 200),
//                               width: 24 * 0.9.w,
//                               height: 24 * 0.9.h,
//                               decoration: BoxDecoration(
//                                 color: isChecked
//                                     ? Colors.blue
//                                     : Colors.transparent,
//                                 border: Border.all(
//                                   color: isChecked
//                                       ? Colors.blue
//                                       : Colors.grey[400]!,
//                                   width: 2,
//                                 ),
//                                 borderRadius: BorderRadius.circular(4 * 0.9.r),
//                               ),
//                               child: isChecked
//                                   ? Icon(
//                                       Icons.check,
//                                       size: 16 * 0.9.r,
//                                       color: Colors.white,
//                                     )
//                                   : null,
//                             ),
//                             SizedBox(width: 12 * 0.9.w),
//
//                             // Item Details
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     item['item_name'] ?? 'Unknown Item',
//                                     style: TextStyle(
//                                       fontSize: 15 * 0.9.sp,
//                                       fontWeight: FontWeight.w500,
//                                       color: isChecked
//                                           ? Colors.grey[600]
//                                           : Colors.black87,
//                                       decoration: isChecked
//                                           ? TextDecoration.lineThrough
//                                           : null,
//                                     ),
//                                   ),
//                                   if (item['info'] != null) ...[
//                                     SizedBox(height: 2 * 0.9.h),
//                                     Container(
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: 8 * 0.9.w,
//                                         vertical: 2 * 0.9.h,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: _getTypeColor(item['info'])
//                                             .withOpacity(0.1),
//                                         borderRadius:
//                                             BorderRadius.circular(12 * 0.9.r),
//                                         border: Border.all(
//                                           color: _getTypeColor(item['info'])
//                                               .withOpacity(0.3),
//                                           width: 1,
//                                         ),
//                                       ),
//                                       child: Text(
//                                         item['info'],
//                                         style: TextStyle(
//                                           fontSize: 10 * 0.9.sp,
//                                           color: _getTypeColor(item['type']),
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ],
//                               ),
//                             ),
//
//                             // Status Indicator
//                             Container(
//                               width: 8 * 0.9.w,
//                               height: 8 * 0.9.h,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color:
//                                     isChecked ? Colors.green : Colors.grey[300],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           );
//         }),
//         SizedBox(height: 24 * 0.9.h),
//       ],
//     );
//   }
//
// // Helper method for type colors
//   Color _getTypeColor(String type) {
//     switch (type.toLowerCase()) {
//       case ' a':
//         return Colors.blue;
//       case ' b':
//         return Colors.green;
//       case 'd':
//         return Colors.orange;
//       default:
//         return Colors.blue;
//     }
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solar_app/Controller/Inspector/plant_inspection_controller.dart';
import '../../../utils/drop_down.dart';

const double _sizeScaleFactor = 0.8;

class StartInspection extends StatefulWidget {
  const StartInspection({super.key});

  @override
  State<StartInspection> createState() => _StartInspectionState();
}

class _StartInspectionState extends State<StartInspection> {
  PlantInspectionController? controller;
  final Map<String, dynamic> inspectionData = Get.arguments ?? {};
  String? controllerTag;

  @override
  void initState() {
    super.initState();
    controllerTag =
        "inspection_${inspectionData['id'] ?? DateTime.now().millisecondsSinceEpoch}";
    controller = Get.put(PlantInspectionController(),
        tag: controllerTag!, permanent: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeFormData();
      String inspectionId = inspectionData['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString();
      controller!.setInspectionId(inspectionId);
      if (inspectionData['id'] != null) {
        controller!.fetchInspectorData(inspectionData['id'], context);
      }
      controller!.getCheckList();
    });
  }

  void _initializeFormData() {
    controller!.dateController.text = DateTime.now().toString().split(' ')[0];
    controller!.timeController.text = TimeOfDay.now().format(context);
    controller!.selectedStatus.value = 'pending';
    controller!.uploadedImagePath.value = null;
    controller!.inspectorReviewController.clear();
    controller!.clientReviewController.clear();
  }

  @override
  void dispose() {
    if (controllerTag != null) {
      Get.delete<PlantInspectionController>(tag: controllerTag!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Start Inspection',
          style: TextStyle(
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w600,
            fontSize: (20.sp) * _sizeScaleFactor,
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all((8.r) * _sizeScaleFactor),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular((12.r) * _sizeScaleFactor),
            ),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.blue,
              size: (18.r) * _sizeScaleFactor,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (!controller!.isDataLoaded.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                SizedBox(height: (16.h) * _sizeScaleFactor),
                Text(
                  'Loading inspection data...',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: (16.sp) * _sizeScaleFactor,
                  ),
                ),
              ],
            ),
          );
        }
        return SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: (20.w) * _sizeScaleFactor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: (20.h) * _sizeScaleFactor),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: (16.w) * _sizeScaleFactor,
                      vertical: (8.h) * _sizeScaleFactor),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius:
                        BorderRadius.circular((25.r) * _sizeScaleFactor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: (8.w) * _sizeScaleFactor,
                        height: (8.h) * _sizeScaleFactor,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: (8.w) * _sizeScaleFactor),
                      Text(
                        'Ready for Inspection',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: (14.sp) * _sizeScaleFactor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: (24.h) * _sizeScaleFactor),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular((20.r) * _sizeScaleFactor),
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -(20.h) * _sizeScaleFactor,
                        right: -(20.w) * _sizeScaleFactor,
                        child: Container(
                          width: (80.w) * _sizeScaleFactor,
                          height: (80.h) * _sizeScaleFactor,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.shade100.withOpacity(0.3),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all((20.r) * _sizeScaleFactor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.all((12.r) * _sizeScaleFactor),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(
                                        (12.r) * _sizeScaleFactor),
                                  ),
                                  child: Icon(
                                    Icons.solar_power,
                                    color: Colors.white,
                                    size: (24.r) * _sizeScaleFactor,
                                  ),
                                ),
                                SizedBox(width: (16.w) * _sizeScaleFactor),
                                Expanded(
                                  child: Text(
                                    inspectionData['plant_name'] ??
                                        'Unknown Plant',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: (20.sp) * _sizeScaleFactor,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: (16.h) * _sizeScaleFactor),
                            Container(
                              padding:
                                  EdgeInsets.all((12.r) * _sizeScaleFactor),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    (12.r) * _sizeScaleFactor),
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.schedule,
                                          color: Colors.blue,
                                          size: (18.r) * _sizeScaleFactor),
                                      SizedBox(width: (8.w) * _sizeScaleFactor),
                                      Text(
                                        'Scheduled: ',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: (14.sp) * _sizeScaleFactor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        inspectionData['time'] ?? 'Not set',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: (14.sp) * _sizeScaleFactor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: (8.h) * _sizeScaleFactor),
                                  Row(
                                    children: [
                                      Icon(Icons.person,
                                          color: Colors.blue,
                                          size: (18.r) * _sizeScaleFactor),
                                      SizedBox(width: (8.w) * _sizeScaleFactor),
                                      Text(
                                        'Inspector: ',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: (14.sp) * _sizeScaleFactor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        inspectionData['inspector_name'] ??
                                            'Not assigned',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: (14.sp) * _sizeScaleFactor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: (8.h) * _sizeScaleFactor),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.blue,
                                        size: (16.r) * _sizeScaleFactor,
                                      ),
                                      SizedBox(width: (8.w) * _sizeScaleFactor),
                                      Text(
                                        'Location: ',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: (14.sp) * _sizeScaleFactor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        inspectionData['plant_address'] ??
                                            'Unknown Location',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: (14.sp) * _sizeScaleFactor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: (32.h) * _sizeScaleFactor),
                Form(
                  key: controller!.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cleaner Information',
                        style: TextStyle(
                          fontSize: (22.sp) * _sizeScaleFactor,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      SizedBox(height: (16.h) * _sizeScaleFactor),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all((10.r) * _sizeScaleFactor),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular((16.r) * _sizeScaleFactor),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding:
                                  EdgeInsets.all((16.r) * _sizeScaleFactor),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(
                                    (16.r) * _sizeScaleFactor),
                              ),
                              child: Icon(
                                Icons.cleaning_services,
                                color: Colors.white,
                                size: (20.r) * _sizeScaleFactor,
                              ),
                            ),
                            SizedBox(width: (16.w) * _sizeScaleFactor),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    inspectionData['cleaner_name'] ??
                                        'Cleaner Name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: (17.sp) * _sizeScaleFactor,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  SizedBox(height: (4.h) * _sizeScaleFactor),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: (8.w) * _sizeScaleFactor,
                                        vertical: (4.h) * _sizeScaleFactor),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(
                                          (12.r) * _sizeScaleFactor),
                                    ),
                                    child: Text(
                                      'Active',
                                      style: TextStyle(
                                        color: Colors.green.shade700,
                                        fontSize: (10.sp) * _sizeScaleFactor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: (32.h) * _sizeScaleFactor),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: controller!.dateController,
                              label: 'Date',
                              icon: Icons.calendar_today,
                              readOnly: true,
                            ),
                          ),
                          SizedBox(
                              width: (12.w) *
                                  _sizeScaleFactor), // Space between fields
                          Expanded(
                            child: _buildTextField(
                              controller: controller!.timeController,
                              label: 'Time',
                              icon: Icons.access_time,
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: (20.h) * _sizeScaleFactor),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular((16.r) * _sizeScaleFactor),
                        ),
                        child: Obx(() => CustomDropdownField<String>(
                              value: controller!.selectedStatus.value.isEmpty
                                  ? null
                                  : controller!.selectedStatus.value,
                              labelText: 'Status',
                              prefixIcon: Icons.flag,
                              items: controller!.statusOptions,
                              itemLabelBuilder: (status) => status,
                              isRequired: true,
                              onChanged: (value) {
                                if (value != null) {
                                  controller!.selectedStatus.value = value;
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select status';
                                }
                                return null;
                              },
                            )),
                      ),
                      SizedBox(height: (32.h) * _sizeScaleFactor),
                      buildChecklistSection(controller!),
                      Text(
                        'Inspection Photos',
                        style: TextStyle(
                          fontSize: (20.sp) * _sizeScaleFactor,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      SizedBox(height: (16.h) * _sizeScaleFactor),
                      _buildPhotoSection(),
                      SizedBox(height: (32.h) * _sizeScaleFactor),
                      _buildTextArea(
                        controller: controller!.inspectorReviewController,
                        label: 'Inspector Review *',
                        hint: 'Describe inspection findings...',
                        icon: Icons.rate_review,
                        maxLines: 4,
                        isRequired: true,
                      ),
                      SizedBox(height: (20.h) * _sizeScaleFactor),
                      _buildTextArea(
                        controller: controller!.clientReviewController,
                        label: 'Client Review (Optional)',
                        hint: 'Add client feedback...',
                        icon: Icons.comment,
                        maxLines: 3,
                      ),
                      SizedBox(height: (40.h) * _sizeScaleFactor),
                      _buildSubmitButton(),
                      SizedBox(height: (32.h) * _sizeScaleFactor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((16.r) * _sizeScaleFactor),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        style: TextStyle(
          fontSize: (16.sp) * _sizeScaleFactor,
          color: Colors.grey.shade800,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.blue,
            fontSize: (14.sp) * _sizeScaleFactor,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all((12.r) * _sizeScaleFactor),
            padding: EdgeInsets.all((8.r) * _sizeScaleFactor),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular((8.r) * _sizeScaleFactor),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: (18.r) * _sizeScaleFactor,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular((16.r) * _sizeScaleFactor),
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular((16.r) * _sizeScaleFactor),
            borderSide: BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular((16.r) * _sizeScaleFactor),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
              horizontal: (16.w) * _sizeScaleFactor,
              vertical: (16.h) * _sizeScaleFactor),
        ),
      ),
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required int maxLines,
    bool isRequired = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((16.r) * _sizeScaleFactor),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        maxLength: 255,
        style: TextStyle(
          fontSize: (16.sp) * _sizeScaleFactor,
          color: Colors.grey.shade800,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: (14.sp) * _sizeScaleFactor,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: (14.sp) * _sizeScaleFactor,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all((12.r) * _sizeScaleFactor),
            padding: EdgeInsets.all((8.r) * _sizeScaleFactor),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular((8.r) * _sizeScaleFactor),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: (18.r) * _sizeScaleFactor,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular((16.r) * _sizeScaleFactor),
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular((16.r) * _sizeScaleFactor),
            borderSide: BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular((16.r) * _sizeScaleFactor),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.symmetric(
              horizontal: (16.w) * _sizeScaleFactor,
              vertical: (16.h) * _sizeScaleFactor),
        ),
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return 'Please provide ${label.toLowerCase().replaceAll('*', '').trim()}';
          }
          if (value != null && value.length > 255) {
            return 'Text cannot exceed 255 characters';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Obx(() {
      final imagePaths = controller!.uploadedImagePaths;
      final isUploading = controller!.isUploadingImage.value;
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((20.r) * _sizeScaleFactor),
        ),
        child: ClipRRect(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                if (imagePaths.isEmpty && !isUploading) ...[
                  GestureDetector(
                    onTap: controller!.uploadImage,
                    child: Container(
                      width: double.infinity,
                      height: (160.h) * _sizeScaleFactor,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        border: Border.all(
                          color: Colors.blue,
                          width: 0.5,
                          style: BorderStyle.solid,
                        ),
                        borderRadius:
                            BorderRadius.circular((16.r) * _sizeScaleFactor),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all((20.r) * _sizeScaleFactor),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(
                                  (20.r) * _sizeScaleFactor),
                            ),
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: (32.r) * _sizeScaleFactor,
                            ),
                          ),
                          SizedBox(height: (16.h) * _sizeScaleFactor),
                          Text(
                            'Add Inspection Photos',
                            style: TextStyle(
                              fontSize: (18.sp) * _sizeScaleFactor,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: (8.h) * _sizeScaleFactor),
                          Text(
                            'Camera • Gallery • Multiple Photos',
                            style: TextStyle(
                              fontSize: (14.sp) * _sizeScaleFactor,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: EdgeInsets.all((20.r) * _sizeScaleFactor),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${imagePaths.length} Photo${imagePaths.length == 1 ? '' : 's'} Added',
                              style: TextStyle(
                                fontSize: (16.sp) * _sizeScaleFactor,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            GestureDetector(
                              onTap:
                                  isUploading ? null : controller!.uploadImage,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: (16.w) * _sizeScaleFactor,
                                  vertical: (8.h) * _sizeScaleFactor,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(
                                      (20.r) * _sizeScaleFactor),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.blue.shade300,
                                  //     blurRadius: (6.r) * _sizeScaleFactor,
                                  //     offset: const Offset(0, 2),
                                  //   ),
                                  // ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add_circle,
                                      color: Colors.white,
                                      size: (18.r) * _sizeScaleFactor,
                                    ),
                                    SizedBox(width: (6.w) * _sizeScaleFactor),
                                    Text(
                                      'Add More',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: (14.sp) * _sizeScaleFactor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: (20.h) * _sizeScaleFactor),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: (12.w) * _sizeScaleFactor,
                            mainAxisSpacing: (12.h) * _sizeScaleFactor,
                            childAspectRatio: 1,
                          ),
                          itemCount: imagePaths.length + (isUploading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (isUploading && index == imagePaths.length) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(
                                      (16.r) * _sizeScaleFactor),
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                                ),
                              );
                            }
                            final imagePath = imagePaths[index];
                            return GestureDetector(
                              onTap: () =>
                                  controller!.viewImageFullScreen(imagePath),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      (16.r) * _sizeScaleFactor),
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          (16.r) * _sizeScaleFactor),
                                      child: Image.file(
                                        File(imagePath),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                    Positioned(
                                      top: (6.h) * _sizeScaleFactor,
                                      right: (6.w) * _sizeScaleFactor,
                                      child: GestureDetector(
                                        onTap: () =>
                                            controller!.removeImage(index),
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              (6.r) * _sizeScaleFactor),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade600,
                                            borderRadius: BorderRadius.circular(
                                                (20.r) * _sizeScaleFactor),
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: (14.r) * _sizeScaleFactor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: (6.h) * _sizeScaleFactor,
                                      right: (6.w) * _sizeScaleFactor,
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            (6.r) * _sizeScaleFactor),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(
                                              (20.r) * _sizeScaleFactor),
                                        ),
                                        child: Icon(
                                          Icons.zoom_in,
                                          color: Colors.white,
                                          size: (14.r) * _sizeScaleFactor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: (56.h) * _sizeScaleFactor,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((16.r) * _sizeScaleFactor),
      ),
      child: Obx(() => ElevatedButton(
            onPressed: controller!.isSubmitting.value
                ? null
                : () => controller!.updateInspectionReport(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular((16.r) * _sizeScaleFactor),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Ink(
              decoration: BoxDecoration(
                color:
                    controller!.isSubmitting.value ? Colors.grey : Colors.blue,
                borderRadius: BorderRadius.circular((16.r) * _sizeScaleFactor),
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: controller!.isSubmitting.value
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: (20.w) * _sizeScaleFactor,
                            height: (20.h) * _sizeScaleFactor,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: (12.w) * _sizeScaleFactor),
                          Text(
                            'Submitting...',
                            style: TextStyle(
                              fontSize: (16.sp) * _sizeScaleFactor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: (20.r) * _sizeScaleFactor,
                          ),
                          SizedBox(width: (8.w) * _sizeScaleFactor),
                          Text(
                            'Submit Inspection Report',
                            style: TextStyle(
                              fontSize: (16.sp) * _sizeScaleFactor,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          )),
    );
  }

  Widget buildChecklistSection(
      PlantInspectionController plantInspectionController) {
    final double _sizeScaleFactor = 0.6; // 20% smaller

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Inspection Checklist',
          style: TextStyle(
            fontSize: (20.sp) * _sizeScaleFactor,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        SizedBox(height: (16.h) * _sizeScaleFactor),
        Obx(() {
          if (plantInspectionController.isLoadingChecklist.value) {
            return Container(
              height: (120.h) * _sizeScaleFactor,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((20.r) * _sizeScaleFactor),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    SizedBox(height: (12.h) * _sizeScaleFactor),
                    Text(
                      'Loading checklist...',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: (14.sp) * _sizeScaleFactor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (plantInspectionController.checklistItems.isEmpty) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all((32.r) * _sizeScaleFactor),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((20.r) * _sizeScaleFactor),
                border: Border.all(color: Colors.blue),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all((16.r) * _sizeScaleFactor),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius:
                          BorderRadius.circular((16.r) * _sizeScaleFactor),
                    ),
                    child: Icon(
                      Icons.checklist_outlined,
                      size: (35.r) * _sizeScaleFactor,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: (16.h) * _sizeScaleFactor),
                  Text(
                    'No Checklist Items',
                    style: TextStyle(
                      fontSize: (20.sp) * _sizeScaleFactor,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: (8.h) * _sizeScaleFactor),
                  Text(
                    'Checklist items will appear here when available',
                    style: TextStyle(
                      fontSize: (17.sp) * _sizeScaleFactor,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular((20.r) * _sizeScaleFactor),
              border: Border.all(color: Colors.blue),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all((20.r) * _sizeScaleFactor),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular((20.r) * _sizeScaleFactor),
                      topRight: Radius.circular((20.r) * _sizeScaleFactor),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress Overview',
                            style: TextStyle(
                              fontSize: (20.sp) * _sizeScaleFactor,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: (12.w) * _sizeScaleFactor,
                              vertical: (6.h) * _sizeScaleFactor,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                  (20.r) * _sizeScaleFactor),
                            ),
                            child: Text(
                              '${plantInspectionController.checklistItems.where((item) => item['checked'] == 1).length}/${plantInspectionController.checklistItems.length}',
                              style: TextStyle(
                                fontSize: (14.sp) * _sizeScaleFactor,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: (12.h) * _sizeScaleFactor),
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular((10.r) * _sizeScaleFactor),
                        child: LinearProgressIndicator(
                          value: plantInspectionController.checklistItems
                                  .where((item) => item['checked'] == 1)
                                  .length /
                              plantInspectionController.checklistItems.length,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: (8.h) * _sizeScaleFactor,
                        ),
                      ),
                      SizedBox(height: (8.h) * _sizeScaleFactor),
                      Text(
                        '${((plantInspectionController.checklistItems.where((item) => item['checked'] == 1).length / plantInspectionController.checklistItems.length) * 100).toInt()}% Complete',
                        style: TextStyle(
                          fontSize: (14.sp) * _sizeScaleFactor,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: plantInspectionController.checklistItems.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Colors.blue,
                    indent: (20.w) * _sizeScaleFactor,
                    endIndent: (20.w) * _sizeScaleFactor,
                  ),
                  itemBuilder: (context, index) {
                    final item =
                        plantInspectionController.checklistItems[index];
                    final isChecked = item['checked'] == 1;
                    return InkWell(
                      onTap: () =>
                          plantInspectionController.toggleChecklistItem(index),
                      borderRadius:
                          BorderRadius.circular((12.r) * _sizeScaleFactor),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: (20.w) * _sizeScaleFactor,
                          vertical: (16.h) * _sizeScaleFactor,
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: (28.w) * _sizeScaleFactor,
                              height: (28.h) * _sizeScaleFactor,
                              decoration: BoxDecoration(
                                color: isChecked
                                    ? Colors.blue
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isChecked ? Colors.blue : Colors.blue,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(
                                    (8.r) * _sizeScaleFactor),
                              ),
                              child: isChecked
                                  ? Icon(
                                      Icons.check_rounded,
                                      size: (18.r) * _sizeScaleFactor,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            SizedBox(width: (16.w) * _sizeScaleFactor),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['item_name'] ?? 'Unknown Item',
                                    style: TextStyle(
                                      fontSize: (17.sp) * _sizeScaleFactor,
                                      fontWeight: FontWeight.w600,
                                      color: isChecked
                                          ? Colors.grey.shade600
                                          : Colors.grey.shade800,
                                      // decoration: isChecked ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                  if (item['info'] != null) ...[
                                    SizedBox(height: (6.h) * _sizeScaleFactor),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: (10.w) * _sizeScaleFactor,
                                        vertical: (4.h) * _sizeScaleFactor,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(
                                            (12.r) * _sizeScaleFactor),
                                        border: Border.all(
                                          color: Colors.blue,
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        item['info'],
                                        style: TextStyle(
                                          fontSize: (12.sp) * _sizeScaleFactor,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: (10.w) * _sizeScaleFactor,
                              height: (10.h) * _sizeScaleFactor,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isChecked
                                    ? Colors.green
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: (8.h) * _sizeScaleFactor),
              ],
            ),
          );
        }),
        SizedBox(height: (32.h) * _sizeScaleFactor),
      ],
    );
  }
}
