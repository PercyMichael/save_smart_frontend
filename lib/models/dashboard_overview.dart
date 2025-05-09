// lib/models/dashboard_overview.dart
class DashboardOverview {
  final double totalBalance;
  final double balanceGrowth;
  final int activeUsers;
  final double newUsersPercentage;
  final double totalWithdrawals;
  final double withdrawalTrend;
  final int transactionCount;
  final double transactionTrend;

  DashboardOverview({
    required this.totalBalance,
    required this.balanceGrowth,
    required this.activeUsers,
    required this.newUsersPercentage,
    required this.totalWithdrawals,
    required this.withdrawalTrend,
    required this.transactionCount,
    required this.transactionTrend,
  });

  factory DashboardOverview.fromJson(Map<String, dynamic> json) {
    return DashboardOverview(
      totalBalance: json['total_balance'].toDouble(),
      balanceGrowth: json['balance_growth'].toDouble(),
      activeUsers: json['active_users'],
      newUsersPercentage: json['new_users_percentage'].toDouble(),
      totalWithdrawals: json['total_withdrawals'].toDouble(),
      withdrawalTrend: json['withdrawal_trend']?.toDouble() ?? 0.0,
      transactionCount: json['transaction_count'],
      transactionTrend: json['transaction_trend']?.toDouble() ?? 0.0,
    );
  }
}