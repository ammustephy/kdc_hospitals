import 'package:flutter/material.dart';

enum AppointmentTab { online, offline }

class AppointmentProvider with ChangeNotifier {
  AppointmentTab _current = AppointmentTab.online;
  AppointmentTab get current => _current;

  void goToOnline() {
    _current = AppointmentTab.online;
    notifyListeners();
  }

  void goToOffline() {
    _current = AppointmentTab.offline;
    notifyListeners();
  }


}
