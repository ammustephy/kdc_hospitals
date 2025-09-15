import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DischargeDetails extends StatefulWidget {
  final int selectedIndex;
  const DischargeDetails({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<DischargeDetails> createState() => _DischargeDetailsState();
}

class _DischargeDetailsState extends State<DischargeDetails> {
  // Dummy discharge summaries
  final List<Map<String, dynamic>> _summaries = [
    {
      'patient': 'John Doe (MRN: 98765432)',
      'admission': '2025-06-01',
      'discharge': '2025-06-07',
      'primaryDiagnosis': 'Community‑acquired pneumonia',
      'secondaryDiagnoses': ['Hypertension'],
      'hospitalCourse': 'Received IV antibiotics, responded well, transitioned to oral.',
      'procedures': ['Chest X‑Ray'],
      'medications': [
        {'name': 'Amoxicillin 500 mg', 'freq': 'TID × 10 days'},
        {'name': 'Lisinopril 10 mg', 'freq': 'Once daily'}
      ],
      'followUp': [{'with': 'Pulmonology', 'on': '2025-06-20'}],
      'instructions': 'Complete antibiotics, rest, recheck CXR in 2 weeks.'
    },
    {
      'patient': 'John Doe (MRN: 45678901)',
      'admission': '2025-05-20',
      'discharge': '2025-05-25',
      'primaryDiagnosis': 'Acute appendicitis',
      'secondaryDiagnoses': [],
      'hospitalCourse': 'Laparoscopic appendectomy, tolerated well post-op.',
      'procedures': ['Appendectomy'],
      'medications': [
        {'name': 'Ibuprofen 400 mg', 'freq': 'TID PRN pain'},
        {'name': 'Ondansetron 4 mg', 'freq': 'PRN nausea'}
      ],
      'followUp': [{'with': 'Surgery clinic', 'on': '2025-06-05'}],
      'instructions': 'Keep wound clean, avoid heavy lifting for 4 weeks.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discharge Summaries', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
      ),
      body: _summaries.isEmpty
          ? const Center(child: Text('No discharge summaries available.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _summaries.length,
        itemBuilder: (context, idx) {
          final s = _summaries[idx];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ExpansionTile(
              key: PageStorageKey(s['patient']),
              title: Text(s['patient'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${s['admission']} → ${s['discharge']}'),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _buildSection('Primary Diagnosis', s['primaryDiagnosis']),
                if ((s['secondaryDiagnoses'] as List).isNotEmpty)
                  _buildSection('Secondary Diagnoses', (s['secondaryDiagnoses'] as List<String>).join(', ')),
                _buildSection('Hospital Course', s['hospitalCourse']),
                _buildList('Procedures', List<String>.from(s['procedures'])),
                _buildMedList('Medications', List<Map<String, String>>.from(s['medications'])),
                _buildList('Follow‑Up', (s['followUp'] as List<dynamic>).map((f) => '${f['with']} on ${f['on']}').toList()),
                _buildSection('Instructions', s['instructions']),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Download Summary'),
                    onPressed: () => _downloadPdf(s['pdfUrl']),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, String content) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black87, fontSize: 14),
        children: [
          TextSpan(text: '$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: content),
        ],
      ),
    ),
  );

  Widget _buildList(String title, List<String> items) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$title:', style: const TextStyle(fontWeight: FontWeight.bold)),
      ...items.map((i) => Text('• $i', style: const TextStyle(fontSize: 14))),
    ]),
  );

  Widget _buildMedList(String title, List<Map<String, String>> meds) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$title:', style: const TextStyle(fontWeight: FontWeight.bold)),
      ...meds.map((m) => Text('• ${m['name']} — ${m['freq']}', style: const TextStyle(fontSize: 14))),
    ]),
  );

  Future<void> _downloadPdf(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open PDF')));
    }
  }
}
