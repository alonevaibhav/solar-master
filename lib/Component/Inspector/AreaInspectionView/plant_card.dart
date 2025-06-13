import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_app/Component/Inspector/AreaInspectionView/plant_info_detail_view.dart';
import '../../../Controller/Inspector/area_inspection_controller.dart';

class PlantCardWidget extends StatelessWidget {
  final Map<String, dynamic> plant;
  final AreaInspectionController controller;

  const PlantCardWidget({
    Key? key,
    required this.plant,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final status = plant['status'] as String;
    final Color cardColor = controller.getStatusColor(status);


    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader(),
                SizedBox(height: 12.h),
                _buildPanelsInfo(),
                SizedBox(height: 12.h),
                Text(
                  plant['name'] ?? 'Unnamed Plant',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                _buildLocationRow(),
                SizedBox(height: 8.h),
                if (status != 'Inspection Complete')
                  _buildContactRow(),
              ],
            ),
          ),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildCardHeader() {
    final status = plant['status'] as String;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 32.r,
          height: 32.r,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            status == 'Inspection Complete'
                ? Icons.check_circle_outline
                : Icons.cleaning_services_outlined,
            size: 18.r,
          ),
        ),
        GestureDetector(

          onTap: () {
            // Navigate to detail screen
            Get.to(() => PlantInspectionDetailView(plantId: plant['id']));
          },
          child: Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_outward,
              size: 18.r,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildPanelsInfo() {
    final status = plant['status'] as String;

    return Row(
      children: [
        Row(
          children: [
            Icon(Icons.grid_view, size: 18.r, color: Colors.grey[700]),
            SizedBox(width: 4.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '${plant['totalPanels']} Panels',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),

        if (status != 'Inspection Complete')
          ...[
            SizedBox(width: 16.w),
            Row(
              children: [
                Icon(Icons.timer, size: 18.r, color: Colors.grey[700]),
                SizedBox(width: 4.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ETA',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      plant['eta'] ?? '0 Minutes',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],

        if (status == 'Inspection Complete')...[
            SizedBox(width: 16.w),
            Row(
              children: [
                Icon(Icons.timer, size: 18.r, color: Colors.grey[700]),
                SizedBox(width: 4.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      plant['time'] ?? '00:00',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
      ],
    );
  }

  Widget _buildLocationRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  plant['location'] ?? 'Unknown Location',
                  style: TextStyle(
                    fontSize: 12.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline,
              size: 16.r,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow() {
    final status = plant['status'] as String;
    final contactLabel = status == 'Ongoing Cleaning' ? 'Contact' : 'Cleaner Name';
    final contactValue = status == 'Ongoing Cleaning' ? plant['contact'] : plant['cleanerName'];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contactLabel,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  contactValue ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.phone,
              size: 16.r,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    final status = plant['status'] as String;
    String buttonText;
    VoidCallback onTap;

    switch (status) {
      case 'Ongoing Cleaning':
        buttonText = 'Start Inspection';
        onTap = () => controller.startInspection(plant['id']);
        break;
      case 'Inspection Complete':
        buttonText = 'Send Remark';
        onTap = () => controller.sendRemark(plant['id']);
        break;
      default:
        return const SizedBox.shrink(); // No button for pending inspection
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 12.h),
          ),
          child: Obx(() => controller.isLoading.value
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          )
              : Text(
            buttonText,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          )),
        ),
      ),
    );
  }
}