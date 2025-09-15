import 'package:flutter/material.dart';

class Department {
  final String name;
  final String description;
  final List<Doctor> doctors;

  Department({required this.name, required this.description, required this.doctors});
}

class Doctor {
  final String name;
  final String specialty;
  final String profile;

  Doctor({required this.name, required this.specialty, required this.profile});
}

class InfoProvider extends ChangeNotifier {
  final List<Department> departments = [
    Department(
      name: "Cardiology",
      description: "Heart and vascular care.",
      doctors: [
        Doctor(name: "Dr. Smith", specialty: "Cardiologist", profile: "20 years experience."),
        Doctor(name: "Dr. Lee", specialty: "Cardiologist", profile: "Expert in stents."),
      ],
    ),
    Department(
      name: "Neurology",
      description: "Brain and nervous system.",
      doctors: [
        Doctor(name: "Dr. John Doe", specialty: "Neurologist", profile: "Stroke specialist."),
      ],
    ),
    // Add more departments...
  ];


  Department? selectedDepartment;
  Doctor? selectedDoctor;

  selectDepartment(Department dept) {
    selectedDepartment = dept;
    notifyListeners();
  }

  selectDoctor(Doctor doctor) {
    selectedDoctor = doctor;
    notifyListeners();
  }
}

class Package {
  final String name;
  final String description;
  final List<Doctor> doctors; // or optional booking-related info
  Package({required this.name, required this.description, this.doctors = const []});
}

// class PackageProvider extends ChangeNotifier {
//   List<Package> packages = [/* populate list */];
//   Package? selectedPackage;
//   Doctor? selectedDoctor;
//
//   void selectPackage(Package pkg) {
//     selectedPackage = pkg;
//     notifyListeners();
//   }
//
//   void selectDoctor(Doctor doc) {
//     selectedDoctor = doc;
//     notifyListeners();
//   }
// }

class PackageProvider extends ChangeNotifier {
  List<Package> packages = [
    Package(
      name: 'Basic Health Checkup',
      description: 'Includes CBC, blood sugar, cholesterol tests.',
      doctors: [
        Doctor(
          name: 'Dr. Anjali Menon',
          specialty: 'General Physician',
          profile: '10 years experience in preventive health.',
        ),
        Doctor(
          name: 'Dr. Rohan Gupta',
          specialty: 'Pathologist',
          profile: 'Expert in diagnostic labs.',
        ),
      ],
    ),
    Package(
      name: 'Advanced Cardiac Package',
      description: 'Includes ECG, ECHO, stress test, lipid profile.',
      doctors: [
        Doctor(
          name: 'Dr. Meera Nair',
          specialty: 'Cardiologist',
          profile: 'Specializes in non-invasive cardiology.',
        ),
      ],
    ),
  ];

  Package? selectedPackage;
  Doctor? selectedDoctor;

  void selectPackage(Package pkg) {
    selectedPackage = pkg;
    notifyListeners();
  }

  void selectDoctor(Doctor doc) {
    selectedDoctor = doc;
    notifyListeners();
  }
}