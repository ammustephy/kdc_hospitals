
import 'package:flutter/material.dart';

import '../Model/SwitchUser.dart';


class UserProvider with ChangeNotifier {
  List<UserAccount> accounts = [
    UserAccount(id: '1', name: 'Alice', avatarUrl: 'https://example.com/a.jpg'),
    UserAccount(id: '2', name: 'Bob', avatarUrl: 'https://example.com/b.jpg'),
  ];

  int currentAccountIndex = 0;

  UserAccount get currentAccount => accounts[currentAccountIndex];

  void switchAccount() {
    currentAccountIndex = (currentAccountIndex + 1) % accounts.length;
    notifyListeners();
  }
}
