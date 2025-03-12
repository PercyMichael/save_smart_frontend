class UserModel {
  final String id;
  final String name;
  final String email;
  final double balance;
  final List<String> goalIds;
  final List<String> transactionIds;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.balance,
    required this.goalIds,
    required this.transactionIds,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      balance: (json['balance'] ?? 0.0).toDouble(),
      goalIds: List<String>.from(json['goalIds'] ?? []),
      transactionIds: List<String>.from(json['transactionIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'balance': balance,
      'goalIds': goalIds,
      'transactionIds': transactionIds,
    };
  }
}