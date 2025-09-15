import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// 💵 Cash on Delivery Payment Page
class PaymentCODPage extends StatelessWidget {
  final double amount;
  const PaymentCODPage({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cash on Delivery"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Amount to be paid on delivery:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(
              "₹$amount",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Order Placed via COD")),
                  );
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text(
                  "Confirm Order",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 💳 UPI Payment Page
class PaymentUPIPage extends StatelessWidget {
  final double amount;
  const PaymentUPIPage({super.key, required this.amount});

  /// Method to launch UPI payment intent
  Future<void> _launchUPIPayment(BuildContext context, String vpa, String name) async {
    final Uri uri = Uri(
      scheme: 'upi',
      host: 'pay',
      queryParameters: {
        'pa': vpa, // Payee VPA
        'pn': name, // Payee Name
        'am': amount.toStringAsFixed(2),
        'cu': 'INR', // Currency
      },
    );

    final url = uri.toString();

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch UPI app for $name')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UPI Payment"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Pay via UPI",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(
              "₹$amount",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 30),

            // GPay button
            PaymentButton(
              label: "Proceed to GPay",
              color: Colors.blue.shade900,
              onPressed: () => _launchUPIPayment(
                context,
                "https://pay.google.com/", // Replace with actual VPA
                "KDCH",
              ),
            ),
            const SizedBox(height: 10),

            // Paytm button
            PaymentButton(
              label: "Proceed to Paytm",
              color: Colors.blue.shade900,
              onPressed: () => _launchUPIPayment(
                context,
                "https://paytm.com/", // Replace with actual VPA
                "KDCH",
              ),
            ),
            const SizedBox(height: 10),

            // PhonePe button
            PaymentButton(
              label: "Proceed to PhonePe",
              color: Colors.blue.shade900,
              onPressed: () => _launchUPIPayment(
                context,
                "https://www.phonepe.com/", // Replace with actual VPA
                "KDCH",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Reusable Payment Button Widget
class PaymentButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const PaymentButton({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
