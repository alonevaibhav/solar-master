// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../Controller/Inspector/info_plant_detail_controller.dart';
// import '../../../Route Manager/app_routes.dart';
// import '../../../View/Cleaner/CleanupManegment/cleanup_controller.dart';
//
// class InfoPlantDetailsView extends StatelessWidget {
//   const InfoPlantDetailsView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final Map<String, dynamic>? plantData = Get.arguments;
//
//     final InfoPlantDetailController controller = Get.put(InfoPlantDetailController());
//
//
//     print('Received plant data: $plantData');
//     final String? uuid = plantData?['uuid']?.toString();
//     print('UUID: $uuid');
//
//
//     // Set UUID after creation
//     controller.setUuid(uuid);
//     controller.printUuidInfo();
//
//     if (plantData == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Plant Details'),
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//           elevation: 0,
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.error_outline,
//                 size: 64.sp,
//                 color: Colors.grey.shade400,
//               ),
//               SizedBox(height: 16.h),
//               Text(
//                 'No plant data available',
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: CustomScrollView(
//         slivers: [
//           _buildSliverAppBar(plantData),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: EdgeInsets.all(20.w),
//               child: Column(
//                 children: [
//                   // _buildScheduleRow(plantData),
//                   SizedBox(height: 24.h),
//                   _buildQuickStatsRow(plantData),
//                   SizedBox(height: 24.h),
//                   _buildSolarHealthSection(controller),
//                   // New solar health section
//                   SizedBox(height: 24.h),
//
//                   _buildBasicInformation(plantData),
//                   SizedBox(height: 20.h),
//                   _buildPersonnelSection(plantData),
//                   SizedBox(height: 20.h),
//                   _buildLocationSection(plantData),
//                   SizedBox(height: 20.h),
//                   _buildSystemInformation(plantData),
//                   if (plantData['info'] != null &&
//                       plantData['info']
//                           .toString()
//                           .isNotEmpty) ...[
//                     SizedBox(height: 20.h),
//                     _buildAdditionalInfo(plantData),
//                   ],
//                   SizedBox(height: 32.h),
//                   Obx(() =>
//                       ElevatedButton(
//                         onPressed: controller.isLoading.value
//                             ? null
//                             : controller.toggleMaintenanceMode,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                           controller.isMaintenanceModeEnabled.value
//                               ? Colors.red
//                               : Colors.green,
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 32, vertical: 16),
//                         ),
//                         child: controller.isLoading.value
//                             ? CircularProgressIndicator(color: Colors.white)
//                             : Text(
//                           controller.isMaintenanceModeEnabled.value
//                               ? 'STOP MAINTENANCE'
//                               : 'START MAINTENANCE',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       )),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSliverAppBar(Map<String, dynamic> plantData) {
//     final isActive = plantData['isActive'] == 1;
//     final underMaintenance = plantData['under_maintenance'] == 1;
//     Color statusColor = Colors.grey.shade400;
//     String statusText = 'Inactive';
//     IconData statusIcon = Icons.power_off;
//
//     if (underMaintenance) {
//       statusColor = const Color(0xFFFF8C00);
//       statusText = 'Under Maintenance';
//       statusIcon = Icons.build;
//     } else if (isActive) {
//       statusColor = const Color(0xFF10B981);
//       statusText = 'Active';
//       statusIcon = Icons.power;
//     }
//
//     return SliverAppBar(
//       expandedHeight: 180.h,
//       floating: false,
//       pinned: true,
//       elevation: 0,
//       backgroundColor: Colors.white,
//       foregroundColor: Colors.black,
//       leading: Container(
//         margin: EdgeInsets.all(8.w),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.9),
//           borderRadius: BorderRadius.circular(12.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black, size: 20.sp),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       actions: [
//         Container(
//           margin: EdgeInsets.only(right: 12.w, top: 8.h, bottom: 8.h),
//           child: _buildCreateTicketButton(),
//         ),
//         Container(
//           margin: EdgeInsets.only(right: 12.w, top: 8.h, bottom: 8.h),
//           child: IconButton(
//             icon: Icon(Icons.settings, color: Colors.white, size: 25.sp),
//             onPressed: () {
//               Get.toNamed(AppRoutes.settingPageRoute, arguments: plantData);
//             },
//           ),
//         ),
//       ],
//       flexibleSpace: FlexibleSpaceBar(
//         background: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 const Color(0xFF3B82F6),
//                 const Color(0xFF1E40AF),
//                 const Color(0xFF1E3A8A),
//               ],
//             ),
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 20.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     padding:
//                     EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//                     decoration: BoxDecoration(
//                       color: statusColor.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(20.r),
//                       border: Border.all(color: statusColor, width: 1),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(statusIcon, color: statusColor, size: 14.sp),
//                         SizedBox(width: 6.w),
//                         Text(
//                           statusText,
//                           style: TextStyle(
//                             color: statusColor,
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 12.h),
//                   Text(
//                     plantData['name'] ?? 'Unnamed Plant',
//                     style: TextStyle(
//                       fontSize: 28.sp,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       height: 1.2,
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   Row(
//                     children: [
//                       Icon(Icons.location_on,
//                           color: Colors.white70, size: 16.sp),
//                       SizedBox(width: 6.w),
//                       Expanded(
//                         child: Text(
//                           plantData['address'] ?? 'No address available',
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             color: Colors.white70,
//                             height: 1.3,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   Widget _buildNavigatableStatCard(String label, String value, IconData icon,
//       Color color,
//       {required VoidCallback onTap}) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             color.withOpacity(0.1),
//             color.withOpacity(0.05),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(16.r), // Adjusted from 20.r
//         border: Border.all(
//           color: color.withOpacity(0.3),
//           width: 1.2, // Adjusted from 1.5
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.15),
//             blurRadius: 12, // Adjusted from 15
//             offset: const Offset(0, 4.8), // Adjusted from 6
//             spreadRadius: 0.8, // Adjusted from 1
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16.r),
//           // Adjusted from 20.r
//           splashColor: color.withOpacity(0.2),
//           highlightColor: color.withOpacity(0.1),
//           child: Container(
//             padding: EdgeInsets.all(14.4.w), // Adjusted from 18.w
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(11.2.w), // Adjusted from 14.w
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         color,
//                         color.withOpacity(0.8),
//                       ],
//                     ),
//                     borderRadius:
//                     BorderRadius.circular(12.8.r), // Adjusted from 16.r
//                     boxShadow: [
//                       BoxShadow(
//                         color: color.withOpacity(0.3),
//                         blurRadius: 6.4, // Adjusted from 8
//                         offset: const Offset(0, 3.2), // Adjusted from 4
//                       ),
//                     ],
//                   ),
//                   child: Icon(
//                     icon,
//                     color: Colors.white,
//                     size: 20.8.sp, // Adjusted from 26.sp
//                   ),
//                 ),
//                 SizedBox(height: 11.2.h), // Adjusted from 14.h
//
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: 10.4.sp, // Adjusted from 13.sp
//                     fontWeight: FontWeight.w700,
//                     color: color,
//                     letterSpacing: 0.4, // Adjusted from 0.5
//                   ),
//                   textAlign: TextAlign.center,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//
//                 SizedBox(height: 6.4.h), // Adjusted from 8.h
//
//                 Container(
//                   width: double.infinity,
//                   padding:
//                   EdgeInsets.symmetric(vertical: 8.h), // Adjusted from 10.h
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.centerLeft,
//                       end: Alignment.centerRight,
//                       colors: [
//                         color,
//                         color.withOpacity(0.8),
//                       ],
//                     ),
//                     borderRadius:
//                     BorderRadius.circular(20.r), // Adjusted from 25.r
//                     boxShadow: [
//                       BoxShadow(
//                         color: color.withOpacity(0.3),
//                         blurRadius: 4.8, // Adjusted from 6
//                         offset: const Offset(0, 2.4), // Adjusted from 3
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Open',
//                         style: TextStyle(
//                           fontSize: 9.6.sp, // Adjusted from 12.sp
//                           color: Colors.white,
//                           fontWeight: FontWeight.w700,
//                           letterSpacing: 0.64, // Adjusted from 0.8
//                         ),
//                       ),
//                       SizedBox(width: 4.8.w), // Adjusted from 6.w
//                       Icon(
//                         Icons.arrow_forward_rounded,
//                         size: 11.2.sp, // Adjusted from 14.sp
//                         color: Colors.white,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQuickStatsRow(Map<String, dynamic> plantData) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildStatCard(
//             'Total Panels',
//             plantData['total_panels']?.toString() ?? '0',
//             Icons.solar_power,
//             const Color(0xFF3B82F6),
//           ),
//         ),
//         SizedBox(width: 12.w),
//         Expanded(
//           child: _buildStatCard(
//             'Capacity',
//             '${plantData['capacity_w']?.toString() ?? '0'} W',
//             Icons.flash_on,
//             const Color(0xFF10B981),
//           ),
//         ),
//         SizedBox(width: 12.w),
//         Expanded(
//           child: _buildStatCard(
//             'Area',
//             '${plantData['area_squrM']?.toString() ?? '0'} m²',
//             Icons.square_foot,
//             const Color(0xFFFF8C00),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatCard(String label, String value, IconData icon,
//       Color color) {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(10.w),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12.r),
//             ),
//             child: Icon(icon, color: color, size: 24.sp),
//           ),
//           SizedBox(height: 12.h),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 14.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey.shade800,
//             ),
//           ),
//           SizedBox(height: 4.h),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 10.sp,
//               color: Colors.grey.shade500,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBasicInformation(Map<String, dynamic> plantData) {
//     return _buildModernSection(
//       'Basic Information',
//       Icons.info_outline,
//       const Color(0xFF3B82F6),
//       [
//         _buildModernInfoRow(
//             'Plant ID', plantData['id']?.toString() ?? 'N/A', Icons.tag),
//         _buildModernInfoRow(
//             'UUID', plantData['uuid'] ?? 'N/A', Icons.fingerprint),
//         _buildModernInfoRow(
//             'Location', plantData['location'] ?? 'N/A', Icons.place),
//       ],
//     );
//   }
//
//   Widget _buildPersonnelSection(Map<String, dynamic> plantData) {
//     return _buildModernSection(
//       'Personnel',
//       Icons.people_outline,
//       const Color(0xFF10B981),
//       [
//         _buildModernInfoRow('Inspector', plantData['inspector_name'] ?? 'N/A',
//             Icons.person_search),
//         _buildModernInfoRow('Cleaner', plantData['cleaner_name'] ?? 'N/A',
//             Icons.cleaning_services),
//         _buildModernInfoRow(
//             'Installer', plantData['installed_by_name'] ?? 'N/A', Icons.build),
//       ],
//     );
//   }
//
//   Widget _buildLocationSection(Map<String, dynamic> plantData) {
//     return _buildModernSection(
//       'Location Details',
//       Icons.map_outlined,
//       const Color(0xFFFF8C00),
//       [
//         _buildModernInfoRow(
//             'State', plantData['state_name'] ?? 'N/A', Icons.location_city),
//         _buildModernInfoRow(
//             'District', plantData['district_name'] ?? 'N/A', Icons.domain),
//         _buildModernInfoRow(
//             'Taluka', plantData['taluka_name'] ?? 'N/A', Icons.location_on),
//         _buildModernInfoRow('Area', plantData['area_name'] ?? 'N/A', Icons.map),
//       ],
//     );
//   }
//
//   Widget _buildSystemInformation(Map<String, dynamic> plantData) {
//     return _buildModernSection(
//       'System Information',
//       Icons.settings_outlined,
//       const Color(0xFF8B5CF6),
//       [
//         _buildModernInfoRow(
//             'User ID', plantData['user_id']?.toString() ?? 'N/A', Icons.person),
//         _buildModernInfoRow('Distributor ID',
//             plantData['distributor_id']?.toString() ?? 'N/A', Icons.business),
//         _buildStatusRow('Status', plantData['isActive'] == 1),
//         _buildMaintenanceRow(
//             'Maintenance', plantData['under_maintenance'] == 1),
//         _buildModernInfoRow(
//             'Created', _formatDateTime(plantData['createAt']), Icons.schedule),
//         _buildModernInfoRow(
//             'Updated', _formatDateTime(plantData['UpdatedAt']), Icons.update),
//       ],
//     );
//   }
//
//   Widget _buildAdditionalInfo(Map<String, dynamic> plantData) {
//     return _buildModernSection(
//       'Additional Information',
//       Icons.note_outlined,
//       const Color(0xFF06B6D4),
//       [
//         Container(
//           width: double.infinity,
//           padding: EdgeInsets.all(16.w),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade50,
//             borderRadius: BorderRadius.circular(12.r),
//             border: Border.all(color: Colors.grey.shade200),
//           ),
//           child: Text(
//             plantData['info'] ?? 'N/A',
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: Colors.grey.shade700,
//               height: 1.4,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildModernSection(String title, IconData icon, Color color,
//       List<Widget> children) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: EdgeInsets.all(20.w),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.05),
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20.r),
//                 topRight: Radius.circular(20.r),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(8.w),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10.r),
//                   ),
//                   child: Icon(icon, color: color, size: 20.sp),
//                 ),
//                 SizedBox(width: 12.w),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey.shade800,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(20.w),
//             child: Column(
//               children: children,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildModernInfoRow(String label, String value, IconData icon) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(6.w),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(8.r),
//             ),
//             child: Icon(icon, size: 16.sp, color: Colors.grey.shade600),
//           ),
//           SizedBox(width: 12.w),
//           SizedBox(
//             width: 100.w,
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: Colors.grey.shade500,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           SizedBox(width: 12.w),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: Colors.grey.shade800,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatusRow(String label, bool isActive) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(6.w),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(8.r),
//             ),
//             child: Icon(Icons.power, size: 16.sp, color: Colors.grey.shade600),
//           ),
//           SizedBox(width: 12.w),
//           SizedBox(
//             width: 100.w,
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: Colors.grey.shade500,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           SizedBox(width: 12.w),
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//               decoration: BoxDecoration(
//                 color: isActive
//                     ? const Color(0xFF10B981).withOpacity(0.1)
//                     : Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(20.r),
//                 border: Border.all(
//                   color:
//                   isActive ? const Color(0xFF10B981) : Colors.grey.shade300,
//                   width: 1,
//                 ),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     width: 6.w,
//                     height: 6.h,
//                     decoration: BoxDecoration(
//                       color: isActive
//                           ? const Color(0xFF10B981)
//                           : Colors.grey.shade400,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   SizedBox(width: 6.w),
//                   Text(
//                     isActive ? 'Active' : 'Inactive',
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       color: isActive
//                           ? const Color(0xFF10B981)
//                           : Colors.grey.shade600,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMaintenanceRow(String label, bool underMaintenance) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(6.w),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(8.r),
//             ),
//             child: Icon(Icons.build, size: 16.sp, color: Colors.grey.shade600),
//           ),
//           SizedBox(width: 12.w),
//           SizedBox(
//             width: 100.w,
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: Colors.grey.shade500,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           SizedBox(width: 12.w),
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//               decoration: BoxDecoration(
//                 color: underMaintenance
//                     ? const Color(0xFFFF8C00).withOpacity(0.1)
//                     : const Color(0xFF10B981).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(20.r),
//                 border: Border.all(
//                   color: underMaintenance
//                       ? const Color(0xFFFF8C00)
//                       : const Color(0xFF10B981),
//                   width: 1,
//                 ),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     underMaintenance ? Icons.warning : Icons.check_circle,
//                     size: 12.sp,
//                     color: underMaintenance
//                         ? const Color(0xFFFF8C00)
//                         : const Color(0xFF10B981),
//                   ),
//                   SizedBox(width: 6.w),
//                   Text(
//                     underMaintenance ? 'Yes' : 'No',
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       color: underMaintenance
//                           ? const Color(0xFFFF8C00)
//                           : const Color(0xFF10B981),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCreateTicketButton() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Color(0xFFE91E63),
//             Color(0xFFAD1457),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(25.r),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFFE91E63).withOpacity(0.3),
//             spreadRadius: 1,
//             blurRadius: 8,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () {
//             Get.toNamed(AppRoutes.inspectorCreateTicket,
//                 arguments: Get.arguments);
//           },
//           borderRadius: BorderRadius.circular(25.r),
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(4.w),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   child: Icon(
//                     Icons.report_problem_outlined,
//                     color: Colors.white,
//                     size: 16.sp,
//                   ),
//                 ),
//                 SizedBox(width: 8.w),
//                 Text(
//                   'Raise Ticket',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 12.sp,
//                     letterSpacing: 0.3,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _formatDateTime(dynamic dateTime) {
//     if (dateTime == null) return 'N/A';
//
//     try {
//       final DateTime parsedDate = DateTime.parse(dateTime.toString());
//       const months = [
//         'Jan',
//         'Feb',
//         'Mar',
//         'Apr',
//         'May',
//         'Jun',
//         'Jul',
//         'Aug',
//         'Sep',
//         'Oct',
//         'Nov',
//         'Dec'
//       ];
//       return '${parsedDate.day} ${months[parsedDate.month - 1]} ${parsedDate
//           .year}';
//     } catch (e) {
//       return dateTime.toString();
//     }
//   }
//   Widget _buildSolarHealthSection(InfoPlantDetailController controller) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Row(
//             children: [
//               Icon(
//                 Icons.health_and_safety,
//                 color: const Color(0xFF059669),
//                 size: 24.sp,
//               ),
//               SizedBox(width: 8.w),
//               Text(
//                 'System Health',
//                 style: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xFF1F2937),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16.h),
//
//           // Health Stats Row (Water and Pressure only)
//           Obx(() => _buildSolarHealthStatsRow(controller)),
//
//           // Critical Status Messages (appears between health stats and RTC time)
//           Obx(() => _buildCriticalStatusMessages(controller)),
//
//           SizedBox(height: 12.h),
//
//           // RTC Time Row (Full width)
//           Obx(() => _buildRtcTimeRow(controller)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSolarHealthStatsRow(InfoPlantDetailController controller) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildHealthStatCard(
//             'Water Availability',
//             Icons.water_drop,
//             const Color(0xFF2563EB),
//             controller.flootStatus,
//             showValue: false, // Don't show value for water
//           ),
//         ),
//         SizedBox(width: 12.w),
//         Expanded(
//           child: _buildHealthStatCard(
//             'Line Pressure',
//             Icons.compress,
//             const Color(0xFF2563EB),
//             controller.pressureStatus,
//             showValue: false, // Don't show value for pressure
//           ),
//         ),
//       ],
//     );
//   }
//
// // New method to build critical status messages
//   Widget _buildCriticalStatusMessages(InfoPlantDetailController controller) {
//     List<String> criticalMessages = [];
//
//     // Check water status
//     if (controller.flootStatus == HealthStatus.critical) {
//       criticalMessages.add("Water is empty");
//     }
//
//     // Check pressure status
//     if (controller.pressureStatus == HealthStatus.critical) {
//       criticalMessages.add("Pressure is high");
//     }
//
//     // Return empty container if no critical messages
//     if (criticalMessages.isEmpty) {
//       return const SizedBox.shrink();
//     }
//
//     return Container(
//       margin: EdgeInsets.only(top: 12.h),
//       padding: EdgeInsets.all(12.w),
//       decoration: BoxDecoration(
//         color: const Color(0xFFEF4444).withOpacity(0.1), // Red background
//         borderRadius: BorderRadius.circular(8.r),
//         border: Border.all(
//           color: const Color(0xFFEF4444).withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.warning,
//                 color: const Color(0xFFEF4444),
//                 size: 20.sp,
//               ),
//               SizedBox(width: 8.w),
//               Text(
//                 'Critical Alert${criticalMessages.length > 1 ? 's' : ''}',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xFFEF4444),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 8.h),
//           ...criticalMessages.map((message) => Padding(
//             padding: EdgeInsets.only(bottom: 4.h),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.error_outline,
//                   color: const Color(0xFFEF4444),
//                   size: 16.sp,
//                 ),
//                 SizedBox(width: 8.w),
//                 Text(
//                   message,
//                   style: TextStyle(
//                     fontSize: 12.sp,
//                     color: const Color(0xFFEF4444),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           )).toList(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRtcTimeRow(InfoPlantDetailController controller) {
//     return _buildHealthStatCard(
//       'RTC Time',
//       Icons.access_time,
//       const Color(0xFF3B82F6),
//       HealthStatus.good, // Time is always shown as good
//       value: controller.formattedRtcTime, // RTC Time still shows value
//       showValue: true, // Show value for RTC time
//     );
//   }
//
//   Widget _buildHealthStatCard(
//       String title,
//       IconData icon,
//       Color color,
//       HealthStatus? status, {
//         String? value,
//         bool showValue = true,
//       }) {
//     // Determine container color based on status
//     Color containerColor;
//     Color borderColor;
//     Color iconColor;
//     Color textColor;
//
//     switch (status) {
//       case HealthStatus.good:
//         containerColor =
//             const Color(0xFF10B981).withOpacity(0.1); // Green background
//         borderColor = const Color(0xFF10B981).withOpacity(0.2);
//         iconColor = const Color(0xFF10B981);
//         textColor = const Color(0xFF10B981);
//         break;
//       case HealthStatus.warning:
//         containerColor =
//             const Color(0xFFF59E0B).withOpacity(0.1); // Yellow background
//         borderColor = const Color(0xFFF59E0B).withOpacity(0.2);
//         iconColor = const Color(0xFFF59E0B);
//         textColor = const Color(0xFF1F2937);
//         break;
//       case HealthStatus.critical:
//         containerColor =
//             const Color(0xFFEF4444).withOpacity(0.1); // Red background
//         borderColor = const Color(0xFFEF4444).withOpacity(0.2);
//         iconColor = const Color(0xFFEF4444);
//         textColor = const Color(0xFF1F2937);
//         break;
//       case null:
//       // TODO: Handle this case.
//         throw UnimplementedError();
//     }
//
//     return Container(
//       padding: EdgeInsets.all(12.w),
//       decoration: BoxDecoration(
//         color: containerColor,
//         // Use status-based color instead of original color
//         borderRadius: BorderRadius.circular(8.r),
//         border: Border.all(
//           color: borderColor, // Use status-based border color
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Icon(
//                 icon,
//                 color: iconColor, // Use status-based icon color
//                 size: 20.sp,
//               ),
//             ],
//           ),
//           SizedBox(height: 8.h),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 10.sp,
//               color: Colors.black,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           // Only show value if showValue is true and value is provided
//           if (showValue && value != null) ...[
//             SizedBox(height: 4.h),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 12.sp,
//                 fontWeight: FontWeight.bold,
//                 color: textColor,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Controller/Inspector/info_plant_detail_controller.dart';
import '../../../Route Manager/app_routes.dart';
import '../../../View/Cleaner/CleanupManegment/cleanup_controller.dart';

class InfoPlantDetailsView extends StatelessWidget {
  const InfoPlantDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? plantData = Get.arguments;

    final InfoPlantDetailController controller = Get.put(InfoPlantDetailController());


    print('Received plant data: $plantData');
    final String? uuid = plantData?['uuid']?.toString();
    print('UUID: $uuid');


    // Set UUID after creation
    controller.setUuid(uuid);
    controller.printUuidInfo();

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
                  // _buildScheduleRow(plantData),
                  SizedBox(height: 24.h),
                  _buildQuickStatsRow(plantData),
                  SizedBox(height: 24.h),
                  _buildSolarHealthSection(controller),
                  // New solar health section
                  SizedBox(height: 24.h),

                  _buildBasicInformation(plantData),
                  SizedBox(height: 20.h),
                  _buildPersonnelSection(plantData),
                  SizedBox(height: 20.h),
                  _buildLocationSection(plantData),
                  SizedBox(height: 20.h),
                  _buildSystemInformation(plantData),
                  if (plantData['info'] != null &&
                      plantData['info']
                          .toString()
                          .isNotEmpty) ...[
                    SizedBox(height: 20.h),
                    _buildAdditionalInfo(plantData),
                  ],
                  SizedBox(height: 32.h),
                  Obx(() =>
                      ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.toggleMaintenanceMode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          controller.isMaintenanceModeEnabled.value
                              ? Colors.red
                              : Colors.green,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                        ),
                        child: controller.isLoading.value
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          controller.isMaintenanceModeEnabled.value
                              ? 'STOP MAINTENANCE'
                              : 'START MAINTENANCE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
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
      actions: [
        Container(
          margin: EdgeInsets.only(right: 12.w, top: 8.h, bottom: 8.h),
          child: _buildCreateTicketButton(),
        ),
        Container(
          margin: EdgeInsets.only(right: 12.w, top: 8.h, bottom: 8.h),
          child: IconButton(
            icon: Icon(Icons.settings, color: Colors.white, size: 25.sp),
            onPressed: () {
              Get.toNamed(AppRoutes.settingPageRoute, arguments: plantData);
            },
          ),
        ),
      ],
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
                    padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
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
                      Icon(Icons.location_on,
                          color: Colors.white70, size: 16.sp),
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


  Widget _buildNavigatableStatCard(String label, String value, IconData icon,
      Color color,
      {required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r), // Adjusted from 20.r
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.2, // Adjusted from 1.5
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 12, // Adjusted from 15
            offset: const Offset(0, 4.8), // Adjusted from 6
            spreadRadius: 0.8, // Adjusted from 1
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          // Adjusted from 20.r
          splashColor: color.withOpacity(0.2),
          highlightColor: color.withOpacity(0.1),
          child: Container(
            padding: EdgeInsets.all(14.4.w), // Adjusted from 18.w
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(11.2.w), // Adjusted from 14.w
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color,
                        color.withOpacity(0.8),
                      ],
                    ),
                    borderRadius:
                    BorderRadius.circular(12.8.r), // Adjusted from 16.r
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 6.4, // Adjusted from 8
                        offset: const Offset(0, 3.2), // Adjusted from 4
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20.8.sp, // Adjusted from 26.sp
                  ),
                ),
                SizedBox(height: 11.2.h), // Adjusted from 14.h

                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.4.sp, // Adjusted from 13.sp
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: 0.4, // Adjusted from 0.5
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 6.4.h), // Adjusted from 8.h

                Container(
                  width: double.infinity,
                  padding:
                  EdgeInsets.symmetric(vertical: 8.h), // Adjusted from 10.h
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        color,
                        color.withOpacity(0.8),
                      ],
                    ),
                    borderRadius:
                    BorderRadius.circular(20.r), // Adjusted from 25.r
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 4.8, // Adjusted from 6
                        offset: const Offset(0, 2.4), // Adjusted from 3
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Open',
                        style: TextStyle(
                          fontSize: 9.6.sp, // Adjusted from 12.sp
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.64, // Adjusted from 0.8
                        ),
                      ),
                      SizedBox(width: 4.8.w), // Adjusted from 6.w
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 11.2.sp, // Adjusted from 14.sp
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
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

  Widget _buildStatCard(String label, String value, IconData icon,
      Color color) {
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
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
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
        _buildModernInfoRow(
            'Plant ID', plantData['id']?.toString() ?? 'N/A', Icons.tag),
        _buildModernInfoRow(
            'UUID', plantData['uuid'] ?? 'N/A', Icons.fingerprint),
        _buildModernInfoRow(
            'Location', plantData['location'] ?? 'N/A', Icons.place),
      ],
    );
  }

  Widget _buildPersonnelSection(Map<String, dynamic> plantData) {
    return _buildModernSection(
      'Personnel',
      Icons.people_outline,
      const Color(0xFF10B981),
      [
        _buildModernInfoRow('Inspector', plantData['inspector_name'] ?? 'N/A',
            Icons.person_search),
        _buildModernInfoRow('Cleaner', plantData['cleaner_name'] ?? 'N/A',
            Icons.cleaning_services),
        _buildModernInfoRow(
            'Installer', plantData['installed_by_name'] ?? 'N/A', Icons.build),
      ],
    );
  }

  Widget _buildLocationSection(Map<String, dynamic> plantData) {
    return _buildModernSection(
      'Location Details',
      Icons.map_outlined,
      const Color(0xFFFF8C00),
      [
        _buildModernInfoRow(
            'State', plantData['state_name'] ?? 'N/A', Icons.location_city),
        _buildModernInfoRow(
            'District', plantData['district_name'] ?? 'N/A', Icons.domain),
        _buildModernInfoRow(
            'Taluka', plantData['taluka_name'] ?? 'N/A', Icons.location_on),
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
        _buildModernInfoRow(
            'User ID', plantData['user_id']?.toString() ?? 'N/A', Icons.person),
        _buildModernInfoRow('Distributor ID',
            plantData['distributor_id']?.toString() ?? 'N/A', Icons.business),
        _buildStatusRow('Status', plantData['isActive'] == 1),
        _buildMaintenanceRow(
            'Maintenance', plantData['under_maintenance'] == 1),
        _buildModernInfoRow(
            'Created', _formatDateTime(plantData['createAt']), Icons.schedule),
        _buildModernInfoRow(
            'Updated', _formatDateTime(plantData['UpdatedAt']), Icons.update),
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

  Widget _buildModernSection(String title, IconData icon, Color color,
      List<Widget> children) {
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
                color: isActive
                    ? const Color(0xFF10B981).withOpacity(0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color:
                  isActive ? const Color(0xFF10B981) : Colors.grey.shade300,
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
                      color: isActive
                          ? const Color(0xFF10B981)
                          : Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isActive
                          ? const Color(0xFF10B981)
                          : Colors.grey.shade600,
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
                color: underMaintenance
                    ? const Color(0xFFFF8C00).withOpacity(0.1)
                    : const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: underMaintenance
                      ? const Color(0xFFFF8C00)
                      : const Color(0xFF10B981),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    underMaintenance ? Icons.warning : Icons.check_circle,
                    size: 12.sp,
                    color: underMaintenance
                        ? const Color(0xFFFF8C00)
                        : const Color(0xFF10B981),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    underMaintenance ? 'Yes' : 'No',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: underMaintenance
                          ? const Color(0xFFFF8C00)
                          : const Color(0xFF10B981),
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

  Widget _buildCreateTicketButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE91E63),
            Color(0xFFAD1457),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE91E63).withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.inspectorCreateTicket,
                arguments: Get.arguments);
          },
          borderRadius: BorderRadius.circular(25.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.report_problem_outlined,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Raise Ticket',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.sp,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDateTime(dynamic dateTime) {
    if (dateTime == null) return 'N/A';

    try {
      final DateTime parsedDate = DateTime.parse(dateTime.toString());
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${parsedDate.day} ${months[parsedDate.month - 1]} ${parsedDate
          .year}';
    } catch (e) {
      return dateTime.toString();
    }
  }
  Widget _buildSolarHealthSection(InfoPlantDetailController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.health_and_safety,
                color: const Color(0xFF059669),
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'System Health',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Health Stats Row (Water and Pressure only)
          Obx(() => _buildSolarHealthStatsRow(controller)),

          // Critical Status Messages (appears between health stats and RTC time)
          Obx(() => _buildCriticalStatusMessages(controller)),

          SizedBox(height: 12.h),

          // RTC Time Row (Full width)
          Obx(() => _buildRtcTimeRow(controller)),
        ],
      ),
    );
  }

  Widget _buildSolarHealthStatsRow(InfoPlantDetailController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildHealthStatCard(
            'Water Availability',
            Icons.water_drop,
            const Color(0xFF2563EB),
            controller.flootStatus,
            showValue: false, // Don't show value for water
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildHealthStatCard(
            'Line Pressure',
            Icons.compress,
            const Color(0xFF2563EB),
            controller.pressureStatus,
            showValue: false, // Don't show value for pressure
          ),
        ),
      ],
    );
  }

