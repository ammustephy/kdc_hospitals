import 'package:flutter/foundation.dart';

import 'Booking_Provider.dart';

class OnlineProvider with ChangeNotifier {
  final List<Booking> _bookings = [];
  List<Booking> get bookings => List.unmodifiable(_bookings);

  void addBooking(Booking booking) {
    _bookings.add(booking);
    notifyListeners();
  }

  void deleteBookingAt(int index) {
    _bookings.removeAt(index);
    notifyListeners();
  }

  void updateBooking(int index, Booking newBooking) {
    _bookings[index] = newBooking;
    notifyListeners();
  }
}
