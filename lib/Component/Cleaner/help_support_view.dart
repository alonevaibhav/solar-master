// controllers/slot_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../Controller/Inspector/manual_controller.dart';

class SlotController extends GetxController {
  final List<Map<String, String>> slots = [
    {'code': '550', 'description': 'slot 1 on time'},
    {'code': '554', 'description': 'slot 1 off time'},
    {'code': '551', 'description': 'slot 2 on time'},
    {'code': '555', 'description': 'slot 2 off time'},
    {'code': '552', 'description': 'slot 3 on time'},
    {'code': '556', 'description': 'slot 3 off time'},
    {'code': '553', 'description': 'slot 4 on time'},
    {'code': '557', 'description': 'slot 4 off time'},
  ].obs;

  // Helper function to convert seconds to HH:MM:SS format
  String formatSeconds(dynamic secondsValue) {
    // Handle both String and int input
    final seconds = secondsValue is String
        ? int.tryParse(secondsValue) ?? 0
        : secondsValue is int
        ? secondsValue
        : 0;

    if (seconds < 0) return '00:00:00';

    final hours = (seconds / 3600).truncate();
    final minutes = ((seconds % 3600) / 60).truncate();
    final remainingSeconds = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

class InfoPage extends StatelessWidget {
  final ManualController controller = Get.find<ManualController>();
  final SlotController slotController = Get.put(SlotController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slot Timings'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text('Error: ${controller.errorMessage.value}'));
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: controller.slotTimingsForDisplay.length,
          itemBuilder: (context, index) {
            final slot = controller.slotTimingsForDisplay[index];
            final formattedTime = slotController.formatSeconds(slot['value']);

            return Card(
              margin: EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${slot['code']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            slot['description'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Time: $formattedTime',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}