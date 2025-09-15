import 'package:flutter/foundation.dart';

class Booking {
  final DateTime date;
  final String slot;

  Booking({ required this.date, required this.slot });
}

// Only one provider that holds all confirmed and rescheduled appointments:
class RebookingProvider with ChangeNotifier {
  DateTime? selectedDate;
  String? selectedSlot;

  final List<Booking> _bookings = [];
  List<Booking> get bookings => List.unmodifiable(_bookings);

  void setDate(DateTime d) { selectedDate = d; notifyListeners(); }
  void setSlot(String s) { selectedSlot = s; notifyListeners(); }

  void confirmBooking() {
    if (selectedDate != null && selectedSlot != null) {
      _bookings.add(Booking(date: selectedDate!, slot: selectedSlot!));
      selectedDate = selectedSlot = null;
      notifyListeners();
    } else {
      throw Exception('Select both date and slot.');
    }
  }
}
