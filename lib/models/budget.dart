class Budget {
  final String id;
  final String category;
  final double limit;
  final double spent;
  final DateTime startDate;
  final DateTime endDate;
  final bool isAlertSent;
  final bool isRecurring;
  final String recurringPeriod; // monthly, weekly, yearly

  Budget({
    required this.id,
    required this.category,
    required this.limit,
    required this.spent,
    required this.startDate,
    required this.endDate,
    this.isAlertSent = false,
    this.isRecurring = false,
    this.recurringPeriod = 'monthly',
  });

  double get remainingAmount => limit - spent;
  double get percentageUsed => (spent / limit) * 100;
  bool get isOverBudget => spent > limit;

  Budget copyWith({
    String? id,
    String? category,
    double? limit,
    double? spent,
    DateTime? startDate,
    DateTime? endDate,
    bool? isAlertSent,
    bool? isRecurring,
    String? recurringPeriod,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      limit: limit ?? this.limit,
      spent: spent ?? this.spent,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isAlertSent: isAlertSent ?? this.isAlertSent,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringPeriod: recurringPeriod ?? this.recurringPeriod,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'limit': limit,
      'spent': spent,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isAlertSent': isAlertSent,
      'isRecurring': isRecurring,
      'recurringPeriod': recurringPeriod,
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      category: json['category'],
      limit: json['limit'],
      spent: json['spent'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isAlertSent: json['isAlertSent'],
      isRecurring: json['isRecurring'],
      recurringPeriod: json['recurringPeriod'],
    );
  }
}
