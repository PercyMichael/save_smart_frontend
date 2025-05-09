import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String name;
  final String email;
  final double balance;
  final List<String> accounts;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.balance = 0.0,
    this.accounts = const [],
  });
}

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  // Sample data for testing
  void loadUser() {
    _user = User(
      id: '1',
      name: 'Sandra Nakawuka',
      email: 'nakawukasandra8@gmail.com',
      balance: 5200.00,
      accounts: ['Savings', 'Checking', 'Investment'],
    );
    notifyListeners();
  }

  void updateUserBalance(double newBalance) {
    if (_user != null) {
      _user = User(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        balance: newBalance,
        accounts: _user!.accounts,
      );
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}