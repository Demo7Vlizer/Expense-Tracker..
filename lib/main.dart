// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'providers/transaction_provider.dart';
import 'views/login_page.dart';
import 'views/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final transactionProvider = TransactionProvider();
  await transactionProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider.value(value: transactionProvider),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey[800],
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
        ),
      ),
      home: FutureBuilder(
        future: Provider.of<AuthService>(context, listen: false).init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Consumer<AuthService>(
            builder: (context, authService, _) {
              return authService.isAuthenticated ? HomePage() : LoginPage();
            },
          );
        },
      ),
    );
  }
}
