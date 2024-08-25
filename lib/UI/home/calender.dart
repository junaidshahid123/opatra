import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:opatra/UI/home/treatment1.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../constant/AppColors.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  @override
  Widget build(BuildContext context) {
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
                )),
            buildStartTreatmentButton()
          ],
        ),
      ),
    );
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

  Widget buildStartTreatmentButton() {
    return InkWell(
      onTap: () {
        Get.to(() => Treatment1());
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
            child: Text(
              'Start Treatment',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          )),
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

  void _onLeftButtonPressed() {
    setState(() {
      _focusedDay = DateTime(
        _focusedDay.year,
        _focusedDay.month - 1,
        _focusedDay.day,
      );
    });
  }

  void _onRightButtonPressed() {
    setState(() {
      _focusedDay = DateTime(
        _focusedDay.year,
        _focusedDay.month + 1,
        _focusedDay.day,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          color: widget.headerColor ?? Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MMMM').format(_focusedDay), // Use month name
                    style: widget.headerTextStyle ??
                        TextStyle(
                            color: Color(0xFF222B45),
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${_focusedDay.year}",
                    style: widget.headerTextStyle ??
                        TextStyle(
                          color: Color(0xFF8F9BB3),
                          fontSize: 12.0,
                        ),
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      _onLeftButtonPressed();
                    },
                    child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFCED3DE)),
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                            margin: EdgeInsets.all(7),
                            child: Image.asset('assets/images/arrowLeft.png'))),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      _onRightButtonPressed();
                    },
                    child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFCED3DE)),
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                            margin: EdgeInsets.all(7),
                            child:
                                Image.asset('assets/images/arrowRight.png'))),
                  ),
                ],
              ),
            ],
          ),
        ),
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => _selectedDays.contains(day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              if (_selectedDays.contains(selectedDay)) {
                _selectedDays.remove(selectedDay);
              } else {
                _selectedDays.add(selectedDay);
              }
              _focusedDay = focusedDay;
            });
            if (widget.onDaysSelected != null) {
              widget.onDaysSelected!(_selectedDays);
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
