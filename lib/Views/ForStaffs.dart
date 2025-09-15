
import 'package:flutter/material.dart';
import 'package:kdc_hospitals/Views/Home.dart';
import 'package:provider/provider.dart';

import '../Model/Category.dart';
import 'Appointments.dart';
import 'Bills.dart';
import 'Booking.dart';
import 'CheckUps.dart';
import 'Discharge.dart';
import 'EmergencyContact.dart';
import 'Information.dart';
import 'LabReports.dart';
import 'MedDelivery.dart';
import 'Med_Reports.dart';
import 'Medications.dart';
import 'Prescriptions.dart';
import 'Radiology.dart';

class StaffHomeProvider with ChangeNotifier {
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




class StaffHomePage extends StatefulWidget {
  const StaffHomePage({super.key});
  @override
  State<StaffHomePage> createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
  int _idx = 0, _catIdx = -1;

  void _onNav(int i) {
    setState(() => _idx = i);
    switch (i) {
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (_) =>  StaffNotificationsPage()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (_) => StaffSettingsPage()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (_) => StaffProfilePage()));
        break;
      default:
    }
  }


  void _switchAccount() => showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Switch Account'),
      content: const Text('Do you want to add another account?'),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context), // close dialog
        ),
        TextButton(
          child: const Text('Add Account'),
          onPressed: () {
            Navigator.pop(context);
            // Navigate to your Add Account page / form here
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddAccountPage(), // <-- your custom page
              ),
            );
          },
        ),
      ],
    ),
  );
  void _onCat(int i, Widget? page) {
    setState(() => _catIdx = i);
    if (page != null) Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    // Assume you have a StaffHomeProvider similar to HomeProvider for categories.
    final staffProv = context.watch<StaffHomeProvider>();
    return Scaffold(
      // AppBar with gradient etc as in your patient home page
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: Colors.transparent, // important for gradient to show
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade900,
                Colors.blue.shade500,
              ],
            ),
          ),
        ),
        title: Column(
          children: [
            SizedBox(height: 10,),
            Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/KDCH-logo.jpg', height: 25),
                      const SizedBox(width: 8),
                      const Text('KDCH',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white)),
                    ]),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (v) => staffProv.search = v,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.switch_account, size: 28, color: Colors.black),
                  tooltip: 'Switch Account',
                  onPressed: _switchAccount,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            // Announcement/Staff news
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  child: ListTile(
                    title: Text("Today's Hospital Announcements"),
                    subtitle: Text("Staff meeting at 3pm, flu vaccine stock updated, ..."),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 25)),
            // Staff Categories (grid)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 140,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                      (_, i) {
                    final cat = staffProv.categories[i];
                    final selected = i == _catIdx;
                    return GestureDetector(
                      onTap: () => _onCat(i, cat.page),
                      child: Card(
                        elevation: selected ? 8 : 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: selected ? Colors.blue : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(cat.imageUrl,
                                  width: 50, height: 50, fit: BoxFit.cover),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              cat.name,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(fontWeight: selected ? FontWeight.bold : null),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: staffProv.categories.length,
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: PhysicalShape(
          elevation: 10,
          color: Colors.white,
          shadowColor: Colors.black38,
          clipper: const ShapeBorderClipper(shape: StadiumBorder()),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const ShapeDecoration(shape: StadiumBorder(), color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (i) {
                const icons = [
                  Icons.home_filled,
                  Icons.notifications_active,
                  Icons.settings,
                  Icons.person_outline,
                ];
                final active = _idx == i;
                return IconButton(
                  icon: Icon(icons[i], color: active ? Colors.black : Colors.grey),
                  onPressed: () => _onNav(i),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}



// class StaffAppointmentsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Today's Appointments")),
//       body: Center(child: Text("List of all appointments scheduled for today. Here staff can mark arrivals, reject, or view details.")),
//     );
//   }
// }
//
//
//
// class PatientCheckupPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Patient Checkups")),
//       body: Center(child: Text("Enter/check patient vitals, diagnosis, and remarks. Add checkup records here.")),
//     );
//   }
// }
//
//
//
// class StaffReportsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Medical Reports")),
//       body: Center(child: Text("View and manage patient medical reports. Add/edit/delete reports as needed.")),
//     );
//   }
// }
//
//
//
// class StaffLabPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Lab Reports")),
//       body: Center(child: Text("Access and manage lab results, upload new lab reports, mark as reviewed.")),
//     );
//   }
// }
//
//
//
// class StaffDischargePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Discharge Summary")),
//       body: Center(child: Text("Fill and view discharge summaries for patients leaving the hospital.")),
//     );
//   }
// }
//
//
//
// class StaffInformationPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Facilities & Info")),
//       body: Center(child: Text("Hospital/clinic info, staff resources, protocols, notices.")),
//     );
//   }
// }
//
//
//
// class StaffEmergencyContactPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Emergency Duty")),
//       body: Center(child: Text("View and manage emergency duty schedules and emergency contact information.")),
//     );
//   }
// }
//
//
//
class StaffNotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: Center(child: Text("All staff notifications and hospital announcements will appear here.")),
    );
  }
}
//
//
//
class StaffSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Center(child: Text("Staff app settings: password change, notification preferences, etc.")),
    );
  }
}
//
//
//
class StaffProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Center(child: Text("Staff profile details, contact info, shift timings, edit options.")),
    );
  }
}
//
//
// class StaffBillingPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // List bills for selected patient, with controls to add discount
//     return Scaffold(
//       appBar: AppBar(title: Text('Billing & Discounts')),
//       body: Center(child: Text('This is where staff can apply discounts to patient bills.')),
//     );
//   }
// }
