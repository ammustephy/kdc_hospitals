// lib/Provider/LoginProvider.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class LoginProvider with ChangeNotifier {
  final storage = const FlutterSecureStorage();
  final auth = LocalAuthentication();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }


  Future<void> saveLoginToken(String token) => storage.write(key: 'token', value: token);
  Future<void> enableBiometric(bool enabled) => storage.write(key: 'biometric_enabled', value: enabled ? 'true' : 'false');

  Future<void> logout() async {
    await storage.deleteAll();
    notifyListeners();
  }

  Future<bool> authenticateBiometric() async {
    final can = await auth.canCheckBiometrics && await auth.isDeviceSupported();
    if (!can) return false;
    try {
      return await auth.authenticate(localizedReason: 'Authenticate to continue', options: const AuthenticationOptions(biometricOnly: true, useErrorDialogs: true, stickyAuth: true));
    } catch (_) {
      return false;
    }
  }
}
