// lib/views/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import 'add_income_page.dart';
import 'expense_page.dart';
import 'history_page.dart';

class HomePage extends StatelessWidget {
  final _currencyFormat = NumberFormat.currency(symbol: '₹');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<TransactionProvider>(
          builder: (context, provider, child) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 180,
                  floating: true,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildHeader(context, provider),
                  ),
                  title: Text('My Finances'),
                ),
                SliverToBoxAdapter(
                  child: _buildQuickActions(context),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == 0) {
                        return _buildRecentTransactionsHeader(
                            context, provider);
                      }
                      final transactions =
                          provider.transactions.take(5).toList();
                      if (transactions.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Text(
                              'No transactions yet',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }
                      final transaction = transactions[index - 1];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: transaction.isIncome
                              ? Colors.green[100]
                              : Colors.red[100],
                          child: Icon(
                            transaction.isIncome
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: transaction.isIncome
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        title: Text(
                          transaction.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(transaction.category),
                        trailing: Text(
                          _currencyFormat.format(transaction.amount),
                          style: TextStyle(
                            color: transaction.isIncome
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    childCount: provider.transactions.isEmpty
                        ? 2
                        : provider.transactions.take(5).length + 1,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TransactionProvider provider) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue, Colors.blue.shade800],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          Text(
            _currencyFormat
                .format(provider.totalIncome - provider.totalExpense),
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              _buildBalanceCard(
                'Income',
                provider.totalIncome,
                Colors.green,
              ),
              SizedBox(width: 16),
              _buildBalanceCard(
                'Expense',
                provider.totalExpense,
                Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(String title, double amount, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _currencyFormat.format(amount),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                context,
                'Add Income',
                Icons.arrow_downward,
                Colors.green,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddIncomePage(
                      onAddIncome: (income) {
                        provider.addTransaction(
                          income.title,
                          income.amount,
                          income.category,
                          true,
                        );
                      },
                    ),
                  ),
                ),
              ),
              _buildActionButton(
                context,
                'Add Expense',
                Icons.arrow_upward,
                Colors.red,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExpensePage(
                      onAddExpense: (expense) {
                        provider.addTransaction(
                          expense.title,
                          expense.amount,
                          expense.category,
                          false,
                        );
                      },
                    ),
                  ),
                ),
              ),
              _buildActionButton(
                context,
                'History',
                Icons.history,
                Colors.blue,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HistoryPage()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsHeader(
    BuildContext context,
    TransactionProvider provider,
  ) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Transactions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HistoryPage()),
            ),
            child: Text('See All'),
          ),
        ],
      ),
    );
  }
}
