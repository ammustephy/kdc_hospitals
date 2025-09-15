import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:kdc_hospitals/Model/Category.dart';
import 'package:kdc_hospitals/Views/Booking.dart';

import '../Views/Appointments.dart';
import '../Views/Bills.dart';
import '../Views/CheckUps.dart';
import '../Views/Discharge.dart';
import '../Views/EmergencyContact.dart';
import '../Views/Information.dart';
import '../Views/LabReports.dart';
import '../Views/MedDelivery.dart';
import '../Views/Med_Reports.dart';
import '../Views/Medications.dart';
import '../Views/Prescriptions.dart';
import '../Views/Radiology.dart';



class HomeProvider with ChangeNotifier {
  final List<Category> categories = [
    Category(
        id: 'booking',
        name: 'Advance Appointment',
        imageUrl: 'assets/images/Hbooking.png',
        page: BookingPage(selectedIndex: 0,)),
    Category(
        id: 'appointments',
        name: 'My Appointments',
        imageUrl: 'assets/images/HAppointment.png',
        page: AppointmentPage(selectedIndex: 1,)),
    Category(
        id: 'Emergency',
        name: 'Emergency',
        imageUrl: 'assets/images/Emergency.png',
        page: EmergencyContactPage(selectedIndex: 11,)),
    Category(
        id: 'Medication',
        name: 'Active Medication',
        imageUrl: 'assets/images/Hmedicine.png',
        page: MedicationsPage(selectedIndex: 2,)),
    Category(
        id: 'medical',
        name: 'Medical Reports',
        imageUrl: 'assets/images/HMedreport.png',
        page: MedReports(selectedIndex: 3,)),
    Category(
        id: 'lab',
        name: 'Lab Reports',
        imageUrl: 'assets/images/Hlab.png',
        page: LabReports(selectedIndex: 4,)),
    Category(
        id: 'Radiology',
        name: 'Radiology Reports',
        imageUrl: 'assets/images/HRadiology.png',
        page: RadiologyPage(selectedIndex: 5,)),
    Category(
        id: 'prescriptions',
        name: 'Prescriptions',
        imageUrl: 'assets/images/Hprescription.png',
        page: Prescriptions(selectedIndex: 6,)),
    Category(
        id: 'Bills',
        name: 'Bill View',
        imageUrl: 'assets/images/Hbill.png',
        page: BillDetails(selectedIndex: 7,)),
    Category(
        id: 'Discharge',
        name: 'Discharge Summary',
        imageUrl: 'assets/images/HDischarge.png',
        page: DischargeDetails(selectedIndex: 8,)),
    Category(
        id: 'HomeDelivery',
        name: 'Home Delivery',
        imageUrl: 'assets/images/delivery.png',
        page: MedicineSearchPage(selectedIndex: 9,)),
    Category(
        id: 'Info',
        name: 'Facilities & Info',
        imageUrl: 'assets/images/info.png',
        page: InformationPage(selectedIndex: 10,)),
    Category(
        id: 'CheckUps',
        name: 'Checkups/Packages',
        imageUrl: 'assets/images/medical-checkup.png',
        page: ChecckupPage(selectedIndex: 10,)),
  ];

  String _search = '';
  String get search => _search;
  set search(String val) {
    _search = val;
    notifyListeners();
  }

}

