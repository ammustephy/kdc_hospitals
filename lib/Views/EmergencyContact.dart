
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Provider/EmergencyProvider.dart';

class EmergencyContactPage extends StatefulWidget {
  final int selectedIndex;
  const EmergencyContactPage({Key? key, required this.selectedIndex}) : super(key: key);
  @override
  State<EmergencyContactPage> createState() => _EmergencyContactPageState();
}

class _EmergencyContactPageState extends State<EmergencyContactPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmergencyProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Emergency Contacts")),
      body: ListView.builder(
        itemCount: provider.contacts.length,
        itemBuilder: (context, index) {
          final contact = provider.contacts[index];
          return Card(
            child: ListTile(
              title: Text(contact.title),
              subtitle: Text(contact.number),
              trailing: IconButton(
                icon: Icon(Icons.call, color: Colors.green),
                onPressed: () async {
                  final telUrl = "tel:${contact.number}";
                  if (await canLaunch(telUrl)) {
                    await launch(telUrl);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not launch phone call')),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
