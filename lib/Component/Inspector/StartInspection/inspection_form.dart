
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solar_app/Controller/Inspector/plant_inspection_controller.dart';
import 'package:solar_app/utils/drop_down.dart';

class InspectionFormStatus extends StatelessWidget {
  final Map<String, dynamic> inspectionData;
  final String controllerTag;

  const InspectionFormStatus({
    Key? key,
    required this.inspectionData,
    required this.controllerTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the controller once at the top level
    final controller = Get.find<PlantInspectionController>(tag: controllerTag);
    // Debug print to verify the data in the UI
    print('Building UI with Date: ${controller.dateController.text}');
    print('Building UI with Time: ${controller.timeController.text}');

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateTimeFields(context, controller),
          SizedBox(height: 16 * 0.9.h),
          _buildStatusDropdown(controller),
          SizedBox(height: 16 * 0.9.h),
          _buildPhotoUploadSection(controller),
          SizedBox(height: 16 * 0.9.h),
          _buildReviewFields(controller),
          SizedBox(height: 24 * 0.9.h),
          _buildSubmitButton(controller),
        ],
      ),
    );
  }

  // WRAP ONLY THIS SPECIFIC WIDGET IN OBX since it uses observable variables
  Widget _buildDateTimeFields(BuildContext context, PlantInspectionController controller) {
    return Obx(() {
      // Debug print to verify the data in the UI
      print('Updating DateTimeFields with Date: ${controller.dateController.text}');
      print('Updating DateTimeFields with Time: ${controller.timeController.text}');

      return Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller.dateController,
              readOnly: true,
              enabled: !controller.isDataLoaded.value,
              decoration: InputDecoration(
                labelText: 'Date *',
                hintText: 'Select date',
                prefixIcon: Icon(
                  Icons.calendar_today,
                  size: 20 * 0.9.sp,
                  color: controller.isDataLoaded.value ? Colors.grey : null,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12 * 0.9.r),
                ),
                filled: controller.isDataLoaded.value,
                fillColor: controller.isDataLoaded.value ? Colors.grey[100] : null,
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12 * 0.9.r),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              style: TextStyle(
                color: controller.isDataLoaded.value ? Colors.grey[600] : null,
              ),
              onTap: controller.isDataLoaded.value
                  ? null
                  : () => _selectDate(context, controller),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select date';
                }
                return null;
              },
            ),
          ),
          SizedBox(width: 12 * 0.9.w),
          Expanded(
            child: TextFormField(
              controller: controller.timeController,
              readOnly: true,
              enabled: !controller.isDataLoaded.value,
              decoration: InputDecoration(
                labelText: 'Time *',
                hintText: 'Select time',
                prefixIcon: Icon(
                  Icons.access_time,
                  size: 20 * 0.9.sp,
                  color: controller.isDataLoaded.value ? Colors.grey : null,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12 * 0.9.r),
                ),
                filled: controller.isDataLoaded.value,
                fillColor: controller.isDataLoaded.value ? Colors.grey[100] : null,
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12 * 0.9.r),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              style: TextStyle(
                color: controller.isDataLoaded.value ? Colors.grey[600] : null,
              ),
              onTap: controller.isDataLoaded.value
                  ? null
                  : () => _selectTime(context, controller),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select time';
                }
                return null;
              },
            ),
          ),
        ],
      );
    });
  }


  Future<void> _selectDate(BuildContext context, PlantInspectionController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.dateController.text = picked.toString().split(' ')[0];
    }
  }

  Future<void> _selectTime(BuildContext context, PlantInspectionController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      controller.timeController.text = picked.format(context);
    }
  }

  Widget _buildStatusDropdown(PlantInspectionController controller) {
    // WRAP ONLY THIS WIDGET IN OBX since it uses selectedStatus observable
    return Obx(() => CustomDropdownField<String>(
      value: controller.selectedStatus.value.isEmpty ? null : controller.selectedStatus.value,
      labelText: 'Status',
      prefixIcon: Icons.flag,
      items: controller.statusOptions,
      itemLabelBuilder: (status) => status,
      isRequired: true,
      onChanged: (value) {
        if (value != null) {
          controller.selectedStatus.value = value;
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select status';
        }
        return null;
      },
    ));
  }

  Widget _buildPhotoUploadSection(PlantInspectionController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Inspection Photos',
          style: TextStyle(
            fontSize: 16 * 0.9.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8 * 0.9.h),
        // WRAP ONLY THIS WIDGET IN OBX since it uses uploadedImagePaths observable
        Obx(() => _buildPhotoGrid(controller)),
      ],
    );
  }

  Widget _buildPhotoGrid(PlantInspectionController controller) {
    final imagePaths = controller.uploadedImagePaths;
    final isUploading = controller.isUploadingImage.value;

    if (imagePaths.isEmpty && !isUploading) {
      return _buildEmptyPhotoState(controller);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPhotoHeader(imagePaths.length, isUploading, controller),
        SizedBox(height: 12 * 0.9.h),
        _buildPhotoGridView(imagePaths, isUploading, controller),
      ],
    );
  }

  Widget _buildEmptyPhotoState(PlantInspectionController controller) {
    return GestureDetector(
      onTap: controller.uploadImage,
      child: Container(
        width: double.infinity,
        height: 120 * 0.9.h,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12 * 0.9.r),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(12 * 0.9.r),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12 * 0.9.r),
                ),
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.blue,
                  size: 32 * 0.9.r,
                ),
              ),
              SizedBox(height: 8 * 0.9.h),
              Text(
                'Add Inspection Photos',
                style: TextStyle(
                  fontSize: 14 * 0.9.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 4 * 0.9.h),
              Text(
                'Camera • Gallery • Multiple',
                style: TextStyle(
                  fontSize: 12 * 0.9.sp,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoHeader(int photoCount, bool isUploading, PlantInspectionController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$photoCount Photo${photoCount == 1 ? '' : 's'} Added',
          style: TextStyle(
            fontSize: 14 * 0.9.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        GestureDetector(
          onTap: isUploading ? null : controller.uploadImage,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12 * 0.9.w,
              vertical: 6 * 0.9.h,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20 * 0.9.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.white, size: 16 * 0.9.r),
                SizedBox(width: 4 * 0.9.w),
                Text(
                  'Add More',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12 * 0.9.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoGridView(List<String> imagePaths, bool isUploading, PlantInspectionController controller) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8 * 0.9.w,
        mainAxisSpacing: 8 * 0.9.h,
        childAspectRatio: 1,
      ),
      itemCount: imagePaths.length + (isUploading ? 1 : 0),
      itemBuilder: (context, index) {
        if (isUploading && index == imagePaths.length) {
          return _buildLoadingIndicator();
        }
        return _buildPhotoItem(imagePaths[index], index, controller);
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12 * 0.9.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    );
  }

  Widget _buildPhotoItem(String imagePath, int index, PlantInspectionController controller) {
    return GestureDetector(
      onTap: () => controller.viewImageFullScreen(imagePath),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12 * 0.9.r),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12 * 0.9.r),
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            _buildRemoveButton(index, controller),
            _buildViewIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildRemoveButton(int index, PlantInspectionController controller) {
    return Positioned(
      top: 4 * 0.9.h,
      right: 4 * 0.9.w,
      child: GestureDetector(
        onTap: () => controller.removeImage(index),
        child: Container(
          padding: EdgeInsets.all(4 * 0.9.r),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12 * 0.9.r),
          ),
          child: Icon(
            Icons.close,
            color: Colors.white,
            size: 12 * 0.9.r,
          ),
        ),
      ),
    );
  }

  Widget _buildViewIndicator() {
    return Positioned(
      bottom: 4 * 0.9.h,
      right: 4 * 0.9.w,
      child: Container(
        padding: EdgeInsets.all(4 * 0.9.r),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12 * 0.9.r),
        ),
        child: Icon(
          Icons.zoom_in,
          color: Colors.white,
          size: 12 * 0.9.r,
        ),
      ),
    );
  }

  // No Obx needed here since these don't use observable variables
  Widget _buildReviewFields(PlantInspectionController controller) {
    return Column(
      children: [
        TextFormField(
          controller: controller.inspectorReviewController,
          maxLines: 4,
          maxLength: 255,
          decoration: InputDecoration(
            labelText: 'Inspector Review *',
            hintText: 'Describe inspection findings...',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14 * 0.9.sp,
            ),
            prefixIcon: Icon(Icons.rate_review, size: 20 * 0.9.sp),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12 * 0.9.r),
            ),
            alignLabelWithHint: true,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide inspector review';
            }
            if (value.length > 255) {
              return 'Review cannot exceed 255 characters';
            }
            return null;
          },
        ),
        SizedBox(height: 16 * 0.9.h),
        TextFormField(
          controller: controller.clientReviewController,
          maxLines: 3,
          maxLength: 255,
          decoration: InputDecoration(
            labelText: 'Client Review (Optional)',
            hintText: 'Add client feedback...',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14 * 0.9.sp,
            ),
            prefixIcon: Icon(Icons.comment, size: 20 * 0.9.sp),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12 * 0.9.r),
            ),
            alignLabelWithHint: true,
          ),
          validator: (value) {
            if (value != null && value.length > 255) {
              return 'Review cannot exceed 255 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton(PlantInspectionController controller) {
    return SizedBox(
      width: double.infinity,
      height: 50 * 0.9.h,
      // WRAP ONLY THIS WIDGET IN OBX since it uses isSubmitting observable
      child: Obx(() => ElevatedButton(
        onPressed: controller.isSubmitting.value
            ? null
            : () => controller.submitInspectionReport(inspectionData),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12 * 0.9.r),
          ),
          elevation: 0,
        ),
        child: controller.isSubmitting.value
            ? const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        )
            : Text(
          'Submit Inspection Report',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16 * 0.9.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      )),
    );
  }
}

