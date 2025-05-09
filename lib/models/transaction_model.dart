import 'package:flutter/material.dart';

enum TransactionType { save, withdrawal, transfer }

class TransactionModel {
  final String id;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String description;
  final String userId;
  final String? goalId;
  
  // Additional fields for transaction details
  final String? depositSource;
  final String? withdrawalDestination;
  final String? mobileProvider;
  final String? mobileMoneyNumber;
  final String? transferRecipient;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.type,
    required this.description,
    required this.userId,
    this.goalId,
    this.depositSource,
    this.withdrawalDestination,
    this.mobileProvider,
    this.mobileMoneyNumber,
    this.transferRecipient, String? mobileMoneyProvider, required String source, String? phoneNumber, required String category,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      type: _parseTransactionType(json['type']),
      description: json['description'] ?? '',
      userId: json['userId'] ?? '',
      goalId: json['goalId'],
      depositSource: json['depositSource'],
      withdrawalDestination: json['withdrawalDestination'],
      mobileProvider: json['mobileProvider'],
      mobileMoneyNumber: json['mobileMoneyNumber'],
      transferRecipient: json['transferRecipient'], source: '', category: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.toString().split('.').last,
      'description': description,
      'userId': userId,
      'goalId': goalId,
      'depositSource': depositSource,
      'withdrawalDestination': withdrawalDestination,
      'mobileProvider': mobileProvider,
      'mobileMoneyNumber': mobileMoneyNumber,
      'transferRecipient': transferRecipient,
    };
  }
  
  // Helper method to parse TransactionType from string
  static TransactionType _parseTransactionType(String? typeStr) {
    if (typeStr == null) return TransactionType.save;
    
    switch (typeStr.toLowerCase()) {
      case 'withdrawal':
        return TransactionType.withdrawal;
      case 'transfer': 
        return TransactionType.transfer;
      case 'save':
      default:
        return TransactionType.save;
    }
  }
  
  // Helper to get a formatted date string
  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  // Helper to get transaction icon based on type
  IconData getTransactionIcon() {
    switch (type) {
      case TransactionType.save:
        return Icons.savings;
      case TransactionType.withdrawal:
        return Icons.money_off;
      case TransactionType.transfer:
        return Icons.swap_horiz;
    }
  }
  
  // Helper to get transaction color based on type
  Color getTransactionColor() {
    switch (type) {
      case TransactionType.save:
        return Colors.green;
      case TransactionType.withdrawal:
        return Colors.red;
      case TransactionType.transfer:
        return Colors.blue;
    }
  }
  
  // Copy with method to create a new instance with modified fields
  TransactionModel copyWith({
    String? id,
    double? amount,
    DateTime? date,
    TransactionType? type,
    String? description,
    String? userId,
    String? goalId,
    String? depositSource,
    String? withdrawalDestination,
    String? mobileProvider,
    String? mobileMoneyNumber,
    String? transferRecipient,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      goalId: goalId ?? this.goalId,
      depositSource: depositSource ?? this.depositSource,
      withdrawalDestination: withdrawalDestination ?? this.withdrawalDestination,
      mobileProvider: mobileProvider ?? this.mobileProvider,
      mobileMoneyNumber: mobileMoneyNumber ?? this.mobileMoneyNumber,
      transferRecipient: transferRecipient ?? this.transferRecipient, source: '', category: '',
    );
  }
  
  @override
  String toString() {
    return 'TransactionModel(id: $id, amount: $amount, type: $type, description: $description)';
  }
}