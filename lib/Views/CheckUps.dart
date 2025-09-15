
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/InfoProvider.dart';





class ChecckupPage extends StatefulWidget {
  final int selectedIndex;
  const ChecckupPage({Key? key, required this.selectedIndex}) : super(key: key);
  @override
  State<ChecckupPage> createState() => _ChecckupPagePageState();
}

class _ChecckupPagePageState extends State<ChecckupPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PackageProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Check-up Packages")),
      body: ListView.builder(
        itemCount: provider.packages.length,
        itemBuilder: (context, index) {
          final pkg = provider.packages[index];
          return ListTile(
            title: Text(pkg.name),
            subtitle: Text(pkg.description),
            onTap: () {
              provider.selectPackage(pkg);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PackageDetailPage()),
              );
            },
          );
        },
      ),
    );
  }
}



class PackageDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PackageProvider>(context);
    final pkg = provider.selectedPackage!;

    return Scaffold(
      appBar: AppBar(title: Text(pkg.name)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pkg.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            // If doctors are part of the package:
            if (pkg.doctors.isNotEmpty) ...[
              Text("Available Doctors", style: TextStyle(fontSize: 18)),
              Expanded(
                child: ListView.builder(
                  itemCount: pkg.doctors.length,
                  itemBuilder: (context, i) {
                    final doc = pkg.doctors[i];
                    return Card(
                      child: ListTile(
                        title: Text(doc.name),
                        subtitle: Text('${doc.specialty}\n${doc.profile}'),
                        isThreeLine: true,
                        trailing: ElevatedButton(
                          onPressed: () {
                            provider.selectDoctor(doc);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => BookAppointmentPage()),
                            );
                          },
                          child: Text("Book"),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => BookAppointmentPage()),
                  );
                },
                child: Text("Book Package"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


class BookAppointmentPage extends StatefulWidget {
  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PackageProvider>(context);
    final pkg = provider.selectedPackage!;
    final doc = provider.selectedDoctor;

    return Scaffold(
      appBar: AppBar(title: Text("Book Appointment")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Booking: ${pkg.name}${doc != null ? " with ${doc.name}" : ""}',
                  style: TextStyle(fontSize: 20)),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: "Preferred Date"),
                validator: (value) => (value == null || value.isEmpty) ? "Enter date" : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text("Confirm Booking"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Booking Confirmed!")));
                    Navigator.popUntil(context, ModalRoute.withName('/'));
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