// AND UPDATE YOUR CONTROLLER METHOD TO FORCE UI REFRESH:
// In your PlantInspectionController, update the method like this:

/*
void _populateFormWithInspectorData() {
  if (inspectorDataResponse?.data != null) {
    final data = inspectorDataResponse!.data;

    // Populate date and time (these will be frozen)
    dateController.text = data.cleaningDate != null
        ? data.cleaningDate.toString().split(' ')[0]
        : DateTime.now().toString().split(' ')[0];

    timeController.text = data.cleaningTime ?? TimeOfDay.now().format(Get.context!);

    // Populate status
    selectedStatus.value = data.status ?? 'pending';

    // Populate reviews if they exist
    if (data.inspectorReview != null && data.inspectorReview!.isNotEmpty) {
      inspectorReviewController.text = data.inspectorReview!;
    }

    if (data.clientReview != null && data.clientReview!.isNotEmpty) {
      clientReviewController.text = data.clientReview!;
    }

    // CRITICAL: Mark data as loaded AFTER setting all values
    isDataLoaded.value = true;

    print('Form populated with data:');
    print('Date: ${dateController.text}');
    print('Time: ${timeController.text}');
    print('Status: ${selectedStatus.value}');
    print('Data loaded: ${isDataLoaded.value}');
  }
}
*/