import 'package:flutter/material.dart';

class AlertItem extends StatelessWidget {
  final Map<String, dynamic> alert;

  const AlertItem({Key? key, required this.alert}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine alert level and set appropriate color
    Color backgroundColor;
    switch (alert['level']) {
      case 'high':
        backgroundColor = Colors.red[400]!;
        break;
      case 'medium':
        backgroundColor = Colors.orange[300]!;
        break;
      case 'low':
      default:
        backgroundColor = Colors.grey[300]!;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            alert['title'] ?? 'Alert',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            alert['time'] ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}