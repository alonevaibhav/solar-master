// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../../API Service/api_service.dart';
// import '../../../../utils/image_full_screen.dart';
//
// class TicketChatController extends GetxController {
//   final currentUserId = 8;
//   final currentUserType = "inspector";
//   final ticketId = 65.obs;
//
//   final messages = <Map<String, dynamic>>[].obs;
//   final messageController = TextEditingController();
//   final scrollController = ScrollController();
//   final isLoading = false.obs;
//   final isSending = false.obs;
//   final uploadedImagePaths = <String>[].obs;
//   final uploadedVideoPaths = <String>[].obs;
//   final isUploadingImage = false.obs;
//   final isUploadingVideo = false.obs;
//
//   Timer? _pollingTimer;
//
//   final String initialTicketId;
//   final ticketIdInspector =
//       ''.obs; // Assuming you're using GetX for state management
//
//   TicketChatController({required this.initialTicketId}) {
//     ticketIdInspector.value = initialTicketId; // Store the initialTicketId
//   }
//
//   List<Map<String, dynamic>> mockMessages = [
//     {
//       "id": 14,
//       "date": "2025-06-11T11:45:09.000Z",
//       "ticket_id": 65,
//       "time": "17:15:09",
//       "sender_id": 8,
//       "msg": "Hello, I need help with this ticket issue.",
//       "created_at": "2025-06-11T11:45:09.000Z",
//       "updatedAt": "2025-06-11T11:45:09.000Z",
//       "sender_type": "inspector",
//       "ip": "::ffff:127.0.0.1",
//       "ticket_title": "Yes bbb",
//       "ticket_status": "open",
//       "sender_name": "John Doe",
//       "attachments": [
//         {
//           "id": 29,
//           "ticket_id": 65,
//           "chat_id": 14,
//           "uploaded_by": "inspector",
//           "uploaded_by_id": 0,
//           "path": "https://picsum.photos/400/300?random=1",
//           "type": "image",
//           "createdAt": "2025-06-11T05:54:46.000Z",
//           "updatedAt": "2025-06-11T05:54:46.000Z",
//           "ip": 0
//         }
//       ]
//     },
//     {
//       "id": 15,
//       "date": "2025-06-11T11:45:13.000Z",
//       "ticket_id": 65,
//       "time": "17:15:13",
//       "sender_id": 28,
//       "msg":
//           "Hi! I'm here to help you with your issue. What exactly seems to be the problem?",
//       "created_at": "2025-06-11T11:45:13.000Z",
//       "updatedAt": "2025-06-11T11:45:13.000Z",
//       "sender_type": "distributor_admin",
//       "ip": "192.168.1.1",
//       "ticket_title": "Yes bbb",
//       "ticket_status": "open",
//       "sender_name": "Admin One",
//       "attachments": []
//     },
//     {
//       "id": 16,
//       "date": "2025-06-11T11:45:14.000Z",
//       "ticket_id": 65,
//       "time": "17:15:14",
//       "sender_id": 8,
//       "msg":
//           "The system is not responding properly when I try to submit the form. Here are some screenshots and a video:",
//       "created_at": "2025-06-11T11:45:14.000Z",
//       "updatedAt": "2025-06-11T11:45:14.000Z",
//       "sender_type": "inspector",
//       "ip": "::ffff:127.0.0.1",
//       "ticket_title": "Yes bbb",
//       "ticket_status": "open",
//       "sender_name": "John Doe",
//       "attachments": [
//         {
//           "id": 30,
//           "ticket_id": 65,
//           "chat_id": 16,
//           "uploaded_by": "inspector",
//           "uploaded_by_id": 8,
//           "path": "https://picsum.photos/400/300?random=2",
//           "type": "image",
//           "createdAt": "2025-06-11T05:54:46.000Z",
//           "updatedAt": "2025-06-11T05:54:46.000Z",
//           "ip": 0
//         },
//         {
//           "id": 31,
//           "ticket_id": 65,
//           "chat_id": 16,
//           "uploaded_by": "inspector",
//           "uploaded_by_id": 8,
//           "path":
//               "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4",
//           "type": "video",
//           "createdAt": "2025-06-11T06:10:34.000Z",
//           "updatedAt": "2025-06-11T06:10:34.000Z",
//           "ip": 0
//         }
//       ]
//     },
//     {
//       "id": 17,
//       "date": "2025-06-11T11:45:15.000Z",
//       "ticket_id": 65,
//       "time": "17:15:15",
//       "sender_id": 28,
//       "msg":
//           "I understand the issue. Let me check the logs and get back to you shortly.",
//       "created_at": "2025-06-11T11:45:15.000Z",
//       "updatedAt": "2025-06-11T11:45:15.000Z",
//       "sender_type": "distributor_admin",
//       "ip": "192.168.1.1",
//       "ticket_title": "Yes bbb",
//       "ticket_status": "open",
//       "sender_name": "Admin One",
//       "attachments": []
//     }
//   ];
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchMessages();
//     startPolling();
//   }
//
//   @override
//   void onClose() {
//     _pollingTimer?.cancel();
//     messageController.dispose();
//     scrollController.dispose();
//     super.onClose();
//   }
//
//   void startPolling() {
//     _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
//       fetchMessages(showLoading: false);
//     });
//   }
//
//   Future<void> fetchMessages({bool showLoading = true}) async {
//     try {
//       if (showLoading) isLoading.value = true;
//
//       // Use ApiService to make the GET request
//       final response = await ApiService.get<Map<String, dynamic>>(
//         endpoint:
//             "/ticketChat/chat/ticket/inspector/${ticketIdInspector.value}",
//         fromJson: (json) => json as Map<String, dynamic>,
//       );
//
//       if (response.success && response.data != null) {
//         var data = response.data!['data'];
//         if (data != null &&
//             data is Map<String, dynamic> &&
//             data['data'] != null) {
//           final newMessages = List<Map<String, dynamic>>.from(data['data']);
//
//           // Only update if messages changed to avoid unnecessary rebuilds
//           if (!_areMessagesEqual(messages, newMessages)) {
//             messages.assignAll(newMessages);
//             _scrollToBottom();
//           }
//         }
//       } else {
//         _showError(response.errorMessage ?? 'Failed to fetch messages');
//       }
//     } catch (e) {
//       _showError('Network error: ${e.toString()}');
//     } finally {
//       if (showLoading) isLoading.value = false;
//     }
//   }
//
//   Future<void> sendMessage() async {
//     final message = messageController.text.trim();
//     if (message.isEmpty &&
//         uploadedImagePaths.isEmpty &&
//         uploadedVideoPaths.isEmpty) return;
//
//     try {
//       isSending.value = true;
//       await Future.delayed(const Duration(milliseconds: 800));
//
//       final now = DateTime.now();
//       final newMessageId =
//           mockMessages.isNotEmpty ? mockMessages.last['id'] + 1 : 1;
//
//       // Create attachments list combining images and videos
//       List<Map<String, dynamic>> attachments = [];
//
//       // Add image attachments
//       attachments.addAll(uploadedImagePaths.map((path) => {
//             "path": path,
//             "type": "image",
//           }));
//
//       // Add video attachments
//       attachments.addAll(uploadedVideoPaths.map((path) => {
//             "path": path,
//             "type": "video",
//           }));
//
//       final mockSentMessage = {
//         "id": newMessageId,
//         "date": now.toIso8601String(),
//         "ticket_id": ticketId.value,
//         "time":
//             "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
//         "sender_id": currentUserId,
//         "msg": message,
//         "created_at": now.toIso8601String(),
//         "updatedAt": now.toIso8601String(),
//         "sender_type": currentUserType,
//         "ip": "::ffff:127.0.0.1",
//         "ticket_title": "Yes bbb",
//         "ticket_status": "open",
//         "sender_name": "John Doe",
//         "attachments": attachments,
//       };
//
//       final mockPostResponse = {
//         "message": "Ticket chat created successfully",
//         "success": true,
//         "data": mockSentMessage,
//         "errors": []
//       };
//
//       if (mockPostResponse['success'] == true) {
//         messageController.clear();
//         uploadedImagePaths.clear();
//         uploadedVideoPaths.clear();
//
//         mockMessages.add(mockSentMessage);
//         messages.add(mockSentMessage);
//         _scrollToBottom();
//
//         Get.snackbar(
//           'Success',
//           'Message sent successfully',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.green.shade100,
//           colorText: Colors.green.shade800,
//           margin: const EdgeInsets.all(16),
//           borderRadius: 8,
//           duration: const Duration(seconds: 2),
//         );
//       } else {
//         _showError('Failed to send message');
//       }
//     } catch (e) {
//       _showError('Network error: ${e.toString()}');
//     } finally {
//       isSending.value = false;
//     }
//   }
//
//   void _showMediaSourceDialog() {
//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.all(20),
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
//             const SizedBox(height: 20),
//             Text(
//               'Select Media',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Image options
//             ListTile(
//               leading: const Icon(Icons.camera_alt, color: Colors.blue),
//               title: const Text('Take Photo'),
//               subtitle: const Text('Capture a new photo'),
//               onTap: () {
//                 Get.back();
//                 _pickImage(ImageSource.camera);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library, color: Colors.green),
//               title: const Text('Photo Gallery'),
//               subtitle: const Text('Choose from gallery'),
//               onTap: () {
//                 Get.back();
//                 _pickImage(ImageSource.gallery);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library_outlined,
//                   color: Colors.orange),
//               title: const Text('Multiple Photos'),
//               subtitle: const Text('Choose multiple photos'),
//               onTap: () {
//                 Get.back();
//                 _pickMultipleImages();
//               },
//             ),
//             // Video options
//             ListTile(
//               leading: const Icon(Icons.videocam, color: Colors.red),
//               title: const Text('Record Video'),
//               subtitle: const Text('Record a new video'),
//               onTap: () {
//                 Get.back();
//                 _pickVideo(ImageSource.camera);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.video_library, color: Colors.purple),
//               title: const Text('Video Gallery'),
//               subtitle: const Text('Choose from gallery'),
//               onTap: () {
//                 Get.back();
//                 _pickVideo(ImageSource.gallery);
//               },
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
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
//           duration: const Duration(seconds: 2),
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
//         uploadedImagePaths.addAll(images.map((image) => image.path));
//         Get.snackbar(
//           'Success',
//           '${images.length} photos added successfully',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//           duration: const Duration(seconds: 2),
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
//   Future<void> _pickVideo(ImageSource source) async {
//     try {
//       isUploadingVideo.value = true;
//       final ImagePicker picker = ImagePicker();
//       final XFile? video = await picker.pickVideo(
//         source: source,
//         maxDuration: const Duration(minutes: 5), // Limit video duration
//       );
//
//       if (video != null) {
//         uploadedVideoPaths.add(video.path);
//         Get.snackbar(
//           'Success',
//           'Video added successfully',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//           duration: const Duration(seconds: 2),
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to pick video: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isUploadingVideo.value = false;
//     }
//   }
//
//   void uploadMedia() {
//     _showMediaSourceDialog();
//   }
//
//   // Keep the old method for backward compatibility
//   void uploadImage() {
//     uploadMedia();
//   }
//
//   bool isMyMessage(Map<String, dynamic> message) {
//     return message['sender_id'] == currentUserId &&
//         message['sender_type'] == currentUserType;
//   }
//
//   String getSenderName(Map<String, dynamic> message) {
//     if (isMyMessage(message)) {
//       return 'You';
//     }
//     return message['sender_name'] ?? 'Unknown';
//   }
//
//   String getMessageTime(Map<String, dynamic> message) {
//     try {
//       final time = message['time'] as String;
//       return time.substring(0, 5);
//     } catch (e) {
//       return '';
//     }
//   }
//
//   String getMessageDate(Map<String, dynamic> message) {
//     try {
//       final dateStr = message['date'] as String;
//       final date = DateTime.parse(dateStr);
//       final now = DateTime.now();
//
//       if (date.day == now.day &&
//           date.month == now.month &&
//           date.year == now.year) {
//         return 'Today';
//       } else if (date.day == now.day - 1 &&
//           date.month == now.month &&
//           date.year == now.year) {
//         return 'Yesterday';
//       } else {
//         return '${date.day}/${date.month}/${date.year}';
//       }
//     } catch (e) {
//       return '';
//     }
//   }
//
//   List<Map<String, dynamic>> getAttachments(Map<String, dynamic> message) {
//     try {
//       final attachments = message['attachments'];
//       if (attachments != null && attachments is List) {
//         return List<Map<String, dynamic>>.from(attachments);
//       }
//       return [];
//     } catch (e) {
//       return [];
//     }
//   }
//
//   List<Map<String, dynamic>> getImageAttachments(
//       List<Map<String, dynamic>> attachments) {
//     return attachments
//         .where((attachment) =>
//             attachment['type'] == 'image' || attachment['type'] == null)
//         .toList();
//   }
//
//   List<Map<String, dynamic>> getVideoAttachments(
//       List<Map<String, dynamic>> attachments) {
//     return attachments
//         .where((attachment) => attachment['type'] == 'video')
//         .toList();
//   }
//
//   String getMediaUrl(String path) {
//     // Check if the path is already a valid URL
//     if (path.startsWith('http://') || path.startsWith('https://')) {
//       return path;
//     }
//     // If not, return the path as-is
//     return path;
//   }
//
// // Keep the old method for backward compatibility
//   String getImageUrl(String path) {
//     return getMediaUrl(path);
//   }
//
//   void openImageFullScreen(
//       String imageUrl, List<String> allImages, int initialIndex) {
//     Get.to(() => ImageFullScreenView(
//           imageUrl: imageUrl,
//           allImages: allImages,
//           initialIndex: initialIndex,
//         ));
//   }
//
//   Future<void> refreshMessages() async {
//     await fetchMessages();
//   }
//
//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (scrollController.hasClients) {
//         scrollController.animateTo(
//           scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   void _showError(String message) {
//     Get.snackbar(
//       'Error',
//       message,
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.red.shade100,
//       colorText: Colors.red.shade800,
//       margin: const EdgeInsets.all(16),
//       borderRadius: 8,
//       duration: const Duration(seconds: 3),
//     );
//   }
//
//   bool _areMessagesEqual(
//       List<Map<String, dynamic>> list1, List<Map<String, dynamic>> list2) {
//     if (list1.length != list2.length) return false;
//     for (int i = 0; i < list1.length; i++) {
//       if (list1[i]['id'] != list2[i]['id']) return false;
//     }
//     return true;
//   }
// }


