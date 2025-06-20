// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../API Service/Model/get_status_data.dart';
// import '../../API Service/api_service.dart';
// import '../../Route Manager/app_routes.dart';
// import '../../utils/constants.dart';
// import 'all_inspection_controller.dart';
//
// class PlantInspectionController extends GetxController {
//   final AllInspectionsController allInspectionsController = Get.put(AllInspectionsController());
//
//   final isLoadingDashboard = false.obs;
//   final errorMessageDashboard = Rxn<String>();
//   final dashboardData = Rxn<Map<String, dynamic>>();
//   final todaysInspections = Rxn<Map<String, dynamic>>();
//   final inspectionItems = <Map<String, dynamic>>[].obs;
//   InspectorDataResponse? inspectorDataResponse; // Store the response data
//   final selectedTabIndex = 0.obs;
//
//   int? inspectionCardId; // Store inspectionCardId
//
//   // Form state variables - these will be unique per instance
//   late final TextEditingController dateController;
//   late final TextEditingController timeController;
//   late final TextEditingController inspectorReviewController;
//   late final TextEditingController clientReviewController;
//   // Changed from single image to multiple images
//   final uploadedImagePaths = <String>[].obs;
//   final isUploadingImage = false.obs;
//   final uploadedImagePath = Rxn<String>();
//
//   late final GlobalKey<FormState> formKey;
//   final selectedStatus = 'pending'.obs;
//   final isSubmitting = false.obs;
//   final isDataLoaded = false.obs; // Track if inspector data is loaded
//
//   // final statusOptions = ['pending', 'cleaning', 'done', 'failed', 'success'];
//   final statusOptions = ['done', 'success', 'cleaning', 'pending', 'failed'];
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // Initialize controllers in onInit to ensure unique instances
//     dateController = TextEditingController();
//     timeController = TextEditingController();
//     inspectorReviewController = TextEditingController();
//     clientReviewController = TextEditingController();
//     formKey = GlobalKey<FormState>();
//     getCheckList();
//
//     // Set initial values only if data is not loaded from API
//     if (!isDataLoaded.value) {
//       _resetFormData();
//     }
//
//     // Only fetch inspection items for dashboard instances (not form instances)
//     if (Get.currentRoute.contains('dashboard') ||
//         Get.currentRoute.contains('inspection_list')) {
//       fetchInspectionItems();
//     }
//     _populateFormWithInspectorData();
//   }
//
//   @override
//   void onReady() {
//     super.onReady();
//   }
//
//   @override
//   void onClose() {
//     // Dispose controllers to prevent memory leaks
//     dateController.dispose();
//     timeController.dispose();
//     inspectorReviewController.dispose();
//     clientReviewController.dispose();
//
//     //delete
//     saveChecklistToPrefs();
//
//     super.onClose();
//   }
//
//   // Reset form data to initial state
//   void _resetFormData() {
//     dateController.text = DateTime.now().toString().split(' ')[0];
//     timeController.text = TimeOfDay.now().format(Get.context!);
//     selectedStatus.value = 'pending';
//     uploadedImagePaths.clear(); // Clear the list instead of setting to null
//     inspectorReviewController.clear();
//     clientReviewController.clear();
//   }
//
//   void _populateFormWithInspectorData() {
//     if (inspectorDataResponse?.data != null) {
//       final data = inspectorDataResponse!.data;
//
//       // Debug prints to verify the data
//       print('Cleaning Date: ${data.cleaningDate}');
//       print('Cleaning Time: ${data.cleaningTime}');
//
//       // Populate date and time
//       dateController.text = data.cleaningDate != null
//           ? data.cleaningDate.toString().split(' ')[0]
//           : DateTime.now().toString().split(' ')[0];
//
//       // Ensure the context is valid for time formatting
//       if (Get.context != null) {
//         timeController.text =
//             data.cleaningTime ?? TimeOfDay.now().format(Get.context!);
//       } else {
//         print('Error: Context is null');
//         timeController.text =
//             DateTime.now().toString().split(' ')[1].split('.')[0];
//       }
//
//       // Populate status
//       selectedStatus.value = data.status ?? 'pending';
//
//       // Populate reviews if they exist
//       if (data.inspectorReview != null && data.inspectorReview!.isNotEmpty) {
//         inspectorReviewController.text = data.inspectorReview!;
//       }
//
//       if (data.clientReview != null && data.clientReview!.isNotEmpty) {
//         clientReviewController.text = data.clientReview!;
//       }
//
//       // Mark data as loaded AFTER setting all values
//       isDataLoaded.value = true;
//
//       // Force UI refresh
//       update();
//
//       print('Form populated with data:');
//       print('Date: ${dateController.text}');
//       print('Time: ${timeController.text}');
//       print('Status: ${selectedStatus.value}');
//       print('Data loaded: ${isDataLoaded.value}');
//     } else {
//       print('Error: inspectorDataResponse or data is null');
//     }
//   }
//
//   void _calculateDashboardStats() {
//     if (inspectionItems.isEmpty) {
//       todaysInspections.value = {
//         'count': 0,
//         'status': {
//           'complete': 0,
//           'pending': 0,
//           'cleaning': 0,
//           'failed': 0,
//           'success': 0
//         },
//       };
//       dashboardData.value = {
//         'todaysInspections': todaysInspections.value,
//       };
//       return;
//     }
//
//     int completedCount = 0;
//     int pendingCount = 0;
//     int cleaningCount = 0;
//     int failedCount = 0;
//     int successCount = 0;
//
//     for (var item in inspectionItems) {
//       String status = item['status']?.toString().toLowerCase() ?? '';
//       switch (status) {
//         case 'completed':
//         case 'done':
//           completedCount++;
//           break;
//         case 'pending':
//           pendingCount++;
//           break;
//         case 'cleaning':
//           cleaningCount++;
//           break;
//         case 'failed':
//           failedCount++;
//           break;
//         case 'success':
//           successCount++;
//           break;
//       }
//     }
//
//     todaysInspections.value = {
//       'count': inspectionItems.length,
//       'status': {
//         'complete': completedCount,
//         'pending': pendingCount,
//         'cleaning': cleaningCount,
//         'failed': failedCount,
//         'success': successCount,
//       },
//     };
//
//     dashboardData.value = {
//       'todaysInspections': todaysInspections.value,
//     };
//   }
//
// // Add this to your controller (PlantInspectionController)
// //   final checklistItems = <Map<String, dynamic>>[].obs;
// //   final isLoadingChecklist = false.obs;
//
//   // Future<void> getCheckList() async {
//   //   try {
//   //     isLoadingChecklist.value = true;
//   //     String? uid = await ApiService.getUid();
//   //
//   //     if (uid == null) {
//   //       errorMessageDashboard.value = 'User ID not found';
//   //       return;
//   //     }
//   //
//   //     final response = await ApiService.get<Map<String, dynamic>>(
//   //       endpoint: getInspectorCheckList(int.parse(uid)),
//   //       fromJson: (json) => json as Map<String, dynamic>,
//   //     );
//   //
//   //     if (response.success == true && response.data != null) {
//   //       final data = response.data!['data'] as List<dynamic>;
//   //       checklistItems.value = data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
//   //       print('Checklist loaded: ${checklistItems.length} items');
//   //     } else {
//   //       print('Failed to fetch checklist: ${response.errorMessage}');
//   //     }
//   //   } catch (e) {
//   //     print('An error occurred while fetching the checklist: $e');
//   //   } finally {
//   //     isLoadingChecklist.value = false;
//   //   }
//   // }
//   // void toggleChecklistItem(int index) {
//   //   if (index >= 0 && index < checklistItems.length) {
//   //     checklistItems[index]['completed'] = checklistItems[index]['completed'] == 1 ? 0 : 1;
//   //     checklistItems.refresh();
//   //   }
//   // }
//
//
//   ///--------------Delete this method if not needed----------------
//   String? inspectionId;
//
//   // Your existing properties
//   RxList<Map<String, dynamic>> checklistItems = <Map<String, dynamic>>[].obs;
//   RxBool isLoadingChecklist = false.obs;
//
//   // Set inspection ID (call this when initializing the controller)
//   void setInspectionId(String id) {
//     inspectionId = id;
//     print('Inspection ID set to: $inspectionId');
//   }
//
//   // Save checklist to SharedPreferences
//   Future<void> saveChecklistToPrefs() async {
//     if (inspectionId == null) {
//       print('Cannot save: inspectionId is null');
//       return;
//     }
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       String key = 'checklist_${inspectionId}';
//       String jsonString = jsonEncode(checklistItems.toList());
//       await prefs.setString(key, jsonString);
//       print('Checklist saved for inspection: $inspectionId (${checklistItems.length} items)');
//     } catch (e) {
//       print('Error saving checklist to prefs: $e');
//     }
//   }
//
//   // Load checklist from SharedPreferences
//   Future<void> loadChecklistFromPrefs() async {
//     if (inspectionId == null) {
//       print('Cannot load: inspectionId is null');
//       return;
//     }
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       String key = 'checklist_${inspectionId}';
//       String? jsonString = prefs.getString(key);
//
//       if (jsonString != null && jsonString.isNotEmpty) {
//         List<dynamic> decoded = jsonDecode(jsonString);
//         checklistItems.value = decoded.map((item) => Map<String, dynamic>.from(item)).toList();
//         print('Checklist loaded from prefs for inspection: $inspectionId (${checklistItems.length} items)');
//       } else {
//         print('No saved checklist found for inspection: $inspectionId');
//       }
//     } catch (e) {
//       print('Error loading checklist from prefs: $e');
//     }
//   }
//
//   // Updated getCheckList method to handle your API response structure
//   Future<void> getCheckList() async {
//     try {
//       isLoadingChecklist.value = true;
//
//       // First try to load from SharedPreferences
//       await loadChecklistFromPrefs();
//
//       // If no saved data or user wants fresh data, fetch from API
//       if (checklistItems.isEmpty) {
//         print('No cached data found, fetching from API...');
//
//         String? uid = await ApiService.getUid();
//         if (uid == null) {
//           errorMessageDashboard.value = 'User ID not found';
//           return;
//         }
//
//         final response = await ApiService.get<Map<String, dynamic>>(
//           endpoint: getInspectorCheckList(int.parse(uid)),
//           fromJson: (json) => json as Map<String, dynamic>,
//         );
//
//         if (response.success == true && response.data != null) {
//           // Handle the actual structure of your API response
//           final responseData = response.data!;
//
//           if (responseData['success'] == true && responseData['data'] != null) {
//             final List<dynamic> apiData = responseData['data'] as List<dynamic>;
//
//             // Convert API data to your checklist format
//             checklistItems.value = apiData.map((item) {
//               final itemMap = Map<String, dynamic>.from(item as Map);
//
//               // Map the API fields to your expected format
//               // You can adjust this mapping based on your needs
//               return {
//                 'id': itemMap['id'],
//                 'checklist_id': itemMap['checklist_id'],
//                 'item_name': itemMap['item_name'],
//                 'type': itemMap['type'],
//                 'info': itemMap['info'],
//                 'inspector_id': itemMap['inspector_id'],
//                 'distributor_admin_id': itemMap['distributor_admin_id'],
//                 'assigned_at': itemMap['assigned_at'],
//                 'completed_at': itemMap['completed_at'],
//                 'completed': itemMap['completed'] ?? 0, // This is your completion status
//                 'checked': itemMap['checked'] ?? 0,     // This seems to be another status field
//                 'inspector_name': itemMap['inspector_name'],
//                 'distributor_admin_name': itemMap['distributor_admin_name'],
//               };
//             }).toList();
//
//             print('Checklist loaded from API: ${checklistItems.length} items');
//
//             // Save to SharedPreferences after loading from API
//             await saveChecklistToPrefs();
//           } else {
//             errorMessageDashboard.value = 'Invalid API response structure';
//             print('API response success is false or data is null');
//           }
//         } else {
//           errorMessageDashboard.value = response.errorMessage ?? 'Failed to fetch checklist';
//           print('Failed to fetch checklist: ${response.errorMessage}');
//         }
//       } else {
//         print('Using cached checklist data: ${checklistItems.length} items');
//       }
//     } catch (e) {
//       errorMessageDashboard.value = 'An error occurred while fetching the checklist';
//       print('An error occurred while fetching the checklist: $e');
//     } finally {
//       isLoadingChecklist.value = false;
//     }
//   }
//
//   // Updated toggleChecklistItem method
//   void toggleChecklistItem(int index) {
//     if (index >= 0 && index < checklistItems.length) {
//       // Toggle the completed status
//       checklistItems[index]['completed'] = checklistItems[index]['completed'] == 1 ? 0 : 1;
//
//       // Also update checked status if needed
//       checklistItems[index]['checked'] = checklistItems[index]['checked'] == 1 ? 0 : 1;
//
//       // Update completed_at timestamp when marking as completed
//       if (checklistItems[index]['completed'] == 1) {
//         checklistItems[index]['completed_at'] = DateTime.now().toIso8601String();
//       } else {
//         checklistItems[index]['completed_at'] = null;
//       }
//
//       checklistItems.refresh();
//
//       // Save to SharedPreferences immediately after toggle
//       saveChecklistToPrefs();
//
//       print('Toggled item $index: completed=${checklistItems[index]['completed']}, checked=${checklistItems[index]['checked']}');
//     }
//   }
//
//   // Clear checklist data from SharedPreferences (optional - for cleanup)
//   Future<void> clearChecklistPrefs() async {
//     if (inspectionId == null) return;
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       String key = 'checklist_${inspectionId}';
//       await prefs.remove(key);
//       print('Checklist cleared for inspection: $inspectionId');
//     } catch (e) {
//       print('Error clearing checklist prefs: $e');
//     }
//   }
//
//   // Method to force refresh from API (useful for pull-to-refresh)
//   Future<void> refreshChecklistFromAPI() async {
//     checklistItems.clear();
//     await getCheckList();
//   }
//
//   // Method to sync local changes with server (call this when submitting)
//   Future<bool> syncChecklistWithServer() async {
//     try {
//       // Implement your API call to sync the checklist changes
//       // This would typically be a PUT or POST request to update the server
//
//       // Example structure:
//       // final response = await ApiService.post(
//       //   endpoint: 'sync-checklist',
//       //   data: {'inspection_id': inspectionId, 'checklist': checklistItems.toList()}
//       // );
//
//       print('Syncing checklist with server for inspection: $inspectionId');
//       return true; // Return true if sync successful
//     } catch (e) {
//       print('Error syncing checklist: $e');
//       return false;
//     }
//   }
//
//   ///--------------Delete this method if not needed----------------
//
// // Add this method to the ApiService class if not already present
//   static String getInspectorCheckList(int inspectorId) =>
//       "/api/inspector/checklist/inspector/$inspectorId";
//
//   Future<void> fetchInspectionItems() async {
//     try {
//       isLoadingDashboard.value = true;
//
//       // Fetch the UID from SharedPreferences
//       String? uid = await ApiService.getUid();
//
//       if (uid == null) {
//         errorMessageDashboard.value = 'User ID not found';
//         return;
//       }
//
//       // Make the API call to fetch inspection items
//       final response = await ApiService.get<Map<String, dynamic>>(
//         endpoint: getTodayScheduleInspector(int.parse(uid)),
//         fromJson: (json) => json as Map<String, dynamic>,
//       );
//
//       if (response.success && response.data != null) {
//         final data = response.data!['data'] as List<dynamic>;
//         inspectionItems.value =
//             data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
//         for (var item in inspectionItems) {
//           print('Status: ${item['status']}');
//         }
//
//         // Calculate dashboard statistics after fetching inspection items
//         _calculateDashboardStats();
//       } else {
//         errorMessageDashboard.value =
//             response.errorMessage ?? 'Failed to load inspection items';
//       }
//     } catch (e) {
//       errorMessageDashboard.value = 'Failed to load inspection items: $e';
//       Get.snackbar('Error', 'Failed to load inspection items');
//     } finally {
//       isLoadingDashboard.value = false;
//     }
//   }
//
//   void changeTab(int index) {
//     selectedTabIndex.value = index;
//   }
//
//   void navigateToInspectionDetails(Map<String, dynamic> item) {
//     Get.toNamed(AppRoutes.inspectorStartInspection, arguments: item);
//   }
//
//   Future<void> refreshDashboard() async {
//     await fetchInspectionItems();
//     await allInspectionsController.fetchAllInspections();
//     Get.snackbar('Success', 'Dashboard refreshed successfully');
//   }
//
//   Color getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'completed':
//       case 'done': // Added this case
//         return const Color(0xFF48BB78); // Professional green
//       case 'pending':
//         return const Color(0xFFA0AEC0); // Professional grey
//       case 'cleaning':
//         return const Color(0xFF3182CE); // Blue for cleaning
//       case 'failed':
//         return const Color(0xFFE53E3E); // Red for failed
//       default:
//         return const Color(0xFFA0AEC0); // Light grey
//     }
//   }
//
//   String getStatusDisplayText(String status) {
//     switch (status.toLowerCase()) {
//       case 'completed':
//       case 'done': // Added this case
//         return 'Completed';
//       case 'pending':
//         return 'Pending';
//       case 'cleaning':
//         return 'Cleaning';
//       case 'failed':
//         return 'Failed';
//       default:
//         return 'Unknown';
//     }
//   }
//
//   void _showImageSourceDialog() {
//     Get.bottomSheet(
//       Container(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Select Image Source',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 20),
//             ListTile(
//               leading: Icon(Icons.camera_alt, color: Colors.blue),
//               title: Text('Camera'),
//               subtitle: Text('Take a new photo'),
//               onTap: () {
//                 Get.back();
//                 _pickImage(ImageSource.camera);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.photo_library, color: Colors.green),
//               title: Text('Gallery'),
//               subtitle: Text('Choose from gallery'),
//               onTap: () {
//                 Get.back();
//                 _pickImage(ImageSource.gallery);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.photo_library_outlined, color: Colors.orange),
//               title: Text('Multiple from Gallery'),
//               subtitle: Text('Choose multiple photos'),
//               onTap: () {
//                 Get.back();
//                 _pickMultipleImages();
//               },
//             ),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//     );
//   }
//
//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       isUploadingImage.value = true;
//       final ImagePicker picker = ImagePicker();
//       final XFile? image = await picker.pickImage(
//         source: source,
//         maxWidth: 1800,
//         maxHeight: 1800,
//         imageQuality: 85,
//       );
//
//       if (image != null) {
//         uploadedImagePaths.add(image.path);
//         Get.snackbar(
//           'Success',
//           'Photo added successfully',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//           duration: Duration(seconds: 2),
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to pick image: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isUploadingImage.value = false;
//     }
//   }
//
//   Future<void> _pickMultipleImages() async {
//     try {
//       isUploadingImage.value = true;
//       final ImagePicker picker = ImagePicker();
//       final List<XFile> images = await picker.pickMultiImage(
//         maxWidth: 1800,
//         maxHeight: 1800,
//         imageQuality: 85,
//       );
//
//       if (images.isNotEmpty) {
//         for (XFile image in images) {
//           uploadedImagePaths.add(image.path);
//         }
//         Get.snackbar(
//           'Success',
//           '${images.length} photos added successfully',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//           duration: Duration(seconds: 2),
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to pick images: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isUploadingImage.value = false;
//     }
//   }
//
//   void uploadImage() {
//     _showImageSourceDialog();
//   }
//
//   void removeImage(int index) {
//     if (index >= 0 && index < uploadedImagePaths.length) {
//       uploadedImagePaths.removeAt(index);
//       Get.snackbar(
//         'Success',
//         'Photo removed successfully',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//         duration: Duration(seconds: 1),
//       );
//     }
//   }
//
//   void viewImageFullScreen(String imagePath) {
//     Get.dialog(
//       Dialog(
//         backgroundColor: Colors.black,
//         child: Stack(
//           children: [
//             Center(
//               child: InteractiveViewer(
//                 child: Image.file(
//                   File(imagePath),
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 40,
//               right: 20,
//               child: IconButton(
//                 onPressed: () => Get.back(),
//                 icon: Icon(
//                   Icons.close,
//                   color: Colors.white,
//                   size: 30,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> submitInspectionReport(
//       Map<String, dynamic> inspectionData) async {
//     if (formKey.currentState!.validate()) {
//       isSubmitting.value = true;
//       try {
//         // Here you would typically make an API call to submit the inspection report
//         // You can access all uploaded images via uploadedImagePaths.value
//         print('Submitting with ${uploadedImagePaths.length} images');
//
//         // For now, we'll just simulate a delay
//         await Future.delayed(const Duration(seconds: 2));
//
//         Get.snackbar(
//           'Success',
//           'Inspection report submitted successfully with ${uploadedImagePaths.length} photos',
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//
//         // Navigate back or to another screen as needed
//         Get.back();
//       } catch (e) {
//         Get.snackbar(
//           'Error',
//           'Failed to submit inspection report: $e',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       } finally {
//         isSubmitting.value = false;
//       }
//     }
//   }
//
//   // ✅ UPDATED CONTROLLER METHOD - Now populates form after fetching
//   Future<void> fetchInspectorData(int inspectionCardId) async {
//     try {
//       String endpoint = getInspectorDataByID(inspectionCardId);
//
//       var response = await ApiService.get<InspectorDataResponse>(
//         endpoint: endpoint,
//         fromJson: (json) => InspectorDataResponse.fromJson(json),
//         includeToken: true,
//       );
//
//       if (response.success) {
//         inspectorDataResponse = response.data; // Store the response data
//         this.inspectionCardId =
//             inspectorDataResponse?.data.id; // Store inspectionCardId
//         print('Fetched data: ${inspectorDataResponse?.data.id}');
//
//         // Populate the form with the fetched data
//         _populateFormWithInspectorData();
//       } else {
//         print('Error fetching data: ${response.errorMessage}');
//         Get.snackbar('Error', 'Failed to load inspection data');
//       }
//     } catch (e) {
//       print('An error occurred: $e');
//       Get.snackbar('Error', 'An error occurred while loading data');
//     }
//   }
//
//   Future<void> updateInspectionReport() async {
//     if (formKey.currentState!.validate()) {
//       // Check if inspectionCardId is available
//       if (inspectionCardId == null) {
//         Get.snackbar('Error', 'Inspection ID not found');
//         return;
//       }
//
//       // Limit photos to maximum 10
//       if (uploadedImagePaths.length > 10) {
//         Get.snackbar('Error', 'Maximum 10 photos allowed');
//         return;
//       }
//
//       isSubmitting.value = true;
//       try {
//         String endpoint = getUpdateInspectorDataEndpoint(inspectionCardId!);
//
//         // Get current date and time
//         DateTime now = DateTime.now();
//         String currentDate = now.toString().split(' ')[0]; // YYYY-MM-DD format
//         String currentTime =
//             "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}"; // HH:MM format
//
//         // Prepare form fields
//         Map<String, String> fields = {
//           'cleaning_date': dateController.text,
//           'cleaning_time': timeController.text,
//           'status': selectedStatus.value,
//           'inspector_review': inspectorReviewController.text,
//           'client_review': clientReviewController.text,
//           'ratings': '4', // Default rating as requested
//           'date': currentDate, // Current date
//           'time': currentTime, // Current time
//         };
//
//         // Prepare files for upload
//         List<MultipartFiles> files = [];
//         for (int i = 0; i < uploadedImagePaths.length; i++) {
//           files.add(MultipartFiles(
//             field:
//                 'attachments', // Use 'attachments' as field name for all images
//             filePath: uploadedImagePaths[i],
//           ));
//         }
//
//         // Make the multipart PUT API call
//         final response = await ApiService.multipartPut<Map<String, dynamic>>(
//           endpoint: endpoint,
//           fields: fields,
//           files: files,
//           fromJson: (json) => json as Map<String, dynamic>,
//           includeToken: true,
//         );
//
//         if (response.success == true) {
//           Get.snackbar(
//             'Success',
//             'Inspection report updated successfully with ${uploadedImagePaths.length} photos',
//             backgroundColor: Colors.green,
//             colorText: Colors.white,
//             duration: Duration(seconds: 2),
//             snackPosition: SnackPosition.BOTTOM, // Show snackbar at the bottom
//           );
//
//           // Optionally refresh the dashboard
//           await refreshDashboard();
//
//           // Navigate back or refresh data as needed
//           Get.offAllNamed(AppRoutes.inspector);
//         } else {
//           Get.snackbar(
//             'Error',
//             response.errorMessage ?? 'Failed to update inspection report',
//             backgroundColor: Colors.red,
//             colorText: Colors.white,
//             duration: Duration(seconds: 3),
//           );
//         }
//       } catch (e) {
//         Get.snackbar(
//           'Error',
//           'Failed to update inspection report: $e',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//           duration: Duration(seconds: 3),
//         );
//         print('Update inspection error: $e');
//       } finally {
//         isSubmitting.value = false;
//       }
//     }
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../API Service/Model/get_status_data.dart';
import '../../API Service/api_service.dart';
import '../../Route Manager/app_routes.dart';
import '../../utils/constants.dart';
import 'all_inspection_controller.dart';

