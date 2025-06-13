import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solar_app/Component/Cleaner/plant_card.dart';

class AssignedPlantsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Assigned Plants',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          PlantCard(
            name: 'Abc Plant Name',
            autoCleanTime: 'hh:mm',
            status: 'Inspection Pending',
            location: 'XYZ-1 Pune Maharashtra(411052)',
            totalPanels: 32,
            cleanPanels: 20,
          ),
          // Add more PlantCard widgets as needed
        ],
      ),
    );
  }
}