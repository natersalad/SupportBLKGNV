import 'package:supportblkgnv/models/user.dart';
import 'package:supportblkgnv/models/business.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      'userId': user.id,
      'businessId': business.id,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'description': description,
      'items': items,
      'type': type.toString().split('.').last,
      'isVerified': isVerified,
    };
  }
  
  factory Transaction.fromFirestore(DocumentSnapshot doc, User user, Business business) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Transaction(
      id: doc.id,
      user: user,
      business: business,
      amount: (data['amount'] ?? 0.0).toDouble(),
      date: data['date'] is Timestamp ? (data['date'] as Timestamp).toDate() : DateTime.now(),
      description: data['description'],
      items: data['items'] != null ? List<String>.from(data['items']) : null,
      type: _parseTransactionType(data['type'] ?? 'other'),
      isVerified: data['isVerified'] ?? false,
    );
  }
  
  static TransactionType _parseTransactionType(String typeStr) {
    switch (typeStr.toLowerCase()) {
      case 'purchase': return TransactionType.purchase;
      case 'donation': return TransactionType.donation;
      case 'service': return TransactionType.service;
      case 'subscription': return TransactionType.subscription;
      default: return TransactionType.other;
    }
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
      'title': title,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'participantIds': participants.map((u) => u.id).toList(),
      'creatorId': creator.id,
      'focusedBusinessIds': focusedBusinesses.map((b) => b.id).toList(),
      'focusedCategories': focusedCategories.map((c) => c.toString().split('.').last).toList(),
    };
  }
  
  factory CirculationGoal.fromFirestore(
    DocumentSnapshot doc, 
    User creator, 
    List<User> participants,
    List<Business> businesses) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return CirculationGoal(
      id: doc.id,
      title: data['title'] ?? 'Untitled Goal',
      description: data['description'] ?? '',
      targetAmount: (data['targetAmount'] ?? 0.0).toDouble(),
      currentAmount: (data['currentAmount'] ?? 0.0).toDouble(),
      startDate: data['startDate'] is Timestamp 
        ? (data['startDate'] as Timestamp).toDate() 
        : DateTime.now(),
      endDate: data['endDate'] is Timestamp 
        ? (data['endDate'] as Timestamp).toDate() 
        : DateTime.now().add(const Duration(days: 30)),
      participants: participants,
      creator: creator,
      focusedBusinesses: businesses,
      focusedCategories: _parseBusinessCategories(data['focusedCategories'] ?? []),
    );
  }
  
  static List<BusinessCategory> _parseBusinessCategories(List<dynamic> categories) {
    List<BusinessCategory> result = [];
    for (var category in categories) {
      result.add(_parseBusinessCategory(category.toString()));
    }
    return result;
  }
  
  static BusinessCategory _parseBusinessCategory(String category) {
    switch (category.toLowerCase()) {
      case 'restaurant': return BusinessCategory.restaurant;
      case 'retail': return BusinessCategory.retail;
      case 'service': return BusinessCategory.service;
      case 'healthcare': return BusinessCategory.healthcare;
      case 'education': return BusinessCategory.education;
      case 'entertainment': return BusinessCategory.entertainment;
      default: return BusinessCategory.other;
    }
  }
}

