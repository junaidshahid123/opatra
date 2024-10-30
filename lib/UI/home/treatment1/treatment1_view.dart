import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/home/treatment1/treatment1_logic.dart';
import 'package:opatra/constant/AppColors.dart';

class Treatment1View extends StatefulWidget {
  final List<int>? selectedAreasList;
  final List<DateTime>? selectedDays; // Made optional
  final String? title; // Remains optional
  final int? id; // Made optional
  final String? selectedTime; // Made optional

// Constructor with optional named parameters
  const Treatment1View({
    this.selectedAreasList,
    this.selectedDays,
    this.title,
    this.id,
    this.selectedTime,
    Key? key,
  }) : super(key: key); // Pass the key to the superclass constructor

  @override
  State<Treatment1View> createState() => _Treatment1ViewState();
}

class _Treatment1ViewState extends State<Treatment1View> {
  final String dummyTextShort =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
      'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
      'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ';
  late Treatment1Controller logic;
  late int _remainingTime; // In seconds
  late Timer _timer;
  bool _isRunning = true; // Initial state: timer is running

  @override
  void initState() {
    super.initState();
    logic = Get.put(Treatment1Controller());

    // Initialize selected areas based on passed selectedAreasList
    if (widget.selectedAreasList != null) {
      for (int area in widget.selectedAreasList!) {
        logic.selectedAreas[area] = true; // Mark areas as selected
      }
    }
    _initializeTimer();
  }

