// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class PlantInfoCard extends StatelessWidget {
//   final Map<String, dynamic> plant;
//   final VoidCallback onTap;
//
//   const PlantInfoCard({
//     Key? key,
//     required this.plant,
//     required this.onTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final double scale = 0.8; // 20% smaller
//
//     // Status logic based on plant data
//     final isActive = plant['isActive'] == 1;
//     final isOnline = plant['isOnline'] == true;
//     final underMaintenance = plant['under_maintenance'] == 1;
//
//     Color statusColor;
//     String statusText;
//
//     if (underMaintenance) {
//       statusColor = Colors.orange;
//       statusText = 'Under Maintenance';
//     } else if (isActive && isOnline) {
//       statusColor = Colors.green;
//       statusText = 'Online';
//     } else if (isActive) {
//       statusColor = Colors.blue;
//       statusText = 'Active';
//     } else {
//       statusColor = Colors.grey;
//       statusText = 'Inactive';
//     }
//
//     // Build location string from available data
//     String locationText = '';
//     if (plant['address'] != null && plant['address'].toString().isNotEmpty) {
//       locationText = plant['address'];
//     } else if (plant['location'] != null && plant['location'].toString().isNotEmpty) {
//       locationText = plant['location'];
//     } else {
//       // Fallback to area and district info
//       final area = plant['area_name'] ?? '';
//       final district = plant['district_name'] ?? '';
//       if (area.isNotEmpty && district.isNotEmpty) {
//         locationText = '$area, $district';
//       } else {
//         locationText = 'Unknown location';
//       }
//     }
//
//     return Card(
//       elevation: 3,
//       margin: EdgeInsets.symmetric(vertical: 10.h * scale, horizontal: 9.w * scale),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r * scale)),
//       color: Colors.grey[50],
//       child: InkWell(
//         borderRadius: BorderRadius.circular(14.r * scale),
//         onTap: onTap,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Top bar with slight grey gradient
//             Container(
//               padding: EdgeInsets.all(16.w * scale),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.grey.shade200, Colors.grey.shade300],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(14.r * scale)),
//               ),
//               child: Row(
//                 children: [
//                   // Icon with grey circle
//                   Container(
//                     width: 44.w * scale,
//                     height: 44.h * scale,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade100,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Icons.solar_power,
//                       size: 24.sp * scale,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   SizedBox(width: 12.w * scale),
//                   // Name + status
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           plant['name'] ?? 'Unnamed Plant',
//                           style: TextStyle(
//                             fontSize: 17.sp * scale,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey.shade800,
//                           ),
//                         ),
//                         SizedBox(height: 4.h * scale),
//                         Row(
//                           children: [
//                             Container(
//                               width: 8.w * scale,
//                               height: 8.h * scale,
//                               decoration: BoxDecoration(
//                                 color: statusColor,
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                             SizedBox(width: 6.w * scale),
//                             Text(
//                               statusText,
//                               style: TextStyle(
//                                 fontSize: 12.sp * scale,
//                                 color: statusColor,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Plant capacity info
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 8.w * scale, vertical: 4.h * scale),
//                     decoration: BoxDecoration(
//                       color: Colors.blue.shade50,
//                       borderRadius: BorderRadius.circular(12.r * scale),
//                     ),
//                     child: Text(
//                       '${plant['capacity_w'] ?? 'N/A'}W',
//                       style: TextStyle(
//                         fontSize: 12.sp * scale,
//                         color: Colors.blue.shade700,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Plant specifications
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.w * scale, vertical: 12.h * scale),
//               child: Row(
//                 children: [
//                   Icon(Icons.dashboard, size: 20.sp * scale, color: Colors.grey.shade600),
//                   SizedBox(width: 8.w * scale),
//                   Expanded(
//                     child: Text(
//                       'Panels: ${plant['total_panels'] ?? 'N/A'} | Area: ${plant['area_squrM'] ?? 'N/A'}m²',
//                       style: TextStyle(
//                         fontSize: 14.sp * scale,
//                         color: Colors.grey.shade700,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             Divider(height: 1.h * scale, indent: 16.w * scale, endIndent: 16.w * scale),
//
//             // Location section
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.w * scale, vertical: 12.h * scale),
//               child: Row(
//                 children: [
//                   Icon(Icons.location_on, size: 20.sp * scale, color: Colors.grey.shade600),
//                   SizedBox(width: 8.w * scale),
//                   Expanded(
//                     child: Text(
//                       locationText,
//                       style: TextStyle(
//                         fontSize: 14.sp * scale,
//                         color: Colors.grey.shade700,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   SizedBox(width: 8.w * scale),
//                   Container(
//                     padding: EdgeInsets.all(6.w * scale),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade100,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(Icons.navigation, size: 16.sp * scale, color: Colors.grey.shade600),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Personnel info
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.w * scale, vertical: 8.h * scale),
//               child: Row(
//                 children: [
//                   Icon(Icons.person, size: 20.sp * scale, color: Colors.grey.shade600),
//                   SizedBox(width: 8.w * scale),
//                   Expanded(
//                     child: Text(
//                       'Inspector: ${plant['inspector_name'] ?? 'N/A'}',
//                       style: TextStyle(
//                         fontSize: 13.sp * scale,
//                         color: Colors.grey.shade600,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // View Details button
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//                 borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.r * scale)),
//               ),
//               child: TextButton(
//                 onPressed: onTap,
//                 style: TextButton.styleFrom(
//                   padding: EdgeInsets.symmetric(vertical: 14.h * scale),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.r * scale)),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'View Details',
//                       style: TextStyle(
//                         color: Colors.grey.shade800,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 15.sp * scale,
//                       ),
//                     ),
//                     SizedBox(width: 6.w * scale),
//                     Icon(Icons.arrow_forward_ios, size: 14.sp * scale, color: Colors.grey.shade600),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class PlantInfoCard extends StatelessWidget {
//   final Map<String, dynamic> plant;
//   final VoidCallback? onTap; // Made nullable for loading state
//   final bool isLoading; // Added loading parameter
//
//   const PlantInfoCard({
//     super.key,
//     required this.plant,
//     this.onTap, // Made optional
//     this.isLoading = false, // Default to false
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final double scale = 0.8; // 20% smaller
//
//     // Status logic based on plant data
//     final isActive = plant['isActive'] == 1;
//     final isOnline = plant['isOnline'] == true;
//     final underMaintenance = plant['under_maintenance'] == 1;
//
//     Color statusColor;
//     String statusText;
//
//     if (underMaintenance) {
//       statusColor = Colors.orange;
//       statusText = 'Under Maintenance';
//     } else if (isActive && isOnline) {
//       statusColor = Colors.green;
//       statusText = 'Online';
//     } else if (isActive) {
//       statusColor = Colors.blue;
//       statusText = 'Active';
//     } else {
//       statusColor = Colors.grey;
//       statusText = 'Inactive';
//     }
//
//     // Build location string from available data
//     String locationText = '';
//     if (plant['address'] != null && plant['address'].toString().isNotEmpty) {
//       locationText = plant['address'];
//     } else if (plant['location'] != null && plant['location'].toString().isNotEmpty) {
//       locationText = plant['location'];
//     } else {
//       // Fallback to area and district info
//       final area = plant['area_name'] ?? '';
//       final district = plant['district_name'] ?? '';
//       if (area.isNotEmpty && district.isNotEmpty) {
//         locationText = '$area, $district';
//       } else {
//         locationText = 'Unknown location';
//       }
//     }
//
//     return Card(
//       elevation: 3,
//       margin: EdgeInsets.symmetric(vertical: 10.h * scale, horizontal: 9.w * scale),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r * scale)),
//       color: Colors.grey[50],
//       child: Stack( // Wrapped in Stack for loading overlay
//         children: [
//           InkWell(
//             borderRadius: BorderRadius.circular(14.r * scale),
//             onTap: isLoading ? null : onTap, // Disable tap when loading
//             child: AnimatedOpacity( // Add opacity animation
//               opacity: isLoading ? 0.6 : 1.0,
//               duration: const Duration(milliseconds: 200),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // Top bar with slight grey gradient
//                   Container(
//                     padding: EdgeInsets.all(16.w * scale),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Colors.grey.shade200, Colors.grey.shade300],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.vertical(top: Radius.circular(14.r * scale)),
//                     ),
//                     child: Row(
//                       children: [
//                         // Icon with grey circle
//                         Container(
//                           width: 44.w * scale,
//                           height: 44.h * scale,
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade100,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.solar_power,
//                             size: 24.sp * scale,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                         SizedBox(width: 12.w * scale),
//                         // Name + status
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 plant['name'] ?? 'Unnamed Plant',
//                                 style: TextStyle(
//                                   fontSize: 17.sp * scale,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.grey.shade800,
//                                 ),
//                               ),
//                               SizedBox(height: 4.h * scale),
//                               Row(
//                                 children: [
//                                   Container(
//                                     width: 8.w * scale,
//                                     height: 8.h * scale,
//                                     decoration: BoxDecoration(
//                                       color: statusColor,
//                                       shape: BoxShape.circle,
//                                     ),
//                                   ),
//                                   SizedBox(width: 6.w * scale),
//                                   Text(
//                                     statusText,
//                                     style: TextStyle(
//                                       fontSize: 12.sp * scale,
//                                       color: statusColor,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Plant capacity info
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 8.w * scale, vertical: 4.h * scale),
//                           decoration: BoxDecoration(
//                             color: Colors.blue.shade50,
//                             borderRadius: BorderRadius.circular(12.r * scale),
//                           ),
//                           child: Text(
//                             '${plant['capacity_w'] ?? 'N/A'}W',
//                             style: TextStyle(
//                               fontSize: 12.sp * scale,
//                               color: Colors.blue.shade700,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // Plant specifications
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16.w * scale, vertical: 12.h * scale),
//                     child: Row(
//                       children: [
//                         Icon(Icons.dashboard, size: 20.sp * scale, color: Colors.grey.shade600),
//                         SizedBox(width: 8.w * scale),
//                         Expanded(
//                           child: Text(
//                             'Panels: ${plant['total_panels'] ?? 'N/A'} | Area: ${plant['area_squrM'] ?? 'N/A'}m²',
//                             style: TextStyle(
//                               fontSize: 14.sp * scale,
//                               color: Colors.grey.shade700,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   Divider(height: 1.h * scale, indent: 16.w * scale, endIndent: 16.w * scale),
//
//                   // Location section
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16.w * scale, vertical: 12.h * scale),
//                     child: Row(
//                       children: [
//                         Icon(Icons.location_on, size: 20.sp * scale, color: Colors.grey.shade600),
//                         SizedBox(width: 8.w * scale),
//                         Expanded(
//                           child: Text(
//                             locationText,
//                             style: TextStyle(
//                               fontSize: 14.sp * scale,
//                               color: Colors.grey.shade700,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         SizedBox(width: 8.w * scale),
//                         Container(
//                           padding: EdgeInsets.all(6.w * scale),
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade100,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(Icons.navigation, size: 16.sp * scale, color: Colors.grey.shade600),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // Personnel info
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16.w * scale, vertical: 8.h * scale),
//                     child: Row(
//                       children: [
//                         Icon(Icons.person, size: 20.sp * scale, color: Colors.grey.shade600),
//                         SizedBox(width: 8.w * scale),
//                         Expanded(
//                           child: Text(
//                             'Inspector: ${plant['inspector_name'] ?? 'N/A'}',
//                             style: TextStyle(
//                               fontSize: 13.sp * scale,
//                               color: Colors.grey.shade600,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // View Details button - Modified for loading state
//                   Container(
//                     decoration: BoxDecoration(
//                       color: isLoading ? Colors.green.shade50 : Colors.grey.shade100,
//                       borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.r * scale)),
//                     ),
//                     child: TextButton(
//                       onPressed: isLoading ? null : onTap,
//                       style: TextButton.styleFrom(
//                         padding: EdgeInsets.symmetric(vertical: 14.h * scale),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.r * scale)),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           if (isLoading) ...[
//                             SizedBox(
//                               width: 16.w * scale,
//                               height: 16.h * scale,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2.w * scale,
//                                 valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
//                               ),
//                             ),
//                             SizedBox(width: 8.w * scale),
//                             Text(
//                               'Loading...',
//                               style: TextStyle(
//                                 color: Colors.green.shade600,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 15.sp * scale,
//                               ),
//                             ),
//                           ] else ...[
//                             Text(
//                               'View Details',
//                               style: TextStyle(
//                                 color: Colors.grey.shade800,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 15.sp * scale,
//                               ),
//                             ),
//                             SizedBox(width: 6.w * scale),
//                             Icon(Icons.arrow_forward_ios, size: 14.sp * scale, color: Colors.grey.shade600),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlantInfoCard extends StatefulWidget {
  final Map<String, dynamic> plant;
  final VoidCallback? onTap;
  final bool isLoading;

  const PlantInfoCard({
    super.key,
    required this.plant,
    this.onTap,
    this.isLoading = false,
  });

  @override
  State<PlantInfoCard> createState() => _PlantInfoCardState();
}

