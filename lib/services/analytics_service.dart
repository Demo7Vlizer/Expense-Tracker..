import '../models/transaction_model.dart';

class AnalyticsService {
  List<Map<String, dynamic>> getCategoryBreakdown(
      List<Transaction> transactions) {
    Map<String, double> categoryTotals = {};

    for (var transaction in transactions) {
      if (categoryTotals.containsKey(transaction.category)) {
        categoryTotals[transaction.category] =
            categoryTotals[transaction.category]! + transaction.amount;
      } else {
        categoryTotals[transaction.category] = transaction.amount;
      }
    }

    return categoryTotals.entries
        .map((e) => {
              'category': e.key,
              'amount': e.value,
              'percentage': (e.value /
                      transactions.fold(
                          0.0, (sum, item) => sum + item.amount)) *
                  100,
            })
        .toList();
  }

  Map<String, dynamic> getMonthlyComparison(List<Transaction> transactions) {
    final now = DateTime.now();
    final currentMonth = transactions
        .where((t) => t.date.month == now.month && t.date.year == now.year);
    final lastMonth = transactions.where(
        (t) => t.date.month == (now.month - 1) && t.date.year == now.year);

    return {
      'currentMonth': _calculateMonthlyStats(currentMonth.toList()),
      'lastMonth': _calculateMonthlyStats(lastMonth.toList()),
      'changePercentage': _calculateChangePercentage(
        currentMonth.toList(),
        lastMonth.toList(),
      ),
    };
  }

  Map<String, double> _calculateMonthlyStats(List<Transaction> transactions) {
    final income = transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
    final expenses = transactions
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);

    return {
      'income': income,
      'expenses': expenses,
      'savings': income - expenses,
    };
  }

  double _calculateChangePercentage(
      List<Transaction> current, List<Transaction> previous) {
    final currentTotal = current.fold(0.0, (sum, t) => sum + t.amount);
    final previousTotal = previous.fold(0.0, (sum, t) => sum + t.amount);

    if (previousTotal == 0) return 0;
    return ((currentTotal - previousTotal) / previousTotal) * 100;
  }
}
