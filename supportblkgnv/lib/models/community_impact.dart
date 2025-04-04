import 'package:supportblkgnv/models/user.dart';
import 'package:supportblkgnv/models/business.dart';

class Transaction {
  final String id;
  final User user;
  final Business business;
  final double amount;
  final DateTime date;
  final String? description;
  final List<String>? items;
  final TransactionType type;
  final bool isVerified;

  Transaction({
    required this.id,
    required this.user,
    required this.business,
    required this.amount,
    required this.date,
    this.description,
    this.items,
    required this.type,
    this.isVerified = false,
  });
}

enum TransactionType {
  purchase,
  donation,
  service,
  subscription,
  other
}

class CirculationGoal {
  final String id;
  final String title;
  final String description;
  final double targetAmount;
  final double currentAmount;
  final DateTime startDate;
  final DateTime endDate;
  final List<User> participants;
  final User creator;
  final List<Business> focusedBusinesses;
  final List<BusinessCategory> focusedCategories;

  CirculationGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetAmount,
    this.currentAmount = 0.0,
    required this.startDate,
    required this.endDate,
    this.participants = const [],
    required this.creator,
    this.focusedBusinesses = const [],
    this.focusedCategories = const [],
  });

  double get progressPercentage => (currentAmount / targetAmount) * 100;
  bool get isCompleted => currentAmount >= targetAmount;
  bool get isActive => DateTime.now().isAfter(startDate) && DateTime.now().isBefore(endDate);
  bool get isExpired => DateTime.now().isAfter(endDate) && !isCompleted;
  int get daysRemaining => endDate.difference(DateTime.now()).inDays;
}

class CommunityImpactReport {
  final String month;
  final int year;
  final double totalSpending;
  final int totalTransactions;
  final Map<BusinessCategory, double> spendingByCategory;
  final List<Business> topBusinesses;
  final double percentIncrease;
  final int activeParticipants;
  final List<CirculationGoal> completedGoals;
  final double economicMultiplier;
  final List<ChartDataPoint> monthlyTrendData;

  CommunityImpactReport({
    required this.month,
    required this.year,
    required this.totalSpending,
    required this.totalTransactions,
    required this.spendingByCategory,
    required this.topBusinesses,
    required this.percentIncrease,
    required this.activeParticipants,
    required this.completedGoals,
    required this.economicMultiplier,
    required this.monthlyTrendData,
  });
}

class ChartDataPoint {
  final DateTime date;
  final double value;
  
  ChartDataPoint({
    required this.date,
    required this.value,
  });
}

class UserImpactStats {
  final User user;
  final double totalSpent;
  final int transactionCount;
  final double averageTransaction;
  final List<Business> favoriteBusinesses;
  final BusinessCategory topCategory;
  final int goalsContributed;
  final int consecutiveWeeks;
  final double impactScore;
  
  UserImpactStats({
    required this.user,
    required this.totalSpent,
    required this.transactionCount,
    required this.averageTransaction,
    required this.favoriteBusinesses,
    required this.topCategory,
    required this.goalsContributed,
    required this.consecutiveWeeks,
    required this.impactScore,
  });
} 