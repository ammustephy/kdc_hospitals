import 'package:flutter/material.dart';

class RadiologyPage extends StatefulWidget {
  final int selectedIndex;
  const RadiologyPage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<RadiologyPage> createState() => _RadiologyPageState();
}

class _RadiologyPageState extends State<RadiologyPage> {
  // Sample radiology reports only
  final List<Map<String, String>> _radiologyReports = [
    {
      'title': 'Abdominal Ultrasound',
      'date': '2025-05-30',
      'summary': 'Normal echotexture, gallbladder without stones.',
      'pdfUrl': 'https://example.com/reports/abdominal_ultrasound_may2025.pdf',
    },
    {
      'title': 'Head CT Scan',
      'date': '2025-05-15',
      'summary': 'No signs of intracranial hemorrhage or mass effect.',
      'pdfUrl': 'https://example.com/reports/head_ct_may2025.pdf',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radiology Reports', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _radiologyReports.isEmpty
          ? const Center(child: Text('No radiology scan reports available.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _radiologyReports.length,
        itemBuilder: (ctx, idx) {
          final report = _radiologyReports[idx];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ExpansionTile(
              key: PageStorageKey(report['title']),
              title: Text(
                report['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(report['date']!),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        // TODO: Use url_launcher to open PDF
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Downloading ${report['title']}...')),
                        );
                      },
                    ),
                    TextButton(
                      child: const Text('View Details'),
                      onPressed: () {
                        // TODO: Navigate to detailed view screen
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
