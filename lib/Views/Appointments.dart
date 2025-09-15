
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/Appointment_Provider.dart';
import 'Home.dart';
import 'OfflineAppointment.dart';
import 'OnlineAppointment.dart';
import 'Profile.dart';


class AppointmentPage extends StatefulWidget {
  final int selectedIndex;
  const AppointmentPage({Key? key, required this.selectedIndex})
      : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  int _idx = 2;
  // int _selectedIndex = 2;
  // int _selectedCategoryIndex = 1;

  // final categories = [
  //   'Advance Appointments',
  //   'My Appointments',
  //   'Active Medication',
  //   'Medical Reports',
  //   'Lab Reports',
  //   'Radiology Reports',
  //   'Prescriptions',
  //   'Bill View',
  //   'Discharge Summary',
  // ];

  // void _onCategoryTap(int idx) {
  //   setState(() => _selectedCategoryIndex = idx);
  //   Widget nextPage;
  //   switch (idx) {
  //     case 0: nextPage = BookingPage(selectedIndex: 0);
  //     case 1: nextPage = AppointmentPage(selectedIndex: 1);
  //     case 2: nextPage = MedicationsPage(selectedIndex: 2);
  //     case 3: nextPage = MedReports(selectedIndex: 3);
  //     case 4: nextPage = LabReports(selectedIndex: 4);
  //     case 5: nextPage = RadiologyPage(selectedIndex: 5);
  //     case 6: nextPage = Prescriptions(selectedIndex: 6);
  //     case 7: nextPage = BillDetails(selectedIndex: 7);
  //     case 8: nextPage = DischargeDetails(selectedIndex: 8);
  //     default: nextPage = BookingPage(selectedIndex: 0);
  //   }
  //   Navigator.push(context, MaterialPageRoute(builder: (_) => nextPage));
  //
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (_) => nextPage),
  //   );
  // }

  void _onNav(int i) {
    if (i == _idx) return; // Already on this page

    switch (i) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
        break;
      case 1:
      // Already here, do nothing
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AppointmentPage(selectedIndex: 1)),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) =>  ProfilePage()),
        );
        break;
    }
    setState(() {
      _idx = i;
    });
  }

  Widget _buildModeCard({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) =>
      Card(
        color: isSelected ? Colors.blue.shade100 : Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: isSelected ? Colors.blue : Colors.black),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.blue : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<AppointmentProvider>();

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blue.shade200,
          title: const Text('Appointments')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔘 Category Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              // child: Row(
              //   children: List.generate(categories.length, (i) {
              //     final isSelected = i == _selectedCategoryIndex;
              //     return Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 4),
              //       child: ChoiceChip(
              //         label: Text(categories[i]),
              //         selected: isSelected,
              //         onSelected: (_) => _onCategoryTap(i),
              //         selectedColor: Colors.blue.shade100,
              //         labelStyle: TextStyle(
              //           color: isSelected ? Colors.blue.shade900 : Colors.black,
              //         ),
              //       ),
              //     );
              //   }
              //   ),
              // ),
            ),
            const SizedBox(height: 20),

            // 🃏 Mode Selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        nav.goToOnline();
                        Navigator.push(context, MaterialPageRoute(builder: (_) =>  OnlineAppointmentPage()));
                      },
                      child: _buildModeCard(
                        icon: Icons.video_call,
                        label: 'Online Appointment',
                        isSelected: nav.current == AppointmentTab.online,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        nav.goToOffline();
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const OfflineAppointmentPage()));
                      },
                      child: _buildModeCard(
                        icon: Icons.person_pin_circle,
                        label: 'Offline Appointment',
                        isSelected: nav.current == AppointmentTab.offline,
                      ),
                    ),
                  ),
                ],
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
            decoration: const ShapeDecoration(
              shape: StadiumBorder(),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (i) {
                const icons = [
                  Icons.home_filled,
                  Icons.notifications_active,
                  Icons.calendar_today,
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
