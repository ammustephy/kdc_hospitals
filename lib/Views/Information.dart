
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/InfoProvider.dart';
class InformationPage extends StatefulWidget {
  final int selectedIndex;
  const InformationPage({Key? key, required this.selectedIndex}) : super(key: key);
  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InfoProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Hospital Departments")),
      body: ListView.builder(
        itemCount: provider.departments.length,
        itemBuilder: (context, index) {
          final dept = provider.departments[index];
          return ListTile(
            title: Text(dept.name),
            subtitle: Text(dept.description),
            onTap: () {
              provider.selectDepartment(dept);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DepartmentDetailPage()),
              );
            },
          );
        },
      ),
    );
  }
}



class DepartmentDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InfoProvider>(context);
    final dept = provider.selectedDepartment!;
    return Scaffold(
      appBar: AppBar(title: Text(dept.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dept.description, style: TextStyle(fontSize: 16)),
          SizedBox(height: 20),
          Text("Doctors:", style: TextStyle(fontSize: 18)),
          Expanded(
            child: ListView.builder(
              itemCount: dept.doctors.length,
              itemBuilder: (context, index) {
                final doctor = dept.doctors[index];
                return Card(
                  child: ListTile(
                    title: Text(doctor.name),
                    subtitle: Text('${doctor.specialty}\n${doctor.profile}'),
                    isThreeLine: true,
                    trailing: ElevatedButton(
                      child: Text("Book Appointment"),
                      onPressed: () {
                        provider.selectDoctor(doctor);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => BookAppointmentDept()),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



class BookAppointmentDept extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InfoProvider>(context);
    final doctor = provider.selectedDoctor!;
    return Scaffold(
      appBar: AppBar(title: Text("Book Appointment")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Booking with ${doctor.name}', style: TextStyle(fontSize: 20)),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: "Preferred Date"),
                validator: (value) => (value == null || value.isEmpty) ? "Enter date" : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text("Confirm"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Implement booking logic here (e.g., provider.addAppointment(...))
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Appointment Booked!")));
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
