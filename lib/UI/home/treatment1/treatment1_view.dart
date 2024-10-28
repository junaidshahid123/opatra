import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/home/treatment1/treatment1_logic.dart';

class Treatment1View extends StatelessWidget {
  const Treatment1View({super.key});

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
                      // _handleTap(details, logic);
                    },
                    child: Stack(
                      children: [
                        _buildHighlightArea(
                            context, logic, 'Forehead', Offset(0.5, 0.2)),
                        _buildHighlightArea(
                            context, logic, 'Cheeks', Offset(0.4, 0.4)),
                        _buildHighlightArea(
                            context, logic, 'Nose', Offset(0.5, 0.5)),
                        _buildHighlightArea(
                            context, logic, 'Chin', Offset(0.5, 0.7)),
                        _buildHighlightArea(
                            context, logic, 'Jawline', Offset(0.6, 0.8)),
                      ],
                    ),
                  ),
                ),
                // Bottom container with treatment options
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
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
                        // buildTreatmentList(logic),
                        TreatmentListWidget(
                          logic: logic,
                        ),
                        _buildContinueButton(context),
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

// Method to build each highlight area with opacity based on selection
  Widget _buildHighlightArea(BuildContext context, Treatment1Controller logic,
      String area, Offset offset)
  {
    // Get the selected state directly without Obx
    final isSelected = logic.isAreaSelected(area);

    return Positioned(
      left: MediaQuery.of(context).size.width * offset.dx,
      top: MediaQuery.of(context).size.height * offset.dy,
      child: GestureDetector(
        onTap: () {
          // Toggle the selection state
          logic.toggleAreaSelection(area);
          // Call setState in the parent widget to rebuild
        },
        child: Opacity(
          opacity: isSelected ? 0.5 : 0.0, // Dim highlight if selected
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.yellowAccent.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  // Function to handle tap locations on the face
  void _handleTap(TapUpDetails details, Treatment1Controller logic) {
    // Here, logic could be used to determine tap area based on `details.localPosition`
    // and invoke `logic.toggleAreaSelection` accordingly.
  }

  // Treatment area selection text
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

  Widget buildTreatmentList(Treatment1Controller logic) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: logic.selectedAreas.keys.length,
            // Set based on area count
            itemBuilder: (context, index) {
              // Get the area name for each index
              String area = logic.selectedAreas.keys.elementAt(index);

              return Obx(
                () {
                  // Get the selected state reactively
                  final bool isSelected = logic.isAreaSelected(area);
                  return InkWell(
                    onTap: () {
                      // Toggle selection and call additional functionality
                      logic.toggleAreaSelection(area);
                      // logic.performAdditionalFunction(area);  // Replace with actual function
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: 60, // Adjust size if needed
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Color(0xFFB7A06A) : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : Color(0xFFC9CBCF),
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          area,
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
              );
            },
          ),
        ],
      ),
    );
  }

  // Back button
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

  // Continue button
  Widget _buildContinueButton(BuildContext context) {
    return InkWell(
      onTap: () {
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
          child: Text(
            'Continue',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
class TreatmentListWidget extends StatefulWidget {
  final Treatment1Controller logic;

  const TreatmentListWidget({Key? key, required this.logic}) : super(key: key);

  @override
  _TreatmentListWidgetState createState() => _TreatmentListWidgetState();
}

class _TreatmentListWidgetState extends State<TreatmentListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.logic.selectedAreas.keys.length,
              itemBuilder: (context, index) {
                String area = widget.logic.selectedAreas.keys.elementAt(index);
                final bool isSelected = widget.logic.isAreaSelected(area);

                return InkWell(
                  onTap: () {
                    setState(() {
                      widget.logic.toggleAreaSelection(area);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: 60,
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFFB7A06A) : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? Colors.transparent : Color(0xFFC9CBCF),
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        area,
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
        ],
      ),
    );
  }
}

