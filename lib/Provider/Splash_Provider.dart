import 'package:flutter/foundation.dart';

class SplashProvider with ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  void finishLoading() {
    _isLoading = false;
    notifyListeners();
  }
}