// New method to build critical status messages
  Widget _buildCriticalStatusMessages(InfoPlantDetailController controller) {
    List<String> criticalMessages = [];

    // Check water status
    if (controller.flootStatus == HealthStatus.critical) {
      criticalMessages.add("Water is empty");
    }

    // Check pressure status
    if (controller.pressureStatus == HealthStatus.critical) {
      criticalMessages.add("Pressure is high");
    }

    // Return empty container if no critical messages
    if (criticalMessages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withOpacity(0.1), // Red background
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xFFEF4444).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning,
                color: const Color(0xFFEF4444),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Critical Alert${criticalMessages.length > 1 ? 's' : ''}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ...criticalMessages.map((message) => Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: const Color(0xFFEF4444),
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFFEF4444),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildRtcTimeRow(InfoPlantDetailController controller) {
    return _buildHealthStatCard(
      'RTC Time',
      Icons.access_time,
      const Color(0xFF3B82F6),
      HealthStatus.good, // Time is always shown as good
      value: controller.formattedRtcTime, // RTC Time still shows value
      showValue: true, // Show value for RTC time
    );
  }

  Widget _buildHealthStatCard(
      String title,
      IconData icon,
      Color color,
      HealthStatus? status, {
        String? value,
        bool showValue = true,
      }) {
    // Determine container color based on status
    Color containerColor;
    Color borderColor;
    Color iconColor;
    Color textColor;

    switch (status) {
      case HealthStatus.good:
        containerColor =
            const Color(0xFF10B981).withOpacity(0.1); // Green background
        borderColor = const Color(0xFF10B981).withOpacity(0.2);
        iconColor = const Color(0xFF10B981);
        textColor = const Color(0xFF10B981);
        break;
      case HealthStatus.warning:
        containerColor =
            const Color(0xFFF59E0B).withOpacity(0.1); // Yellow background
        borderColor = const Color(0xFFF59E0B).withOpacity(0.2);
        iconColor = const Color(0xFFF59E0B);
        textColor = const Color(0xFF1F2937);
        break;
      case HealthStatus.critical:
        containerColor =
            const Color(0xFFEF4444).withOpacity(0.1); // Red background
        borderColor = const Color(0xFFEF4444).withOpacity(0.2);
        iconColor = const Color(0xFFEF4444);
        textColor = const Color(0xFF1F2937);
        break;
      case null:
      // TODO: Handle this case.
        throw UnimplementedError();
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: containerColor,
        // Use status-based color instead of original color
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: borderColor, // Use status-based border color
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: iconColor, // Use status-based icon color
                size: 20.sp,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          // Only show value if showValue is true and value is provided
          if (showValue && value != null) ...[
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

