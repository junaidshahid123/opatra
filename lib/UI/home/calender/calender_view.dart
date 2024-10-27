import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:opatra/UI/home/calender/calender_logic.dart';
import 'package:opatra/UI/home/treatment1.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../constant/AppColors.dart';

class CalenderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;

    final RxString selectedTime = arguments['selectedTime'];
    final int device_id = arguments['id'];
    final String device_title = arguments['title'];

    return GetBuilder<CalenderController>(
        init: CalenderController(),
        builder: (logic) {
          return Scaffold(
            backgroundColor: AppColors.appWhiteColor,
            body: SafeArea(
              child: Column(
                children: [
                  buildAppBar(),
                  buildNextTreatment(),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFFBF3D7)),
                        borderRadius: BorderRadius.circular(20)),
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: CustomizableCalendar(
                      selectedDayColor: Color(0xFFB7A06A),
                      onDaysSelected: (selectedDays) {
                        logic.updateSelectedDays(
                            selectedDays); // Update controller
                      },
                    ),
                  ),
                  buildStartTreatmentButton(
                      context, logic, selectedTime, device_id, device_title)
                ],
              ),
            ),
          );
        });
  }

  Widget buildNextTreatment() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20, left: 20),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xFFFBF3D7))),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Text(
          'Your Next Treatment is on Wednesday\nat 03:25',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.appPrimaryBlackColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
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
          buildBackOption(),
          Spacer(),
          buildName(),
          Spacer(),
          buildNotificationOption()
        ],
      ),
    );
  }

  Widget buildName() {
    return const Text(
      'LUMIQUARTZ',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
    );
  }

  Widget buildBackOption() {
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

  Widget buildNotificationOption() {
    return Stack(
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
          child: Image.asset('assets/images/penIcon.png'),
        ),
      ],
    );
  }

  Widget buildStartTreatmentButton(
      BuildContext context,
      CalenderController logic,
      RxString selectedTime,
      int device_id,
      String device_title) {
    return InkWell(
      onTap: () {
        logic.deviceSchedule(selectedTime, device_id,
            device_title); // Pass the selected time value to the function
      },
      child: Container(
          margin: EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
          width: MediaQuery.of(context).size.width,
          height: 45,
          decoration: BoxDecoration(
            color: Color(0xFFB7A06A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
              child: logic.isLoading.value == true
                  ? SizedBox(
                      width: 20.0, // Adjust the width
                      height: 20.0, // Adjust the height
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                        color: AppColors.appWhiteColor,
                      ),
                    )
                  : Text(
                      'Start Treatment',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ))),
    );
  }
}

class CustomizableCalendar extends StatefulWidget {
  final Color? headerColor;
  final Color? selectedDayColor;
  final Color? todayColor;
  final TextStyle? dayTextStyle;
  final TextStyle? weekendTextStyle;
  final TextStyle? headerTextStyle;
  final Function(List<DateTime>)? onDaysSelected;
  final List<DateTime>? initialSelectedDays;

  const CustomizableCalendar({
    Key? key,
    this.headerColor,
    this.selectedDayColor,
    this.todayColor,
    this.dayTextStyle,
    this.weekendTextStyle,
    this.headerTextStyle,
    this.onDaysSelected,
    this.initialSelectedDays,
  }) : super(key: key);

  @override
  _CustomizableCalendarState createState() => _CustomizableCalendarState();
}

class _CustomizableCalendarState extends State<CustomizableCalendar> {
  late DateTime _focusedDay;
  late List<DateTime> _selectedDays;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialSelectedDays?.first ?? DateTime.now();
    _selectedDays = widget.initialSelectedDays ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Your other calendar UI components here...

        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => _selectedDays.contains(day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              // Toggle selection for the day
              if (_selectedDays.contains(selectedDay)) {
                _selectedDays.remove(selectedDay); // Remove if already selected
              } else {
                _selectedDays.add(selectedDay); // Add if not selected
              }
              _focusedDay = focusedDay;
            });

            // Update the selected days in the controller
            if (widget.onDaysSelected != null) {
              widget.onDaysSelected!(
                  _selectedDays); // Pass the updated list of selected days
            }
          },
          headerVisible: false,
          // Hide default header
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
                color: widget.todayColor ?? Color(0xFFB7A06A),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10)),
            selectedDecoration: BoxDecoration(
                color: widget.selectedDayColor ?? Colors.blueGrey,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10)),
            defaultTextStyle: widget.dayTextStyle ??
                TextStyle(color: Colors.black, fontSize: 14.0),
            weekendTextStyle: widget.weekendTextStyle ??
                TextStyle(color: Color(0xFF8F9BB3), fontSize: 14.0),
          ),
        ),
      ],
    );
  }
}