class CommunityImpactReport {
  final String id;
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
    required this.id,
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
        (key, value) => MapEntry(key.toString().split('.').last, value),
      ),
      'topBusinessIds': topBusinesses.map((b) => b.id).toList(),
      'percentIncrease': percentIncrease,
      'activeParticipants': activeParticipants,
      'completedGoalIds': completedGoals.map((goal) => goal.id).toList(),
      'economicMultiplier': economicMultiplier,
      'monthlyTrendData': monthlyTrendData.map((data) => data.toMap()).toList(),
    };
  }
  
  factory CommunityImpactReport.fromFirestore(
    DocumentSnapshot doc,
    List<Business> topBusinesses,
    List<CirculationGoal> completedGoals,
    Map<BusinessCategory, double> spendingByCategory) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return CommunityImpactReport(
      id: doc.id,
      month: data['month'] ?? '',
      year: data['year'] ?? DateTime.now().year,
      totalSpending: (data['totalSpending'] ?? 0.0).toDouble(),
      totalTransactions: data['totalTransactions'] ?? 0,
      spendingByCategory: spendingByCategory,
      topBusinesses: topBusinesses,
      percentIncrease: (data['percentIncrease'] ?? 0.0).toDouble(),
      activeParticipants: data['activeParticipants'] ?? 0,
      completedGoals: completedGoals,
      economicMultiplier: (data['economicMultiplier'] ?? 1.0).toDouble(),
      monthlyTrendData: _parseChartDataPoints(data['monthlyTrendData'] ?? []),
    );
  }
  
  static List<ChartDataPoint> _parseChartDataPoints(List<dynamic> data) {
    List<ChartDataPoint> result = [];
    for (var point in data) {
      if (point is Map<String, dynamic>) {
        try {
          DateTime date;
          if (point['date'] is Timestamp) {
            date = (point['date'] as Timestamp).toDate();
          } else if (point['date'] is String) {
            date = DateTime.parse(point['date']);
          } else {
            date = DateTime.now();
          }
          
          result.add(ChartDataPoint(
            date: date,
            value: (point['value'] ?? 0.0).toDouble(),
          ));
        } catch (e) {
          print('Error parsing chart data point: $e');
        }
      }
    }
    return result;
  }
}

class ChartDataPoint {
  final DateTime date;
  final double value;

  ChartDataPoint({required this.date, required this.value});

  Map<String, dynamic> toMap() {
    return {'date': Timestamp.fromDate(date), 'value': value};
  }
  
  factory ChartDataPoint.fromFirestore(Map<String, dynamic> data) {
    DateTime date;
    if (data['date'] is Timestamp) {
      date = (data['date'] as Timestamp).toDate();
    } else if (data['date'] is String) {
      date = DateTime.parse(data['date']);
    } else {
      date = DateTime.now();
    }
    
    return ChartDataPoint(
      date: date,
      value: (data['value'] ?? 0.0).toDouble(),
    );
  }
}

class UserImpactStats {
  final String id;
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
    required this.id,
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
      'userId': user.id,
      'totalSpent': totalSpent,
      'transactionCount': transactionCount,
      'averageTransaction': averageTransaction,
      'favoriteBusinessIds': favoriteBusinesses.map((b) => b.id).toList(),
      'topCategory': topCategory.toString().split('.').last,
      'goalsContributed': goalsContributed,
      'consecutiveWeeks': consecutiveWeeks,
      'impactScore': impactScore,
    };
  }
  
  factory UserImpactStats.fromFirestore(
    DocumentSnapshot doc,
    User user,
    List<Business> favoriteBusinesses) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return UserImpactStats(
      id: doc.id,
      user: user,
      totalSpent: (data['totalSpent'] ?? 0.0).toDouble(),
      transactionCount: data['transactionCount'] ?? 0,
      averageTransaction: (data['averageTransaction'] ?? 0.0).toDouble(),
      favoriteBusinesses: favoriteBusinesses,
      topCategory: _parseBusinessCategory(data['topCategory'] ?? 'other'),
      goalsContributed: data['goalsContributed'] ?? 0,
      consecutiveWeeks: data['consecutiveWeeks'] ?? 0,
      impactScore: (data['impactScore'] ?? 0.0).toDouble(),
    );
  }
  
  static BusinessCategory _parseBusinessCategory(String category) {
    switch (category.toLowerCase()) {
      case 'restaurant': return BusinessCategory.restaurant;
      case 'retail': return BusinessCategory.retail;
      case 'service': return BusinessCategory.service;
      case 'healthcare': return BusinessCategory.healthcare;
      case 'education': return BusinessCategory.education;
      case 'entertainment': return BusinessCategory.entertainment;
      default: return BusinessCategory.other;
    }
  }
}