class PlantInspectionController extends GetxController {
  final AllInspectionsController allInspectionsController = Get.put(AllInspectionsController());

  final isLoadingDashboard = false.obs;
  final errorMessageDashboard = Rxn<String>();
  final dashboardData = Rxn<Map<String, dynamic>>();
  final todaysInspections = Rxn<Map<String, dynamic>>();
  final inspectionItems = <Map<String, dynamic>>[].obs;
  InspectorDataResponse? inspectorDataResponse; // Store the response data
  final selectedTabIndex = 0.obs;

  int? inspectionCardId; // Store inspectionCardId

  // Form state variables - these will be unique per instance
  late final TextEditingController dateController;
  late final TextEditingController timeController;
  late final TextEditingController inspectorReviewController;
  late final TextEditingController clientReviewController;
  // Changed from single image to multiple images
  final uploadedImagePaths = <String>[].obs;
  final isUploadingImage = false.obs;
  final uploadedImagePath = Rxn<String>();

  late final GlobalKey<FormState> formKey;
  final selectedStatus = 'pending'.obs;
  final isSubmitting = false.obs;
  final isDataLoaded = false.obs; // Track if inspector data is loaded

  // final statusOptions = ['pending', 'cleaning', 'done', 'failed', 'success'];
  final statusOptions = ['done', 'success', 'cleaning', 'pending', 'failed'];

