import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class IncomeExpenseChart extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;

  IncomeExpenseChart({required this.totalIncome, required this.totalExpense});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: totalIncome,
            color: Colors.green,
            title: 'Income',
          ),
          PieChartSectionData(
            value: totalExpense,
            color: Colors.red,
            title: 'Expense',
          ),
        ],
      ),
    );
  }
}
