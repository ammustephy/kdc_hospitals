import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_animate/flutter_animate.dart';  // 🔑 Import flutter_animate

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), _checkLogin);
  }

  Future<void> _checkLogin() async {
    final token = await storage.read(key: 'token');
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      (token?.isNotEmpty ?? false) ? '/home' : '/login',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          // 🔹 Animated Logo
          Image.asset('assets/images/KDCH-logo.jpg', width: 100, height: 100)
              .animate()                                 // enable animation
              // .scale(begin: 0.5, end: 1.0, duration: 800.ms)
              .fadeIn(duration: 800.ms)
              .then(delay: 200.ms)                       // wait 200ms after fade completes
              .slideY(begin: 0.2, end: 0, duration: 400.ms),

          const SizedBox(height: 16),

          // 🔹 Animated Text
          Column(
            children: [
              Row(mainAxisSize: MainAxisSize.min, children: [
                Text('KDCH', style: TextStyle(fontSize: 25,
                    color: Colors.blue.shade900,fontWeight: FontWeight.bold)),
                // Text('Cura', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600, color: Colors.orange.shade900)),
              ]),
              // const SizedBox(height: 5),
              Text(
                'Kozhikode District Co-operative Hospital',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.blue.shade900),
              ),
            ],
          )
              .animate()
              .fadeIn(delay: 1000.ms, duration: 600.ms)  // start after logo finishes
              .slideY(begin: 0.3, end: 0, delay: 1000.ms, duration: 600.ms),
        ]),
      ),
    );
  }
}
