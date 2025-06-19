class UserModel {
  final String id;
  final String name;
  final String email;
  final double balance;
  final List<String> goalIds;
  final List<String> transactionIds;
  final String? displayName;
  final String? phoneNumber;
  final String? district;
  final String? photoUrl;
  final bool isAdmin;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.balance,
    required this.goalIds,
    required this.transactionIds,
    this.displayName,
    this.phoneNumber,
    this.district,
    this.photoUrl,
    this.isAdmin = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      balance: (json['balance'] ?? 0.0).toDouble(),
      goalIds: List<String>.from(json['goalIds'] ?? []),
      transactionIds: List<String>.from(json['transactionIds'] ?? []),
      displayName: json['displayName'],
      phoneNumber: json['phoneNumber'],
      district: json['district'],
      photoUrl: json['photoUrl'],
      isAdmin: json['isAdmin'] ?? false,
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
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'district': district,
      'photoUrl': photoUrl,
      'isAdmin': isAdmin,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    double? balance,
    List<String>? goalIds,
    List<String>? transactionIds,
    String? displayName,
    String? phoneNumber,
    String? district,
    String? photoUrl,
    bool? isAdmin,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      balance: balance ?? this.balance,
      goalIds: goalIds ?? this.goalIds,
      transactionIds: transactionIds ?? this.transactionIds,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      district: district ?? this.district,
      photoUrl: photoUrl ?? this.photoUrl,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}