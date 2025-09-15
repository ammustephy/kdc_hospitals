import 'dart:async';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

import 'ForStaffs.dart';
import 'ForgotPassword.dart';
import 'Home.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool _isHidden = true;

  // Example user authentication function, replace with your real API
  Future<Map<String, dynamic>> authenticateUser(String id, String password) async {
    await Future.delayed(Duration(seconds: 2)); // simulate network delay

    // Example: hardcoded users for demo
    if (id == "patient123" && password == "password") {
      return {"role": "patient"}; // patient role
    } else if (id == "staff123" && password == "password") {
      return {"role": "staff"}; // staff role
    } else {
      throw Exception("Invalid credentials");
    }
  }

  Future<void> _handleLogin() async {
    setState(() => isLoading = true);
    try {
      final user = await authenticateUser(idController.text.trim(), passwordController.text.trim());
      if (user['role'] == 'patient') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else if (user['role'] == 'staff') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StaffHomePage()),
        );
      } else {
        throw Exception("Unknown user role");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GlassmorphicContainer(
                width: double.infinity,
                height: 600,
                borderRadius: 20,
                blur: 20,
                alignment: Alignment.center,
                border: 1,
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                  stops: const [0.1, 1],
                ),
                borderGradient: LinearGradient(colors: [
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(0.5),
                ]),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      TextField(
                        controller: idController,
                        enabled: !isLoading,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Enter UID',
                          prefixIcon: const Icon(Icons.person),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.3),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        enabled: !isLoading,
                        obscureText: _isHidden,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.3),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_isHidden ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _isHidden = !_isHidden),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: isLoading
                              ? null
                              : () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                          ),
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.teal,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 50),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/KDCH-logo.jpg', height: 50, width: 40),
                        const SizedBox(width: 2),
                        Text(
                          'KDCH',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
