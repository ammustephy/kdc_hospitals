import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileProvider with ChangeNotifier {
  String _name = '';
  String _mobile = '';
  String _email = '';
  String _dob = '';
  String _gender = '';
  File? _profileImage;

  // Getters
  String get name => _name;
  String get mobile => _mobile;
  String get email => _email;
  String get dob => _dob;
  String get gender => _gender;
  File? get profileImage => _profileImage;

  // Setters
  void updateName(String val) {
    _name = val;
    notifyListeners();
  }

  void updateMobile(String val) {
    _mobile = val;
    notifyListeners();
  }

  void updateEmail(String val) {
    _email = val;
    notifyListeners();
  }

  void updateDob(String val) {
    _dob = val;
    notifyListeners();
  }

  void updateGender(String val) {
    _gender = val;
    notifyListeners();
  }

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _profileImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  void saveProfile() {
    // Save logic here (Firebase or DB)
    debugPrint("=== Profile Saved ===");
    debugPrint("Name: $_name");
    debugPrint("Mobile Number: $_mobile");
    debugPrint("Email: $_email");
    debugPrint("DOB: $_dob");
    debugPrint("Gender: $_gender");
    debugPrint("Image Path: ${_profileImage?.path}");
  }
}
