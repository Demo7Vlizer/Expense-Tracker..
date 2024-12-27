import 'package:flutter/material.dart';
import '../models/income_model.dart';
import '../models/expense_model.dart';

class TransactionHistoryPage extends StatefulWidget {
  final List<Income> incomes;
  final List<Expense> expenses;

  TransactionHistoryPage({required this.incomes, required this.expenses});

  @override
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  String selectedFilter = 'Income'; // Default filter

  @override
  Widget build(BuildContext context) {
    // Filtered transactions based on the selected filter
    List<Income> filteredIncomes = widget.incomes;
    List<Expense> filteredExpenses = widget.expenses;

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Control
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedFilter = 'Income';
                    });
                  },
                  child: Text('Income'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedFilter = 'Expense';
                    });
                  },
                  child: Text('Expense'),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Display Transactions based on the selected filter
            if (selectedFilter == 'Income') ...[
              Text(
                'Income Transactions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredIncomes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Income: ₹${filteredIncomes[index].amount}'),
                      subtitle: Text(filteredIncomes[index].date.toString()),
                    );
                  },
                ),
              ),
            ] else ...[
              Text(
                'Expense Transactions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredExpenses.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title:
                          Text('Expense: ₹${filteredExpenses[index].amount}'),
                      subtitle: Text(filteredExpenses[index].date.toString()),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
