import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/home/select_device/select_device_view.dart';
import 'package:opatra/UI/home/treatment/treatment_logic.dart';
import 'package:opatra/constant/AppColors.dart';

class TreatmentView extends StatelessWidget {
  const TreatmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TreatmentController>(
        init: TreatmentController(),
        builder: (logic) {
          return Scaffold(
              backgroundColor: AppColors.appWhiteColor,
              body: SafeArea(
                child: Column(
                  children: [
                    buildAppBar(logic),
                    Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: Obx(
                            () => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                logic.isLoading.value == true
                                    ? Center(
                                        child: CircularProgressIndicator(
                                        color: AppColors.appPrimaryColor,
                                      ))
                                    : logic.mdGetDevices.value == null
                                        ? buildText(logic)
                                        : Container(),
                                logic.isLoading.value == true
                                    ? Center(
                                        child: CircularProgressIndicator(
                                        color: AppColors.appPrimaryColor,
                                      ))
                                    : logic.mdGetDevices.value == null
                                        ? buildSelectDeviceButton(
                                            context, logic)
                                        : buildGridView(context, logic),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ));
        });
  }

  Widget buildSelectDeviceButton(
      BuildContext context, TreatmentController logic) {
    return InkWell(
      onTap: () {
        logic.onSelectDeviceTap();
      },
      child: Container(
          margin: EdgeInsets.only(top: 10),
          width: MediaQuery.of(context).size.width / 3,
          height: 45,
          decoration: BoxDecoration(
            color: Color(0xFFB7A06A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              'Select Device',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFFFFFFFF)),
            ),
          )),
    );
  }

  Widget buildGridView(BuildContext context, TreatmentController logic) {
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
                itemCount: logic.mdGetDevices.value!.data!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      // Call the controller's function instead of writing the logic here
                      // await logic.selectAndStoreDevice(index);
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
                                // Image.network(logic.mdGetDevices.value!.data![index].image!.src!),
                                Container(
                                  margin: EdgeInsets.only(left: 20, bottom: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${logic.mdGetDevices.value!.data![index].productName!.length > 10 ? logic.mdGetDevices.value!.data![index].productName!.substring(0, 10) + '...' : logic.mdGetDevices.value!.data![index].productName!}',
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

  Widget buildText(TreatmentController logic) {
    return Obx(() {
      // Check if the stored device is available
      if (logic.storedDevice.value != null) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Load image from the model's imageUrl property
            Image.network(
              logic.storedDevice.value!.image!.src ?? '', // Load from model
              width: 100, // Set appropriate width
              height: 100, // Set appropriate height
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image,
                    size: 100); // Default icon if loading fails
              },
            ),
            SizedBox(height: 10), // Add space between image and text
            Text(
              'Selected Device: ${logic.storedDevice.value!.title}',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xFF333333)),
              textAlign: TextAlign.center,
            ),
          ],
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Default image or icon if no device is selected
            Icon(
              Icons.devices, // Default icon
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 10), // Add space between image and text
            Text(
              "You don't have any selected\ndevice",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xFF333333)),
              textAlign: TextAlign.center,
            ),
          ],
        );
      }
    });
  }

  Widget buildAppBar(TreatmentController logic) {
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
          logic.deviceExists.value == false ? buildAddIcon() : Spacer(),
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

  Widget buildAddIcon() {
    return InkWell(
      onTap: () {
        Get.to(() => SelectDeviceView());
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
            child: Image.asset('assets/images/pluIcon.png'),
          ),
        ],
      ),
    );
  }

  Widget buildName() {
    return Text(
      'Treatment',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
    );
  }
}
