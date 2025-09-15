
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Provider/Booking_Provider.dart';
import 'Appointments.dart';

class ReAppointmentPage extends StatefulWidget {
  const ReAppointmentPage({super.key});
  @override
  _ReAppointmentPageState createState() => _ReAppointmentPageState();
}

class _ReAppointmentPageState extends State<ReAppointmentPage> {
  DateTime _focusedDay = DateTime.now();
  final slots = [
    '9am-10am',
    '10am-11am',
    '11am-12pm',
    '1pm-2pm',
    '2pm-3pm',
    '3pm-4pm'
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, booking, _) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Reschedule Appointment',
              style: TextStyle(color: Colors.black)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Date Selector
            const Text('Select Date',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 30)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(day, booking.selectedDate),
              onDaySelected: (sel, focus) {
                booking.setDate(sel);
                setState(() => _focusedDay = focus);
              },
              onPageChanged: (focus) => setState(() => _focusedDay = focus),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                    color: Colors.grey[300], shape: BoxShape.circle),
                selectedDecoration: const BoxDecoration(
                    color: Colors.black87, shape: BoxShape.circle),
                selectedTextStyle: const TextStyle(color: Colors.white),
              ),
              headerStyle:
              const HeaderStyle(formatButtonVisible: false, titleCentered: true),
            ),

            const SizedBox(height: 20),

            // Time Slot Selector
            const Text('Select Hour',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            DropdownButton<String>(
              hint: const Text('Choose Time Slot'),
              value: booking.selectedSlot,
              isExpanded: true,
              items: slots
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (String? val) {
                if (val != null) booking.setSlot(val);
              },
            ),

            SizedBox(height: 70,),

            // Confirm Button
            ElevatedButton(
              onPressed: () {
                try {
                  booking.confirmBooking();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking confirmed!')));
                  Navigator.push(context, MaterialPageRoute(builder: (_) =>  AppointmentPage(selectedIndex: 1,)));
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text('Confirm', style: TextStyle(color: Colors.white, fontSize: 16)),
            )
          ]),
        ),
      ),
    );
  }
}
