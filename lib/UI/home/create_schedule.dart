import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:opatra/UI/home/calender.dart';
import '../../constant/AppColors.dart';

class CreateSchedule extends StatefulWidget {
  const CreateSchedule({super.key});

  @override
  State<CreateSchedule> createState() => _CreateScheduleState();
}

class _CreateScheduleState extends State<CreateSchedule> {
  RxBool sunday = false.obs;
  RxBool monday = false.obs;
  RxBool tuesday = false.obs;
  RxBool wednesday = false.obs;
  RxBool thursday = false.obs;
  RxBool friday = false.obs;
  RxBool saturday = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhiteColor,
      body: SafeArea(
        child: Column(
          children: [buildAppBar(), buildDetails()],
        ),
      ),
    );
  }

  Widget buildDetails() {
    return Expanded(
        child: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(right: 20, left: 20, top: 20),
        child: Column(
          children: [
            buildImage(),
            buildDeviceName(),
            buildDescription(),
            buildDays(),
            buildText(),
            buildTreatmentTime(),
            buildTreatmentTimeField(),
            buildSaveButton()
          ],
        ),
      ),
    ));
  }

  Widget buildSaveButton() {
    return InkWell(
      onTap: (){
        Get.to(()=>CalenderScreen());
      },
      child: Container(
          margin: EdgeInsets.only(top: 50, bottom: 20),
          width: MediaQuery.of(context).size.width,
          height: 45,
          decoration: BoxDecoration(
            color: Color(0xFFB7A06A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              'Save Schedule',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          )),
    );
  }

  Widget buildTreatmentTimeField() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Container(
        height: 45,
        width: double.infinity, // Full width
        child: TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFEDEDED),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFEDEDED),
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFEDEDED),
              ),
            ),
            suffixIcon: Container(
              height: 10, // Specific height
              width: 10, // Specific width
              child: Container(
                margin: EdgeInsets.all(15),
                child: Image.asset(
                  'assets/images/clockIcon.png', // Adjust the image within the container
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTreatmentTime() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Text(
            'Select your preferred treatment time',
            style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 12,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget buildText() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Text(
        'or use existing schedule',
        style: TextStyle(
            color: Color(0xFFB7A06A),
            fontSize: 13,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget buildDays() {
    return Obx(() => Container(
          margin: EdgeInsets.only(top: 20),
          child: Row(
            children: [
              buildSunday(),
              Spacer(),
              buildMonday(),
              Spacer(),
              buildTuesday(),
              Spacer(),
              buildWednesday(),
              Spacer(),
              buildThursday(),
              Spacer(),
              buildFriday(),
              Spacer(),
              buildSaturday()
            ],
          ),
        ));
  }

  Widget buildSaturday() {
    return InkWell(
      onTap: () {
        saturday.value = !saturday.value;
      },
      child: Column(
        children: [
          Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: saturday.value == true
                      ? Color(0xFFB7A06A)
                      : Colors.transparent,
                  border: Border.all(
                      color: saturday.value == true
                          ? Colors.transparent
                          : AppColors.appGrayColor)),
              child: saturday.value == true
                  ? Center(
                      child: Container(
                          margin: EdgeInsets.all(10),
                          child: Image.asset('assets/images/tickMarkIcon.png')))
                  : Container()),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'S',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppColors.appPrimaryBlackColor),
            ),
          )
        ],
      ),
    );
  }

  Widget buildFriday() {
    return InkWell(
      onTap: () {
        friday.value = !friday.value;
      },
      child: Column(
        children: [
          Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: friday.value == true
                      ? Color(0xFFB7A06A)
                      : Colors.transparent,
                  border: Border.all(
                      color: friday.value == true
                          ? Colors.transparent
                          : AppColors.appGrayColor)),
              child: friday.value == true
                  ? Center(
                      child: Container(
                          margin: EdgeInsets.all(10),
                          child: Image.asset('assets/images/tickMarkIcon.png')))
                  : Container()),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'F',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppColors.appPrimaryBlackColor),
            ),
          )
        ],
      ),
    );
  }

  Widget buildThursday() {
    return InkWell(
      onTap: () {
        thursday.value = !thursday.value;
      },
      child: Column(
        children: [
          Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: thursday.value == true
                      ? Color(0xFFB7A06A)
                      : Colors.transparent,
                  border: Border.all(
                      color: thursday.value == true
                          ? Colors.transparent
                          : AppColors.appGrayColor)),
              child: thursday.value == true
                  ? Center(
                      child: Container(
                          margin: EdgeInsets.all(10),
                          child: Image.asset('assets/images/tickMarkIcon.png')))
                  : Container()),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'T',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppColors.appPrimaryBlackColor),
            ),
          )
        ],
      ),
    );
  }

  Widget buildWednesday() {
    return InkWell(
      onTap: () {
        wednesday.value = !wednesday.value;
      },
      child: Column(
        children: [
          Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: wednesday.value == true
                      ? Color(0xFFB7A06A)
                      : Colors.transparent,
                  border: Border.all(
                      color: wednesday.value == true
                          ? Colors.transparent
                          : AppColors.appGrayColor)),
              child: wednesday.value == true
                  ? Center(
                      child: Container(
                          margin: EdgeInsets.all(10),
                          child: Image.asset('assets/images/tickMarkIcon.png')))
                  : Container()),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'W',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppColors.appPrimaryBlackColor),
            ),
          )
        ],
      ),
    );
  }

  Widget buildTuesday() {
    return InkWell(
      onTap: () {
        tuesday.value = !tuesday.value;
      },
      child: Column(
        children: [
          Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: tuesday.value == true
                      ? Color(0xFFB7A06A)
                      : Colors.transparent,
                  border: Border.all(
                      color: tuesday.value == true
                          ? Colors.transparent
                          : AppColors.appGrayColor)),
              child: tuesday.value == true
                  ? Center(
                      child: Container(
                          margin: EdgeInsets.all(10),
                          child: Image.asset('assets/images/tickMarkIcon.png')))
                  : Container()),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'T',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppColors.appPrimaryBlackColor),
            ),
          )
        ],
      ),
    );
  }

  Widget buildMonday() {
    return InkWell(
      onTap: () {
        monday.value = !monday.value;
      },
      child: Column(
        children: [
          Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: monday.value == true
                      ? Color(0xFFB7A06A)
                      : Colors.transparent,
                  border: Border.all(
                      color: monday.value == true
                          ? Colors.transparent
                          : AppColors.appGrayColor)),
              child: monday.value == true
                  ? Center(
                      child: Container(
                          margin: EdgeInsets.all(10),
                          child: Image.asset('assets/images/tickMarkIcon.png')))
                  : Container()),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'M',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppColors.appPrimaryBlackColor),
            ),
          )
        ],
      ),
    );
  }

  Widget buildSunday() {
    return InkWell(
      onTap: () {
        sunday.value = !sunday.value;
      },
      child: Column(
        children: [
          Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: sunday.value == true
                      ? Color(0xFFB7A06A)
                      : Colors.transparent,
                  border: Border.all(
                      color: sunday.value == true
                          ? Colors.transparent
                          : AppColors.appGrayColor)),
              child: sunday.value == true
                  ? Center(
                      child: Container(
                          margin: EdgeInsets.all(10),
                          child: Image.asset('assets/images/tickMarkIcon.png')))
                  : Container()),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'S',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppColors.appPrimaryBlackColor),
            ),
          )
        ],
      ),
    );
  }

  Widget buildDescription() {
    return Row(
      children: [
        Text(
          'Using the lumiquatrz 3 times a week, combined\nwith the right techniques, will give you results that\n speak for themselves.',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF797E86)),
        ),
      ],
    );
  }

  Widget buildDeviceName() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Text(
            'LUMIQUARTZ',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: AppColors.appPrimaryBlackColor),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.appPrimaryBlackColor),
        height: MediaQuery.of(context).size.height / 3.5,
        width: double.infinity,
        child: Image.asset(
          'assets/images/scheduleItem.png',
          fit: BoxFit.fill,
        ));
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
      'Create Schedule',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
    );
  }
}
