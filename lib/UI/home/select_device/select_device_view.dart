import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/home/select_device/select_device_logic.dart';
import '../../../constant/AppColors.dart';

class SelectDeviceView extends StatelessWidget {
  const SelectDeviceView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectDeviceController>(
        init: SelectDeviceController(),
        builder: (logic) {
          return Scaffold(
            backgroundColor: AppColors.appWhiteColor,
            body: SafeArea(
              child: Column(
                children: [buildAppBar(), buildGridView(context, logic)],
              ),
            ),
          );
        });
  }

  Widget buildAppBar() {
    return Container(
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 30,
      ),
      child: Row(
        children: [
          buildSideBarOption(),
          Spacer(),
          buildName(),
          Spacer(),
          Container(),
          Spacer()
        ],
      ),
    );
  }

  Widget buildSideBarOption() {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 50.sp,
            width: 50.sp,
            child: Image.asset('assets/images/ellipse.png'),
          ),
          Container(
            height: 15,
            width: 15,
            child: Image.asset('assets/images/leftArrow.png'),
          ),
        ],
      ),
    );
  }

  Widget buildName() {
    return Text(
      'Select Device',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
    );
  }

  Widget buildGridView(BuildContext context, SelectDeviceController logic) {
    return Obx(() => logic.isLoading.value == true
        ? Center(child: CircularProgressIndicator())
        : Expanded(
            child: Container(
              margin: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 0.8,
                ),
                itemCount: logic.devices.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      // Call the controller's function instead of writing the logic here
                      await logic.selectAndStoreDevice(index);
                      print('logic.devices[index].id========${logic.devices[index].id}');
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFFBF3D7)),
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.appWhiteColor,
                          ),
                          child: Container(
                            margin: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Image.network(logic.devices[index].image!.src!),
                                Container(
                                  margin: EdgeInsets.only(left: 20, bottom: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${logic.devices[index].title!.length > 10 ? logic.devices[index].title!.substring(0, 10) + '...' : logic.devices[index].title}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: AppColors.appPrimaryBlackColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ));
  }
}
