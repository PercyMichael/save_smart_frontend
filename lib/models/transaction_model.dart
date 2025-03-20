enum TransactionType { deposit, withdrawal, transfer }

class TransactionModel {
  final String id;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String description;
  final String userId;
  final String? goalId;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.type,
    required this.description,
    required this.userId,
    this.goalId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      type: _parseTransactionType(json['type']),
      description: json['description'] ?? '',
      userId: json['userId'] ?? '',
      goalId: json['goalId'],
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
    };
  }

  static TransactionType _parseTransactionType(String? typeStr) {
    if (typeStr == 'deposit') return TransactionType.deposit;
    if (typeStr == 'withdrawal') return TransactionType.withdrawal;
    if (typeStr == 'transfer') return TransactionType.transfer;
    return TransactionType.deposit; // Default
  }
}
