import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InspectionItem extends StatefulWidget {
  final Map<String, dynamic> inspectionData;
  final VoidCallback onTap;

  const InspectionItem({
    Key? key,
    required this.inspectionData,
    required this.onTap,
  }) : super(key: key);

  @override
  State<InspectionItem> createState() => _InspectionItemState();
}

class _InspectionItemState extends State<InspectionItem> with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Color _getStatusColor() {
    final status = widget.inspectionData['status']?.toString().toLowerCase() ?? '';
    switch (status) {
      case 'completed':
      case 'done':  // Added this case
        return const Color(0xFF48BB78); // Professional green
      case 'success':  // Added this case
        return const Color(0xFF48B7BB); // Professional green
      case 'pending':
        return const Color(0xFF718096); // Professional grey
      case 'cleaning':
        return const Color(0xFF3182CE); // Blue for cleaning
      case 'failed':
        return const Color(0xFFE53E3E); // Red for failed
      default:
        return const Color(0xFFA0AEC0); // Light grey for unknown
    }
  }

  String _getStatusDisplayText() {
    final status = widget.inspectionData['status']?.toString().toLowerCase() ?? '';
    switch (status) {
      case 'completed':
      case 'done':  // Added this case
        return 'Completed';
      case 'success':  // Added this case
        return 'Success';
      case 'pending':
        return 'Pending';
      case 'cleaning':
        return 'Cleaning';
      case 'failed':
        return 'Failed';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final plantName = widget.inspectionData['plant_name'] ?? 'Unknown Plant';
    final plantAddress = widget.inspectionData['plant_address'] ?? 'Address not available';
    final inspectorName = widget.inspectionData['inspector_name'] ?? 'Unknown Inspector';
    final cleanerName = widget.inspectionData['cleaner_name'] ?? 'Unknown Cleaner';
    final time = widget.inspectionData['time'] ?? 'Time not set';
    final totalPanels = widget.inspectionData['total_panels']?.toString() ?? '0';
    final capacity = widget.inspectionData['capacity_w']?.toString() ?? '0';
    final area = widget.inspectionData['area_squrM']?.toString() ?? '0';
    final location = widget.inspectionData['plant_location'] ?? 'Location not specified';
    final stateName = widget.inspectionData['state_name'] ?? '';
    final talukaName = widget.inspectionData['taluka_name'] ?? '';
    final areaName = widget.inspectionData['area_name'] ?? '';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: _getStatusColor().withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE2E8F0),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          children: [
            // Main card content - clickable to expand
            GestureDetector(
              onTap: _toggleExpansion,
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _getStatusColor(),
                      _getStatusColor().withOpacity(0.85),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            plantName,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            _getStatusDisplayText(),
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: Colors.white.withOpacity(0.9),
                          size: 16.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            plantAddress,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.white.withOpacity(0.9),
                          size: 16.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Scheduled: $time',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isExpanded ? 'Tap to collapse details' : 'Tap to view details',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.white.withOpacity(0.7),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white.withOpacity(0.8),
                            size: 18.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Expandable details section
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(Icons.person, 'Inspector', inspectorName),
                    SizedBox(height: 12.h),
                    _buildDetailRow(Icons.cleaning_services, 'Cleaner', cleanerName),
                    SizedBox(height: 16.h),

                    // Plant specifications section
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7FAFC),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: _getStatusColor().withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Plant Specifications',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D3748),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: _buildSpecItem('Total Panels', totalPanels, Icons.solar_power),
                              ),
                              Expanded(
                                child: _buildSpecItem('Capacity', '${capacity}W', Icons.battery_charging_full),
                              ),
                              Expanded(
                                child: _buildSpecItem('Area', '${area}m²', Icons.area_chart),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    if (location.isNotEmpty)
                      _buildDetailRow(Icons.business, 'Plant Location', location),
                    if (stateName.isNotEmpty || talukaName.isNotEmpty || areaName.isNotEmpty)
                      SizedBox(height: 12.h),
                    if (stateName.isNotEmpty || talukaName.isNotEmpty || areaName.isNotEmpty)
                      _buildDetailRow(
                        Icons.map,
                        'Region',
                        [areaName, talukaName, stateName].where((s) => s.isNotEmpty).join(', '),
                      ),

                    SizedBox(height: 20.h),

                    // Start Inspection Button inside expandable section
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getStatusColor(),
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shadowColor: _getStatusColor().withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_circle_filled,
                              size: 20.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Start Inspection',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: _getStatusColor().withOpacity(0.8),
          size: 18.sp,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF718096),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF2D3748),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: _getStatusColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            color: _getStatusColor(),
            size: 20.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: const Color(0xFF718096),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}