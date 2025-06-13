import 'package:flutter/material.dart';

class ScheduleItem extends StatelessWidget {
  final Map<String, dynamic> schedule;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ScheduleItem({
    Key? key,
    required this.schedule,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isMarkedForDeletion = schedule['isMarkedForDeletion'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isMarkedForDeletion ? Colors.amber[100] : Colors.green[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Delete indicator
          if (isMarkedForDeletion)
            Container(
              width: 36,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red[300],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
                size: 20,
              ),
            ),

          // Schedule content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.watch_later_outlined,
                    size: 20,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${schedule['day']}, ${schedule['time']}${schedule['amPm']}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Edit button
          if (!isMarkedForDeletion)
            IconButton(
              icon: const Icon(
                Icons.edit,
                size: 20,
                color: Colors.black54,
              ),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }
}