  @override
  void onInit() {
    super.onInit();

    // Initialize controllers in onInit to ensure unique instances
    dateController = TextEditingController();
    timeController = TextEditingController();
    inspectorReviewController = TextEditingController();
    clientReviewController = TextEditingController();
    formKey = GlobalKey<FormState>();
    getCheckList();

    // Set initial values only if data is not loaded from API
    if (!isDataLoaded.value) {
      _resetFormData();
    }

    // Only fetch inspection items for dashboard instances (not form instances)
    if (Get.currentRoute.contains('dashboard') ||
        Get.currentRoute.contains('inspection_list')) {
      fetchInspectionItems();
    }
    _populateFormWithInspectorData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    dateController.dispose();
    timeController.dispose();
    inspectorReviewController.dispose();
    clientReviewController.dispose();

    //delete
    saveChecklistToPrefs();

    super.onClose();
  }

  // Reset form data to initial state
  void _resetFormData() {
    dateController.text = DateTime.now().toString().split(' ')[0];
    timeController.text = TimeOfDay.now().format(Get.context!);
    selectedStatus.value = 'pending';
    uploadedImagePaths.clear(); // Clear the list instead of setting to null
    inspectorReviewController.clear();
    clientReviewController.clear();
  }

  void _populateFormWithInspectorData() {
    if (inspectorDataResponse?.data != null) {
      final data = inspectorDataResponse!.data;

      // Debug prints to verify the data
      print('Cleaning Date: ${data.cleaningDate}');
      print('Cleaning Time: ${data.cleaningTime}');

      // Populate date and time
      dateController.text = data.cleaningDate != null
          ? data.cleaningDate.toString().split(' ')[0]
          : DateTime.now().toString().split(' ')[0];

      // Ensure the context is valid for time formatting
      if (Get.context != null) {
        timeController.text =
            data.cleaningTime ?? TimeOfDay.now().format(Get.context!);
      } else {
        print('Error: Context is null');
        timeController.text =
        DateTime.now().toString().split(' ')[1].split('.')[0];
      }

      // Populate status
      selectedStatus.value = data.status ?? 'pending';

      // Populate reviews if they exist
      if (data.inspectorReview != null && data.inspectorReview!.isNotEmpty) {
        inspectorReviewController.text = data.inspectorReview!;
      }

      if (data.clientReview != null && data.clientReview!.isNotEmpty) {
        clientReviewController.text = data.clientReview!;
      }

      // Mark data as loaded AFTER setting all values
      isDataLoaded.value = true;

      // Force UI refresh
      update();

      print('Form populated with data:');
      print('Date: ${dateController.text}');
      print('Time: ${timeController.text}');
      print('Status: ${selectedStatus.value}');
      print('Data loaded: ${isDataLoaded.value}');
    } else {
      print('Error: inspectorDataResponse or data is null');
    }
  }

