import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction_model.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _filter = 'all';
  final _dateFormat = DateFormat('MMM dd, yyyy');
  final _currencyFormat = NumberFormat.currency(symbol: '₹');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: Consumer<TransactionProvider>(
              builder: (context, provider, child) {
                final transactions = _getFilteredTransactions(provider);
                if (transactions.isEmpty) {
                  return Center(
                    child: Text('No transactions found'),
                  );
                }
                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    return _buildTransactionItem(transactions[index], provider);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        children: [
          _buildFilterChip('All', 'all'),
          _buildFilterChip('Income', 'income'),
          _buildFilterChip('Expense', 'expense'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return FilterChip(
      label: Text(label),
      selected: _filter == value,
      onSelected: (selected) {
        setState(() {
          _filter = value;
        });
      },
    );
  }

  List<Transaction> _getFilteredTransactions(TransactionProvider provider) {
    switch (_filter) {
      case 'income':
        return provider.incomes;
      case 'expense':
        return provider.expenses;
      default:
        return provider.transactions;
    }
  }

  Widget _buildTransactionItem(
      Transaction transaction, TransactionProvider provider) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => provider.deleteTransaction(transaction.id),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              transaction.isIncome ? Colors.green[100] : Colors.red[100],
          child: Icon(
            transaction.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: transaction.isIncome ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          transaction.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${transaction.category} • ${_dateFormat.format(transaction.date)}',
        ),
        trailing: Text(
          _currencyFormat.format(transaction.amount),
          style: TextStyle(
            color: transaction.isIncome ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
