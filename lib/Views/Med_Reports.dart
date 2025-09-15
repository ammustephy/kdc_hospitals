import 'package:flutter/material.dart';

class MedReports extends StatefulWidget {
  final int selectedIndex;
  const MedReports({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<MedReports> createState() => _MedReportsState();
}

class _MedReportsState extends State<MedReports> {
  // All possible reports, with types
  final List<Map<String, String>> _allReports = [
    {
      'type': 'lab',
      'title': 'Blood Test – CBC',
      'date': '2025-06-25',
      'summary': 'Complete blood count results are within normal range.',
      'pdfUrl': 'https://example.com/reports/cbc_june2025.pdf',
    },
    {
      'type': 'radiology', // radiology-type
      'title': 'Chest X‑Ray',
      'date': '2025-06-18',
      'summary': 'No abnormalities detected.',
      'pdfUrl': 'https://example.com/reports/chestxray_june2025.pdf',
    },
    {
      'type': 'lab',
      'title': 'Metabolic Panel',
      'date': '2025-06-10',
      'summary': 'Liver and kidney functions are normal.',
      'pdfUrl': 'https://example.com/reports/metabolic_june2025.pdf',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter to include only lab reports
    final labReports = _allReports.where((r) => r['type'] == 'lab').toList(); // using where() :contentReference[oaicite:1]{index=1}

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Medical Reports', style: TextStyle(color: Colors.black)),
      ),
      body: labReports.isEmpty
          ? const Center(child: Text('No medical lab reports available.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: labReports.length,
        itemBuilder: (context, index) {
          final report = labReports[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ExpansionTile(
              title: Text(report['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(report['date']!),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(report['summary']!),
                ),
                const SizedBox(height: 8),
                ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Download PDF'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Downloading ${report['title']}...')),
                        );
                      },
                    ),
                    TextButton(
                      child: const Text('View Details'),
                      onPressed: () {
                        // Navigate to a detailed view screen if needed.
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}