  void _calculateDashboardStats() {
    if (inspectionItems.isEmpty) {
      todaysInspections.value = {
        'count': 0,
        'status': {
          'complete': 0,
          'pending': 0,
          'cleaning': 0,
          'failed': 0,
          'success': 0
        },
      };
      dashboardData.value = {
        'todaysInspections': todaysInspections.value,
      };
      return;
    }

    int completedCount = 0;
    int pendingCount = 0;
    int cleaningCount = 0;
    int failedCount = 0;
    int successCount = 0;

    for (var item in inspectionItems) {
      String status = item['status']?.toString().toLowerCase() ?? '';
      switch (status) {
        case 'completed':
        case 'done':
          completedCount++;
          break;
        case 'pending':
          pendingCount++;
          break;
        case 'cleaning':
          cleaningCount++;
          break;
        case 'failed':
          failedCount++;
          break;
        case 'success':
          successCount++;
          break;
      }
    }

    todaysInspections.value = {
      'count': inspectionItems.length,
      'status': {
        'complete': completedCount,
        'pending': pendingCount,
        'cleaning': cleaningCount,
        'failed': failedCount,
        'success': successCount,
      },
    };

    dashboardData.value = {
      'todaysInspections': todaysInspections.value,
    };
  }

// Add this to your controller (PlantInspectionController)
//   final checklistItems = <Map<String, dynamic>>[].obs;
//   final isLoadingChecklist = false.obs;

