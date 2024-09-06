import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomBarHostController extends GetxController {
  var userName = ''.obs; // RxString to hold the userName
  var userEmail = ''.obs; // RxString to hold the userName

  @override
  void onInit() {
    super.onInit();
    _loadUserName(); // Load userName when the controller is initialized
    _loadUserEmail();
    update();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    userName.value =
        prefs.getString('userName') ?? 'Guest'; // Set default to 'Guest'
  }

  Future<void> _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    userEmail.value =
        prefs.getString('userEmail') ?? ''; // Set default to 'Guest'
  }
}
