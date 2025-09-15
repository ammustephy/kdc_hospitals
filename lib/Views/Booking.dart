import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Provider/Booking_Provider.dart';
import 'OfflineAppointment.dart';
import 'OnlineAppointment.dart';


class BookingPage extends StatefulWidget {
  final int selectedIndex;
  const BookingPage({Key? key, required this.selectedIndex})
      : super(key: key);
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime _focusedDay = DateTime.now();
  final slots = ['9am-10am', '10am-11am', '11am-12pm', '1pm-2pm', '2pm-3pm', '3pm-4pm'];
  final departments = ['Cardiology','Dermatology','Pediatrics','Orthopedics','Neurology'];

  final categories = [
    'Advance Appointments',
    'My Appointments',
    'Active Medication',
    'Medical Reports',
    'Lab Reports',
    'Radiology Reports',
    'Prescriptions',
    'Bill View',
    'Discharge Summary',
  ];
  // int _selectedCategoryIndex = -1;

  // void _onCategoryTap(int idx) {
  //   setState(() => _selectedCategoryIndex = idx);
  //   Navigator.push(context, MaterialPageRoute(builder: (_) {
  //     switch (idx) {
  //       case 0: return  BookingPage(selectedIndex: 0,);
  //       case 1: return  AppointmentPage(selectedIndex: 1,);
  //       case 2: return  MedicationsPage(selectedIndex: 2,);
  //       case 3: return  MedReports(selectedIndex: 3,);
  //       case 4: return  LabReports(selectedIndex: 4,);
  //       case 5: return  RadiologyPage(selectedIndex: 5,);
  //       case 6: return  Prescriptions(selectedIndex: 6,);
  //       case 7: return  BillDetails(selectedIndex: 7,);
  //       case 8: return  DischargeDetails(selectedIndex: 8,);
  //       default: return  BookingPage(selectedIndex: 0,);
  //     }
  //   }
  //   )
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, booking, _) => Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.blue.shade200,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Book Appointment',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Date',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 30)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (d) => booking.selectedDate != null && isSameDay(d, booking.selectedDate!),
                onDaySelected: (sel, focus) {
                  booking.setDate(sel);
                  setState(() => _focusedDay = focus);
                },
                onPageChanged: (focus) => setState(() => _focusedDay = focus),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
                  selectedDecoration: BoxDecoration(color: Colors.black87, shape: BoxShape.circle),
                  selectedTextStyle: const TextStyle(color: Colors.white),
                ),
                headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Department',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              DropdownButton<String>(
                hint: const Text('Choose Department'),
                value: booking.selectedDepartment,
                isExpanded: true,
                items: departments.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (val) {
                  if (val != null) booking.setDepartment(val);
                },
              ),
              // const SizedBox(height: 8),
              // Text(
              //   'Dept: ${booking.selectedDepartment ?? '-'}',
              //   style: TextStyle(color: Colors.grey[600]),
              // ),
              const SizedBox(height: 20),
              const Text(
                'Select Hour',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              DropdownButton<String>(
                hint: const Text('Choose Time Slot'),
                value: booking.selectedSlot,
                isExpanded: true,
                items: slots.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) {
                  if (val != null) booking.setSlot(val);
                },
              ),
              // const SizedBox(height: 8),
              // Text(
              //   'Slot: ${booking.selectedSlot ?? '-'}',
              //   style: TextStyle(color: Colors.grey[600]),
              // ),
              const SizedBox(height: 20),
              if (booking.selectedDate != null &&
                  booking.selectedDepartment != null &&
                  booking.selectedSlot != null)
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        booking.setMode(AppointmentMode.online);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (_) => OnlineAppointmentPage()),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: booking.mode == AppointmentMode.online
                            ? Colors.blue
                            : Colors.grey[300],
                      ),
                      child: const Text('Online'),
                    ),

                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        booking.setMode(AppointmentMode.offline);
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>OfflineAppointmentPage()),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        booking.mode == AppointmentMode.offline
                            ? Colors.blue
                            : Colors.grey[300],
                      ),
                      child: const Text('Offline'),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    try {
                      final confirmed = booking.confirmBooking();
                      if (confirmed != null) {
                        final page = (confirmed.mode == AppointmentMode.online)
                            ? const OnlineAppointmentPage()
                            : const OfflineAppointmentPage();

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Confirm Booking'),
                            content: const Text('Proceed to appointment?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  booking.resetSelections();
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => page));
                                },
                                child: const Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                },
                                child: const Text('No'),
                              ),
                            ],
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Confirm Booking', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}