  // Future<void> getCheckList() async {
  //   try {
  //     isLoadingChecklist.value = true;
  //     String? uid = await ApiService.getUid();
  //
  //     if (uid == null) {
  //       errorMessageDashboard.value = 'User ID not found';
  //       return;
  //     }
  //
  //     final response = await ApiService.get<Map<String, dynamic>>(
  //       endpoint: getInspectorCheckList(int.parse(uid)),
  //       fromJson: (json) => json as Map<String, dynamic>,
  //     );
  //
  //     if (response.success == true && response.data != null) {
  //       final data = response.data!['data'] as List<dynamic>;
  //       checklistItems.value = data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  //       print('Checklist loaded: ${checklistItems.length} items');
  //     } else {
  //       print('Failed to fetch checklist: ${response.errorMessage}');
  //     }
  //   } catch (e) {
  //     print('An error occurred while fetching the checklist: $e');
  //   } finally {
  //     isLoadingChecklist.value = false;
  //   }
  // }
  // void toggleChecklistItem(int index) {
  //   if (index >= 0 && index < checklistItems.length) {
  //     checklistItems[index]['completed'] = checklistItems[index]['completed'] == 1 ? 0 : 1;
  //     checklistItems.refresh();
  //   }
  // }


  ///--------------Delete this method if not needed----------------
  String? inspectionId;

