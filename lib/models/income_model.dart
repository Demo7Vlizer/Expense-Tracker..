class Income {
  final String title;
  final double amount;
  final String category;
  final DateTime date;

  Income({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'amount': amount,
        'category': category,
        'date': date.toIso8601String(),
      };

  static Income fromJson(Map<String, dynamic> json) {
    return Income(
      title: json['title'],
      amount: json['amount'],
      category: json['category'],
      date: DateTime.parse(json['date']),
    );
  }
}
