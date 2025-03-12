import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
// ignore: unused_import
import '../models/user_model.dart';
import '../models/transaction_model.dart';
import '../models/goal_model.dart';
import '../utils/constants.dart';

class ApiService {
  final String baseUrl = ApiConstants.baseUrl;
  
  // User API methods
  Future<Map<String, dynamic>> fetchUser(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users/$userId'));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }
  
  Future<void> updateUserBalance(String userId, double newBalance) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'balance': newBalance}),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to update balance: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating balance: $e');
    }
  }
  
  // Transaction API methods
  Future<List<dynamic>> fetchTransactions(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/transactions?userId=$userId'),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching transactions: $e');
    }
  }
  
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transactions'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(transaction.toJson()),
      );
      
      if (response.statusCode != 201) {
        throw Exception('Failed to add transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding transaction: $e');
    }
  }
  
  // Goal API methods
  Future<List<dynamic>> fetchGoals(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/goals?userId=$userId'),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load goals: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching goals: $e');
    }
  }
  
  Future<void> addGoal(GoalModel goal) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/goals'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(goal.toJson()),
      );
      
      if (response.statusCode != 201) {
        throw Exception('Failed to add goal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding goal: $e');
    }
  }
  
  Future<void> updateGoalAmount(String goalId, double newAmount) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/goals/$goalId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'currentAmount': newAmount}),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to update goal amount: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating goal amount: $e');
    }
  }
}