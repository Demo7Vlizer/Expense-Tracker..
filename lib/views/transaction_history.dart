import 'package:flutter/material.dart';
import '../models/income_model.dart';
import '../models/expense_model.dart';

class TransactionHistoryPage extends StatelessWidget {
  final List<Income> incomes;
  final List<Expense> expenses;

  TransactionHistoryPage({required this.incomes, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: ListView.builder(
        itemCount: incomes.length + expenses.length,
        itemBuilder: (context, index) {
          if (index < incomes.length) {
            final income = incomes[index];
            return ListTile(
              title: Text('Income: ₹${income.amount}'),
              subtitle: Text(income.date.toString()),
            );
          } else {
            final expense = expenses[index - incomes.length];
            return ListTile(
              title: Text('Expense: ₹${expense.amount}'),
              subtitle: Text(expense.date.toString()),
            );
          }
        },
      ),
    );
  }
}
