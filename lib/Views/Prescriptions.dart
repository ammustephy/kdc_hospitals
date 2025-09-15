import 'package:flutter/material.dart';

class Prescriptions extends StatefulWidget {
  final int selectedIndex;
  const Prescriptions({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<Prescriptions> createState() => _PrescriptionsState();
}

class _PrescriptionsState extends State<Prescriptions> {
  // Dummy prescription data
  final List<Map<String, String>> _prescriptions = [
    {
      'title': 'Prescription – 2025‑06‑20',
      'doctor': 'Dr. Smith',
      'medication': 'Amoxicillin 500 mg',
      'dosage': 'TID for 7 days',
      'date': '2025‑06‑20',
      'pdfUrl': 'https://example.com/prescriptions/amoxicillin_june2025.pdf',
    },
    {
      'title': 'Prescription – 2025‑05‑15',
      'doctor': 'Dr. Patel',
      'medication': 'Ibuprofen 200 mg',
      'dosage': 'PRN pain relief',
      'date': '2025‑05‑15',
      'pdfUrl': 'https://example.com/prescriptions/ibuprofen_may2025.pdf',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescriptions', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _prescriptions.isEmpty
          ? const Center(child: Text('No prescriptions found.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _prescriptions.length,
        itemBuilder: (ctx, idx) {
          final p = _prescriptions[idx];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p['title']!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Prescribed by: ${p['doctor']}',
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('Medication: ${p['medication']}',
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('Dosage: ${p['dosage']}',
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: use url_launcher to open PDF link
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Opening prescription: ${p['title']}')),
                        );
                      },
                      icon: const Icon(Icons.picture_as_pdf,color: Colors.white,),
                      label: const Text('View PDF',style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
