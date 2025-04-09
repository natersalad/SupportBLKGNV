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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user.toMap(),
      'business': business.toMap(),
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'items': items,
      'type': type.toString(),
      'isVerified': isVerified,
    };
  }
}

enum TransactionType { purchase, donation, service, subscription, other }

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
  bool get isActive =>
      DateTime.now().isAfter(startDate) && DateTime.now().isBefore(endDate);
  bool get isExpired => DateTime.now().isAfter(endDate) && !isCompleted;
  int get daysRemaining => endDate.difference(DateTime.now()).inDays;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'participants': participants.map((u) => u.toMap()).toList(),
      'creator': creator.toMap(),
      'focusedBusinesses': focusedBusinesses.map((b) => b.toMap()).toList(),
      'focusedCategories': focusedCategories.map((c) => c.toString()).toList(),
    };
  }
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

  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'year': year,
      'totalSpending': totalSpending,
      'totalTransactions': totalTransactions,
      'spendingByCategory': spendingByCategory.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
      'topBusinesses': topBusinesses.map((b) => b.toMap()).toList(),
      'percentIncrease': percentIncrease,
      'activeParticipants': activeParticipants,
      'completedGoals': completedGoals.map((goal) => goal.toMap()).toList(),
      'economicMultiplier': economicMultiplier,
      'monthlyTrendData': monthlyTrendData.map((data) => data.toMap()).toList(),
    };
  }
}

class ChartDataPoint {
  final DateTime date;
  final double value;

  ChartDataPoint({required this.date, required this.value});

  Map<String, dynamic> toMap() {
    return {'date': date.toIso8601String(), 'value': value};
  }
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

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'totalSpent': totalSpent,
      'transactionCount': transactionCount,
      'averageTransaction': averageTransaction,
      'favoriteBusinesses': favoriteBusinesses.map((b) => b.toMap()).toList(),
      'topCategory': topCategory.toString(),
      'goalsContributed': goalsContributed,
      'consecutiveWeeks': consecutiveWeeks,
      'impactScore': impactScore,
    };
  }
}
