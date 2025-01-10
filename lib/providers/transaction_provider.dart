import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';
import '../services/storage_service.dart';
import 'package:uuid/uuid.dart';

class TransactionProvider with ChangeNotifier {
  final StorageService _storageService;
  List<Transaction> _transactions = [];
  final _uuid = Uuid();

  TransactionProvider(this._storageService) {
    _loadTransactions();
  }

  List<Transaction> get transactions => [..._transactions];

  List<Transaction> get incomes =>
      _transactions.where((t) => t.isIncome).toList();

  List<Transaction> get expenses =>
      _transactions.where((t) => !t.isIncome).toList();

  double get totalIncome => incomes.fold(0, (sum, item) => sum + item.amount);

  double get totalExpense => expenses.fold(0, (sum, item) => sum + item.amount);

  Future<void> _loadTransactions() async {
    final incomeData = _storageService.getIncomes();
    final expenseData = _storageService.getExpenses();

    _transactions = [
      ...incomeData.map((e) => Transaction.fromJson(e)),
      ...expenseData.map((e) => Transaction.fromJson(e)),
    ];
    notifyListeners();
  }

  Future<void> addTransaction(
      String title, double amount, String category, bool isIncome,
      {String? note}) async {
    final transaction = Transaction(
      id: _uuid.v4(),
      title: title,
      amount: amount,
      date: DateTime.now(),
      category: category,
      isIncome: isIncome,
      note: note,
    );

    _transactions.add(transaction);
    await _saveTransactions();
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
    await _saveTransactions();
    notifyListeners();
  }

  Future<void> _saveTransactions() async {
    final incomeData = incomes.map((e) => e.toJson()).toList();
    final expenseData = expenses.map((e) => e.toJson()).toList();

    await _storageService.saveIncome(incomeData);
    await _storageService.saveExpense(expenseData);
  }
}
