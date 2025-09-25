import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_app/Component/Inspector/PlantInfo/plant_info_card.dart';
import '../../../Controller/Inspector/plant_info_controller.dart';
import '../../../Services/init.dart';

class PlantInfoView extends StatelessWidget {
  const PlantInfoView({super.key});

  Future<void> _handleBackPress() async {
    try {
      await AppInitializer.disconnectMQTT();
      print('✅ MQTT disconnected on back press');
    } catch (e) {
      print('❌ Error disconnecting MQTT: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final PlantInfoController controller = Get.put(PlantInfoController());

    return WillPopScope(
      onWillPop: () async {
        await _handleBackPress();
        return true; // Allow the page to pop
      },
      child: Scaffold(
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
            onPressed: () async {
              await _handleBackPress();
              Navigator.of(context).pop();
            },
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
      
          // return ListView.builder(
          //   padding: EdgeInsets.all(16.w),
          //   itemCount: controller.plants.length,
          //   itemBuilder: (context, index) {
          //     final plant = controller.plants[index];
          //     return Padding(
          //       padding: EdgeInsets.only(bottom: 12.h),
          //       child: PlantInfoCard(
          //         plant: plant,
          //         onTap: () => controller.viewPlantDetails(plant['id']),
          //       ),
          //     );
          //   },
          // );
          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.plants.length,
            itemBuilder: (context, index) {
              final plant = controller.plants[index];
              return Obx(() => PlantInfoCard(
                plant: plant,
                isLoading: controller.loadingPlantId.value == plant['id'].toString(),
                onTap: controller.isNavigating.value
                    ? null // Disable all taps when any plant is loading
                    : () => controller.viewPlantDetails(plant['id']),
              ));
            },
          );
        }),
      ),
    );
  }
}
