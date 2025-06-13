import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CleanUpHistoryController extends GetxController {
  // Observable variables
  var isLoading = true.obs;
  var cleanupItems = <CleanupItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCleanupData();
  }

  // Fetch data from API or local storage
  Future<void> fetchCleanupData() async {
    try {
      // Simulate API call with delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock data based on the design
      final mockItems = [
        CleanupItem(
          areaNumber: '1',
          date: '7 May',
          time: '6:00 PM',
          panelCount: 32,
          plantName: 'Abc Plant Name',
          plantId: 'XYZ-1',
          location: 'Pune Maharashtra(411052)',
        ),  CleanupItem(
          areaNumber: '1',
          date: '7 May',
          time: '6:00 PM',
          panelCount: 32,
          plantName: 'Abc Plant Name',
          plantId: 'XYZ-1',
          location: 'Pune Maharashtra(411052)',
        ), CleanupItem(
          areaNumber: '1',
          date: '7 May',
          time: '6:00 PM',
          panelCount: 32,
          plantName: 'Abc Plant Name',
          plantId: 'XYZ-1',
          location: 'Pune Maharashtra(411052)',
        ),
        // You can add more items here if needed
      ];

      cleanupItems.assignAll(mockItems);
    } catch (e) {
      debugPrint('Error fetching cleanup data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Handle Send Remark button tap
  void onSendRemarkTap() {
    Get.snackbar(
      'Send Remark',
      'Sending remark functionality will be implemented here',
      snackPosition: SnackPosition.BOTTOM,
    );

    // Here you would typically navigate to a form or open a dialog
    // Get.to(() => RemarkFormView());
  }
}

// Model class for cleanup item
class CleanupItem {
  final String areaNumber;
  final String date;
  final String time;
  final int panelCount;
  final String plantName;
  final String plantId;
  final String location;

  CleanupItem({
    required this.areaNumber,
    required this.date,
    required this.time,
    required this.panelCount,
    required this.plantName,
    required this.plantId,
    required this.location,
  });
}