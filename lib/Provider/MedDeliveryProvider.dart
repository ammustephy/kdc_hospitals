import 'package:flutter/material.dart';

class Medicine {
  final String name;
  final double price;
  int quantity;

  Medicine({
    required this.name,
    required this.price,
    this.quantity = 1,
  });
}

class MedicineProvider extends ChangeNotifier {
  final List<Medicine> _medicines = [
    Medicine(name: "Paracetamol 500mg", price: 20),
    Medicine(name: "Aspirin 100mg", price: 30),
    Medicine(name: "Cough Syrup", price: 80),
    Medicine(name: "Vitamin C Tablets", price: 50),
    Medicine(name: "Amoxicillin 250mg", price: 60),
  ];

  List<Medicine> get medicines => _medicines;
  final List<Medicine> _cart = [];
  List<Medicine> get cart => _cart;

  void incrementQuantity(Medicine med) {
    med.quantity++;
    notifyListeners();
  }

  void decrementQuantity(Medicine med) {
    if (med.quantity > 1) {
      med.quantity--;
      notifyListeners();
    }
  }

  void addToCart(Medicine med) {
    if (!_cart.contains(med)) {
      _cart.add(Medicine(
        name: med.name,
        price: med.price,
        quantity: med.quantity,
      ));
    } else {
      final index = _cart.indexWhere((item) => item.name == med.name);
      _cart[index].quantity += med.quantity;
    }
    med.quantity = 1; // reset after adding
    notifyListeners();
  }

  void removeFromCart(Medicine med) {
    _cart.remove(med);
    notifyListeners();
  }

  double get totalAmount {
    return _cart.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
}
