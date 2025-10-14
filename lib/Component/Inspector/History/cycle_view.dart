import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:solar_app/Component/Inspector/History/widget/filter.dart';
import '../../../Model/Inspector/history_model.dart';
import 'history_controller.dart';

class CycleGroupWidget extends StatelessWidget {
  final CycleData cycle;
  final bool isLastGroup;
  InspectorHistoryController controller;

  CycleGroupWidget({
    super.key,
    required this.cycle,
    required this.isLastGroup,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final summary = cycle.summary;
    final isCompleted = summary.isCompleted;
    final hasFault = summary.faultCount > 0;

    Color headerColor = isCompleted
        ? Colors.green[700]!
        : hasFault
            ? Colors.red[700]!
            : Colors.blue[700]!;

    Color headerBgColor = isCompleted
        ? Colors.green[50]!
        : hasFault
            ? Colors.red[50]!
            : Colors.blue[50]!;

    return Container(
      margin: EdgeInsets.only(bottom: isLastGroup ? 0 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          // Cycle Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: headerBgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: headerColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: headerColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.check_circle
                        : hasFault
                            ? Icons.error
                            : Icons.refresh,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cleaning Cycle #${cycle.cycleNumber}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: headerColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        isCompleted
                            ? 'Completed Successfully'
                            : hasFault
                                ? 'Completed with ${summary.faultCount} Fault(s)'
                                : 'In Progress/Stopped',
                        style: TextStyle(
                          fontSize: 14,
                          color: headerColor.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: headerColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: headerColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    '${summary.totalEvents} event${summary.totalEvents != 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: headerColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          // Cycle Summary Info
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryItem(
                    'Started', summary.startedAt, Icons.play_arrow),
                if (summary.completedAt != null) ...[
                  SizedBox(height: 8),
                  _buildSummaryItem(
                      'Completed', summary.completedAt!, Icons.check),
                ],
                SizedBox(height: 8),
                _buildSummaryItem(
                    'Start Method', summary.startMethod, Icons.touch_app),
                SizedBox(height: 8),
                _buildSummaryItem(
                    'Stop Method', summary.stopMethod, Icons.stop_circle),
                SizedBox(height: 8),
                _buildSummaryItem(
                  'Solenoid Range',
                  '${summary.solenoidRange.min} - ${summary.solenoidRange.max}',
                  Icons.info,
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          // Timeline for events
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              children: cycle.events.asMap().entries.map((entry) {
                int index = entry.key;
                CycleEvent event = entry.value;
                bool isLastEvent = index == cycle.events.length - 1;

                return _buildTimelineItem(event, isLastEvent);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(CycleEvent event, bool isLast) {
    String timeAgo = 'Unknown time';
    String fullDate = 'Unknown date';

    if (event.timestamp.isNotEmpty) {
      try {
        DateTime dateTime = DateTime.parse(event.timestamp);
        DateTime now = DateTime.now();
        Duration difference = now.difference(dateTime);

        if (difference.inMinutes < 1) {
          timeAgo = 'Just now';
        } else if (difference.inMinutes < 60) {
          timeAgo = '${difference.inMinutes}m ago';
        } else if (difference.inHours < 24) {
          timeAgo = '${difference.inHours}h ago';
        } else {
          timeAgo = '${difference.inDays}d ago';
        }

        fullDate =
            DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime.toLocal());
      } catch (e) {
        timeAgo = 'Unknown';
        fullDate = event.timestamp;
      }
    }

    Color circleColor = Colors.grey[400]!;
    Color textColor = Colors.grey[700]!;
    IconData statusIcon = Icons.circle;
    String statusText = event.status;

    if (event.complete == 1 ||
        event.status.toLowerCase().contains('cycle complete')) {
      circleColor = Colors.green[500]!;
      textColor = Colors.green[700]!;
      statusIcon = Icons.check_circle;
    } else if (event.status.toLowerCase().contains('fault') ||
        event.status.toLowerCase().contains('error')) {
      circleColor = Colors.red[500]!;
      textColor = Colors.red[700]!;
      statusIcon = Icons.error;
    } else if (event.status.toLowerCase().contains('started')) {
      circleColor = Colors.blue[500]!;
      textColor = Colors.blue[700]!;
      statusIcon = Icons.play_circle;
    } else if (event.status.toLowerCase().contains('stopped')) {
      circleColor = Colors.orange[500]!;
      textColor = Colors.orange[700]!;
      statusIcon = Icons.pause_circle;
    } else if (event.status.toLowerCase().contains('warning')) {
      circleColor = Colors.amber[500]!;
      textColor = Colors.amber[700]!;
      statusIcon = Icons.warning;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: circleColor.withOpacity(0.3),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  statusIcon,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 50,
                  color: Colors.grey[300],
                  margin: EdgeInsets.symmetric(vertical: 4),
                ),
            ],
          ),

          SizedBox(width: 12),

          // Content
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (event.solenoid != 0)
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.purple[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.purple[200]!),
                          ),
                          child: Text(
                            'Solenoid: ${event.solenoid}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.purple[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Device Time: ',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            event.time,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
