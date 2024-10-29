import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/home/treatment1/treatment1_logic.dart';
import 'package:opatra/constant/AppColors.dart';

class Treatment1View extends StatelessWidget {
  final List<DateTime> selectedDays;
  final String title;
  final int id;
  final String selectedTime;

  // Constructor with named parameters
  const Treatment1View({
    required this.selectedDays,
    required this.title,
    required this.id,
    super.key,
    required this.selectedTime,
  });

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
                        // _buildHighlightArea(
                        //     context, logic, 5, Offset(0.6, 0.8)),
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
                        _buildSelectYourTreatmentAreas(),
                        TreatmentListWidget(
                          logic: logic,
                        ),
                        _buildContinueButton(context, logic),
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

    // Define dimensions for selected and unselected states

    final double widthFactor = (isSelected && area == 1)
        ? 0.6
        : (isSelected && area == 4)
            ? 0.2
            : 0.25;
    final double heightFactor = (isSelected && area == 4) ? 0.05 : 0.1;

    // Define margin
    const double margin = 5.0;

    // Define additional margin specifically for the forehead image (case 1)
    const double foreheadTopMarginFor1 = 40.0;
    const double foreheadTopMarginFor2 = 40.0;
    const double foreheadLeftMargin1 = 20.0;
    const double foreheadLeftMargin3 = 100.0;
    const double foreheadLeftMargin4 = 30.0;
    const double foreheadTopMarginFor3 = -50.0;
    const double foreheadTopMarginFor4 = -80.0;
    const double foreheadRightMarginFor2 = 100.0;
    const double foreheadRightMarginFor3 = -100.0;

    // Define border radius and image path for each area
    BorderRadius borderRadius;
    String imagePath;

    switch (area) {
      case 1: // Forehead
        borderRadius = BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(70),
          bottomRight: Radius.circular(70),
        );
        imagePath = 'assets/images/head.png';
        break;
      case 2: // Right Cheek
        borderRadius = BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(70),
          bottomRight: Radius.circular(70),
        );
        imagePath = 'assets/images/right.png';
        break;
      case 3: // Left Cheek
        borderRadius = BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        );
        imagePath = 'assets/images/left.png';
        break;
      case 4: // Chin
        borderRadius = BorderRadius.only(
          topLeft: Radius.circular(100),
          topRight: Radius.circular(100),
          bottomLeft: Radius.circular(100),
          bottomRight: Radius.circular(100),
        );
        imagePath = 'assets/images/chin.png';
        break;
      default:
        borderRadius = BorderRadius.circular(50);
        imagePath = 'assets/images/womenImage.png';
    }

    return Positioned(
        right:
            MediaQuery.of(context).size.width * (offset.dx - widthFactor / 2) -
                margin +
                (area == 2
                    ? foreheadRightMarginFor2
                    : area == 3
                        ? foreheadRightMarginFor3
                        : -10),
        // left:
        //     MediaQuery.of(context).size.width * (offset.dx - widthFactor / 2) -
        //         margin +
        //         (area == 4
        //                     ? foreheadLeftMargin4
        //                     :100 ),
        // Apply extra left margin for case 1
        top: MediaQuery.of(context).size.height *
                (offset.dy - heightFactor / 2) -
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
        // Apply extra top margin for case 1
        child: GestureDetector(
          onTap: () {
            logic.toggleAreaSelection(area);
          },
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: isSelected ? 1.0 : 0.0, // Show image only when selected
            child: Container(
                width: MediaQuery.of(context).size.width * widthFactor +
                    (margin * 0.5),
                height: MediaQuery.of(context).size.height * heightFactor +
                    (margin * 0.5),
                child: Container(
                  // color: AppColors.appPrimaryColor,
                  width: 40,
                  height: 40,
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
          ),
        ));
  }

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
    return
   Obx(()=>   InkWell(
     onTap: () {
       print(logic.selectedAreasList.length);
       print(selectedDays.length);
       print(selectedTime);
       print(title);
       print(id);
       logic.deviceSchedule(selectedTime,id,title,selectedDays);
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
         child:  Center(
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
             ))
     ),
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
