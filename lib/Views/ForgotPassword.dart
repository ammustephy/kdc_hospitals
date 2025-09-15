import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  bool isLoading = false;
  String? message;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      isLoading = true;
      message = null;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      setState(() => message = 'A reset link has been sent.');
    } catch (e) {
      setState(() => message = 'Failed to send link. Try again.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: MediaQuery.of(context).viewPadding.top + 60,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: GlassmorphicContainer(
            width: double.infinity,
            height: 350,
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
            borderGradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.5),
                Colors.white.withOpacity(0.5),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Enter your Student ID to receive a reset link.',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: idController,
                      decoration: InputDecoration(
                        hintText: 'Enter UID',
                        prefixIcon: const Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Please enter UID'
                          : null,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "Send Link",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      message!,
                      style: TextStyle(
                        color:
                        message!.startsWith('Failed') ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
