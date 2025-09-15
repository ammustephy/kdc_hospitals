
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/MedDeliveryProvider.dart';
import 'Payment.dart';

class MedicineSearchPage extends StatefulWidget {
  final int selectedIndex;
  const MedicineSearchPage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<MedicineSearchPage> createState() => _MedicineSearchPageState();
}

class _MedicineSearchPageState extends State<MedicineSearchPage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MedicineProvider>(context);
    final filteredList = provider.medicines
        .where((med) => med.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Search & Order Medicine"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MedicineCartSummaryPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Search Medicine",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                setState(() => searchQuery = val);
              },
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final med = filteredList[index];
                  return Card(
                    child: ListTile(
                      title: Text(med.name),
                      subtitle: Text("₹${med.price}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () => provider.decrementQuantity(med),
                          ),
                          Text("${med.quantity}",style: TextStyle(fontSize: 15),),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: () => provider.incrementQuantity(med),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                            child: Text("Add",style: TextStyle(color: Colors.white),),
                            onPressed: () {
                              provider.addToCart(med);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${med.name} added to cart")),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (provider.cart.isNotEmpty)
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: Text("Proceed to Summary (${provider.cart.length} items)",
                  style: TextStyle(color: Colors.white),),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MedicineCartSummaryPage()),
                  );
                },
              ),
            SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }
}





class MedicineCartSummaryPage extends StatelessWidget {
  const MedicineCartSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MedicineProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Summary"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // 🛒 Cart Items
            Expanded(
              child: provider.cart.isEmpty
                  ? const Center(
                child: Text(
                  'Your cart is empty',
                  style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
                  : ListView.builder(
                itemCount: provider.cart.length,
                itemBuilder: (context, index) {
                  final med = provider.cart[index];
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                        med.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "₹${med.price} × ${med.quantity} = ₹${med.price * med.quantity}",
                        style:
                        const TextStyle(color: Colors.black54),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => provider.removeFromCart(med),
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(thickness: 1),

            // 💰 Total Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Amount:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "₹${provider.totalAmount}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 💳 Payment Methods
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Select Payment Method:",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 10),

            PaymentOptionTile(
              icon: Icons.money,
              label: "Cash on Delivery",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        PaymentCODPage(amount: provider.totalAmount),
                  ),
                );
              },
            ),
            PaymentOptionTile(
              icon: Icons.payment,
              label: "UPI (GPay, Paytm, PhonePe)",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        PaymentUPIPage(amount: provider.totalAmount),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

/// Reusable widget for payment method list tiles
class PaymentOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const PaymentOptionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade900),
        title: Text(label),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}


