import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_app/Component/Inspector/PlantInfo/plant_info_card.dart';
import '../../../Controller/Cleaner/plant_info_controller.dart';
import '../../../Controller/Inspector/plant_info_controller.dart';
import 'cleaner_plant_info_card.dart';

class CleanerInfoPage extends StatelessWidget {
  const CleanerInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CleanerPlantInfoController controller = Get.put(CleanerPlantInfoController());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Info Plants',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp, // Responsive font
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: SizedBox(
              width: 40.w,
              height: 40.w,
              child: const CircularProgressIndicator(),
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${controller.errorMessage.value}',
                    style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: 120.w,
                    height: 40.h,
                    child: ElevatedButton(
                      onPressed: controller.fetchPlants,
                      child: Text('Retry', style: TextStyle(fontSize: 14.sp)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.plants.isEmpty) {
          return Center(
            child: Text(
              'No plants assigned yet',
              style: TextStyle(fontSize: 16.sp),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.plants.length,
          itemBuilder: (context, index) {
            final plant = controller.plants[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: PlantInfoCard(
                plant: plant,
                onTap: () => controller.viewPlantDetails(plant['id']),
              ),
            );
          },
        );
      }),
    );
  }
}
