import 'package:flutter/material.dart';

class NotificationService {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void showBudgetAlert(String category, String percentage) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('You have used $percentage% of your $category budget'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'VIEW',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to budget details
          },
        ),
      ),
    );
  }

  void scheduleRecurringReminder() {
    // This can be implemented later with a different approach
  }
}
