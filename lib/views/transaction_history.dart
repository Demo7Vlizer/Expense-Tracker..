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
                  },
                  child: Text('Income'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[200],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Logic to show expense transactions
                  },
                  child: Text('Expense'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[200],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Income Transactions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // List of income transactions
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
            // Similar section for expenses can be added here
          ],
        ),
      ),
    );
  }
}
