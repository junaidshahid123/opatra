import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/home/calender/calender_logic.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../constant/AppColors.dart';
import '../treatment1/treatment1_view.dart';

class CalenderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Accessing the arguments passed to this view
    final args = Get.arguments;

    // Extracting the necessary values from the arguments
    final String selectedTime = args['selectedTime'];
    final String title = args['title'];
    final int id = args['id'];
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
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: CustomizableCalendar(
                      selectedDayColor: Color(0xFFB7A06A),
                      todayColor: AppColors.appHistoryDateTextColor,
                      // Example for the today color
                      dayTextStyle:
                          TextStyle(fontSize: 16, color: Colors.black),
                      weekendTextStyle:
                          TextStyle(fontSize: 16, color: Colors.red),
                      onDaysSelected: (selectedDays) {
                        print('Selected days: $selectedDays');
                        logic.updateSelectedDays(
                            selectedDays); // Update controller
                      },
                    ),
                  ),
                  buildStartTreatmentButton(
                      context, logic, selectedTime, id, title)
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
      String selectedTime,
      int device_id,
      String device_title) {
    return InkWell(
      onTap: () {
        print("Selected Days: ${logic.selectedDays}");
        print("Title: $device_title");
        print("ID: $device_id");
        print("Selected Time: $selectedTime");

        // Check if at least one day is selected
        if (logic.selectedDays.isNotEmpty) {
          // Navigate to Treatment1View and pass the arguments
          Get.to(() => Treatment1View(
                selectedDays: logic.selectedDays,
                title: device_title,
                id: device_id,
                selectedTime: selectedTime,
              ));
        } else {
          // Show a snackbar if no day is selected
          Get.snackbar(
            'Error',
            'Please Select At Least One Day',
            backgroundColor: Colors.red,
          );
        }
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
          // Inside CustomizableCalendar
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              if (_selectedDays.contains(selectedDay)) {
                _selectedDays.remove(selectedDay);
              } else {
                _selectedDays.add(selectedDay);
              }
              _focusedDay = focusedDay;
            });

            // Call the parent's callback if it exists
            if (widget.onDaysSelected != null) {
              widget.onDaysSelected!(_selectedDays);
            }
          },
          headerVisible: false,
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: widget.todayColor ?? Color(0xFFB7A06A),
              shape: BoxShape.rectangle,
              // Change to rectangle if you want rounded corners
              borderRadius: BorderRadius.circular(10), // Only for rectangles
            ),
            selectedDecoration: BoxDecoration(
              color: widget.selectedDayColor ?? Colors.blueGrey,
              shape: BoxShape.rectangle,
              // Change to rectangle if you want rounded corners
              // borderRadius: BorderRadius.circular(10), // Only for rectangles
            ),
            defaultTextStyle: widget.dayTextStyle ??
                TextStyle(color: Colors.black, fontSize: 14.0),
            weekendTextStyle: widget.weekendTextStyle ??
                TextStyle(color: Color(0xFF8F9BB3), fontSize: 14.0),
          ),
        )
      ],
    );
  }
}
