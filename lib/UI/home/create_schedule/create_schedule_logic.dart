import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/MDProductDetail.dart';
import '../calender/calender_view.dart';

class CreateScheduleController extends GetxController {
  Rx<Product?> storedDevice = Rx<Product?>(null);

  RxBool sunday = false.obs;
  RxBool monday = false.obs;
  RxBool tuesday = false.obs;
  RxBool wednesday = false.obs;
  RxBool thursday = false.obs;
  RxBool friday = false.obs;
  RxBool saturday = false.obs;
  RxString selectedTime = ''.obs; // Observable for storing selected time
  var selectedTimes = List.generate(7, (index) => ''.obs);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getDevice();
  }

  // List to store selected days
  var selectedDays = <String>[].obs;

  // Method to handle day selection
  void toggleDaySelection(String day, RxBool isSelected) {
    isSelected.value = !isSelected.value;

    if (isSelected.value) {
      selectedDays.add(day); // Add day to list if selected
    } else {
      selectedDays.remove(day); // Remove day from list if deselected
    }
  }

  void onSaveClick() {
    print('selectedTime=====${selectedTime}');
    print('storedDevice.value!.title=====${storedDevice.value!.title}');
    print(' storedDevice.value!.id=====${ storedDevice.value!.id}');
    Get.to(
      () => CalenderView(),
      arguments: {
        'selectedTime': selectedTime,
        'title': storedDevice.value!.title,
        'id': storedDevice.value!.id,
      },
    );
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
}
