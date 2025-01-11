import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _isDarkMode = false;
  String _currency = 'USD';
  bool _enableBiometric = false;
  bool _enableNotifications = true;

  bool get isDarkMode => _isDarkMode;
  String get currency => _currency;
  bool get enableBiometric => _enableBiometric;
  bool get enableNotifications => _enableNotifications;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _currency = prefs.getString('currency') ?? 'USD';
    _enableBiometric = prefs.getBool('enableBiometric') ?? false;
    _enableNotifications = prefs.getBool('enableNotifications') ?? true;
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> setCurrency(String currency) async {
    _currency = currency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', currency);
    notifyListeners();
  }

  // Add more settings methods as needed
}