class _PlantInfoCardState extends State<PlantInfoCard>
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
    final double scale = 0.8;

    // Enhanced status logic
    final isActive = widget.plant['isActive'] == 1;
    final isOnline = widget.plant['isOnline'] == true;
    final underMaintenance = widget.plant['under_maintenance'] == 1;

    Color statusColor;
    String statusText;
    IconData statusIcon;
    List<Color> gradientColors;

    if (underMaintenance) {
      statusColor = const Color(0xFFFF8C00);
      statusText = 'Under Maintenance';
      statusIcon = Icons.build;
      gradientColors = [Colors.orange.shade50, Colors.orange.shade100];
    } else if (isActive && isOnline) {
      statusColor = const Color(0xFF10B981);
      statusText = 'Online';
      statusIcon = Icons.power;
      gradientColors = [Colors.green.shade50, Colors.green.shade100];
    } else if (isActive) {
      statusColor = const Color(0xFF3B82F6);
      statusText = 'Active';
      statusIcon = Icons.flash_on;
      gradientColors = [Colors.blue.shade50, Colors.blue.shade100];
    } else {
      statusColor = const Color(0xFF6B7280);
      statusText = 'Inactive';
      statusIcon = Icons.power_off;
      gradientColors = [Colors.grey.shade50, Colors.grey.shade100];
    }

    // Build location string
    String locationText = '';
    if (widget.plant['address'] != null &&
        widget.plant['address'].toString().isNotEmpty) {
      locationText = widget.plant['address'];
    } else if (widget.plant['location'] != null &&
        widget.plant['location'].toString().isNotEmpty) {
      locationText = widget.plant['location'];
    } else {
      final area = widget.plant['area_name'] ?? '';
      final district = widget.plant['district_name'] ?? '';
      if (area.isNotEmpty && district.isNotEmpty) {
        locationText = '$area, $district';
      } else {
        locationText = 'Unknown location';
      }
    }

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
                color: Colors.black26, // border color
                width: 0.5, // border thickness
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
                                  // Enhanced plant icon
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
                                      Icons.solar_power_rounded,
                                      size: 25.sp * scale,
                                      color: statusColor,
                                    ),
                                  ),
                                  SizedBox(width: 16.w * scale),

                                  // Plant info
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.plant['name'] ??
                                              'Unnamed Plant',
                                          style: TextStyle(
                                            fontSize: 18.sp * scale,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF1F2937),
                                            height: 1.2,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 8.h * scale),
                                      ],
                                    ),
                                  ),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        // 🔹 Status indicator
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6.w * scale,
                                            vertical: 4.h * scale, // same padding as second container
                                          ),
                                          decoration: BoxDecoration(
                                            color: statusColor,
                                            borderRadius: BorderRadius.circular(16.r * scale), // unified radius
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
                                                statusIcon,
                                                size: 8.sp * scale,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 3.w * scale),
                                              Text(
                                                statusText,
                                                style: TextStyle(
                                                  fontSize: 8.sp * scale, // unified font size
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        SizedBox(height: 5.h * scale),

                                        // 🔹 Capacity tag
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6.w * scale,
                                            vertical: 4.h * scale, // same as above
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(16.r * scale), // same as above
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
                                            '${widget.plant['capacity_w'] ?? 'N/A'}W',
                                            style: TextStyle(
                                              fontSize: 9.sp * scale, // same as status
                                              color: const Color(0xFF3B82F6),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )


                                  // Capacity badge
                                ],
                              ),
                            ),

                            // Specs section with icons
                            Padding(
                              padding: EdgeInsets.all(20.w * scale),
                              child: Column(
                                children: [
                                  // Panels and area
                                  _buildInfoRow(
                                    Icons.dashboard_outlined,
                                    'Specifications',
                                    'Panels: ${widget.plant['total_panels'] ?? 'N/A'} • Area: ${widget.plant['area_squrM'] ?? 'N/A'}m²',
                                    scale,
                                  ),

                                  SizedBox(height: 16.h * scale),

                                  // Location
                                  _buildInfoRow(
                                    Icons.location_on_outlined,
                                    'Location',
                                    locationText,
                                    scale,
                                  ),

                                  SizedBox(height: 16.h * scale),

                                  // Inspector
                                  _buildInfoRow(
                                    Icons.person_outline,
                                    'Inspector',
                                    widget.plant['inspector_name'] ??
                                        'Not assigned',
                                    scale,
                                  ),
                                ],
                              ),
                            ),

                            // Enhanced action button
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(20.r * scale),
                                ),
                              ),
                              child: Material(
                                color: widget.isLoading
                                    ? const Color(0xFF10B981).withOpacity(0.1)
                                    : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(20.r * scale),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(20.r * scale),
                                  ),
                                  onTap: widget.isLoading ? null : widget.onTap,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 18.h * scale),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: widget.isLoading
                                          ? [
                                              SizedBox(
                                                width: 20.w * scale,
                                                height: 20.h * scale,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    const Color(0xFF10B981),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 12.w * scale),
                                              Text(
                                                'Loading Details...',
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFF10B981),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.sp * scale,
                                                ),
                                              ),
                                            ]
                                          : [
                                              Icon(
                                                Icons.visibility_outlined,
                                                size: 20.sp * scale,
                                                color: const Color(0xFF4B5563),
                                              ),
                                              SizedBox(width: 8.w * scale),
                                              Text(
                                                'View Details',
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFF1F2937),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.sp * scale,
                                                ),
                                              ),
                                              SizedBox(width: 8.w * scale),
                                              Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 14.sp * scale,
                                                color: const Color(0xFF6B7280),
                                              ),
                                            ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Loading overlay
                      if (widget.isLoading)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20.r * scale),
                            ),
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

  Widget _buildInfoRow(
      IconData icon, String label, String value, double scale) {
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
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 2.h * scale),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp * scale,
                  color: const Color(0xFF1F2937),
                  fontWeight: FontWeight.w500,
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
}
