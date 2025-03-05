import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constant/AppColors.dart';
import 'create_schedule_logic.dart';

class CreateScheduleView extends StatelessWidget {
  CreateScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateScheduleController>(
        init: CreateScheduleController(),
        builder: (logic) {
          return Scaffold(
            backgroundColor: AppColors.appWhiteColor,
            body: SafeArea(
              child: Column(
                children: [buildAppBar(), buildDetails(context, logic)],
              ),
            ),
          );
        });
  }

  Widget buildDetails(BuildContext context, CreateScheduleController logic) {
    print('logic.selectedTime======${logic.selectedTime}');
    return Container(
      margin: EdgeInsets.only(right: 20, left: 20, top: 20),
      child: Column(
        children: [
          buildImage(context, logic),
          buildDeviceName(context, logic),
          buildDescription(context, logic),
          // buildDays(context, logic),
          buildText(context, logic),
          buildTreatmentTimeField(context, logic),
          buildSaveButton(context, logic),
        ],
      ),
    );
  }

  Widget buildTreatmentTime(
      BuildContext context, CreateScheduleController logic) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Container(
        height: 45,
        width: double.infinity, // Full width
        child: TextField(
          style: TextStyle(color: Color(0xFF666666)),
          decoration: InputDecoration(
            hintText: "00:00",
            hintStyle: TextStyle(
              color: Color(0xFF666666), // Set the hint text color here
            ),
            // Hint for the clock
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
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4), // Limit to 4 digits (HHmm)
          ],
        ),
      ),
    );
  }

  Widget buildSaveButton(BuildContext context, logic) {
    return InkWell(
      onTap: () {
        logic.onSaveClick();
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

  Widget buildTreatmentTimeField(
      BuildContext context, CreateScheduleController logic) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () async {
          // Show the TimePicker when tapped
          TimeOfDay? selectedTimeA = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );

          // If a time is selected, handle it accordingly
          if (selectedTimeA != null) {
            print('Selected Time: ${selectedTimeA.format(context)}');
            logic.updateTime(context,selectedTimeA);

          }
        },
        child: Container(
          height: 45,
          width: double.infinity, // Full width
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFEDEDED)),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    logic.selectedTime.isEmpty // Access the value here
                        ? 'Select Time' // Placeholder text
                        : logic.selectedTime, // Display selected time
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Image.asset(
                  'assets/images/clockIcon.png', // Clock icon
                  height: 20,
                  width: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildText(BuildContext context, CreateScheduleController logic) {
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

  Widget buildDays(BuildContext context, CreateScheduleController logic) {
    return Obx(() => Container(
          margin: EdgeInsets.only(top: 20),
          child: Row(
            children: [
              buildDayWithLogic(context, logic, 'S', logic.sunday),
              Spacer(),
              buildDayWithLogic(context, logic, 'M', logic.monday),
              Spacer(),
              buildDayWithLogic(context, logic, 'T', logic.tuesday),
              Spacer(),
              buildDayWithLogic(context, logic, 'W', logic.wednesday),
              Spacer(),
              buildDayWithLogic(context, logic, 'T', logic.thursday),
              Spacer(),
              buildDayWithLogic(context, logic, 'F', logic.friday),
              Spacer(),
              buildDayWithLogic(context, logic, 'S', logic.saturday),
            ],
          ),
        ));
  }

  Widget buildDayWithLogic(BuildContext context, CreateScheduleController logic,
      String day, RxBool isSelected) {
    return InkWell(
      onTap: () {
        logic.toggleDaySelection(
            day, isSelected); // Toggle selection and update the list
      },
      child: Column(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:
                    isSelected.value ? Color(0xFFB7A06A) : Colors.transparent,
                border: Border.all(
                    color: isSelected.value
                        ? Colors.transparent
                        : AppColors.appGrayColor)),
            child: isSelected.value
                ? Center(
                    child: Container(
                        margin: EdgeInsets.all(10),
                        child: Image.asset('assets/images/tickMarkIcon.png')))
                : Container(),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              day,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppColors.appPrimaryBlackColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDescription(
      BuildContext context, CreateScheduleController logic) {
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

  Widget buildDeviceName(BuildContext context, CreateScheduleController logic) {
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

  Widget buildImage(BuildContext context, CreateScheduleController logic) {
    return Obx(() {
      // Check if the image is available in the controller
      if (logic.storedDevice.value != null) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.appPrimaryBlackColor,
          ),
          height: MediaQuery.of(context).size.height / 3.5,
          width: double.infinity,
          child: Image.network(
            logic.storedDevice.value!.image!.src ?? '', // Load from model
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.broken_image,
                  size: 100); // Default icon if loading fails
            },
          ),
        );
      } else {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.appPrimaryBlackColor,
          ),
          height: MediaQuery.of(context).size.height / 3.5,
          width: double.infinity,
          child: Image.asset(
            'assets/images/scheduleItem.png', // Default image
            fit: BoxFit.fill,
          ),
        );
      }
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
      'Create Schedule',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
    );
  }
}
