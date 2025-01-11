import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../views/home_page.dart';
import '../views/income_page.dart';
import '../views/expense_page.dart';
import '../models/transaction_model.dart';
import '../views/history_page.dart';
import '../services/auth_service.dart';
import '../views/calculator_page.dart';

class DrawerMenu extends StatelessWidget {
  final Function(Transaction) onAddIncome;
  final Function(Transaction) onAddExpense;
  final List<Transaction> transactions;

  DrawerMenu({
    required this.onAddIncome,
    required this.onAddExpense,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.arrow_upward),
            title: Text('Income'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IncomePage(onAddIncome: onAddIncome),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.arrow_downward),
            title: Text('Expense'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExpensePage(onAddExpense: onAddExpense),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Transaction History'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HistoryPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.calculate),
            title: Text('Calculator'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CalculatorPage(),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Provider.of<AuthService>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