  // Your existing properties
  RxList<Map<String, dynamic>> checklistItems = <Map<String, dynamic>>[].obs;
  RxBool isLoadingChecklist = false.obs;

  // Set inspection ID (call this when initializing the controller)
  void setInspectionId(String id) {
    inspectionId = id;
    print('Inspection ID set to: $inspectionId');
  }

  // Save checklist to SharedPreferences
  Future<void> saveChecklistToPrefs() async {
    if (inspectionId == null) {
      print('Cannot save: inspectionId is null');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      String key = 'checklist_${inspectionId}';
      String jsonString = jsonEncode(checklistItems.toList());
      await prefs.setString(key, jsonString);
      print('Checklist saved for inspection: $inspectionId (${checklistItems.length} items)');
    } catch (e) {
      print('Error saving checklist to prefs: $e');
    }
  }

  // Load checklist from SharedPreferences
  Future<void> loadChecklistFromPrefs() async {
    if (inspectionId == null) {
      print('Cannot load: inspectionId is null');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      String key = 'checklist_${inspectionId}';
      String? jsonString = prefs.getString(key);

      if (jsonString != null && jsonString.isNotEmpty) {
        List<dynamic> decoded = jsonDecode(jsonString);
        checklistItems.value = decoded.map((item) => Map<String, dynamic>.from(item)).toList();
        print('Checklist loaded from prefs for inspection: $inspectionId (${checklistItems.length} items)');
      } else {
        print('No saved checklist found for inspection: $inspectionId');
      }
    } catch (e) {
      print('Error loading checklist from prefs: $e');
    }
  }

