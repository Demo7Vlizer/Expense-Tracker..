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
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Logic to show income transactions
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IncomeListView(incomes: incomes),
                      ),
                    );
                  },
                  child: Text('Income'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[200],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Logic to show expense transactions
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ExpenseListView(expenses: expenses),
                      ),
                    );
                  },
                  child: Text('Expense'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[200],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Display income transactions by default
            Text(
              'Income Transactions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: incomes.length,
                itemBuilder: (context, index) {
                  final income = incomes[index];
                  return Card(
                    color: Colors.lightBlue[100],
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(income.title),
                      subtitle: Text('₹${income.amount.toStringAsFixed(2)}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// New widget to display income transactions
class IncomeListView extends StatelessWidget {
  final List<Income> incomes;

  IncomeListView({required this.incomes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Income Transactions'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: incomes.length,
        itemBuilder: (context, index) {
          final income = incomes[index];
          return Card(
            color: Colors.lightBlue[100],
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(income.title),
              subtitle: Text('₹${income.amount.toStringAsFixed(2)}'),
            ),
          );
        },
      ),
    );
  }
}

// New widget to display expense transactions
class ExpenseListView extends StatelessWidget {
  final List<Expense> expenses;

  ExpenseListView({required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Transactions'),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final expense = expenses[index];
          return Card(
            color: Colors.red[100],
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(expense.title),
              subtitle: Text('₹${expense.amount.toStringAsFixed(2)}'),
            ),
          );
        },
      ),
    );
  }
}
