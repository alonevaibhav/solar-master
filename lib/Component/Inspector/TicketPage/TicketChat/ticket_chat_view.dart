
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solar_app/Component/Inspector/TicketPage/TicketChat/ticket_chat_controller.dart';

import '../../../../utils/video_player.dart';

class TicketChatView extends StatelessWidget {
  const TicketChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> ticketData = Get.arguments;
    final String ticketId = ticketData['id'];
    print('Ticket ID: $ticketId');
    final TicketChatController controller = Get.put(TicketChatController(initialTicketId: ticketId));


    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey.shade700, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ticket Chat',
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Ticket #${controller.ticketId.value}',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.grey.shade700, size: 20.sp),
            onPressed: controller.refreshMessages,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.messages.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                  ),
                );
              }

              if (controller.messages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 64.sp,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No messages yet',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Start the conversation!',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshMessages,
                color: const Color(0xFF2196F3),
                child: ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    final isMyMessage = controller.isMyMessage(message);
                    final showDate = index == 0 ||
                        controller.getMessageDate(controller.messages[index - 1]) !=
                            controller.getMessageDate(message);

                    return Column(
                      children: [
                        if (showDate) ...[
                          SizedBox(height: 16.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              controller.getMessageDate(message),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],
                        _buildMessageBubble(message, isMyMessage, controller),
                        SizedBox(height: 8.h),
                      ],
                    );
                  },
                ),
              );
            }),
          ),
          Obx(() {
            final hasMedia = controller.uploadedImagePaths.isNotEmpty ||
                controller.uploadedVideoPaths.isNotEmpty;

            return hasMedia
                ? Container(
              height: 100.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.uploadedImagePaths.length +
                    controller.uploadedVideoPaths.length,
                itemBuilder: (context, index) {
                  if (index < controller.uploadedImagePaths.length) {
                    return _buildImagePreview(
                        controller.uploadedImagePaths[index],
                        index,
                        controller,
                        isImage: true
                    );
                  } else {
                    final videoIndex = index - controller.uploadedImagePaths.length;
                    return _buildVideoPreview(
                        controller.uploadedVideoPaths[videoIndex],
                        videoIndex,
                        controller
                    );
                  }
                },
              ),
            )
                : SizedBox.shrink();
          }),
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.attachment, color: Colors.grey.shade700, size: 24.sp),
                    onPressed: controller.uploadMedia,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: TextField(
                        controller: controller.messageController,
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => controller.sendMessage(),
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 12.h,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Obx(() => GestureDetector(
                    onTap: controller.isSending.value ? null : controller.sendMessage,
                    child: Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: controller.isSending.value
                            ? Colors.grey.shade300
                            : const Color(0xFF2196F3),
                        borderRadius: BorderRadius.circular(22.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2196F3).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: controller.isSending.value
                          ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isMyMessage, TicketChatController controller) {
    final attachments = controller.getAttachments(message);
    final hasText = message['msg'] != null && message['msg'].toString().trim().isNotEmpty;

    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: 280.w),
        margin: EdgeInsets.only(
          left: isMyMessage ? 60.w : 0,
          right: isMyMessage ? 0 : 60.w,
        ),
        child: Column(
          crossAxisAlignment: isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMyMessage) ...[
              Padding(
                padding: EdgeInsets.only(left: 12.w, bottom: 4.h),
                child: Text(
                  controller.getSenderName(message),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            if (hasText || attachments.isNotEmpty) ...[
              Container(
                decoration: BoxDecoration(
                  color: isMyMessage ? const Color(0xFF2196F3) : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.r),
                    topRight: Radius.circular(18.r),
                    bottomLeft: Radius.circular(isMyMessage ? 18.r : 4.r),
                    bottomRight: Radius.circular(isMyMessage ? 4.r : 18.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isMyMessage ? const Color(0xFF2196F3).withOpacity(0.3) : Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasText) ...[
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, attachments.isEmpty ? 4.h : 8.h),
                        child: Text(
                          message['msg'] ?? '',
                          style: TextStyle(
                            color: isMyMessage ? Colors.white : Colors.grey.shade800,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                    if (attachments.isNotEmpty) ...[
                      _buildAttachments(attachments, isMyMessage, controller),
                    ],
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
                      child: Text(
                        controller.getMessageTime(message),
                        style: TextStyle(
                          color: isMyMessage ? Colors.white.withOpacity(0.7) : Colors.grey.shade500,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAttachments(List<Map<String, dynamic>> attachments, bool isMyMessage, TicketChatController controller) {
    final imageAttachments = controller.getImageAttachments(attachments );
    final videoAttachments = controller.getVideoAttachments(attachments );

    return Column(
      children: [
        if (imageAttachments.isNotEmpty)
          _buildImageAttachments(imageAttachments, isMyMessage, controller),
        if (videoAttachments.isNotEmpty)
          _buildVideoAttachments(videoAttachments, isMyMessage, controller),
      ],
    );
  }

  Widget _buildImageAttachments(List<Map<String, dynamic>> attachments, bool isMyMessage, TicketChatController controller) {
    final imageUrls = attachments
        .map((attachment) => controller.getImageUrl(attachment['path'] ?? ''))
        .where((url) => url.isNotEmpty)
        .toList();

    if (imageUrls.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.fromLTRB(8.w, 0, 8.w, 8.h),
      child: _buildImageGrid(imageUrls, controller),
    );
  }

  Widget _buildVideoAttachments(List<Map<String, dynamic>> attachments, bool isMyMessage, TicketChatController controller) {
    return Container(
      margin: EdgeInsets.fromLTRB(8.w, 0, 8.w, 8.h),
      child: Column(
        children: attachments.map((attachment) {
          return GestureDetector(
            onTap: () {
              _navigateToVideoPlayer(Get.context!, attachment['path']);
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Icon(Icons.videocam, color: Colors.grey.shade700),
                  SizedBox(width: 8.w),
                  Text(
                    'Video Attachment',
                    style: TextStyle(
                      color: isMyMessage ? Colors.white : Colors.grey.shade800,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildImageGrid(List<String> imageUrls, TicketChatController controller) {
    if (imageUrls.isEmpty) return const SizedBox.shrink();

    if (imageUrls.length == 1) {
      return _buildImageThumbnail(imageUrls[0], imageUrls, 0, controller, width: 200.w, height: 150.h);
    } else if (imageUrls.length == 2) {
      return Row(
        children: [
          Expanded(
            child: _buildImageThumbnail(imageUrls[0], imageUrls, 0, controller, width: 140.w, height: 120.h),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: _buildImageThumbnail(imageUrls[1], imageUrls, 1, controller, width: 140.w, height: 120.h),
          ),
        ],
      );
    } else {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.w,
          mainAxisSpacing: 4.h,
          childAspectRatio: 1,
        ),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return _buildImageThumbnail(imageUrls[index], imageUrls, index, controller, width: 140.w, height: 120.h);
        },
      );
    }
  }

  Widget _buildImageThumbnail(String imagePath, List<String> allImageUrls, int index, TicketChatController controller, {required double width, required double height}) {
    return GestureDetector(
      onTap: () {
        controller.openImageFullScreen(imagePath, allImageUrls, index);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 4.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: imagePath.startsWith('http://') || imagePath.startsWith('https://')
              ? Image.network(
            imagePath,
            width: width,
            height: height,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return Container(
                  width: width,
                  height: height,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: width,
                height: height,
                color: Colors.grey.shade200,
                child: const Icon(Icons.error),
              );
            },
          )
              : Image.file(
            File(imagePath),
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: width,
                height: height,
                color: Colors.grey.shade200,
                child: const Icon(Icons.error),
              );
            },
          ),
        ),
      ),
    );
  }



  Widget _buildImagePreview(String imagePath, int index, TicketChatController controller, {required bool isImage}) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(right: 8.w),
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            image: DecorationImage(
              image: FileImage(File(imagePath)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            icon: Icon(Icons.cancel, size: 20.sp, color: Colors.red),
            onPressed: () {
              controller.uploadedImagePaths.removeAt(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPreview(String videoPath, int index, TicketChatController controller) {
    return GestureDetector(
      onTap: () {
        _navigateToVideoPlayer(Get.context!, videoPath);
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(right: 8.w),
            width: 100.w,
            height: 100.h,
            color: Colors.grey.shade200,
            child: Icon(
              Icons.videocam,
              color: Colors.grey.shade400,
              size: 40.sp,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: Icon(Icons.cancel, size: 20.sp, color: Colors.red),
              onPressed: () {
                controller.uploadedVideoPaths.removeAt(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToVideoPlayer(BuildContext context, String videoPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoPath: videoPath),
      ),
    );
  }
}
