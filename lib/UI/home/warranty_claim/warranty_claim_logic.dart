import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../constant/AppLinks.dart';
import '../bottom_bar_host/bottom_bar_host_view.dart';

class WarrantyClaimController extends GetxController {
  RxString selectedProduct = ''.obs;
  RxBool isLoading = false.obs;
  RxBool yesOption = false.obs;
  RxString selectedCountry = 'United Kingdom'.obs;
  final fastNameController = TextEditingController(),
      nameController = TextEditingController(),
      lastNameController = TextEditingController(),
      emailController = TextEditingController(),
      addressController = TextEditingController(),
      adviceController = TextEditingController(),
      phoneController = TextEditingController(),
      messageController = TextEditingController(),
      receiptNumberController = TextEditingController(),
      issueFoundController = TextEditingController(),
      placeOfPurchaseController = TextEditingController();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  final warrantyClaims = GlobalKey<FormState>();
  DateTime? dateOfBirth;
  DateTime? dateOfPurchase;
  final dobController = TextEditingController();
  final doPController = TextEditingController();
  var selectedCountryCode = ''.obs; // Default country code
  bool isPhoneValid = true; // Track phone validation state
  String fullPhoneNumber = '';
  var selectedImage = ''.obs; // To hold the path of the selected image
  var base64Image = ''.obs; // To hold the Base64 representation of the image
  final ScrollController scrollController = ScrollController();
  final List<String> itemNames = [
    'AIR FLOSS',
    'CAVISHAPER',
    'CYROFACE',
    'CELLUSHAPER',
    'CLEO GOLD MASK',
    'CLEANLIFT',
    'CAPSULATE CHAIR',
    'CLEAN PRO5',
    'COOL GLOBE',
    'DERMISONIC',
    'DERMISONIC II',
    'DERMINECK',
    'DERMIEYE',
    'DERMIEYE PLUS',
    'DERMILIGHT',
    'DERMISYSTEM',
    'DERMILIPS',
    'DERMIPORES',
    'DERMISTEAM',
    'DERMIBRASION',
    'EYEPOD',
    'FACECARE +',
    'FLEXILED',
    'GLAMBRUSH',
    'GLOW MASK',
    'GLOW MASK PRO',
    'HANDYLIGHT',
    'HANDYSPA',
    'IBROW',
    'LIGHT MASK',
    'LUX BRUSH',
    'LUMICAP',
    'LUMIQUARTZ FACE WAND',
    'MICROLIFT',
    'NECOLLAGE',
    'OPATRA LIGHT MACHINE (COMPACT)',
    'OPATRA LIGHT PRO MACHINE',
    'OPULENCE BRUSH',
    'PURE BRUSH',
    'PURE DUO',
    'PULSE',
    'PULSE NECK',
    'PROSHAPER',
    'PURIFY BRUSH',
    'ROBOLIGHT',
    'SYNERGY FACE',
    'SYNERGY NECK',
    'SYNERGY EYE',
    'SYNERGY COLLECTION SUITCASE',
    'SMILE TEETH WHITENING',
    'SYNERGY MARBLE',
    'SYNERGY MARBLE EYE',
    'SYNERGY MARBLE ROSE QUARTZ',
    'THERAPAD',
    ' VITA+',
  ];

  void updateProduct(selectedItem) {
    selectedProduct.value = selectedItem;
    update();
  }

