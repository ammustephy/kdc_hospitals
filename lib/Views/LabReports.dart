import 'package:flutter/material.dart';

class LabReports extends StatefulWidget {
  final int selectedIndex;
  const LabReports({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<LabReports> createState() => _LabReportsState();
}

class _LabReportsState extends State<LabReports> {
  // Example data for lab test reports
  final List<Map<String, String>> _labReports = [
    {
      'title': 'Complete Blood Count (CBC)',
      'date': '2025-06-25',
      'summary': 'All parameters are within normal range.',
      'pdfUrl': 'https://example.com/reports/cbc_june2025.pdf',
    },
    {
      'title': 'Liver Function Test (LFT)',
      'date': '2025-06-20',
      'summary': 'Liver enzymes show mild elevation; follow-up recommended.',
      'pdfUrl': 'https://example.com/reports/lft_june2025.pdf',
    },
    {
      'title': 'Kidney Panel',
      'date': '2025-06-15',
      'summary': 'Renal function is normal.',
      'pdfUrl': 'https://example.com/reports/kidney_june2025.pdf',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Reports', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _labReports.isEmpty
          ? const Center(child: Text('No lab test reports available.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _labReports.length,
        itemBuilder: (ctx, idx) {
          final report = _labReports[idx];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            child: ExpansionTile(
              // Keys preserve expansion state when scrolling :contentReference[oaicite:0]{index=0}
              key: PageStorageKey(report['title']),
              title: Text(report['title']!,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(report['date']!),
              childrenPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              children: [
                Text(report['summary']!),
                const SizedBox(height: 8),
                ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Download PDF'),
                      onPressed: () {
                        // Use url_launcher to open PDF
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Downloading ${report['title']}...')),
                        );
                      },
                    ),
                    TextButton(
                      child: const Text('View Details'),
                      onPressed: () {
                        // Navigate to detailed report screen if needed
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
