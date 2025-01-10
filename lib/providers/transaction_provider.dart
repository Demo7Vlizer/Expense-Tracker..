import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  DateTime? _lastModified;
  List<String> _categories = [
    'Salary',
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Others'
  ];

  TransactionProvider() {
    init();
  }

  List<Transaction> get transactions => _transactions;
  List<Transaction> get incomes =>
      _transactions.where((t) => t.isIncome).toList();
  List<Transaction> get expenses =>
      _transactions.where((t) => !t.isIncome).toList();
  List<String> get categories => _categories;
  DateTime? get lastModified => _lastModified;

  double get totalIncome => _transactions
      .where((t) => t.isIncome)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => !t.isIncome)
      .fold(0, (sum, t) => sum + t.amount);

  // Initialize from SharedPreferences
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    // Load transactions
    final transactionsJson = prefs.getStringList('transactions') ?? [];
    _transactions = transactionsJson
        .map((json) => Transaction.fromJson(jsonDecode(json)))
        .toList();

    // Load categories
    _categories = prefs.getStringList('categories') ?? _categories;

    // Load last modified
    final lastModifiedStr = prefs.getString('last_modified');
    if (lastModifiedStr != null) {
      _lastModified = DateTime.parse(lastModifiedStr);
    }

    notifyListeners();
  }

  // Add a new transaction
  Future<void> addTransaction(
    String title,
    double amount,
    String category,
    bool isIncome, {
    String? note,
  }) async {
    final transaction = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      category: category,
      isIncome: isIncome,
      date: DateTime.now(),
      note: note,
    );

    _transactions.insert(0, transaction);
    _lastModified = DateTime.now();
    await _saveTransactions();
    notifyListeners();
  }

  // Delete a transaction
  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
    _lastModified = DateTime.now();
    await _saveTransactions();
    notifyListeners();
  }

  // Add a new category
  Future<void> addCategory(String category) async {
    if (!_categories.contains(category)) {
      _categories.add(category);
      await _saveCategories();
      notifyListeners();
    }
  }

  // Remove a category
  Future<void> removeCategory(String category) async {
    if (_categories.contains(category)) {
      _categories.remove(category);
      await _saveCategories();
      notifyListeners();
    }
  }

  // Clear all data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _transactions = [];
    _categories = [
      'Salary',
      'Food',
      'Transport',
      'Shopping',
      'Bills',
      'Entertainment',
      'Others'
    ];
    _lastModified = null;
    notifyListeners();
  }

  // Export data as JSON string
  String exportData() {
    return jsonEncode({
      'transactions': _transactions.map((t) => t.toJson()).toList(),
      'categories': _categories,
      'last_modified': _lastModified?.toIso8601String(),
    });
  }

  // Import data from JSON string
  Future<void> importData(String jsonString) async {
    try {
      final data = jsonDecode(jsonString);
      _transactions = (data['transactions'] as List)
          .map((t) => Transaction.fromJson(t))
          .toList();
      _categories = List<String>.from(data['categories']);
      _lastModified = data['last_modified'] != null
          ? DateTime.parse(data['last_modified'])
          : DateTime.now();
      await _saveEverything();
      notifyListeners();
    } catch (e) {
      print('Error importing data: $e');
      throw Exception('Invalid data format');
    }
  }

  // Save transactions to SharedPreferences
  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson =
        _transactions.map((t) => jsonEncode(t.toJson())).toList();
    await prefs.setStringList('transactions', transactionsJson);
    await prefs.setString('last_modified', DateTime.now().toIso8601String());
  }

  // Save categories to SharedPreferences
  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('categories', _categories);
  }

  // Save everything to SharedPreferences
  Future<void> _saveEverything() async {
    await _saveTransactions();
    await _saveCategories();
  }

  // Get transactions for a specific date range
  List<Transaction> getTransactionsForDateRange(DateTime start, DateTime end) {
    return _transactions.where((t) {
      return t.date.isAfter(start.subtract(Duration(days: 1))) &&
          t.date.isBefore(end.add(Duration(days: 1)));
    }).toList();
  }

  // Get total for a specific category
  double getTotalForCategory(String category, {bool? isIncome}) {
    return _transactions
        .where((t) =>
            t.category == category &&
            (isIncome == null || t.isIncome == isIncome))
        .fold(0, (sum, t) => sum + t.amount);
  }
}
