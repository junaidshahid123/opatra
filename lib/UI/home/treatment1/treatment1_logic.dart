import 'package:get/get.dart';

// class Treatment1Controller extends GetxController {
//   final RxList<int> selectedIndices = <int>[].obs;
//   var selectedAreas = {
//     'Forehead': false,
//     'Cheeks': false,
//     'Nose': false,
//     'Chin': false,
//     'Jawline': false,
//   }.obs;
//
//   // Toggle the selection for a specific area
//   void toggleAreaSelection(String area) {
//     if (selectedAreas.containsKey(area)) {
//       selectedAreas[area] = !selectedAreas[area]!;
//       update(); // Update the UI to reflect changes
//     }
//   }
//
//   // Check if an area is selected
//   bool isAreaSelected(String area) {
//     return selectedAreas[area] ?? false;
//   }
// }

class Treatment1Controller extends GetxController {
  RxList<int> selectedIndices = <int>[].obs;
  Map<String, bool> selectedAreas = {
    'Forehead': false,
    'Cheeks': false,
    'Nose': false,
    'Chin': false,
    'Jawline': false,
  };

  void toggleAreaSelection(String area) {
    selectedAreas[area] = !selectedAreas[area]!;
    update(); // Update UI
  }

  bool isAreaSelected(String area) {
    return selectedAreas[area] ?? false;
  }

  void selectAreaByIndex(int index) {
    switch (index) {
      case 0:
        toggleAreaSelection('Forehead');
        break;
      case 1:
        toggleAreaSelection('Cheeks');
        break;
      case 2:
        toggleAreaSelection('Nose');
        break;
      case 3:
        toggleAreaSelection('Chin');
        break;
      case 4:
        toggleAreaSelection('Jawline');
        break;
      default:
        break;
    }
  }
}

