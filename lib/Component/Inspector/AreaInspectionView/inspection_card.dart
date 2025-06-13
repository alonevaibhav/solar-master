
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Controller/Inspector/area_inspection_controller.dart';

class InspectionForm extends StatelessWidget {
  final String plantId;
  final AreaInspectionController controller = Get.find<AreaInspectionController>();

  InspectionForm({
    Key? key,
    required this.plantId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get plant-specific data
    final cleaningChecklist = controller.getPlantCleaningChecklist(plantId);
    final issueController = controller.getPlantIssueController(plantId);
    final remarkController = controller.getPlantRemarkController(plantId);
    final formKey = controller.getPlantFormKey(plantId);
    final uploadedImagePath = controller.getPlantUploadedImagePath(plantId);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cleaning checklist - now uses plant-specific data
          ...List.generate(
            cleaningChecklist.length,
                (index) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Obx(
                    () => CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Cleaning ${index + 1}', // Made more specific
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: cleaningChecklist[index],
                  onChanged: (value) {
                    cleaningChecklist[index] = value ?? false;
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.blue,
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Image upload section - now uses plant-specific data
          GestureDetector(
            onTap: () => controller.uploadImage(plantId), // Pass plantId
            child: Container(
              width: double.infinity,
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Obx(() {
                final imagePath = uploadedImagePath.value; // Plant-specific image
                final isUploading = controller.isUploadingImage.value;

                if (isUploading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (imagePath != null) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  );
                }

                // Placeholder UI
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cloud_upload, color: Colors.grey, size: 32.r),
                      SizedBox(height: 8.h),
                      Text(
                        'Tap to upload image',
                        style:
                        TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),

          SizedBox(height: 16.h),

          // Issue description field - now uses plant-specific controller
          TextFormField(
            controller: issueController, // Plant-specific controller
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Describe issue...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              contentPadding: EdgeInsets.all(16.r),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please describe the issue';
              }
              return null;
            },
          ),

          SizedBox(height: 16.h),

          // Remark field - now uses plant-specific controller
          TextFormField(
            controller: remarkController, // Plant-specific controller
            decoration: InputDecoration(
              hintText: 'Add remark...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              contentPadding: EdgeInsets.all(16.r),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please add a remark';
              }
              return null;
            },
          ),

          SizedBox(height: 24.h),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.sendRemark(plantId),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                disabledBackgroundColor: Colors.grey,
              ),
              child: controller.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                'Submit',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }
}