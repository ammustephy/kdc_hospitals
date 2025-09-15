// lib/Views/NotificationsPage.dart
import 'package:flutter/material.dart';

import 'Home.dart';
import 'Profile.dart';
import 'Settings.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _idx = 1; // Notifications tab

  // Dummy notifications list
  final List<Map<String, dynamic>> _notifications = [
    {
      'time': '07:00 AM',
      'title': 'Take Amoxicillin',
      'description': '500 mg – 1 pill',
      'type': 'medication'
    },
    {
      'time': '09:00 AM',
      'title': 'Measure BP',
      'description': 'Record your blood pressure',
      'type': 'health'
    },
    {
      'time': '12:00 PM',
      'title': 'Take Metformin',
      'description': '500 mg – 1 pill',
      'type': 'medication'
    },
    {
      'time': '03:00 PM',
      'title': 'Blood Test Tomorrow',
      'description': 'Fasting glucose test at 08:00 AM',
      'type': 'lab'
    },
    {
      'time': '08:00 PM',
      'title': 'Doctor Appointment',
      'description': 'Telemedicine with Dr. Smith at 08:30 PM',
      'type': 'appointment'
    },
  ];

  void _onNav(int i) {
    if (i == _idx) return;
    Widget next;
    switch (i) {
      case 0:
        next = const HomePage();
        break;
      case 2:
        next = const SettingsPage();
        break;
      case 3:
        next =  ProfilePage();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => next));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notifications', style: TextStyle(color: Colors.black)),
      ),
      body: _notifications.isEmpty
          ? const Center(child: Text('No new notifications!'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (ctx, i) {
          final note = _notifications[i];
          Icon leadingIcon;
          switch (note['type']) {
            case 'medication':
              leadingIcon = const Icon(Icons.medical_services, color: Colors.red);
              break;
            case 'lab':
              leadingIcon = const Icon(Icons.science, color: Colors.blue);
              break;
            case 'appointment':
              leadingIcon = const Icon(Icons.schedule, color: Colors.green);
              break;
            default:
              leadingIcon = const Icon(Icons.info_outline);
          }
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            elevation: 1,
            child: ListTile(
              leading: leadingIcon,  // your icon widget goes here
              title: Text(note['title']),
              subtitle: Text(note['description']),
              trailing: IconButton(
                icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                onPressed: () {
                  setState(() {
                    _notifications.removeAt(i);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Marked "${note['title']}" done')),
                  );
                },
              ),
            ),
          );
        },
      ),
      extendBody: true,
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