import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../API Service/api_service.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/image_full_screen.dart';

class TicketChatController extends GetxController {
  final currentUserId = 8;
  final currentUserType = "inspector";
  final ticketId = 65.obs;

  final messages = <Map<String, dynamic>>[].obs;
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final isLoading = false.obs;
  final isSending = false.obs;
  final uploadedImagePaths = <String>[].obs;
  final uploadedVideoPaths = <String>[].obs;
  final isUploadingImage = false.obs;
  final isUploadingVideo = false.obs;

  Timer? _pollingTimer;

  final String initialTicketId;
  final ticketIdInspector =
      ''.obs; // Assuming you're using GetX for state management

  TicketChatController({required this.initialTicketId}) {
    ticketIdInspector.value = initialTicketId; // Store the initialTicketId
  }

  List<Map<String, dynamic>> mockMessages = [
    {
      "id": 14,
      "date": "2025-06-11T11:45:09.000Z",
      "ticket_id": 65,
      "time": "17:15:09",
      "sender_id": 8,
      "msg": "Hello, I need help with this ticket issue.",
      "created_at": "2025-06-11T11:45:09.000Z",
      "updatedAt": "2025-06-11T11:45:09.000Z",
      "sender_type": "inspector",
      "ip": "::ffff:127.0.0.1",
      "ticket_title": "Yes bbb",
      "ticket_status": "open",
      "sender_name": "John Doe",
      "attachments": [
        {
          "id": 29,
          "ticket_id": 65,
          "chat_id": 14,
          "uploaded_by": "inspector",
          "uploaded_by_id": 0,
          "path": "https://picsum.photos/400/300?random=1",
          "type": "image",
          "createdAt": "2025-06-11T05:54:46.000Z",
          "updatedAt": "2025-06-11T05:54:46.000Z",
          "ip": 0
        }
      ]
    },
    {
      "id": 15,
      "date": "2025-06-11T11:45:13.000Z",
      "ticket_id": 65,
      "time": "17:15:13",
      "sender_id": 28,
      "msg":
      "Hi! I'm here to help you with your issue. What exactly seems to be the problem?",
      "created_at": "2025-06-11T11:45:13.000Z",
      "updatedAt": "2025-06-11T11:45:13.000Z",
      "sender_type": "distributor_admin",
      "ip": "192.168.1.1",
      "ticket_title": "Yes bbb",
      "ticket_status": "open",
      "sender_name": "Admin One",
      "attachments": []
    },
    {
      "id": 16,
      "date": "2025-06-11T11:45:14.000Z",
      "ticket_id": 65,
      "time": "17:15:14",
      "sender_id": 8,
      "msg":
      "The system is not responding properly when I try to submit the form. Here are some screenshots and a video:",
      "created_at": "2025-06-11T11:45:14.000Z",
      "updatedAt": "2025-06-11T11:45:14.000Z",
      "sender_type": "inspector",
      "ip": "::ffff:127.0.0.1",
      "ticket_title": "Yes bbb",
      "ticket_status": "open",
      "sender_name": "John Doe",
      "attachments": [
        {
          "id": 30,
          "ticket_id": 65,
          "chat_id": 16,
          "uploaded_by": "inspector",
          "uploaded_by_id": 8,
          "path": "https://picsum.photos/400/300?random=2",
          "type": "image",
          "createdAt": "2025-06-11T05:54:46.000Z",
          "updatedAt": "2025-06-11T05:54:46.000Z",
          "ip": 0
        },
        {
          "id": 31,
          "ticket_id": 65,
          "chat_id": 16,
          "uploaded_by": "inspector",
          "uploaded_by_id": 8,
          "path":
          "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4",
          "type": "video",
          "createdAt": "2025-06-11T06:10:34.000Z",
          "updatedAt": "2025-06-11T06:10:34.000Z",
          "ip": 0
        }
      ]
    },
    {
      "id": 17,
      "date": "2025-06-11T11:45:15.000Z",
      "ticket_id": 65,
      "time": "17:15:15",
      "sender_id": 28,
      "msg":
      "I understand the issue. Let me check the logs and get back to you shortly.",
      "created_at": "2025-06-11T11:45:15.000Z",
      "updatedAt": "2025-06-11T11:45:15.000Z",
      "sender_type": "distributor_admin",
      "ip": "192.168.1.1",
      "ticket_title": "Yes bbb",
      "ticket_status": "open",
      "sender_name": "Admin One",
      "attachments": []
    }
  ];

