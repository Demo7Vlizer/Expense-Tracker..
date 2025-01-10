import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _incomeKey = 'income_data';
  static const String _expenseKey = 'expense_data';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<void> saveIncome(List<Map<String, dynamic>> incomes) async {
    await _prefs.setString(_incomeKey, jsonEncode(incomes));
  }

  Future<void> saveExpense(List<Map<String, dynamic>> expenses) async {
    await _prefs.setString(_expenseKey, jsonEncode(expenses));
  }

  List<Map<String, dynamic>> getIncomes() {
    final String? data = _prefs.getString(_incomeKey);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  List<Map<String, dynamic>> getExpenses() {
    final String? data = _prefs.getString(_expenseKey);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  Future<void> clearAll() async {
    await _prefs.remove(_incomeKey);
    await _prefs.remove(_expenseKey);
  }
}
