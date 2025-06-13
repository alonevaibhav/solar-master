import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertsController extends GetxController {
  // Observable variables for state management
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();
  final searchQuery = ''.obs;

  // Store alerts data directly in Map<String, dynamic> as required
  final alertsList = Rxn<List<Map<String, dynamic>>>();
  final filteredAlertsList = Rxn<List<Map<String, dynamic>>>();

  // Selected area
  final selectedArea = 'Area - 1'.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with empty lists
    alertsList.value = [];
    filteredAlertsList.value = [];
    // Load data when controller initializes
    fetchAlerts();
  }

  @override
  void onReady() {
    super.onReady();
    // Set up reaction to search query changes
    ever(searchQuery, (_) => filterAlerts());
    // Set up reaction to filter changes
    ever(activeFilter, (_) => filterAlerts());
  }

  @override
  void onClose() {
    // Clean up any resources
    super.onClose();
  }

  // Change search query
  void updateSearch(String query) {
    searchQuery.value = query;
  }

  // Active filter for alerts
  final activeFilter = 'all'.obs; // 'all', 'high', 'low'

  // Set active filter
  void setFilter(String filter) {
    activeFilter.value = filter;
    filterAlerts();
  }

  // Filter alerts based on search query and active filter
  void filterAlerts() {
    List<Map<String, dynamic>>? filtered = alertsList.value;

    // Apply search filter if needed
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered?.where((alert) {
        final location = alert['location']?.toString().toLowerCase() ?? '';
        final area = alert['area']?.toString().toLowerCase() ?? '';
        final tags = alert['tags'] as List<String>? ?? [];

        return location.contains(query) ||
            area.contains(query) ||
            tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }

    // Apply priority filter if not 'all'
    if (activeFilter.value != 'all') {
      filtered = filtered?.where((alert) =>
      alert['priority'] == activeFilter.value).toList();
    }

    filteredAlertsList.value = filtered;
  }

  // Mock fetch alerts from API
  Future<void> fetchAlerts() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock response data - would come from an API in production
      final response = [
        {
          'id': '1',
          'priority': 'high',
          'location': 'Abc Plant',
          'area': 'Area - 1',
          'dateTime': '7 May 6:00 Pm',
          'tags': ['Water Level', 'Damage', 'Not Working', 'Electricity'],
          'coordinates': {'lat': 37.7749, 'lng': -122.4194},
        },
        {
          'id': '2',
          'priority': 'low',
          'location': 'Abc Plant',
          'area': 'Area - 1',
          'dateTime': '7 May 6:00 Pm',
          'tags': ['Water Level', 'Damage', 'Not Working', 'Electricity'],
          'coordinates': {'lat': 37.7749, 'lng': -122.4194},
        },
      ];

      // Store the response directly (no model conversion)
      alertsList.value = response;

      // Initialize filtered list with all alerts
      filteredAlertsList.value = alertsList.value;

    } catch (e) {
      errorMessage.value = 'Failed to load alerts: ${e.toString()}';
      Get.snackbar(
        'Error',
        'Failed to load alerts',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // View alert details
  void viewAlertDetails(String alertId) {
    final alert = alertsList.value?.firstWhere(
          (alert) => alert['id'] == alertId,
      orElse: () => <String, dynamic>{},
    );

    if (alert?.isNotEmpty == true) {
      Get.toNamed('/alert-details', arguments: alert);
    }
  }

  // View location on map
  void viewLocationOnMap(Map<String, dynamic> coordinates) {
    // This would open a map view with the given coordinates
    Get.toNamed('/map-view', arguments: coordinates);
  }

  // Refresh alerts data
  Future<void> refreshAlerts() async {
    await fetchAlerts();
  }

// Don't need these getter methods anymore since we're using the filter approach
// Get high priority alerts
/*
  List<Map<String, dynamic>> get highPriorityAlerts {
    return filteredAlertsList.value?.where((alert) =>
      alert['priority'] == 'high').toList() ?? [];
  }

  // Get low priority alerts
  List<Map<String, dynamic>> get lowPriorityAlerts {
    return filteredAlertsList.value?.where((alert) =>
      alert['priority'] == 'low').toList() ?? [];
  }
  */
}