  // Scroll to the first error field
  void _scrollToFirstError() {
    final firstErrorPosition =
        warrantyClaims.currentContext!.findRenderObject()!.paintBounds.topLeft;
    scrollController.animateTo(
      firstErrorPosition.dy,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void showImageSourceDialog(WarrantyClaimController logic) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text('Select Image Source'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              GestureDetector(
                onTap: () {
                  logic.pickImage(
                      image_picker.ImageSource.camera); // Use alias here
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Camera'),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  logic.pickImage(
                      image_picker.ImageSource.gallery); // Use alias here
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Gallery'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to pick an image from the camera or gallery
  Future<void> pickImage(image_picker.ImageSource source) async {
    final picker = image_picker.ImagePicker();
    try {
      final pickedImage = await picker.pickImage(source: source);
      if (pickedImage != null) {
        selectedImage.value = pickedImage.path; // Store the path of the image
        base64Image.value = await convertImageToBase64(
            File(selectedImage.value)); // Convert to Base64
        print('Image picked: ${pickedImage.path}'); // Debug print
        print(
            'Base64 image: ${base64Image.value.substring(0, 30)}...'); // Print part of the Base64 for debugging
      } else {
        print('No image selected.'); // Debug print
      }
    } catch (e) {
      print('Error picking image: $e'); // Error handling
    }
  }

  Future<String> convertImageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes); // Return the Base64 string
  }

  void setSelectedCountry(String country) {
    selectedCountry.value = country;
  }

  Future<void> onBirthdayTap() async {
    print("Opening date picker for Date of Birth...");

    DateTime currentDate = DateTime.now();
    DateTime initialDate =
        DateTime(currentDate.year - 18, currentDate.month, currentDate.day);
    DateTime firstDate = DateTime(currentDate.year - 100);
    DateTime lastDate = initialDate;

    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      dateOfBirth = pickedDate;
      dobController.clear();
      dobController.text = DateFormat('dd/MM/yyyy').format(dateOfBirth!);
      print("Selected Date of Birth: $pickedDate");
      update();
    } else {
      print("Date of Birth is not selected");
    }
  }

  Future<void> onPurchaseTap() async {
    print("Opening date picker for Date of Purchase...");

    DateTime currentDate = DateTime.now();
    DateTime initialDate = currentDate;
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = currentDate;

    print("Current Date: $currentDate");
    print("Initial Date: $initialDate");
    print("First Date: $firstDate");
    print("Last Date: $lastDate");

    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      dateOfPurchase = pickedDate;
      doPController.clear();
      doPController.text = DateFormat('dd/MM/yyyy').format(dateOfPurchase!);
      print("Selected Date of Purchase: $pickedDate");
      update();
    } else {
      print("Date of Purchase is not selected");
    }
  }

  Future<void> sendData() async {
    // Validate the form using formKey
    final isValid = warrantyClaims.currentState!.validate();

    // If the form is not valid, show validation errors and stop further execution
    if (!isValid) {
      autoValidateMode =
          AutovalidateMode.onUserInteraction; // Enable auto validation
      _scrollToFirstError();

      update(); // Call update() to refresh the UI
      return; // Stop execution here since the form is invalid
    }

    // Show loading spinner
    isLoading.value = true;
    final url = Uri.parse(ApiUrls.warrantyClaims);

    String formattedDob = convertDateToCorrectFormat(dobController.text);
    String formattedDoP = convertDateToCorrectFormat(doPController.text);

    // Data to be sent in the POST request
    final Map<String, dynamic> data = {
      "product_name": "Product 1",
      // Add this field
      "first_name": "${nameController.text}",
      // First name from controller
      "last_name": "${lastNameController.text}",
      // Last name from controller
      "email": "junaid459561@gmail.com",
      // Email
      "address": "${addressController.text}",
      // Address from controller
      "phone": "${fullPhoneNumber}",
      // Phone number
      "dob": "${formattedDob}",
      // Date of birth
      "place_of_purchase": "${placeOfPurchaseController.text}",
      // Place of purchase
      "date_of_purchase": "${formattedDoP}",
      // Date of purchase
      "recipient_number": "${receiptNumberController.text}",
      // Receipt number
      "advisor_name": adviceController.text,
      // Advisor name (set based on your logic)
      "notification": yesOption.value == true ? true : false,
      // Notification preference
      "country_id": 1,
      // Country ID
      "issue_found": 'bfchjbfchf',
      // Issue found
      "image": "${base64Image.value}",
      // Base64 image as a string
    };

    print('data===${data}');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Get the token from shared prefs
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json", // Ensure the content type is JSON
          "Authorization": "Bearer $token", // Add Bearer token to the headers
        },
        body: jsonEncode(data), // Convert the data to a JSON string
      );

      // Check if the POST request was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Data sent successfully!');
        Get.snackbar(
          'Success',
          'Request Submitted Successfully',
          backgroundColor: Color(0xFFB7A06A),
        );
        Get.offAll(BottomBarHostView());
        isLoading.value = false;
      } else {
        isLoading.value = false;
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      isLoading.value = false;
      print('Error sending data: $e');
    }
  }

  String convertDateToCorrectFormat(String date) {
    List<String> dateParts = date.split('/'); // Split the date by '/'

    if (dateParts.length == 3) {
      // Re-arrange the date parts: [2] for year, [1] for month, [0] for day
      return '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}'; // Returns YYYY-MM-DD format
    } else {
      return date; // Return the original date if format is incorrect
    }
  }
}
