import 'package:flutter/foundation.dart';

enum GoalStatus {
  inProgress,
  completed,
  failed,
}

class SavingGoal {
  final String id;
  final String title;
  final String description;
  final double targetAmount;
  final double currentAmount;
  final DateTime startDate;
  final DateTime targetDate;
  final GoalStatus status;
  final String category;

  SavingGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetAmount,
    required this.currentAmount,
    required this.startDate,
    required this.targetDate,
    this.status = GoalStatus.inProgress,
    this.category = 'General',
  });

  double get progressPercentage => (currentAmount / targetAmount) * 100;
  
  bool get isCompleted => currentAmount >= targetAmount;
  
  int get daysLeft {
    final now = DateTime.now();
    return targetDate.difference(now).inDays;
  }
  
  SavingGoal copyWith({
    String? id,
    String? title,
    String? description,
    double? targetAmount,
    double? currentAmount,
    DateTime? startDate,
    DateTime? targetDate,
    GoalStatus? status,
    String? category,
  }) {
    return SavingGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      startDate: startDate ?? this.startDate,
      targetDate: targetDate ?? this.targetDate,
      status: status ?? this.status,
      category: category ?? this.category,
    );
  }
}

class GoalProvider with ChangeNotifier {
  List<SavingGoal> _goals = [];

  List<SavingGoal> get goals => _goals;
  
  // Get goals sorted by progress (descending)
  List<SavingGoal> get goalsByProgress {
    final sorted = List<SavingGoal>.from(_goals);
    sorted.sort((a, b) => b.progressPercentage.compareTo(a.progressPercentage));
    return sorted;
  }
  
  // Get goals sorted by closest to deadline
  List<SavingGoal> get goalsByDeadline {
    final sorted = List<SavingGoal>.from(_goals);
    sorted.sort((a, b) => a.targetDate.compareTo(b.targetDate));
    return sorted;
  }

  // Load sample goals for testing
  void loadSampleGoals() {
    final now = DateTime.now();
    
    _goals = [
      SavingGoal(
        id: '1',
        title: 'Emergency Fund',
        description: 'Build 3 months of living expenses',
        targetAmount: 10000,
        currentAmount: 7500,
        startDate: DateTime(now.year - 1, now.month, 1),
        targetDate: DateTime(now.year, now.month + 2, 1),
      ),
      SavingGoal(
        id: '2',
        title: 'Vacation',
        description: 'Summer trip to Europe',
        targetAmount: 3000,
        currentAmount: 1200,
        startDate: DateTime(now.year, now.month - 3, 1),
        targetDate: DateTime(now.year, now.month + 4, 1),
        category: 'Travel',
      ),
      SavingGoal(
        id: '3',
        title: 'New Laptop',
        description: 'Replace old computer',
        targetAmount: 1500,
        currentAmount: 1500,
        startDate: DateTime(now.year, now.month - 5, 1),
        targetDate: DateTime(now.year, now.month - 1, 1),
        status: GoalStatus.completed,
        category: 'Electronics',
      ),
    ];
    
    notifyListeners();
  }

  void addGoal(SavingGoal goal) {
    _goals.add(goal);
    notifyListeners();
  }

  void updateGoal(String id, SavingGoal updatedGoal) {
    final index = _goals.indexWhere((goal) => goal.id == id);
    if (index != -1) {
      _goals[index] = updatedGoal;
      notifyListeners();
    }
  }

  void deleteGoal(String id) {
    _goals.removeWhere((goal) => goal.id == id);
    notifyListeners();
  }

  void addAmountToGoal(String id, double amount) {
    final index = _goals.indexWhere((goal) => goal.id == id);
    if (index != -1) {
      final goal = _goals[index];
      final newAmount = goal.currentAmount + amount;
      final newStatus = newAmount >= goal.targetAmount 
          ? GoalStatus.completed 
          : goal.status;
      
      _goals[index] = goal.copyWith(
        currentAmount: newAmount,
        status: newStatus,
      );
      
      notifyListeners();
    }
  }
}