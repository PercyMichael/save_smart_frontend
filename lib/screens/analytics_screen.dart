import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AnalyticsScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // Updated to Ugandan Shillings
  final currencyFormatter = NumberFormat.currency(locale: 'en_UG', symbol: 'UGX ', decimalDigits: 0);
  final percentFormatter = NumberFormat.percentPattern();
  
  // Theme color as specified
  final Color themeColor = const Color(0xFF8EB55D);

  // Sample data - in a real app, this would come from a database or API
  final double totalSavings = 12000000.00; // 12 million UGX
  final double monthlyIncome = 3000000.00; // 3 million UGX
  final double monthlySaved = 600000.00; // 600k UGX
  final double previousMonthSaved = 450000.00; // 450k UGX
  final int consistentWeeks = 8;
  final List<SavingsGoal> savingsGoals = [
    SavingsGoal('Emergency Fund', 15000000, 9000000, Color(0xFF8EB55D)),
    // ignore: deprecated_member_use
    SavingsGoal('Business Investment', 7500000, 3000000, Color(0xFF8EB55D).withOpacity(0.8)),
    // ignore: deprecated_member_use
    SavingsGoal('New Motorcycle', 4000000, 2500000, Color(0xFF8EB55D).withOpacity(0.6)),
  ];
  final List<double> monthlySavings = [350000, 400000, 450000, 500000, 550000, 600000];
  final List<String> months = ['Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar'];
  final List<SavingInsight> insights = [
    SavingInsight(
      'Consistency Milestone',
      'You\'ve saved consistently for 8 weeks! Great habit building.',
      Icons.emoji_events,
      Color(0xFF8EB55D),
    ),
    SavingInsight(
      'Saving Increase',
      'You saved 33% more this month compared to last month.',
      Icons.trending_up,
      Color(0xFF8EB55D),
    ),
    SavingInsight(
      'Tip',
      'Try setting up mobile money auto-transfers to reach your goals faster.',
      Icons.lightbulb,
      Color(0xFF8EB55D),
    ),
  ];
  final List<TransactionRecord> recentTransactions = [
    TransactionRecord('Salary Deposit', 'Mar 1', 900000, true),
    TransactionRecord('Market Business Savings', 'Mar 5', 200000, true),
    TransactionRecord('School Fees Withdrawal', 'Mar 10', 300000, false),
    TransactionRecord('Bonus Savings', 'Mar 15', 120000, true),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Analytics', style: TextStyle(color: Colors.white)),
        backgroundColor: themeColor,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.insights), text: 'Overview'),
            Tab(icon: Icon(Icons.flag), text: 'Goals'),
            Tab(icon: Icon(Icons.history), text: 'History'),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey[100], // Light background color
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildGoalsTab(),
            _buildHistoryTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    final savingRate = monthlySaved / monthlyIncome;
    final savingRateChange = (monthlySaved - previousMonthSaved) / previousMonthSaved;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Savings Overview Card
        Card(
          elevation: 4,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Savings',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  currencyFormatter.format(totalSavings),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Savings Growth',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 60,
                            getTitlesWidget: (value, meta) {
                              // Simplified UGX values in K format
                              // ignore: prefer_interpolation_to_compose_strings
                              String formattedValue = (value / 1000).toStringAsFixed(0) + 'K';
                              return Text(
                                formattedValue,
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 && value.toInt() < months.length) {
                                return Text(
                                  months[value.toInt()],
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: monthlySavings.asMap().entries.map((entry) {
                            return FlSpot(entry.key.toDouble(), entry.value);
                          }).toList(),
                          isCurved: true,
                          color: themeColor,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            // ignore: deprecated_member_use
                            color: themeColor.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Spending & Saving Patterns Card
        Card(
          elevation: 4,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saving Patterns',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatWidget(
                      'Monthly\nSavings',
                      currencyFormatter.format(monthlySaved),
                    ),
                    _buildStatWidget(
                      'Saving\nRate',
                      percentFormatter.format(savingRate),
                    ),
                    _buildStatWidget(
                      'Consistent\nWeeks',
                      '$consistentWeeks',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Monthly saving change: '),
                    Text(
                      '${savingRateChange > 0 ? '+' : ''}${percentFormatter.format(savingRateChange)}',
                      style: TextStyle(
                        color: savingRateChange > 0 ? themeColor : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Insights Section
        const Text(
          'Insights & Tips',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...insights.map((insight) => _buildInsightCard(insight)),
      ],
    );
  }

  Widget _buildStatWidget(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard(SavingInsight insight) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          // ignore: deprecated_member_use
          backgroundColor: insight.color.withOpacity(0.2),
          child: Icon(insight.icon, color: insight.color),
        ),
        title: Text(insight.title),
        subtitle: Text(insight.description),
      ),
    );
  }

  Widget _buildGoalsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Your Savings Goals',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...savingsGoals.map((goal) => _buildGoalCard(goal)),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Add New Goal', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            backgroundColor: themeColor,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalCard(SavingsGoal goal) {
    final progressPercentage = goal.currentAmount / goal.targetAmount;
    final remainingAmount = goal.targetAmount - goal.currentAmount;
    
    // Simple projection - assumes current monthly rate continues
    final monthsToGoal = remainingAmount / monthlySaved;
    final projectedCompletion = DateTime.now().add(Duration(days: (monthsToGoal * 30).round()));
    final projectedDateStr = DateFormat('MMM yyyy').format(projectedCompletion);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  goal.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${(progressPercentage * 100).round()}%',
                  style: TextStyle(
                    color: goal.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progressPercentage,
                backgroundColor: Colors.grey[200],
                color: goal.color,
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${currencyFormatter.format(goal.currentAmount)} of ${currencyFormatter.format(goal.targetAmount)}',
                ),
                const SizedBox(),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Projected completion: $projectedDateStr',
              style: TextStyle(color: Colors.grey[600]),
            ),
            if (progressPercentage >= 0.5 && progressPercentage < 1.0)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  '🎉 Halfway there!',
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (progressPercentage >= 1.0)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  '🏆 Goal achieved!',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Activity History',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // Calendar view placeholder - in a real app, you would use a calendar widget
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              'Calendar View - Showing saving activity',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Recent Transactions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...recentTransactions.map((transaction) => _buildTransactionItem(transaction)),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {},
          child: Text('View All Transactions', style: TextStyle(color: themeColor)),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(TransactionRecord transaction) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: transaction.isDeposit
              // ignore: deprecated_member_use
              ? themeColor.withOpacity(0.2)
              // ignore: deprecated_member_use
              : Colors.red.withOpacity(0.2),
          child: Icon(
            transaction.isDeposit ? Icons.arrow_downward : Icons.arrow_upward,
            color: transaction.isDeposit ? themeColor : Colors.red,
          ),
        ),
        title: Text(transaction.description),
        subtitle: Text(transaction.date),
        trailing: Text(
          '${transaction.isDeposit ? '+' : '-'}${currencyFormatter.format(transaction.amount)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: transaction.isDeposit ? themeColor : Colors.red,
          ),
        ),
      ),
    );
  }
}

// Data models
class SavingsGoal {
  final String name;
  final double targetAmount;
  final double currentAmount;
  final Color color;

  SavingsGoal(this.name, this.targetAmount, this.currentAmount, this.color);
}

class SavingInsight {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  SavingInsight(this.title, this.description, this.icon, this.color);
}

class TransactionRecord {
  final String description;
  final String date;
  final double amount;
  final bool isDeposit;

  TransactionRecord(this.description, this.date, this.amount, this.isDeposit);
}