import 'package:get/get.dart';

import '../Controller/Inspector/alerts_controller.dart';
import '../Controller/Cleaner/cleanup_controller.dart';
import '../Controller/Cleaner/general_information_controller.dart';
import '../Controller/Cleaner/profile_controller.dart';
import '../Controller/Cleaner/today_inspections_controller.dart';
import '../Controller/Inspector/area_inspection_controller.dart';
import '../Controller/Inspector/plant_managment_controller.dart';
import '../Controller/login_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {


    // Register all controllers here
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<TodayInspectionsController>(() => TodayInspectionsController(),);
    Get.lazyPut<CleanUpHistoryController>(() => CleanUpHistoryController(),);
    Get.lazyPut<ProfileController>(() => ProfileController(),);
    Get.lazyPut<GeneralInformationController>(() => GeneralInformationController(),);
    Get.lazyPut<PlantManagementController>(() => PlantManagementController(),);
    Get.lazyPut<AreaInspectionController>(() => AreaInspectionController(),);
    Get.lazyPut<AlertsController>(() => AlertsController(), fenix: true, // Keep the controller in memory even when not in use
    );
  }
}
