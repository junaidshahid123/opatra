import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:opatra/UI/Splash%20Screen.dart';
import 'constant/AppColors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: ((context, child) {
      return GetMaterialApp(
          useInheritedMediaQuery: true,
          title: 'Opatra',
          color: AppColors.appPrimaryColor,
          // themeMode: themeController.theme ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData(
            fontFamily: 'Graphik',
            brightness: Brightness.dark,
            primaryColor: AppColors.appPrimaryColor,
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          //themeMode: ThemeMode.system,
          theme: ThemeData(
            fontFamily: 'Graphik',
            brightness: Brightness.light,
            useMaterial3: true,
          ),
          home: SplashScreen());
    }));
  }
}
