class GoalModel {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final String userId;
  final bool isCompleted;

  GoalModel({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.userId,
    this.isCompleted = false,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      targetAmount: (json['targetAmount'] ?? 0.0).toDouble(),
      currentAmount: (json['currentAmount'] ?? 0.0).toDouble(),
      targetDate: json['targetDate'] != null 
          ? DateTime.parse(json['targetDate']) 
          : DateTime.now().add(const Duration(days: 30)),
      userId: json['userId'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate': targetDate.toIso8601String(),
      'userId': userId,
      'isCompleted': isCompleted,
    };
  }

  double get progressPercentage => 
      targetAmount > 0 ? (currentAmount / targetAmount * 100) : 0;
      
  int get daysRemaining => 
      targetDate.difference(DateTime.now()).inDays;
}