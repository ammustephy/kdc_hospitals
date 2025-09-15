import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/Booking_Provider.dart';
import 'ReAppointment.dart';


class OfflineAppointmentPage extends StatelessWidget {
  const OfflineAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<BookingProvider>();
    final offlineList = prov.bookings.where((b) => b.mode == AppointmentMode.offline).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Offline Appointments')),
      body: offlineList.isEmpty
          ? const Center(child: Text('No offline appointments.'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: offlineList.length,
        itemBuilder: (_, i) {
          final b = offlineList[i];
          final dateStr = MaterialLocalizations.of(context).formatFullDate(b.date);

          return Dismissible(
            key: ValueKey(b.id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (_) => showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Confirm delete'),
                content: const Text('Delete this appointment?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
            onDismissed: (_) {
              final originalIndex = prov.bookings.indexWhere((ap) => ap.id == b.id);
              if (originalIndex >= 0) prov.deleteBookingAt(originalIndex);
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                title: Text(
                  '${b.department} • $dateStr',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  '🕒 ${b.slot}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                trailing: TextButton.icon(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  label: const Text('Reschedule'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReAppointmentPage()),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}