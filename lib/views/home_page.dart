// lib/views/home_page.dart
import 'package:flutter/material.dart';
import 'income_page.dart';
import 'expense_page.dart';
import '../services/auth_service.dart';
import '../widgets/drawer_menu.dart';
import '../models/income_model.dart';
import '../models/expense_model.dart';

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Remaining Balance: ₹${remainingBalance.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            Text('Total Income: ₹${totalIncome.toStringAsFixed(2)}'),
            Text('Total Expense: ₹${totalExpense.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IncomePage(onAddIncome: addIncome),
                  ),
                );
              },
              child: Text('Add Income'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpensePage(onAddExpense: addExpense),
                  ),
                );
              },
              child: Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
