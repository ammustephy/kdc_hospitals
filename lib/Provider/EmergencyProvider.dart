import 'package:flutter/material.dart';

class EmergencyContact {
  final String title;
  final String number;

  EmergencyContact({required this.title, required this.number});
}

class EmergencyProvider extends ChangeNotifier {
  final List<EmergencyContact> contacts = [
    EmergencyContact(title: "Emergency Department", number: "108"),
    EmergencyContact(title: "Reception", number: "0124-567890"),
    EmergencyContact(title: "Emergency Ambulance", number: "102"),
  ];

// If you want to allow updates/additions, add methods here
}
