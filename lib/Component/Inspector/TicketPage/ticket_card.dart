
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../Controller/Inspector/ticket_controller.dart';

class TicketCardWidget extends StatelessWidget {
  final Map<String, dynamic> ticket;
  final Function(String) onCallPressed;
  final Function(String) onNavigatePressed;
  final Function(Map<String, dynamic>) onTap;

  const TicketCardWidget({
    Key? key,
    required this.ticket,
    required this.onCallPressed,
    required this.onNavigatePressed,
    required this.onTap,
  }) : super(key: key);

  Map<String, String> _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) {
      return {'date': 'N/A', 'time': 'N/A'};
    }

    try {
      DateTime dateTime = DateTime.parse(dateTimeStr);
      String formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);
      String formattedTime = DateFormat('h:mm a').format(dateTime);

      return {'date': formattedDate, 'time': formattedTime};
    } catch (e) {
      return {'date': 'N/A', 'time': 'N/A'};
    }
  }



  Color _getStatusColor(bool isClosed) {
    return isClosed ? const Color(0xFF38A169) : const Color(0xFFED8936);
  }

  @override
  Widget build(BuildContext context) {
    final bool isClosed = ticket['status'] == 'closed';
    final String priority = ticket['priority'] ?? '3'; // Default to Medium
    final Map<String, String> dateTime = _formatDateTime(ticket['createdAt']);

    return GestureDetector(
      onTap: () => onTap(ticket),
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: _getStatusColor(isClosed).withOpacity(0.3),
            width: 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isClosed, priority),
              SizedBox(height: 12.h),
              if (ticket['description'] != null &&
                  ticket['description'].toString().isNotEmpty)
                _buildDescription(),
              SizedBox(height: 12.h),
              _buildDetailsSection(dateTime),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isClosed, String priority) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title: ${ticket['title'] ?? 'Untitled Ticket'}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3748),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              _buildStatusIndicator(isClosed),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        _buildPriorityBadge(priority),
      ],
    );
  }

  Widget _buildPriorityBadge(String priority) {
    final TicketController ticketController = Get.find<TicketController>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: ticketController.getPriorityColor(priority),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        ticketController.getPriorityLabel(priority).toUpperCase(),
        style: TextStyle(
          fontSize: 10.sp,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(bool isClosed) {
    return Row(
      children: [
        Container(
          width: 6.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: _getStatusColor(isClosed),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          isClosed ? 'Closed' : 'Open',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: _getStatusColor(isClosed),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.w,
        ),
      ),
      child: Text(
        ticket['description'] ?? '',
        style: TextStyle(
          fontSize: 13.sp,
          color: const Color(0xFF4A5568),
          height: 1.4,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDetailsSection(Map<String, String> dateTime) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  'Creator',
                  ticket['creator_name'] ?? 'Unknown',
                  Icons.account_circle_outlined,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildDetailItem(
                  'Department',
                  ticket['department'] ?? 'N/A',
                  Icons.business_outlined,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  'Date',
                  dateTime['date']!,
                  Icons.calendar_today_outlined,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildDetailItem(
                  'Time',
                  dateTime['time']!,
                  Icons.access_time_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14.w,
          color: const Color(0xFF718096),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: const Color(0xFF718096),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF2D3748),
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRemarkSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.note_outlined,
                size: 14.w,
                color: const Color(0xFF718096),
              ),
              SizedBox(width: 6.w),
              Text(
                'Remark',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: const Color(0xFF718096),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            ticket['remark'] ?? 'No remarks',
            style: TextStyle(
              fontSize: 11.sp,
              color: const Color(0xFF2D3748),
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
