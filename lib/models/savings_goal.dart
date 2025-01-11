class SavingsGoal {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final String icon;

  SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.icon,
  });

  double get progressPercentage => (currentAmount / targetAmount) * 100;
  bool get isAchieved => currentAmount >= targetAmount;
}
