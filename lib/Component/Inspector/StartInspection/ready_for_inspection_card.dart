// start_inspection.dart

//
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:solar_app/Component/Inspector/StartInspection/ready_for_inspection_card.dart';
// import 'package:solar_app/Controller/Inspector/plant_inspection_controller.dart';
// import '../../../utils/drop_down.dart';
// import '../AreaInspectionView/inspection_card.dart';
// import 'cleaner_status_card.dart';
// import 'inspection_form.dart';
//
// class StartInspection extends StatefulWidget {
//   const StartInspection({super.key});
//
//   @override
//   State<StartInspection> createState() => _StartInspectionState();
// }
//
// class _StartInspectionState extends State<StartInspection> {
//   late PlantInspectionController controller;
//   final Map<String, dynamic> inspectionData = Get.arguments ?? {};
//   late String controllerTag;
//
//   @override
//   void initState() {
//     super.initState();
//     controllerTag = "inspection_${inspectionData['id'] ?? DateTime.now().millisecondsSinceEpoch}";
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller = Get.put(PlantInspectionController(), tag: controllerTag);
//       _initializeAndFetchData();
//     });
//   }
//
//   void _initializeAndFetchData() async {
//     // Set default values first
//     controller.dateController.text = DateTime.now().toString().split(' ')[0];
//     controller.timeController.text = TimeOfDay.now().format(context);
//     controller.selectedStatus.value = 'pending';
//     controller.uploadedImagePaths.clear();
//     controller.inspectorReviewController.clear();
//     controller.clientReviewController.clear();
//
//     // Then fetch and populate data from API
//     if (inspectionData['id'] != null) {
//       await controller.fetchInspectorData(inspectionData['id']);
//     }
//   }
//
//   @override
//   void dispose() {
//     Get.delete<PlantInspectionController>(tag: controllerTag);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: _buildAppBar(),
//       body: GetBuilder<PlantInspectionController>(
//         tag: controllerTag,
//         init: PlantInspectionController(),
//         builder: (controller) {
//           return SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16 * 0.9.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 16 * 0.9.h),
//                   ReadyForInspectionCard(inspectionData: inspectionData),
//                   SizedBox(height: 24 * 0.9.h),
//                   CleanerStatusCard(inspectionData: inspectionData),
//                   SizedBox(height: 24 * 0.9.h),
//                   InspectionFormStatus(
//                     inspectionData: inspectionData,
//                     controllerTag: controllerTag,
//                   ),
//                   SizedBox(height: 24 * 0.9.h),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   AppBar _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       title: Text(
//         'Start Inspection',
//         style: TextStyle(
//           color: Colors.black,
//           fontWeight: FontWeight.w500,
//           fontSize: 18 * 0.9.sp,
//         ),
//       ),
//       leading: IconButton(
//         icon: Icon(Icons.arrow_back, color: Colors.black, size: 24 * 0.9.sp),
//         onPressed: () => Get.back(),
//       ),
//       actions: [
//         IconButton(
//           icon: Icon(Icons.refresh, color: Colors.black, size: 24 * 0.9.sp),
//           onPressed: () async {
//             if (inspectionData['id'] != null) {
//               await controller.fetchInspectorData(inspectionData['id']);
//             }
//           },
//         ),
//       ],
//     );
//   }
// }


// widgets/ready_for_inspection_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReadyForInspectionCard extends StatelessWidget {
  final Map<String, dynamic> inspectionData;

  const ReadyForInspectionCard({
    super.key,
    required this.inspectionData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusIndicator(),
        SizedBox(height: 16 * 0.9.h),
        _buildInspectionCard(),
      ],
    );
  }

  Widget _buildStatusIndicator() {
    return Row(
      children: [
        Container(
          width: 8 * 0.9.w,
          height: 8 * 0.9.h,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
        ),
        SizedBox(width: 8 * 0.9.w),
        Text(
          'Ready for Inspection',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 12 * 0.9.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildInspectionCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16 * 0.9.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12 * 0.9.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8 * 0.9.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPlantInfo(),
          SizedBox(height: 8 * 0.9.h),
          _buildScheduleInfo(),
          SizedBox(height: 4 * 0.9.h),
          _buildInspectorInfo(),
          SizedBox(height: 16 * 0.9.h),
          _buildLocationInfo(),
        ],
      ),
    );
  }

  Widget _buildPlantInfo() {
    return Text(
      inspectionData['plant_name'] ?? 'Unknown Plant',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18 * 0.9.sp,
      ),
    );
  }

  Widget _buildScheduleInfo() {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.black87,
          fontSize: 14 * 0.9.sp,
        ),
        children: [
          const TextSpan(
            text: 'Scheduled: ',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: inspectionData['time'] ?? 'Not set',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInspectorInfo() {
    return Row(
      children: [
        Text(
          'Inspector: ',
          style: TextStyle(
            fontSize: 14 * 0.9.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          inspectionData['inspector_name'] ?? 'Not assigned',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 14 * 0.9.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo() {
    return Container(
      padding: EdgeInsets.all(8 * 0.9.r),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8 * 0.9.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
            style: TextStyle(
              fontSize: 11 * 0.9.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 4 * 0.9.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  inspectionData['plant_address'] ?? 'Unknown Location',
                  style: TextStyle(
                    fontSize: 12 * 0.9.sp,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.near_me,
                color: Colors.blue,
                size: 20 * 0.9.r,
              ),
            ],
          ),
        ],
      ),
    );
  }
}