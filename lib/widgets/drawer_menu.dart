import 'package:flutter/material.dart';
import '../views/home_page.dart';
import '../views/income_page.dart';
import '../views/expense_page.dart';
import '../models/income_model.dart';
import '../models/expense_model.dart';

class DrawerMenu extends StatelessWidget {
  final Function(Income) onAddIncome;
  final Function(Expense) onAddExpense;

  DrawerMenu({required this.onAddIncome, required this.onAddExpense});

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
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          ListTile(
            title: Text('Income'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => IncomePage(onAddIncome: onAddIncome),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Expense'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ExpensePage(onAddExpense: onAddExpense),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
  }
}