  void _initializeTimer() {
    final parts = widget.selectedTime!.split(':');
    final minutes = int.parse(parts[0]);
    final seconds = int.parse(parts[1]);

    _remainingTime = (minutes * 60) + seconds; // Convert to total seconds

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel(); // Stop the timer when it reaches zero
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel(); // Stop timer when it reaches zero
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  void _toggleTimer() {
    setState(() {
      if (_isRunning) {
        _timer.cancel(); // Pause the timer
      } else {
        _startTimer(); // Resume the timer
      }
      _isRunning = !_isRunning; // Toggle the running state
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Treatment1Controller>(
      init: Treatment1Controller(),
      builder: (logic) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Background image
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/womenImage.png',
                    fit: BoxFit.cover,
                  ),
                ),
                // Highlight areas overlay
                Positioned.fill(
                  child: GestureDetector(
                    onTapUp: (details) {
                      // Handle tap logic based on coordinates if needed
                    },
                    child: Stack(
                      children: [
                        _buildHighlightArea(
                            context, logic, 1, Offset(0.5, 0.2)),
                        _buildHighlightArea(
                            context, logic, 2, Offset(0.4, 0.4)),
                        _buildHighlightArea(
                            context, logic, 3, Offset(0.5, 0.5)),
                        _buildHighlightArea(
                            context, logic, 4, Offset(0.5, 0.7)),
                      ],
                    ),
                  ),
                ),
                // Bottom container with treatment options
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3.4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        widget.selectedAreasList != null
                            ? Container()
                            : _buildSelectYourTreatmentAreas(),
                        widget.selectedAreasList != null
                            ? Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _formatTime(_remainingTime),
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: AppColors
                                                  .appPrimaryBlackColor,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _toggleTimer();
                                          },
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                height: 40.sp,
                                                width: 40.sp,
                                                child: Image.asset(
                                                    'assets/images/ellipse.png'),
                                              ),
                                              Container(
                                                height: 15,
                                                width: 15,
                                                child: Image.asset(
                                                  _isRunning
                                                      ? 'assets/images/pauseIcon.png' // Show pause icon if running
                                                      : 'assets/images/playIcon.png', // Show play icon if paused),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : TreatmentListWidget(
                                logic: logic,
                              ),
                        widget.selectedAreasList != null
                            ? Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                child: Text(
                                  dummyTextShort,
                                  style: TextStyle(
                                      color: AppColors.appHistoryDateTextColor),
                                ))
                            : Container(),
                        Spacer(),
                        widget.selectedAreasList == null
                            ? _buildContinueButton(
                                context,
                                logic,
                              )
                            : Container(
                                margin: EdgeInsets.only(
                                    bottom: 20, left: 20, right: 20),
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
                                            'Next',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          )))
                      ],
                    ),
                  ),
                ),
                Positioned(top: 20, left: 20, child: _buildBackOption()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHighlightArea(BuildContext context, Treatment1Controller logic,
      int area, Offset offset) {
    final isSelected = logic.isAreaSelected(area);

    // Define dimensions for selected and unselected states, excluding chin
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double widthFactor = (isSelected && area == 1)
        ? 0.6
        : (isSelected && area == 4)
            ? 1.0 // Keep full size for chin
            : 0.25;
    final double heightFactor = (isSelected && area == 4) ? 0.06 : 0.1;

    // Define margin, which won't apply to chin area
    final double margin = screenWidth * 0.01;

    // Define additional margin adjustments for other areas
    final double foreheadTopMarginFor1 = screenHeight * 0.05;
    final double foreheadTopMarginFor2 = screenHeight * 0.05;
    final double foreheadLeftMargin1 = screenWidth * 0.05;
    final double foreheadLeftMargin3 = screenWidth * 0.25;
    final double foreheadLeftMargin4 = screenWidth * 0.08;
    final double foreheadTopMarginFor3 = -screenHeight * 0.06;
    final double foreheadTopMarginFor4 = -screenHeight * 0.08;
    final double foreheadRightMarginFor2 = screenWidth * 0.25;
    final double foreheadRightMarginFor3 = -screenWidth * 0.25;
    final double foreheadRightMarginFor4 = -screenWidth * 0.08;

    // Define border radius and image path for each area
    BorderRadius borderRadius;
    String imagePath;

    switch (area) {
      case 1: // Forehead
        borderRadius = BorderRadius.only(
          topLeft: Radius.circular(screenWidth * 0.08),
          topRight: Radius.circular(screenWidth * 0.08),
          bottomLeft: Radius.circular(screenWidth * 0.18),
          bottomRight: Radius.circular(screenWidth * 0.18),
        );
        imagePath = 'assets/images/head.png';
        break;
      case 2: // Right Cheek
        borderRadius = BorderRadius.only(
          topLeft: Radius.circular(screenWidth * 0.08),
          topRight: Radius.circular(screenWidth * 0.08),
          bottomLeft: Radius.circular(screenWidth * 0.18),
          bottomRight: Radius.circular(screenWidth * 0.18),
        );
        imagePath = 'assets/images/right.png';
        break;
      case 3: // Left Cheek
        borderRadius = BorderRadius.only(
          topLeft: Radius.circular(screenWidth * 0.04),
          topRight: Radius.circular(screenWidth * 0.04),
          bottomLeft: Radius.circular(screenWidth * 0.13),
          bottomRight: Radius.circular(screenWidth * 0.13),
        );
        imagePath = 'assets/images/left.png';
        break;
      case 4: // Chin
        borderRadius = BorderRadius.zero; // No border radius for original form
        imagePath = 'assets/images/chin.png';
        break;
      default:
        borderRadius = BorderRadius.circular(screenWidth * 0.13);
        imagePath = 'assets/images/womenImage.png';
    }

    return Positioned(
      right: screenWidth * (offset.dx - widthFactor / 2) -
          margin +
          (area == 2
              ? foreheadRightMarginFor2
              : area == 3
                  ? foreheadRightMarginFor3 - screenWidth * 0.01
                  : area == 4
                      ? foreheadRightMarginFor4
                      : -screenWidth * 0.025),
      top: screenHeight * (offset.dy - heightFactor / 2) -
          margin +
          (area == 1
              ? foreheadTopMarginFor1
              : area == 2
                  ? foreheadTopMarginFor2
                  : area == 3
                      ? foreheadTopMarginFor3
                      : area == 4
                          ? foreheadTopMarginFor4
                          : 0),
      child: GestureDetector(
        onTap: () {
          logic.toggleAreaSelection(area);
        },
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: isSelected ? 1.0 : 0.0, // Show image only when selected
          child: area == 4
              ? Container(
                  width: screenWidth * widthFactor + (margin * 0.4),
                  height: screenHeight * heightFactor + (margin * 0.4),
                  child: ClipRRect(
                      borderRadius: borderRadius,
                      child: Image.asset(
                          imagePath))) // Display chin image in original form
              : Container(
                  width: screenWidth * widthFactor + (margin * 0.5),
                  height: screenHeight * heightFactor + (margin * 0.5),
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  // Widget _buildHighlightArea(BuildContext context, Treatment1Controller logic,
  //     int area, Offset offset)
  // {
  //   final isSelected = logic.isAreaSelected(area);
  //
  //   // Define dimensions for selected and unselected states, excluding chin
  //   final double widthFactor = (isSelected && area == 1)
  //       ? 0.6
  //       : (isSelected && area == 4)
  //           ? 1.0 // Keep full size for chin
  //           : 0.25;
  //   final double heightFactor = (isSelected && area == 4) ? 0.06 : 0.1;
  //
  //   // Define margin, which won't apply to chin area
  //   const double margin = 5.0;
  //
  //   // Define additional margin adjustments for other areas
  //   const double foreheadTopMarginFor1 = 40.0;
  //   const double foreheadTopMarginFor2 = 40.0;
  //   const double foreheadLeftMargin1 = 20.0;
  //   const double foreheadLeftMargin3 = 100.0;
  //   const double foreheadLeftMargin4 = 30.0;
  //   const double foreheadTopMarginFor3 = -50.0;
  //   const double foreheadTopMarginFor4 = -60.0;
  //   const double foreheadRightMarginFor2 = 100.0;
  //   const double foreheadRightMarginFor3 = -100.0;
  //   const double foreheadRightMarginFor4 = -30.0;
  //
  //   // Define border radius and image path for each area
  //   BorderRadius borderRadius;
  //   String imagePath;
  //
  //   switch (area) {
  //     case 1: // Forehead
  //       borderRadius = BorderRadius.only(
  //         topLeft: Radius.circular(30),
  //         topRight: Radius.circular(30),
  //         bottomLeft: Radius.circular(70),
  //         bottomRight: Radius.circular(70),
  //       );
  //       imagePath = 'assets/images/head.png';
  //       break;
  //     case 2: // Right Cheek
  //       borderRadius = BorderRadius.only(
  //         topLeft: Radius.circular(30),
  //         topRight: Radius.circular(30),
  //         bottomLeft: Radius.circular(70),
  //         bottomRight: Radius.circular(70),
  //       );
  //       imagePath = 'assets/images/right.png';
  //       break;
  //     case 3: // Left Cheek
  //       borderRadius = BorderRadius.only(
  //         topLeft: Radius.circular(15),
  //         topRight: Radius.circular(15),
  //         bottomLeft: Radius.circular(50),
  //         bottomRight: Radius.circular(50),
  //       );
  //       imagePath = 'assets/images/left.png';
  //       break;
  //     case 4: // Chin
  //       borderRadius = BorderRadius.zero; // No border radius for original form
  //       imagePath = 'assets/images/chin.png';
  //       break;
  //     default:
  //       borderRadius = BorderRadius.circular(50);
  //       imagePath = 'assets/images/womenImage.png';
  //   }
  //
  //   return Positioned(
  //     right: MediaQuery.of(context).size.width * (offset.dx - widthFactor / 2) -
  //             margin +
  //             (area == 2
  //                 ? foreheadRightMarginFor2
  //                 : area == 3
  //                     ? foreheadRightMarginFor3 - 5
  //                     : area == 4
  //                 ? foreheadRightMarginFor4 : -10),
  //     top: MediaQuery.of(context).size.height * (offset.dy - heightFactor / 2) -
  //         margin +
  //         (area == 1
  //             ? foreheadTopMarginFor1
  //             : area == 2
  //                 ? foreheadTopMarginFor2
  //                 : area == 3
  //                     ? foreheadTopMarginFor3
  //                     : area == 4
  //                         ? foreheadTopMarginFor4
  //                         : 0),
  //     child: GestureDetector(
  //       onTap: () {
  //         logic.toggleAreaSelection(area);
  //       },
  //       child: AnimatedOpacity(
  //         duration: Duration(milliseconds: 300),
  //         opacity: isSelected ? 1.0 : 0.0, // Show image only when selected
  //         child: area == 4
  //             ? Container(
  //                 width: MediaQuery.of(context).size.width * widthFactor +
  //                     (margin * 0.4),
  //                 height: MediaQuery.of(context).size.height * heightFactor +
  //                     (margin * 0.4),
  //                 child: ClipRRect(
  //                     borderRadius: borderRadius,
  //                     child: Image.asset(
  //                         imagePath))) // Display chin image in original form
  //             : Container(
  //                 width: MediaQuery.of(context).size.width * widthFactor +
  //                     (margin * 0.5),
  //                 height: MediaQuery.of(context).size.height * heightFactor +
  //                     (margin * 0.5),
  //                 child: ClipRRect(
  //                   borderRadius: borderRadius,
  //                   child: Image.asset(
  //                     imagePath,
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //               ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSelectYourTreatmentAreas() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        'Please select your treatment\nareas',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black),
      ),
    );
  }

  Widget _buildBackOption() {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 50,
            width: 50,
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

  Widget _buildContinueButton(
      BuildContext context, Treatment1Controller logic) {
    return Obx(() => InkWell(
          onTap: () {
            // print(logic.selectedAreasList.length);
            // print(widget.selectedDays!.length);
            // print(widget.selectedTime);
            // print(widget.title);
            // print(widget.id);
            logic.deviceSchedule(widget.selectedTime!, widget.id!,
                widget.title!, widget.selectedDays!);
            // Navigate to the next screen
          },
          child: Container(
              margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
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
                          'Continue',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ))),
        ));
  }
}

class TreatmentListWidget extends StatelessWidget {
  final Treatment1Controller logic;

  const TreatmentListWidget({Key? key, required this.logic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: logic.selectedAreas.keys.length,
            itemBuilder: (context, index) {
              int area = logic.selectedAreas.keys.elementAt(index);
              final bool isSelected = logic.isAreaSelected(area);

              return InkWell(
                onTap: () {
                  logic.toggleAreaSelection(area);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: 60,
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFFB7A06A) : Colors.transparent,
                    border: Border.all(
                      color:
                          isSelected ? Colors.transparent : Color(0xFFC9CBCF),
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      area.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
