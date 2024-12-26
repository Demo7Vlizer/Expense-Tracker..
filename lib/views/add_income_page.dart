import 'package:flutter/material.dart';
import '../models/income_model.dart';

class AddIncomePage extends StatefulWidget {
  final Function(Income) onAddIncome;

  AddIncomePage({required this.onAddIncome});

  @override
  _AddIncomePageState createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String selectedCategory = 'Salary';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Income')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount (₹)'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              items: <String>['Salary', 'Gift', 'Other']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final income = Income(
                  title: titleController.text,
                  amount: double.parse(amountController.text),
                  category: selectedCategory,
                );
                widget.onAddIncome(income);
                Navigator.pop(context);
              },
              child: Text('Add Income'),
            ),
          ],
        ),
      ),
    );
  }
}
