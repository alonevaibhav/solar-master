import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solar_app/Component/Cleaner/support_card.dart';

class HelpSupportView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Help & Support',
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
      body: SupportCard(
        name: 'Inspector Name',
        phone: '+91 9876543210',
      ),
    );
  }
}