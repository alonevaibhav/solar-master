
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/Cleaner/cleanup_controller.dart';
import 'cleanup_card.dart';

class CleanUpHistoryView extends StatelessWidget {
  const CleanUpHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.put(CleanUpHistoryController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Clean-up History',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildDateHeader(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: controller.cleanupItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cleanupItems[index];
                  return CleanupCardWidget(
                    areaNumber: item.areaNumber,
                    date: item.date,
                    time: item.time,
                    panelCount: item.panelCount,
                    plantName: item.plantName,
                    plantId: item.plantId,
                    location: item.location,
                    onSendRemarkTap: () => controller.onSendRemarkTap(),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tuesday',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              '9/11 Sep',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.calendar_today,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}