import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Route Manager/app_routes.dart';

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? plantData = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Options'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildScheduleTile(
              title: 'Automatic Schedule',
              description: 'Let the system optimize your schedule',
              icon: Icons.auto_awesome,
              color: Colors.blue,
              onTap: () {
                Get.toNamed(AppRoutes.automaticSchedule, arguments: plantData);
              },            ),
            SizedBox(height: 16),
            _buildScheduleTile(
              title: 'Manual Schedule',
              description: 'Create your own custom schedule',
              icon: Icons.edit_calendar,
              color: Colors.green,
              onTap: () {
                Get.toNamed(AppRoutes.manualSchedule, arguments: plantData);
              },            ),
            SizedBox(height: 16),
            _buildScheduleTile(
              title: 'Schedule Info',
              description: 'View your current schedule details',
              icon: Icons.info,
              color: Colors.orange,
              onTap: () {
                Get.toNamed(AppRoutes.cleanerHelp, arguments: plantData);
              },            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleTile({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}