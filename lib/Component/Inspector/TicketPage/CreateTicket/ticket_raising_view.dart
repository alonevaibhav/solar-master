import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solar_app/Component/Inspector/TicketPage/CreateTicket/priority_indicator.dart';
import 'package:solar_app/Component/Inspector/TicketPage/CreateTicket/ticket_controller.dart';
import '../../../../utils/custom_text_form_field.dart';
import '../../../../utils/drop_down.dart';

class TicketRaisingView extends StatelessWidget {
  const TicketRaisingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Map<String, dynamic>? plantData = Get.arguments;
    // Example of using plantData
    if (plantData != null) {
      // You can now use the plantData to build your UI or pass it to the controller
      print('plant_id: ${plantData['id']}');
      print('inspector_id: ${plantData['inspector_id']}');
      print('distributor_admin_id: ${plantData['distributor_admin_id']}');
      print('creator_type: ${plantData['creator_type']}'); // by default Inspector
      print('user_id: ${plantData['user_id']}');
      print('ip'); // took from mobile app


      // Add more fields as needed
    }
    final TicketRaisingController controller = Get.put(TicketRaisingController(plantData: plantData));
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Raise Support Ticket',
          style: TextStyle(
            fontSize: 18.sp * 0.9,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w * 0.9),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w * 0.9),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r * 0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 0,
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12.w * 0.9),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1565C0).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.r * 0.9),
                                ),
                                child: Icon(
                                  Icons.support_agent,
                                  color: const Color(0xFF1565C0),
                                  size: 24.sp * 0.9,
                                ),
                              ),
                              SizedBox(width: 16.w * 0.9),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Need Help?',
                                      style: TextStyle(
                                        fontSize: 20.sp * 0.9,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    SizedBox(height: 4.h * 0.9),
                                    Text(
                                      'Describe your issue and our support team will assist you.',
                                      style: TextStyle(
                                        fontSize: 14.sp * 0.9,
                                        color: const Color(0xFF6B7280),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h * 0.9),
                    Container(
                      padding: EdgeInsets.all(24.w * 0.9),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r * 0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 0,
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ticket Details',
                            style: TextStyle(
                              fontSize: 18.sp * 0.9,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                          SizedBox(height: 20.h * 0.9),
                          CustomTextFormField(
                            controller: controller.titleController,
                            validator: controller.validateTitle,
                            labelText: 'Ticket Title *',
                            hintText: 'Brief summary of the issue',
                            borderRadius: 12.r,
                            errorBorderColor: theme.colorScheme.error,
                            labelStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF374151),
                            ),
                            hintStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              color: const Color(0xFF9CA3AF),
                            ),
                            textStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLength: 100,
                          ),
                          SizedBox(height: 20.h * 0.9),
                          Obx(() => CustomDropdownField<String>(
                            value: controller.selectedTicketType.value,
                            labelText: 'Issue Category',
                            hintText: 'Select category of issue',
                            items: controller.ticketTypes,
                            itemLabelBuilder: (type) => controller.getTicketTypeLabel(type),
                            onChanged: (value) => controller.selectedTicketType.value = value,
                            validator: controller.validateTicketType,
                            prefixIcon: Icons.category_outlined,
                            isRequired: true,
                            borderColor: const Color(0xFFE5E7EB),
                            focusedBorderColor: const Color(0xFF1565C0),
                            fillColor: const Color(0xFFF9FAFB),
                            borderRadius: 12.r * 0.9,
                            labelStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF374151),
                            ),
                            hintStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              color: const Color(0xFF9CA3AF),
                            ),
                            itemTextStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                          SizedBox(height: 20.h * 0.9),
                          Obx(() => CustomDropdownField<String>(
                            value: controller.selectedDepartment.value,
                            labelText: 'Department',
                            hintText: 'Select department',
                            items: controller.departments,
                            itemLabelBuilder: (department) => controller.getDepartmentLabel(department),
                            onChanged: (value) => controller.selectedDepartment.value = value,
                            validator: controller.validateDepartment,
                            prefixIcon: Icons.business,
                            isRequired: true,
                            borderColor: const Color(0xFFE5E7EB),
                            focusedBorderColor: const Color(0xFF1565C0),
                            fillColor: const Color(0xFFF9FAFB),
                            borderRadius: 12.r * 0.9,
                            labelStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF374151),
                            ),
                            hintStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              color: const Color(0xFF9CA3AF),
                            ),
                            itemTextStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                          SizedBox(height: 20.h * 0.9),
                          Obx(() => CustomDropdownField<String>(
                            value: controller.selectedPriority.value,
                            labelText: 'Priority Level',
                            hintText: 'Select priority level',
                            items: controller.priorities,
                            itemLabelBuilder: (priority) => controller.getPriorityLabel(priority),
                            onChanged: (value) => controller.selectedPriority.value = value,
                            validator: controller.validatePriority,
                            prefixIcon: Icons.priority_high,
                            isRequired: true,
                            borderColor: const Color(0xFFE5E7EB),
                            focusedBorderColor: const Color(0xFF1565C0),
                            fillColor: const Color(0xFFF9FAFB),
                            borderRadius: 12.r * 0.9,
                            labelStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF374151),
                            ),
                            hintStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              color: const Color(0xFF9CA3AF),
                            ),
                            itemTextStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                          SizedBox(height: 8.h * 0.9),
                          Obx(() => controller.selectedPriority.value != null
                              ? PriorityIndicator(priority: controller.selectedPriority.value!)
                              : const SizedBox.shrink()),
                          SizedBox(height: 20.h * 0.9),
                          CustomTextFormField(
                            controller: controller.descriptionController,
                            validator: controller.validateDescription,
                            maxLines: 6,
                            minLines: 4,
                            labelText: 'Description *',
                            hintText: 'Provide detailed description of the issue, steps to reproduce, and any relevant information...',
                            alignLabelWithHint: true,
                            borderRadius: 12.r,
                            errorBorderColor: theme.colorScheme.error,
                            labelStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF374151),
                            ),
                            hintStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              color: const Color(0xFF9CA3AF),
                              height: 1.4,
                            ),
                            textStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                            maxLength: 1000,
                          ),
                          SizedBox(height: 20.h * 0.9),
                          Text(
                            'Upload Photos',
                            style: TextStyle(
                              fontSize: 16.sp * 0.9,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8.h * 0.9),
                          Obx(() {
                            final imagePaths = controller.uploadedImagePaths;
                            final isUploading = controller.isUploadingImage.value;

                            if (imagePaths.isEmpty && !isUploading) {
                              return GestureDetector(
                                onTap: controller.uploadImage,
                                child: Container(
                                  width: double.infinity,
                                  height: 120.h * 0.9,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12.r * 0.9),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(12.r * 0.9),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12.r * 0.9),
                                          ),
                                          child: Icon(
                                            Icons.add_a_photo,
                                            color: Colors.blue,
                                            size: 32.r * 0.9,
                                          ),
                                        ),
                                        SizedBox(height: 8.h * 0.9),
                                        Text(
                                          'Add Photos',
                                          style: TextStyle(
                                            fontSize: 14.sp * 0.9,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        SizedBox(height: 4.h * 0.9),
                                        Text(
                                          'Camera • Gallery • Multiple',
                                          style: TextStyle(
                                            fontSize: 12.sp * 0.9,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${imagePaths.length} Photo${imagePaths.length == 1 ? '' : 's'} Added',
                                      style: TextStyle(
                                        fontSize: 14.sp * 0.9,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: isUploading ? null : controller.uploadImage,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w * 0.9,
                                          vertical: 6.h * 0.9,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(20.r * 0.9),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 16.r * 0.9,
                                            ),
                                            SizedBox(width: 4.w * 0.9),
                                            Text(
                                              'Add More',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.sp * 0.9,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h * 0.9),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 8.w * 0.9,
                                    mainAxisSpacing: 8.h * 0.9,
                                    childAspectRatio: 1,
                                  ),
                                  itemCount: imagePaths.length + (isUploading ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (isUploading && index == imagePaths.length) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(12.r * 0.9),
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

                                    final imagePath = imagePaths[index];
                                    return GestureDetector(
                                      onTap: () => controller.viewImageFullScreen(imagePath),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12.r * 0.9),
                                          border: Border.all(color: Colors.grey[300]!),
                                        ),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12.r * 0.9),
                                              child: Image.file(
                                                File(imagePath),
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),
                                            ),
                                            Positioned(
                                              top: 4.h * 0.9,
                                              right: 4.w * 0.9,
                                              child: GestureDetector(
                                                onTap: () => controller.removeImage(index),
                                                child: Container(
                                                  padding: EdgeInsets.all(4.r * 0.9),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.withOpacity(0.8),
                                                    borderRadius: BorderRadius.circular(12.r * 0.9),
                                                  ),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 12.r * 0.9,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 4.h * 0.9,
                                              right: 4.w * 0.9,
                                              child: Container(
                                                padding: EdgeInsets.all(4.r * 0.9),
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.6),
                                                  borderRadius: BorderRadius.circular(12.r * 0.9),
                                                ),
                                                child: Icon(
                                                  Icons.zoom_in,
                                                  color: Colors.white,
                                                  size: 12.r * 0.9,
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
                            );
                          }),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h * 0.9),
                    Obx(() => SizedBox(
                      width: double.infinity,
                      height: 56.h * 0.9,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value ? null : controller.submitTicket,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r * 0.9),
                          ),
                          disabledBackgroundColor: const Color(0xFF9CA3AF),
                        ),
                        child: controller.isLoading.value
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20.w * 0.9,
                              height: 20.h * 0.9,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w * 0.9),
                            Text(
                              'Creating Ticket...',
                              style: TextStyle(
                                fontSize: 16.sp * 0.9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.send_outlined,
                              size: 20.sp * 0.9,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8.w * 0.9),
                            Text(
                              'Submit Ticket',
                              style: TextStyle(
                                fontSize: 16.sp * 0.9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                    SizedBox(height: 16.h * 0.9),
                    SizedBox(
                      width: double.infinity,
                      height: 48.h * 0.9,
                      child: OutlinedButton(
                        onPressed: controller.clearForm,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF6B7280),
                          side: BorderSide(
                            color: const Color(0xFFE5E7EB),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r * 0.9),
                          ),
                        ),
                        child: Text(
                          'Clear Form',
                          style: TextStyle(
                            fontSize: 14.sp * 0.9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h * 0.9),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