  // Updated getCheckList method to handle your API response structure
  Future<void> getCheckList() async {
    try {
      isLoadingChecklist.value = true;

      // First try to load from SharedPreferences
      await loadChecklistFromPrefs();

      // If no saved data or user wants fresh data, fetch from API
      if (checklistItems.isEmpty) {
        print('No cached data found, fetching from API...');

        String? uid = await ApiService.getUid();
        if (uid == null) {
          errorMessageDashboard.value = 'User ID not found';
          return;
        }

        final response = await ApiService.get<Map<String, dynamic>>(
          endpoint: getInspectorCheckList(int.parse(uid)),
          fromJson: (json) => json as Map<String, dynamic>,
        );

        if (response.success == true && response.data != null) {
          // Handle the actual structure of your API response
          final responseData = response.data!;

          if (responseData['success'] == true && responseData['data'] != null) {
            final List<dynamic> apiData = responseData['data'] as List<dynamic>;

            // Convert API data to your checklist format
            checklistItems.value = apiData.map((item) {
              final itemMap = Map<String, dynamic>.from(item as Map);

              // Map the API fields to your expected format
              // You can adjust this mapping based on your needs
              return {
                'id': itemMap['id'],
                'checklist_id': itemMap['checklist_id'],
                'item_name': itemMap['item_name'],
                'type': itemMap['type'],
                'info': itemMap['info'],
                'inspector_id': itemMap['inspector_id'],
                'distributor_admin_id': itemMap['distributor_admin_id'],
                'assigned_at': itemMap['assigned_at'],
                'completed_at': itemMap['completed_at'],
                'completed': itemMap['completed'] ?? 0, // This is your completion status
                'checked': itemMap['checked'] ?? 0,     // This seems to be another status field
                'inspector_name': itemMap['inspector_name'],
                'distributor_admin_name': itemMap['distributor_admin_name'],
              };
            }).toList();

            print('Checklist loaded from API: ${checklistItems.length} items');

            // Save to SharedPreferences after loading from API
            await saveChecklistToPrefs();
          } else {
            errorMessageDashboard.value = 'Invalid API response structure';
            print('API response success is false or data is null');
          }
        } else {
          errorMessageDashboard.value = response.errorMessage ?? 'Failed to fetch checklist';
          print('Failed to fetch checklist: ${response.errorMessage}');
        }
      } else {
        print('Using cached checklist data: ${checklistItems.length} items');
      }
    } catch (e) {
      errorMessageDashboard.value = 'An error occurred while fetching the checklist';
      print('An error occurred while fetching the checklist: $e');
    } finally {
      isLoadingChecklist.value = false;
    }
  }

  // Updated toggleChecklistItem method
  void toggleChecklistItem(int index) {
    if (index >= 0 && index < checklistItems.length) {
      // Toggle the checked status
      checklistItems[index]['checked'] = checklistItems[index]['checked'] == 1 ? 0 : 1;

      // Optionally, you can also update the completed status if needed
      // checklistItems[index]['completed'] = checklistItems[index]['completed'] == 1 ? 0 : 1;

      // Update completed_at timestamp when marking as checked
      if (checklistItems[index]['checked'] == 1) {
        checklistItems[index]['completed_at'] = DateTime.now().toIso8601String();
      } else {
        checklistItems[index]['completed_at'] = null;
      }

      checklistItems.refresh();

      // Save to SharedPreferences immediately after toggle
      saveChecklistToPrefs();

      print('Toggled item $index: checked=${checklistItems[index]['checked']}');
    }
  }


  // Clear checklist data from SharedPreferences (optional - for cleanup)
  Future<void> clearChecklistPrefs() async {
    if (inspectionId == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      String key = 'checklist_${inspectionId}';
      await prefs.remove(key);
      print('Checklist cleared for inspection: $inspectionId');
    } catch (e) {
      print('Error clearing checklist prefs: $e');
    }
  }

  // Method to force refresh from API (useful for pull-to-refresh)
  Future<void> refreshChecklistFromAPI() async {
    checklistItems.clear();
    await getCheckList();
  }

  // Method to sync local changes with server (call this when submitting)
  Future<bool> syncChecklistWithServer() async {
    try {
      // Implement your API call to sync the checklist changes
      // This would typically be a PUT or POST request to update the server

      // Example structure:
      // final response = await ApiService.post(
      //   endpoint: 'sync-checklist',
      //   data: {'inspection_id': inspectionId, 'checklist': checklistItems.toList()}
      // );

      print('Syncing checklist with server for inspection: $inspectionId');
      return true; // Return true if sync successful
    } catch (e) {
      print('Error syncing checklist: $e');
      return false;
    }
  }

  ///--------------Delete this method if not needed----------------

// Add this method to the ApiService class if not already present
  static String getInspectorCheckList(int inspectorId) =>
      "/api/inspector/checklist/inspector/$inspectorId";

  Future<void> fetchInspectionItems() async {
    try {
      isLoadingDashboard.value = true;

      // Fetch the UID from SharedPreferences
      String? uid = await ApiService.getUid();

      if (uid == null) {
        errorMessageDashboard.value = 'User ID not found';
        return;
      }

      // Make the API call to fetch inspection items
      final response = await ApiService.get<Map<String, dynamic>>(
        endpoint: getTodayScheduleInspector(int.parse(uid)),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final data = response.data!['data'] as List<dynamic>;
        inspectionItems.value =
            data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
        for (var item in inspectionItems) {
          print('Status: ${item['status']}');
        }

        // Calculate dashboard statistics after fetching inspection items
        _calculateDashboardStats();
      } else {
        errorMessageDashboard.value =
            response.errorMessage ?? 'Failed to load inspection items';
      }
    } catch (e) {
      errorMessageDashboard.value = 'Failed to load inspection items: $e';
      Get.snackbar('Error', 'Failed to load inspection items');
    } finally {
      isLoadingDashboard.value = false;
    }
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void navigateToInspectionDetails(Map<String, dynamic> item) {
    Get.toNamed(AppRoutes.inspectorStartInspection, arguments: item);
  }

  Future<void> refreshDashboard() async {
    await fetchInspectionItems();
    await allInspectionsController.fetchAllInspections();
    Get.snackbar('Success', 'Dashboard refreshed successfully');
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'done': // Added this case
        return const Color(0xFF48BB78); // Professional green
      case 'pending':
        return const Color(0xFFA0AEC0); // Professional grey
      case 'cleaning':
        return const Color(0xFF3182CE); // Blue for cleaning
      case 'failed':
        return const Color(0xFFE53E3E); // Red for failed
      default:
        return const Color(0xFFA0AEC0); // Light grey
    }
  }

