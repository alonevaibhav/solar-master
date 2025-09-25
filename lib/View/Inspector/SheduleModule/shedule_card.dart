// // widgets/schedule_card_widget.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:solar_app/API%20Service/Model/Request/shedule_model.dart';
//
// class ScheduleCardWidget extends StatelessWidget {
//   final Schedule schedule;
//   final VoidCallback? onTap;
//
//   const ScheduleCardWidget({
//     Key? key,
//     required this.schedule,
//     this.onTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     try {
//       return _buildCard(context);
//     } catch (e) {
//       return Container(
//         padding: EdgeInsets.all(16.w),
//         decoration: BoxDecoration(
//           color: Colors.red[100],
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child: Text('Error rendering schedule card: $e'),
//       );
//     }
//   }
//
//   Widget _buildCard(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.only(bottom: 12.h),
//         padding: EdgeInsets.all(16.w),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12.r),
//           border: Border.all(color: Colors.grey[200]!),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             _buildScheduleHeader(),
//             SizedBox(height: 12.h),
//             _buildScheduleDetails(),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Widget _buildScheduleHeader() {
//     return Row(
//       children: [
//         _buildStatusIcon(),
//         SizedBox(width: 12.w),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Schedule ID: ${schedule.id}',
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   _buildStatusBadge(),
//                 ],
//               ),
//               SizedBox(height: 4.h),
//               Text(
//                 'Plant ID: ${schedule.plantId}',
//                 style: TextStyle(
//                   fontSize: 12.sp,
//                   color: Colors.grey[600],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatusIcon() {
//     return Container(
//       padding: EdgeInsets.all(8.w),
//       decoration: BoxDecoration(
//         color: _getStatusColor().withOpacity(0.1),
//         shape: BoxShape.circle,
//       ),
//       child: Icon(
//         _getStatusIcon(),
//         color: _getStatusColor(),
//         size: 20.sp,
//       ),
//     );
//   }
//
//   Widget _buildStatusBadge() {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: 8.w,
//         vertical: 4.h,
//       ),
//       decoration: BoxDecoration(
//         color: _getStatusColor(),
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: Text(
//         _capitalizeStatus(),
//         style: TextStyle(
//           fontSize: 10.sp,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildScheduleDetails() {
//     return Container(
//       padding: EdgeInsets.all(12.w),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(8.r),
//       ),
//       child: Column(
//         children: [
//           _buildScheduleInfoRow(),
//           SizedBox(height: 8.h),
//           _buildWeekDayRow(),
//           SizedBox(height: 8.h),
//           _buildInspectorActiveRow(),
//           if (schedule.notes != null && schedule.notes!.isNotEmpty && schedule.notes != 'null') ...[
//             SizedBox(height: 8.h),
//             _buildNotesSection(),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildScheduleInfoRow() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildDetailItem(
//             Icons.calendar_today_outlined,
//             'Schedule',
//             _formatScheduleDate(schedule.scheduleDate),
//           ),
//         ),
//         Expanded(
//           child: _buildDetailItem(
//             Icons.access_time_outlined,
//             'Time',
//             _formatTime(schedule.inspection_time),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildWeekDayRow() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildDetailItem(
//             Icons.view_week_outlined,
//             'Week',
//             'Week ${schedule.week}',
//           ),
//         ),
//         Expanded(
//           child: _buildDetailItem(
//             Icons.today_outlined,
//             'Day',
//             _getDayName(schedule.day),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildInspectorActiveRow() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildDetailItem(
//             Icons.person_outline,
//             'Inspector',
//             'ID: ${schedule.inspectorId}',
//           ),
//         ),
//         Expanded(
//           child: _buildDetailItem(
//             Icons.assignment_ind_outlined,
//             'Assigned By',
//             'ID: ${schedule.assignedBy}',
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildNotesSection() {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(8.w),
//       decoration: BoxDecoration(
//         color: Colors.blue[50],
//         borderRadius: BorderRadius.circular(6.r),
//         border: Border.all(color: Colors.blue[200]!),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.notes_outlined,
//                 size: 14.sp,
//                 color: Colors.blue[700],
//               ),
//               SizedBox(width: 4.w),
//               Text(
//                 'Notes:',
//                 style: TextStyle(
//                   fontSize: 11.sp,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.blue[700],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 4.h),
//           Text(
//             schedule.notes!,
//             style: TextStyle(
//               fontSize: 11.sp,
//               color: Colors.blue[800],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailItem(IconData icon, String label, String value) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           size: 14.sp,
//           color: Colors.grey[600],
//         ),
//         SizedBox(width: 4.w),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 10.sp,
//                   color: Colors.grey[500],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 11.sp,
//                   color: Colors.black87,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Helper methods for status handling
//   Color _getStatusColor() {
//     String status = schedule.status.toLowerCase();
//     switch (status) {
//       case 'completed':
//         return Colors.green;
//       case 'in_progress':
//         return Colors.orange;
//       case 'scheduled':
//         return Colors.blue;
//       case 'pending':
//         return Colors.amber;
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   IconData _getStatusIcon() {
//     String status = schedule.status.toLowerCase();
//     switch (status) {
//       case 'completed':
//         return Icons.check_circle_outline;
//       case 'in_progress':
//         return Icons.hourglass_empty_outlined;
//       case 'scheduled':
//         return Icons.schedule_outlined;
//       case 'pending':
//         return Icons.pending_outlined;
//       case 'cancelled':
//         return Icons.cancel_outlined;
//       default:
//         return Icons.help_outline;
//     }
//   }
//
//   String _capitalizeStatus() {
//     if (schedule.status.isEmpty) return 'Pending';
//     return schedule.status.split('_').map((word) =>
//     word[0].toUpperCase() + word.substring(1).toLowerCase()
//     ).join(' ');
//   }
//
//   // Helper methods for date/time formatting
//   String _formatScheduleDate(String dateStr) {
//     if (dateStr.isEmpty) return 'N/A';
//     try {
//       DateTime date = DateTime.parse(dateStr);
//       return '${date.day}/${date.month}/${date.year}';
//     } catch (e) {
//       print('Date parsing error: $e for date: $dateStr');
//       return 'Invalid Date';
//     }
//   }
//
//   String _formatTime(String timeStr) {
//     if (timeStr.isEmpty) return 'N/A';
//     try {
//       List<String> parts = timeStr.split(':');
//       if (parts.length < 2) return timeStr;
//
//       int hour = int.parse(parts[0]);
//       int minute = int.parse(parts[1]);
//
//       String period = 'AM';
//       if (hour >= 12) {
//         period = 'PM';
//         if (hour > 12) hour -= 12;
//       }
//       if (hour == 0) hour = 12;
//
//       return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
//     } catch (e) {
//       print('Time parsing error: $e for time: $timeStr');
//       return timeStr;
//     }
//   }
//
//   String _getDayName(String day) {
//     switch (day.toLowerCase()) {
//       case 'mo':
//         return 'Monday';
//       case 'tu':
//         return 'Tuesday';
//       case 'we':
//         return 'Wednesday';
//       case 'th':
//         return 'Thursday';
//       case 'fr':
//         return 'Friday';
//       case 'sa':
//         return 'Saturday';
//       case 'su':
//         return 'Sunday';
//       default:
//         return day.isNotEmpty ? day : 'N/A';
//     }
//   }
// }


// widgets/schedule_card_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_app/API%20Service/Model/Request/shedule_model.dart';

class ScheduleCardWidget extends StatefulWidget {
  final Schedule schedule;
  final VoidCallback? onTap;
  final bool isLoading;

  const ScheduleCardWidget({
    Key? key,
    required this.schedule,
    this.onTap,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<ScheduleCardWidget> createState() => _ScheduleCardWidgetState();
}

class _ScheduleCardWidgetState extends State<ScheduleCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isLoading && widget.onTap != null) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return _buildCard(context);
    } catch (e) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text('Error rendering schedule card: $e'),
      );
    }
  }

  Widget _buildCard(BuildContext context) {
    final double scale = 0.8;
    final statusColor = _getStatusColor();
    final gradientColors = _getGradientColors();

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 12.h * scale, horizontal: 1.w * scale),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r * scale),
              border: Border.all(
                color: Colors.black26,
                width: 0.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.r * scale),
                onTap: widget.isLoading ? null : widget.onTap,
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r * scale),
                    border: Border.all(
                      color: _isPressed
                          ? statusColor.withOpacity(0.3)
                          : Colors.grey.shade200,
                      width: 1.5,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Subtle background pattern
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r * scale),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.grey.shade50.withOpacity(0.3),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ),

                      // Main content
                      AnimatedOpacity(
                        opacity: widget.isLoading ? 0.7 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Column(
                          children: [
                            // Enhanced header section
                            Container(
                              padding: EdgeInsets.all(10.w * scale),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: gradientColors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.r * scale),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Enhanced schedule icon
                                  Container(
                                    width: 40.w * scale,
                                    height: 40.h * scale,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          statusColor.withOpacity(0.1),
                                          statusColor.withOpacity(0.2),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: statusColor.withOpacity(0.2),
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.schedule_rounded,
                                      size: 25.sp * scale,
                                      color: statusColor,
                                    ),
                                  ),
                                  SizedBox(width: 16.w * scale),

                                  // Schedule info
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Schedule #${widget.schedule.id}',
                                          style: TextStyle(
                                            fontSize: 18.sp * scale,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF1F2937),
                                            height: 1.2,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4.h * scale),
                                        Text(
                                          'Plant ID: ${widget.schedule.plantId}',
                                          style: TextStyle(
                                            fontSize: 12.sp * scale,
                                            color: const Color(0xFF6B7280),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6.w * scale,
                                            vertical: 4.h * scale,
                                          ),
                                          decoration: BoxDecoration(
                                            color: statusColor,
                                            borderRadius: BorderRadius.circular(16.r * scale),
                                            boxShadow: [
                                              BoxShadow(
                                                color: statusColor.withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                _getStatusIcon(),
                                                size: 9.sp * scale,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 3.w * scale),
                                              Text(
                                                _capitalizeStatus(),
                                                style: TextStyle(
                                                  fontSize: 9.sp * scale,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        SizedBox(width: 5.h * scale),

                                        // Week tag
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6.w * scale,
                                            vertical: 4.h * scale,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(16.r * scale),
                                            border: Border.all(
                                              color: const Color(0xFF3B82F6).withOpacity(0.2),
                                              width: 1.5,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.05),
                                                blurRadius: 4,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            'Week ${widget.schedule.week}',
                                            style: TextStyle(
                                              fontSize: 9.sp * scale,
                                              color: const Color(0xFF3B82F6),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Details section with icons
                            Padding(
                              padding: EdgeInsets.all(20.w * scale),
                              child: Column(
                                children: [
                                  // Date and time
                                  _buildInfoRow(
                                    Icons.calendar_today_outlined,
                                    'Schedule',
                                    '${_formatScheduleDate(widget.schedule.scheduleDate)} • ${_formatTime(widget.schedule.inspection_time)}',
                                    scale,
                                  ),

                                  SizedBox(height: 16.h * scale),

                                  // Day and Week
                                  _buildInfoRow(
                                    Icons.today_outlined,
                                    'Day & Week',
                                    '${_getDayName(widget.schedule.day)} • Week ${widget.schedule.week}',
                                    scale,
                                  ),

                                  SizedBox(height: 16.h * scale),

                                  // Inspector
                                  _buildInfoRow(
                                    Icons.person_outline,
                                    'Inspector',
                                    'ID: ${widget.schedule.inspectorId} • Assigned by: ${widget.schedule.assignedBy}',
                                    scale,
                                  ),

                                  // Notes section (if available)
                                  if (widget.schedule.notes != null &&
                                      widget.schedule.notes!.isNotEmpty &&
                                      widget.schedule.notes != 'null') ...[
                                    SizedBox(height: 16.h * scale),
                                    _buildNotesSection(scale),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, double scale) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32.w * scale,
          height: 32.h * scale,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r * scale),
          ),
          child: Icon(
            icon,
            size: 18.sp * scale,
            color: const Color(0xFF3B82F6),
          ),
        ),
        SizedBox(width: 12.w * scale),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp * scale,
                  color: const Color(0xFF6B7280),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 2.h * scale),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp * scale,
                  color: const Color(0xFF1F2937),
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(double scale) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w * scale),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12.r * scale),
        border: Border.all(
          color: Colors.blue.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(4.w * scale),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(6.r * scale),
                ),
                child: Icon(
                  Icons.notes_outlined,
                  size: 16.sp * scale,
                  color: Colors.blue.shade700,
                ),
              ),
              SizedBox(width: 8.w * scale),
              Text(
                'Notes',
                style: TextStyle(
                  fontSize: 12.sp * scale,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h * scale),
          Text(
            widget.schedule.notes!,
            style: TextStyle(
              fontSize: 13.sp * scale,
              color: Colors.blue.shade800,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for status handling
  Color _getStatusColor() {
    int isActive = widget.schedule.isActive; // Assuming isActive is an int field
    return isActive == 1 ? const Color(0xFF3B82F6) : const Color(0xFFEF4444);
  }


  List<Color> _getGradientColors() {
    int isActive = widget.schedule.isActive;

    if (isActive == 1) {
      // Active - use green shades
      return[Colors.blue.shade50, Colors.blue.shade100];

    } else {
      // Inactive - use red shades
      return [Colors.red.shade50, Colors.red.shade100];
    }
  }


  // IconData _getStatusIcon() {
  //   String status = widget.schedule.status.toLowerCase();
  //   switch (status) {
  //     case 'completed':
  //       return Icons.check_circle_outline;
  //     case 'in_progress':
  //       return Icons.hourglass_empty_outlined;
  //     case 'scheduled':
  //       return Icons.schedule_outlined;
  //     case 'pending':
  //       return Icons.pending_outlined;
  //     case 'cancelled':
  //       return Icons.cancel_outlined;
  //     default:
  //       return Icons.help_outline;
  //   }
  // }
  //
  // String _capitalizeStatus() {
  //   if (widget.schedule.status.isEmpty) return 'Pending';
  //   return widget.schedule.status.split('_').map((word) =>
  //   word[0].toUpperCase() + word.substring(1).toLowerCase()
  //   ).join(' ');
  // }
  IconData _getStatusIcon() {
    return widget.schedule.isActive == 1 ?
    Icons.check_circle_rounded :
    Icons.cancel_rounded;
  }

  String _capitalizeStatus() {
    String status = widget.schedule.isActive == 1 ? "active" : "inactive";
    return status[0].toUpperCase() + status.substring(1);
  }


  // Helper methods for date/time formatting
  String _formatScheduleDate(String dateStr) {
    if (dateStr.isEmpty) return 'N/A';
    try {
      DateTime date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      print('Date parsing error: $e for date: $dateStr');
      return 'Invalid Date';
    }
  }

  String _formatTime(String timeStr) {
    if (timeStr.isEmpty) return 'N/A';
    try {
      List<String> parts = timeStr.split(':');
      if (parts.length < 2) return timeStr;

      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      String period = 'AM';
      if (hour >= 12) {
        period = 'PM';
        if (hour > 12) hour -= 12;
      }
      if (hour == 0) hour = 12;

      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      print('Time parsing error: $e for time: $timeStr');
      return timeStr;
    }
  }

  String _getDayName(String day) {
    switch (day.toLowerCase()) {
      case 'mo':
        return 'Monday';
      case 'tu':
        return 'Tuesday';
      case 'we':
        return 'Wednesday';
      case 'th':
        return 'Thursday';
      case 'fr':
        return 'Friday';
      case 'sa':
        return 'Saturday';
      case 'su':
        return 'Sunday';
      default:
        return day.isNotEmpty ? day : 'N/A';
    }
  }
}