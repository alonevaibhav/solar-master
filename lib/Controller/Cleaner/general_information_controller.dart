import 'package:get/get.dart';

class GeneralInformationController extends GetxController {
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Simulate fetching data
    fetchData();
  }

  void fetchData() {
    isLoading.value = true;
    // Simulate a delay for data fetching
    Future.delayed(Duration(milliseconds: 1), () {
      isLoading.value = false;
    });
  }
}
