import 'dart:convert';
import 'package:get/get.dart';
import 'package:opatra/models/MDProductDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../select_device/select_device_view.dart';

class TreatmentController extends GetxController {
  Rx<Product?> storedDevice = Rx<Product?>(null);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getDevice();
  }

  Future<void> getDevice() async {
    // Access SharedPreferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Retrieve the JSON string from SharedPreferences
    String? deviceJson = sharedPreferences.getString('selectedDevice');

    // Check if the JSON string is not null
    if (deviceJson != null) {
      // Decode the JSON string and convert it into a Device object
      Map<String, dynamic> deviceMap = jsonDecode(deviceJson);
      storedDevice.value = Product.fromJson(deviceMap);

      // You can now use the storedDevice object
      print('Retrieved Device: ${storedDevice.value!.title}');
    } else {
      print('No device found in SharedPreferences.');
    }
  }

  void onSelectDeviceTap() {
    Get.to(() => SelectDeviceView());
  }
}