  String getStatusDisplayText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'done': // Added this case
        return 'Completed';
      case 'pending':
        return 'Pending';
      case 'cleaning':
        return 'Cleaning';
      case 'failed':
        return 'Failed';
      default:
        return 'Unknown';
    }
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

  Future<void> submitInspectionReport(
      Map<String, dynamic> inspectionData) async {
    if (formKey.currentState!.validate()) {
      isSubmitting.value = true;
      try {
        // Here you would typically make an API call to submit the inspection report
        // You can access all uploaded images via uploadedImagePaths.value
        print('Submitting with ${uploadedImagePaths.length} images');

        // For now, we'll just simulate a delay
        await Future.delayed(const Duration(seconds: 2));

        Get.snackbar(
          'Success',
          'Inspection report submitted successfully with ${uploadedImagePaths.length} photos',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate back or to another screen as needed
        Get.back();
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to submit inspection report: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isSubmitting.value = false;
      }
    }
  }

  // ✅ UPDATED CONTROLLER METHOD - Now populates form after fetching
  Future<void> fetchInspectorData(int inspectionCardId) async {
    try {
      String endpoint = getInspectorDataByID(inspectionCardId);

      var response = await ApiService.get<InspectorDataResponse>(
        endpoint: endpoint,
        fromJson: (json) => InspectorDataResponse.fromJson(json),
        includeToken: true,
      );

      if (response.success) {
        inspectorDataResponse = response.data; // Store the response data
        this.inspectionCardId =
            inspectorDataResponse?.data.id; // Store inspectionCardId
        print('Fetched data: ${inspectorDataResponse?.data.id}');

        // Populate the form with the fetched data
        _populateFormWithInspectorData();
      } else {
        print('Error fetching data: ${response.errorMessage}');
        Get.snackbar('Error', 'Failed to load inspection data');
      }
    } catch (e) {
      print('An error occurred: $e');
      Get.snackbar('Error', 'An error occurred while loading data');
    }
  }
  Future<void> updateInspectionReport() async {
    if (formKey.currentState!.validate()) {
      // Check if inspectionCardId is available
      if (inspectionCardId == null) {
        Get.snackbar('Error', 'Inspection ID not found');
        return;
      }

      // Limit photos to maximum 10
      if (uploadedImagePaths.length > 10) {
        Get.snackbar('Error', 'Maximum 10 photos allowed');
        return;
      }

      isSubmitting.value = true;
      try {
        String endpoint = getUpdateInspectorDataEndpoint(inspectionCardId!);

        // Get current date and time
        DateTime now = DateTime.now();
        String currentDate = now.toString().split(' ')[0]; // YYYY-MM-DD format
        String currentTime =
            "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}"; // HH:MM format

        // Prepare checklist data - only the 3 required fields
        List<Map<String, dynamic>> checklistResult = checklistItems.map((item) => {
          'id': item['id'],
          'checked': item['checked'] ?? 0,
          'item_name': item['item_name'],
        }).toList();

        // Convert to JSON string
        String checklistJsonString = jsonEncode(checklistResult);

        // Log the JSON string to check size (remove in production)
        print('Checklist JSON size: ${checklistJsonString.length} characters');
        print('Total checklist items: ${checklistItems.length}');

        // Prepare form fields
        Map<String, String> fields = {
          'cleaning_date': dateController.text,
          'cleaning_time': timeController.text,
          'status': selectedStatus.value,
          'inspector_review': inspectorReviewController.text,
          'client_review': clientReviewController.text,
          'ratings': '4', // Default rating as requested
          'date': currentDate, // Current date
          'time': currentTime, // Current time
          'inspector_checklist_result': checklistJsonString, // Send as JSON string
        };

        // Prepare files for upload
        List<MultipartFiles> files = [];
        for (int i = 0; i < uploadedImagePaths.length; i++) {
          files.add(MultipartFiles(
            field: 'attachments', // Use 'attachments' as field name for all images
            filePath: uploadedImagePaths[i],
          ));
        }

        // Make the multipart PUT API call
        final response = await ApiService.multipartPut<Map<String, dynamic>>(
          endpoint: endpoint,
          fields: fields,
          files: files,
          fromJson: (json) => json as Map<String, dynamic>,
          includeToken: true,
        );

        if (response.success == true) {
          // Calculate completion stats for success message
          int completedItems = checklistItems.where((item) => item['checked'] == 1).length;
          int totalItems = checklistItems.length;

          Get.snackbar(
            'Success',
            'Inspection report submitted successfully with checklist (${completedItems}/${totalItems} items completed)',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
          );

          // Clear saved checklist from SharedPreferences after successful submission
          await clearChecklistPrefs();

          // Optionally refresh the dashboard
          await refreshDashboard();

          // Navigate back or refresh data as needed
          Get.offAllNamed(AppRoutes.inspector);
        } else {
          Get.snackbar(
            'Error',
            response.errorMessage ?? 'Failed to update inspection report',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to update inspection report: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        print('Update inspection error: $e');
      } finally {
        isSubmitting.value = false;
      }
    }
  }

}
