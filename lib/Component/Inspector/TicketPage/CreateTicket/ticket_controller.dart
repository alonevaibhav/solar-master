import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../API Service/api_service.dart';

class TicketRaisingController extends GetxController {
  final Map<String, dynamic>? plantData;

  TicketRaisingController({this.plantData});

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final selectedTicketType = Rxn<String>();
  final selectedPriority = Rxn<String>();
  final selectedDepartment = Rxn<String>(); // New department selection
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final ticketData = Rxn<Map<String, dynamic>>();

  final List<String> ticketTypes = ['software', 'hardware', 'accounts'];
  final List<String> priorities = ['1', '2', '3', '4', '5'];
  final List<String> departments = [
    'services',
    'technical',
    'account'
  ]; // Department list

  final Map<String, String> priorityLabels = {
    '1': 'Critical',
    '2': 'High',
    '3': 'Medium',
    '4': 'Low',
    '5': 'Very Low'
  };

  final Map<String, String> ticketTypeLabels = {
    'software': 'Software Issue',
    'hardware': 'Hardware Issue',
    'accounts': 'Account Related'
  };

  final Map<String, String> departmentLabels = {
    'services': 'Services',
    'technical': 'Technical',
    'accounts': 'Accounts'
  };

  final uploadedImagePaths = <String>[].obs;
  final isUploadingImage = false.obs;

  @override
  void onInit() {
    super.onInit();
    selectedPriority.value = '3';
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ticket title is required';
    }
    if (value.trim().length < 5) {
      return 'Title must be at least 5 characters long';
    }
    if (value.trim().length > 100) {
      return 'Title must not exceed 100 characters';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters long';
    }
    if (value.trim().length > 1000) {
      return 'Description must not exceed 1000 characters';
    }
    return null;
  }

  String? validateTicketType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a ticket type';
    }
    return null;
  }

  String? validatePriority(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select priority level';
    }
    return null;
  }

  String? validateDepartment(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a department';
    }
    return null;
  }

  String getPriorityLabel(String priority) {
    return '${priorityLabels[priority]}';
  }

  String getTicketTypeLabel(String type) {
    return ticketTypeLabels[type] ?? type;
  }

  String getDepartmentLabel(String department) {
    return departmentLabels[department] ?? department;
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    selectedTicketType.value = null;
    selectedPriority.value = '3';
    selectedDepartment.value = null;
    errorMessage.value = '';
    ticketData.value = null;
    uploadedImagePaths.clear();
  }

  void _showImageSourceDialog() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Select Image Source',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.blue),
              title: Text('Camera'),
              subtitle: Text('Take a new photo'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.green),
              title: Text('Gallery'),
              subtitle: Text('Choose from gallery'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library_outlined, color: Colors.orange),
              title: Text('Multiple from Gallery'),
              subtitle: Text('Choose multiple photos'),
              onTap: () {
                Get.back();
                _pickMultipleImages();
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      isUploadingImage.value = true;
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        uploadedImagePaths.add(image.path);
        Get.snackbar(
          'Success',
          'Photo added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploadingImage.value = false;
    }
  }

  Future<void> _pickMultipleImages() async {
    try {
      isUploadingImage.value = true;
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage(
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        for (XFile image in images) {
          uploadedImagePaths.add(image.path);
        }
        Get.snackbar(
          'Success',
          '${images.length} photos added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick images: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploadingImage.value = false;
    }
  }

  void uploadImage() {
    _showImageSourceDialog();
  }

  void removeImage(int index) {
    if (index >= 0 && index < uploadedImagePaths.length) {
      uploadedImagePaths.removeAt(index);
      Get.snackbar(
        'Success',
        'Photo removed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 1),
      );
    }
  }

  void viewImageFullScreen(String imagePath) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submitTicket() async {
    if (!formKey.currentState!.validate()) {
      Get.snackbar(
        'Validation Error',
        'Please fill all required fields correctly',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Collect data from the form with default values for potentially null fields
      final fields = {
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'priority': selectedPriority.value ?? '3',
        'ticket_type': selectedTicketType.value ?? 'software',
        'plant_id': plantData?['id'].toString() ?? '',
        'department': selectedDepartment.value ?? 'technical',
        'inspector_id': plantData?['inspector_id'].toString() ?? '',
        'distributor_admin_id': plantData?['distributor_admin_id'].toString() ?? '',
        'ip': '192.168.1.1', // Replace with actual IP retrieval logic
        'creator_type': 'inspector',
        'user_id': plantData?['user_id'].toString() ?? '',
      };

      // Prepare the files for the multipart request
      final files = uploadedImagePaths.map((path) {
        return MultipartFiles(
          field: 'attachments',
          filePath: path,
        );
      }).toList();

      // Make the API call
      final response = await ApiService.multipartPost<Map<String, dynamic>>(
        endpoint: '/api/tickets/create/inspector',
        fields: fields,
        files: files,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.success ) {
        Get.snackbar(
          'Success',
          'Ticket #${response.data!['id']} has been created successfully',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.back(result: response.data);
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage ?? 'Failed to create ticket. Please try again.',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
          icon: const Icon(Icons.error_outline, color: Colors.red),
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to create ticket. Please try again.',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
