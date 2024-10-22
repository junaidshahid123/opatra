import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RegisterYourOwnProductController extends GetxController {
  RxBool yesOption = false.obs;
  RxString selectedCountry = 'UK'.obs;
  final phoneController = TextEditingController();
  var selectedCountryCode = ''.obs; // Default country code
  bool isPhoneValid = true; // Track phone validation state
  String fullPhoneNumber = '';
  final dobController = TextEditingController();
  final doPController = TextEditingController();
  DateTime? dateOfBirth;
  DateTime? dateOfPurchase;

  void setSelectedCountry(String country) {
    selectedCountry.value = country;
  }

  Future<void> onBirthdayTap() async {
    print("Opening date picker for Date of Birth...");

    DateTime currentDate = DateTime.now();
    DateTime initialDate = DateTime(currentDate.year - 18, currentDate.month, currentDate.day);
    DateTime firstDate = DateTime(currentDate.year - 100);
    DateTime lastDate = initialDate;

    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      dateOfBirth = pickedDate;
      dobController.clear();
      dobController.text = DateFormat('dd/MM/yyyy').format(dateOfBirth!);
      print("Selected Date of Birth: $pickedDate");
      update();
    } else {
      print("Date of Birth is not selected");
    }
  }

  Future<void> onPurchaseTap() async {
    print("Opening date picker for Date of Purchase...");

    DateTime currentDate = DateTime.now();
    DateTime initialDate = currentDate;
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = currentDate;

    print("Current Date: $currentDate");
    print("Initial Date: $initialDate");
    print("First Date: $firstDate");
    print("Last Date: $lastDate");

    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      dateOfPurchase = pickedDate;
      doPController.clear();
      doPController.text = DateFormat('dd/MM/yyyy').format(dateOfPurchase!);
      print("Selected Date of Purchase: $pickedDate");
      update();
    } else {
      print("Date of Purchase is not selected");
    }
  }


}
