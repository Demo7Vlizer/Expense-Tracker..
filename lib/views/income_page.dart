import 'package:flutter/material.dart';
import 'add_income_page.dart';
import '../models/transaction_model.dart';

class IncomePage extends StatelessWidget {
  final Function(Transaction) onAddIncome;

  IncomePage({required this.onAddIncome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Income Tracker'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Track your income here!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddIncomePage(onAddIncome: onAddIncome),
                  ),
                );
              },
              child: Text('Add Income'),
            ),
          ],
        ),
      ),
    );
  }
}
