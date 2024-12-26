// lib/views/home_page.dart
import 'package:flutter/material.dart';
import 'add_income_page.dart';
import 'add_expense_page.dart';
import '../services/auth_service.dart';
import '../widgets/drawer_menu.dart';
import '../models/income_model.dart';
import '../models/expense_model.dart';
import 'transaction_history.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Income> incomes = [];
  List<Expense> expenses = [];

  double get totalIncome => incomes.fold(0, (sum, item) => sum + item.amount);
  double get totalExpense => expenses.fold(0, (sum, item) => sum + item.amount);
  double get remainingBalance => totalIncome - totalExpense;

  void addIncome(Income income) {
    setState(() {
      incomes.add(income);
    });
  }

  void addExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
    });
  }

  void _showAddIncomeSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddIncomePage(onAddIncome: addIncome);
      },
    );
  }

  void _showAddExpenseSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddExpensePage(onAddExpense: addExpense);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      drawer: DrawerMenu(
        onAddIncome: addIncome,
        onAddExpense: addExpense,
        incomes: incomes,
        expenses: expenses,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dashboard Cards
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Remaining Balance', style: TextStyle(fontSize: 18)),
                    Text('₹${remainingBalance.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Total Income', style: TextStyle(fontSize: 18)),
                    Text('₹${totalIncome.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Total Expense', style: TextStyle(fontSize: 18)),
                    Text('₹${totalExpense.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: TransactionHistoryPage(
                incomes: incomes,
                expenses: expenses,
              ),
            ),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _showAddIncomeSheet,
                  icon: Icon(Icons.add),
                  label: Text('Add Income'),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddExpenseSheet,
                  icon: Icon(Icons.remove),
                  label: Text('Add Expense'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionHistoryPage(
                      incomes: incomes,
                      expenses: expenses,
                    ),
                  ),
                );
              },
              child: Text('View Transaction History'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            _showAddIncomeSheet, // You can also use this for adding expenses
        child: Icon(Icons.add),
        tooltip: 'Add Income',
      ),
    );
  }
}
