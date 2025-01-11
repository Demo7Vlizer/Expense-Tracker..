import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/budget.dart';
import '../services/notification_service.dart';

class BudgetProvider with ChangeNotifier {
  List<Budget> _budgets = [];
  final NotificationService _notificationService;

  BudgetProvider(this._notificationService);

  List<Budget> get budgets => _budgets;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final budgetData = prefs.getStringList('budgets') ?? [];
    _budgets =
        budgetData.map((data) => Budget.fromJson(jsonDecode(data))).toList();
    _checkBudgetAlerts();
    notifyListeners();
  }

  Future<void> addBudget(Budget budget) async {
    _budgets.add(budget);
    await _saveBudgets();
    _scheduleNotification(budget);
    notifyListeners();
  }

  Future<void> updateBudgetSpending(String budgetId, double amount) async {
    final budgetIndex = _budgets.indexWhere((b) => b.id == budgetId);
    if (budgetIndex != -1) {
      final updatedBudget = _budgets[budgetIndex]
          .copyWith(spent: _budgets[budgetIndex].spent + amount);
      _budgets[budgetIndex] = updatedBudget;

      if (updatedBudget.percentageUsed >= 80 && !updatedBudget.isAlertSent) {
        _notificationService.showBudgetAlert(updatedBudget.category,
            updatedBudget.percentageUsed.toStringAsFixed(1));
        _budgets[budgetIndex] = updatedBudget.copyWith(isAlertSent: true);
      }

      await _saveBudgets();
      notifyListeners();
    }
  }

  void _checkBudgetAlerts() {
    for (var budget in _budgets) {
      if (budget.percentageUsed >= 80 && !budget.isAlertSent) {
        _scheduleNotification(budget);
      }
    }
  }

  void _scheduleNotification(Budget budget) {
    if (budget.percentageUsed >= 80) {
      _notificationService.showBudgetAlert(
          budget.category, budget.percentageUsed.toStringAsFixed(1));
    }
  }

  Future<void> _saveBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    final budgetData = _budgets.map((b) => jsonEncode(b.toJson())).toList();
    await prefs.setStringList('budgets', budgetData);
  }
}
