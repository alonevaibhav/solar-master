import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solar_app/Route%20Manager/app_routes.dart';

import '../../utils/dialog_box.dart';
import '../login_controller.dart';

class IUserProfile extends GetxController {
  // User information
  final RxString userName = 'Ravi Sharma'.obs;
  final RxString userPhone = '9876543210'.obs;
  final RxString userAddress = 'Rajnagar, Punjab'.obs;

  // Theme state
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  @override
  void onReady() {
    super.onReady();
    // Additional initialization if needed
  }

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }

  // Load user profile data from storage or API
  void loadUserProfile() async {
    try {
      // TODO: Replace with actual API or storage implementation
      await Future.delayed(const Duration(milliseconds: 300));

      // Mock data loading (in a real app, this would come from API or local storage)
      userName.value = 'Ravi Sharma';
      userPhone.value = '9876543210';
      userAddress.value = 'Rajnagar, Punjab';
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load profile information',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Edit profile action
  void editProfile() {
    // Navigate to edit profile screen
    Get.toNamed(AppRoutes.cleanerUpdateProfile);
  }

  // Navigate to assigned plants screen
  void goToAssignedPlants() {
    Get.toNamed(AppRoutes.inspectorAssignedPlants);
  }
  // Navigate to assigned plants screen
  void goToPlantInfo() {
    Get.toNamed(AppRoutes.inspectorPlantInfo);
  }

  // Navigate to help and support screen
  void goToHelpAndSupport() {
    Get.toNamed(AppRoutes.cleanerHelp);
  }

  // Navigate to cleanup history screen
  void goToCleanupHistory() {
    Get.toNamed(AppRoutes.cleanerCleanupHistory);
  }

  // Logout function
  void logout() {
    Get.dialog(
      ConfirmationDialog(
        title: 'Logout',
        content: 'Are you sure you want to logout?',
        confirmButtonText: 'Logout',
        cancelButtonText: 'Cancel',
        onConfirm: () {
          final loginController = Get.find<LoginController>();
          loginController.logout();
        },
      ),
    );
  }


  // Delete account function
  void showDeleteConfirmation() {
    Get.dialog(
      ConfirmationDialog(
        title: 'Delete Account',
        content:
            'Are you sure you want to delete your account? This action cannot be undone.',
        confirmButtonText: 'Delete',
        cancelButtonText: 'Cancel',
        onConfirm: () {
          // Show loading dialog
          Get.dialog(
            const Center(child: CircularProgressIndicator()),
            barrierDismissible: false,
          );

          // Simulate API call
          Future.delayed(const Duration(seconds: 2), () {
            Get.back(); // Close loading dialog
            Get.offAllNamed('/login');
            Get.snackbar(
              'Account Deleted',
              'Your account has been successfully deleted',
              snackPosition: SnackPosition.BOTTOM,
            );
          });
        },
      ),
    );
  }

  // Navigate to home
  void goToHome() {
    Get.offAllNamed('/home');
  }
}
