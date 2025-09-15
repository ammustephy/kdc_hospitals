import 'package:flutter/material.dart';

class MedicationsPage extends StatefulWidget {
  final int selectedIndex;
  const MedicationsPage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<MedicationsPage> createState() => _MedicationsPageState();
}

class _MedicationsPageState extends State<MedicationsPage> {
  // Example static medication details; replace with dynamic data later
  final List<Map<String, String>> _activeMeds = [
    {
      'name': 'Atorvastatin',
      'dosage': '20 mg',
      'schedule': 'Once daily (Evening)',
      'nextDose': 'Today, 8 PM',
    },
    {
      'name': 'Metformin',
      'dosage': '500 mg',
      'schedule': 'Twice daily',
      'nextDose': 'Tomorrow, 8 AM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Medications'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        foregroundColor: Colors.black,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _activeMeds.length,
        itemBuilder: (context, index) {
          final med = _activeMeds[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(med['name']!,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('Dosage: ${med['dosage']}'),
                    const SizedBox(height: 4),
                    Text('Schedule: ${med['schedule']}'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Next Dose: ${med['nextDose']}',
                            style: const TextStyle(fontStyle: FontStyle.italic)),
                        ElevatedButton.icon(
                          onPressed: () {
                            // mark as taken
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('Taken',style: TextStyle(color: Colors.white),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
