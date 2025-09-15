import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

enum AppointmentMode { online, offline }

class Booking {
  final String id;
  final DateTime date;
  final String department;
  final String slot;
  final AppointmentMode mode;

  Booking({
    required this.id,
    required this.date,
    required this.department,
    required this.slot,
    required this.mode,
  });
}

class BookingProvider with ChangeNotifier {
  DateTime? selectedDate;
  String? selectedDepartment;
  String? selectedSlot;
  AppointmentMode? mode;

  final List<Booking> _bookings = [];
  List<Booking> get bookings => List.unmodifiable(_bookings);

  void setDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setDepartment(String dept) {
    selectedDepartment = dept;
    notifyListeners();
  }

  void setSlot(String slot) {
    selectedSlot = slot;
    notifyListeners();
  }

  void setMode(AppointmentMode m) {
    mode = m;
    notifyListeners();
  }

  Booking? confirmBooking() {
    if (selectedDate == null ||
        selectedDepartment == null ||
        selectedSlot == null ||
        mode == null) {
      throw Exception('Please complete all fields');
    }
    final newBooking = Booking(
      id: Uuid().v4(),
      date: selectedDate!,
      department: selectedDepartment!,
      slot: selectedSlot!,
      mode: mode!,
    );
    _bookings.add(newBooking);

    // Don't reset here—so UI still shows selected values until navigation happens
    notifyListeners();
    return newBooking;
  }

  void resetSelections() {
    selectedDate = null;
    selectedDepartment = null;
    selectedSlot = null;
    mode = null;
    notifyListeners();
  }

  void deleteBookingAt(int index) {
    _bookings.removeAt(index);
    notifyListeners();
  }

}
