import 'package:flutter/material.dart';

class BillDetails extends StatefulWidget {
  final int selectedIndex;
  const BillDetails({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<BillDetails> createState() => _BillDetailsState();
}

class _BillDetailsState extends State<BillDetails> {
  // Dummy billing data
  final List<Map<String, dynamic>> _bills = [
    {
      'invoice': 'INV-2025-06-01',
      'date': '2025-06-01',
      'total': 150.75,
      'items': [
        {'name': 'Consultation Fee', 'amount': 50.00},
        {'name': 'Blood Test', 'amount': 75.00},
        {'name': 'X-Ray', 'amount': 25.75},
      ],
      'pdfUrl': 'https://example.com/bills/inv_june01_2025.pdf',
    },
    {
      'invoice': 'INV-2025-05-15',
      'date': '2025-05-15',
      'total': 200.00,
      'items': [
        {'name': 'MRI Scan', 'amount': 150.00},
        {'name': 'Medicine', 'amount': 50.00},
      ],
      'pdfUrl': 'https://example.com/bills/inv_may15_2025.pdf',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Details', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _bills.isEmpty
          ? const Center(child: Text('No billing records found.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _bills.length,
        itemBuilder: (ctx, idx) {
          final bill = _bills[idx];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ExpansionTile(
              key: PageStorageKey(bill['invoice']),
              title: Text(bill['invoice'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Date: ${bill['date']}'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List<Widget>.from(bill['items'].map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item['name']),
                            Text('₹${item['amount'].toStringAsFixed(2)}'),
                          ],
                        ),
                      ))),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('₹${bill['total'].toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Download Bill'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Downloading ${bill['invoice']}...')),
                        );
                      },
                    ),
                    TextButton(
                      child: const Text('View PDF'),
                      onPressed: () {
                        // TODO: Launch PDF viewer
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
