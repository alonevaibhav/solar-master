import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CleanerDetailsPage extends StatelessWidget {
  const CleanerDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? plantData = Get.arguments;

    if (plantData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Plant Details'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64.sp,
                color: Colors.grey.shade400,
              ),
              SizedBox(height: 16.h),
              Text(
                'No plant data available',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(plantData),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  _buildQuickStatsRow(plantData),
                  SizedBox(height: 24.h),
                  _buildBasicInformation(plantData),
                  SizedBox(height: 20.h),
                  _buildPersonnelSection(plantData),
                  SizedBox(height: 20.h),
                  _buildLocationSection(plantData),
                  SizedBox(height: 20.h),
                  _buildSystemInformation(plantData),
                  if (plantData['info'] != null && plantData['info'].toString().isNotEmpty) ...[
                    SizedBox(height: 20.h),
                    _buildAdditionalInfo(plantData),
                  ],
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(Map<String, dynamic> plantData) {
    final isActive = plantData['isActive'] == 1;
    final underMaintenance = plantData['under_maintenance'] == 1;

    Color statusColor = Colors.grey.shade400;
    String statusText = 'Inactive';
    IconData statusIcon = Icons.power_off;

    if (underMaintenance) {
      statusColor = const Color(0xFFFF8C00);
      statusText = 'Under Maintenance';
      statusIcon = Icons.build;
    } else if (isActive) {
      statusColor = const Color(0xFF10B981);
      statusText = 'Active';
      statusIcon = Icons.power;
    }

    return SliverAppBar(
      expandedHeight: 180.h,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 20.sp),
          onPressed: () => Get.back(),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF3B82F6),
                const Color(0xFF1E40AF),
                const Color(0xFF1E3A8A),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: statusColor, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, color: statusColor, size: 14.sp),
                        SizedBox(width: 6.w),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    plantData['name'] ?? 'Unnamed Plant',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white70, size: 16.sp),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          plantData['address'] ?? 'No address available',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white70,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatsRow(Map<String, dynamic> plantData) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Panels',
            plantData['total_panels']?.toString() ?? '0',
            Icons.solar_power,
            const Color(0xFF3B82F6),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            'Capacity',
            '${plantData['capacity_w']?.toString() ?? '0'} W',
            Icons.flash_on,
            const Color(0xFF10B981),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            'Area',
            '${plantData['area_squrM']?.toString() ?? '0'} m²',
            Icons.square_foot,
            const Color(0xFFFF8C00),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInformation(Map<String, dynamic> plantData) {
    return _buildModernSection(
      'Basic Information',
      Icons.info_outline,
      const Color(0xFF3B82F6),
      [
        _buildModernInfoRow('Plant ID', plantData['id']?.toString() ?? 'N/A', Icons.tag),
        _buildModernInfoRow('UUID', plantData['uuid'] ?? 'N/A', Icons.fingerprint),
        _buildModernInfoRow('Location', plantData['location'] ?? 'N/A', Icons.place),
      ],
    );
  }

  Widget _buildPersonnelSection(Map<String, dynamic> plantData) {
    return _buildModernSection(
      'Personnel',
      Icons.people_outline,
      const Color(0xFF10B981),
      [
        _buildModernInfoRow('Inspector', plantData['inspector_name'] ?? 'N/A', Icons.person_search),
        _buildModernInfoRow('Cleaner', plantData['cleaner_name'] ?? 'N/A', Icons.cleaning_services),
        _buildModernInfoRow('Installer', plantData['installed_by_name'] ?? 'N/A', Icons.build),
      ],
    );
  }

  Widget _buildLocationSection(Map<String, dynamic> plantData) {
    return _buildModernSection(
      'Location Details',
      Icons.map_outlined,
      const Color(0xFFFF8C00),
      [
        _buildModernInfoRow('State', plantData['state_name'] ?? 'N/A', Icons.location_city),
        _buildModernInfoRow('District', plantData['district_name'] ?? 'N/A', Icons.domain),
        _buildModernInfoRow('Taluka', plantData['taluka_name'] ?? 'N/A', Icons.location_on),
        _buildModernInfoRow('Area', plantData['area_name'] ?? 'N/A', Icons.map),
      ],
    );
  }

  Widget _buildSystemInformation(Map<String, dynamic> plantData) {
    return _buildModernSection(
      'System Information',
      Icons.settings_outlined,
      const Color(0xFF8B5CF6),
      [
        _buildModernInfoRow('User ID', plantData['user_id']?.toString() ?? 'N/A', Icons.person),
        _buildModernInfoRow('Distributor ID', plantData['distributor_id']?.toString() ?? 'N/A', Icons.business),
        _buildStatusRow('Status', plantData['isActive'] == 1),
        _buildMaintenanceRow('Maintenance', plantData['under_maintenance'] == 1),
        _buildModernInfoRow('Created', _formatDateTime(plantData['createAt']), Icons.schedule),
        _buildModernInfoRow('Updated', _formatDateTime(plantData['UpdatedAt']), Icons.update),
      ],
    );
  }

  Widget _buildAdditionalInfo(Map<String, dynamic> plantData) {
    return _buildModernSection(
      'Additional Information',
      Icons.note_outlined,
      const Color(0xFF06B6D4),
      [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            plantData['info'] ?? 'N/A',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernSection(String title, IconData icon, Color color, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(icon, color: color, size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 16.sp, color: Colors.grey.shade600),
          ),
          SizedBox(width: 12.w),
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, bool isActive) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.power, size: 16.sp, color: Colors.grey.shade600),
          ),
          SizedBox(width: 12.w),
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF10B981).withOpacity(0.1) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isActive ? const Color(0xFF10B981) : Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFF10B981) : Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isActive ? const Color(0xFF10B981) : Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
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

  Widget _buildMaintenanceRow(String label, bool underMaintenance) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.build, size: 16.sp, color: Colors.grey.shade600),
          ),
          SizedBox(width: 12.w),
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: underMaintenance ? const Color(0xFFFF8C00).withOpacity(0.1) : const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: underMaintenance ? const Color(0xFFFF8C00) : const Color(0xFF10B981),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    underMaintenance ? Icons.warning : Icons.check_circle,
                    size: 12.sp,
                    color: underMaintenance ? const Color(0xFFFF8C00) : const Color(0xFF10B981),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    underMaintenance ? 'Yes' : 'No',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: underMaintenance ? const Color(0xFFFF8C00) : const Color(0xFF10B981),
                      fontWeight: FontWeight.w600,
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

  String _formatDateTime(dynamic dateTime) {
    if (dateTime == null) return 'N/A';

    try {
      final DateTime parsedDate = DateTime.parse(dateTime.toString());
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${parsedDate.day} ${months[parsedDate.month - 1]} ${parsedDate.year}';
    } catch (e) {
      return dateTime.toString();
    }
  }
}