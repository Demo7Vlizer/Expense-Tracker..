class Transaction {
  final String id;
  final String title;
  final double amount;
  final String category;
  final bool isIncome;
  final DateTime date;
  final String? note;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.isIncome,
    required this.date,
    this.note,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: json['amount'] as double,
      category: json['category'] as String,
      isIncome: json['isIncome'] as bool,
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'isIncome': isIncome,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    bool? isIncome,
    DateTime? date,
    String? note,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      isIncome: isIncome ?? this.isIncome,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }
}
