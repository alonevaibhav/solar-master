import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';


Widget buildSummaryItem(String label, String value, IconData icon) {
  return Row(
    children: [
      Icon(icon, size: 14, color: Colors.grey[500]),
      SizedBox(width: 8),
      Text(
        '$label:',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(width: 8),
      Expanded(
        child: Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[800],
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}