  @override
  void onInit() {
    super.onInit();
    fetchMessages();
    startPolling();
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      fetchMessages(showLoading: false);
    });
  }

  Future<void> fetchMessages({bool showLoading = true}) async {
    try {
      if (showLoading) isLoading.value = true;

      // Use ApiService to make the GET request
      final response = await ApiService.get<Map<String, dynamic>>(
        endpoint: "/ticketChat/chat/ticket/inspector/${ticketIdInspector.value}",
        // endpoint:  getChatByID(ticketIdInspector as int) ,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        var data = response.data!['data'];
        if (data != null &&
            data is Map<String, dynamic> &&
            data['data'] != null) {
          final newMessages = List<Map<String, dynamic>>.from(data['data']);

          // Only update if messages changed to avoid unnecessary rebuilds
          if (!_areMessagesEqual(messages, newMessages)) {
            messages.assignAll(newMessages);
            _scrollToBottom();
          }
        }
      } else {
        _showError(response.errorMessage ?? 'Failed to fetch messages');
      }
    } catch (e) {
      _showError('Network error: ${e.toString()}');
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final message = messageController.text.trim();
    if (message.isEmpty && uploadedImagePaths.isEmpty && uploadedVideoPaths.isEmpty) return;

    try {
      isSending.value = true;

      final now = DateTime.now();

      // Prepare fields for multipart request
      Map<String, String> fields = {
        "ticket_id": ticketIdInspector.value,
        "msg": message,
        "ip": "127.0.0.1", // Default IP
      };

      // Prepare files for multipart request
      List<MultipartFiles> files = [];

      // Add image files
      for (var path in uploadedImagePaths) {
        files.add(MultipartFiles(
          field: 'attachments',
          filePath: path,
        ));
      }

      // Add video files
      for (var path in uploadedVideoPaths) {
        files.add(MultipartFiles(
          field: 'attachments',
          filePath: path,
        ));
      }

      // Use ApiService to make the multipart POST request
      final response = await ApiService.multipartPost<Map<String, dynamic>>(
        endpoint: "/ticketChat/chat/inspector",
        fields: fields,
        files: files,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        messageController.clear();
        uploadedImagePaths.clear();
        uploadedVideoPaths.clear();

        // Assuming the response contains the new message data
        final newMessage = response.data!;
        messages.add(newMessage);
        _scrollToBottom();

        Get.snackbar(
          'Success',
          'Message sent successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 2),
        );
      } else {
        _showError(response.errorMessage ?? 'Failed to send message');
      }
    } catch (e) {
      _showError('Network error: ${e.toString()}');
    } finally {
      isSending.value = false;
    }
  }


  void _showMediaSourceDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 20),
            Text(
              'Select Media',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Image options
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Take Photo'),
              subtitle: const Text('Capture a new photo'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Photo Gallery'),
              subtitle: const Text('Choose from gallery'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: Colors.orange),
              title: const Text('Multiple Photos'),
              subtitle: const Text('Choose multiple photos'),
              onTap: () {
                Get.back();
                _pickMultipleImages();
              },
            ),
            // Video options
            ListTile(
              leading: const Icon(Icons.videocam, color: Colors.red),
              title: const Text('Record Video'),
              subtitle: const Text('Record a new video'),
              onTap: () {
                Get.back();
                _pickVideo(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library, color: Colors.purple),
              title: const Text('Video Gallery'),
              subtitle: const Text('Choose from gallery'),
              onTap: () {
                Get.back();
                _pickVideo(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
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
          duration: const Duration(seconds: 2),
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
        uploadedImagePaths.addAll(images.map((image) => image.path));
        Get.snackbar(
          'Success',
          '${images.length} photos added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
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

  Future<void> _pickVideo(ImageSource source) async {
    try {
      isUploadingVideo.value = true;
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 5), // Limit video duration
      );

      if (video != null) {
        uploadedVideoPaths.add(video.path);
        Get.snackbar(
          'Success',
          'Video added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick video: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploadingVideo.value = false;
    }
  }

  void uploadMedia() {
    _showMediaSourceDialog();
  }

  // Keep the old method for backward compatibility
  void uploadImage() {
    uploadMedia();
  }

  bool isMyMessage(Map<String, dynamic> message) {
    return message['sender_id'] == currentUserId &&
        message['sender_type'] == currentUserType;
  }

  String getSenderName(Map<String, dynamic> message) {
    if (isMyMessage(message)) {
      return 'You';
    }
    return message['sender_name'] ?? 'Unknown';
  }

  String getMessageTime(Map<String, dynamic> message) {
    try {
      final time = message['time'] as String;
      return time.substring(0, 5);
    } catch (e) {
      return '';
    }
  }

  String getMessageDate(Map<String, dynamic> message) {
    try {
      final dateStr = message['date'] as String;
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();

      if (date.day == now.day &&
          date.month == now.month &&
          date.year == now.year) {
        return 'Today';
      } else if (date.day == now.day - 1 &&
          date.month == now.month &&
          date.year == now.year) {
        return 'Yesterday';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return '';
    }
  }

  List<Map<String, dynamic>> getAttachments(Map<String, dynamic> message) {
    try {
      final attachments = message['attachments'];
      if (attachments != null && attachments is List) {
        return List<Map<String, dynamic>>.from(attachments);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  List<Map<String, dynamic>> getImageAttachments(
      List<Map<String, dynamic>> attachments) {
    return attachments
        .where((attachment) =>
    attachment['type'] == 'image' || attachment['type'] == null)
        .toList();
  }

  List<Map<String, dynamic>> getVideoAttachments(
      List<Map<String, dynamic>> attachments) {
    return attachments
        .where((attachment) => attachment['type'] == 'video')
        .toList();
  }

  String getMediaUrl(String path) {
    // Check if the path is already a valid URL
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    // If not, return the path as-is
    return path;
  }

// Keep the old method for backward compatibility
  String getImageUrl(String path) {
    return getMediaUrl(path);
  }

  void openImageFullScreen(
      String imageUrl, List<String> allImages, int initialIndex) {
    Get.to(() => ImageFullScreenView(
      imageUrl: imageUrl,
      allImages: allImages,
      initialIndex: initialIndex,
    ));
  }

  Future<void> refreshMessages() async {
    await fetchMessages();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade800,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
    );
  }

  bool _areMessagesEqual(
      List<Map<String, dynamic>> list1, List<Map<String, dynamic>> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i]['id'] != list2[i]['id']) return false;
    }
    return true;
  }
}
