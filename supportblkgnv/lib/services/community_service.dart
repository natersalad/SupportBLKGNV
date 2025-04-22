import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:supportblkgnv/models/user.dart';
import 'package:supportblkgnv/models/business.dart';
import 'package:supportblkgnv/models/community_goal.dart';
import 'package:supportblkgnv/models/community_impact.dart';
import 'package:supportblkgnv/services/mock_community_service.dart';

class CommunityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String goalsCollection = 'community_goals';
  final String transactionsCollection = 'transactions';
  final String impactReportsCollection = 'impact_reports';
  final String circulationGoalsCollection = 'circulation_goals';
  final String userImpactCollection = 'user_impact_stats';

  // Set to false to use real Firebase data
  final bool _devMode = false;

  // Get all community goals
  Future<List<CommunityGoal>> getCommunityGoals() async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 800));
      return MockCommunityService().getCommunityGoals();
    }

    try {
      final goalsSnapshot =
          await _firestore
              .collection(goalsCollection)
              .orderBy('endDate', descending: false)
              .get();

      List<CommunityGoal> goals = [];
      for (var doc in goalsSnapshot.docs) {
        goals.add(CommunityGoal.fromFirestore(doc));
      }

      return goals;
    } catch (e) {
      debugPrint('Error getting community goals: $e');
      return [];
    }
  }

  // Get community goal by ID
  Future<CommunityGoal?> getCommunityGoalById(String goalId) async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      final mockGoals = MockCommunityService().getCommunityGoals();
      return mockGoals.firstWhere(
        (goal) => goal.id == goalId,
        orElse: () => mockGoals.first,
      );
    }

    try {
      final doc =
          await _firestore.collection(goalsCollection).doc(goalId).get();
      if (!doc.exists) return null;

      return CommunityGoal.fromFirestore(doc);
    } catch (e) {
      debugPrint('Error getting community goal by ID: $e');
      return null;
    }
  }

  // Create a new community goal
  Future<CommunityGoal?> createCommunityGoal({
    required String title,
    required String description,
    required double targetAmount,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 800));

      final mockGoal = CommunityGoal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        targetAmount: targetAmount,
        currentAmount: 0,
        startDate: startDate,
        endDate: endDate,
        participants: [],
      );

      return mockGoal;
    }

    try {
      final goalData = {
        'title': title,
        'description': description,
        'targetAmount': targetAmount,
        'currentAmount': 0.0,
        'startDate': Timestamp.fromDate(startDate),
        'endDate': Timestamp.fromDate(endDate),
        'participants': [],
      };

      final docRef = await _firestore.collection(goalsCollection).add(goalData);
      final doc = await docRef.get();

      return CommunityGoal.fromFirestore(doc);
    } catch (e) {
      debugPrint('Error creating community goal: $e');
      return null;
    }
  }

  // Get latest community impact report
  Future<CommunityImpactReport?> getLatestImpactReport() async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 800));
      return MockCommunityService().getCommunityImpactReport();
    }

    try {
      final reportsSnapshot =
          await _firestore
              .collection(impactReportsCollection)
              .orderBy('year', descending: true)
              .orderBy('month', descending: true)
              .limit(1)
              .get();

      if (reportsSnapshot.docs.isEmpty) return null;

      final reportDoc = reportsSnapshot.docs.first;

      // Get top businesses
      final List<dynamic> topBusinessIds =
          reportDoc.data()['topBusinessIds'] ?? [];
      List<Business> topBusinesses = [];
      for (String businessId in topBusinessIds) {
        final businessDoc =
            await _firestore.collection('businesses').doc(businessId).get();
        if (businessDoc.exists) {
          final business = Business.fromFirestore(businessDoc);
          topBusinesses.add(business);
        }
      }

      // Get completed goals
      final List<dynamic> completedGoalIds =
          reportDoc.data()['completedGoalIds'] ?? [];
      List<CirculationGoal> completedGoals = [];

      // This section would be more complex in real implementation
      // We would need to get the full CirculationGoal objects
      // For this example, we'll just use an empty list

      // Get spending by category
      Map<BusinessCategory, double> spendingByCategory = {};
      final Map<String, dynamic> categorySpending =
          reportDoc.data()['spendingByCategory'] as Map<String, dynamic>? ?? {};

      categorySpending.forEach((key, value) {
        spendingByCategory[_parseBusinessCategory(key)] =
            (value as num).toDouble();
      });

      return CommunityImpactReport.fromFirestore(
        reportDoc,
        topBusinesses,
        completedGoals,
        spendingByCategory,
      );
    } catch (e) {
      debugPrint('Error getting latest impact report: $e');
      return null;
    }
  }

  // Get transactions for a user
  Future<List<Transaction>> getUserTransactions(String userId) async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 800));
      return MockCommunityService().getRecentTransactions();
    }

    try {
      final transactionsSnapshot =
          await _firestore
              .collection(transactionsCollection)
              .where('userId', isEqualTo: userId)
              .orderBy('date', descending: true)
              .get();

      // Cache for users and businesses
      Map<String, User> userCache = {};
      Map<String, Business> businessCache = {};

      List<Transaction> transactions = [];
      for (var doc in transactionsSnapshot.docs) {
        final String userId = doc.data()['userId'];
        final String businessId = doc.data()['businessId'];

        // Get user
        User user;
        if (userCache.containsKey(userId)) {
          user = userCache[userId]!;
        } else {
          final userDoc =
              await _firestore.collection('users').doc(userId).get();
          if (userDoc.exists) {
            user = User.fromFirestore(userDoc);
            userCache[userId] = user;
          } else {
            continue; // Skip if user not found
          }
        }

        // Get business
        Business business;
        if (businessCache.containsKey(businessId)) {
          business = businessCache[businessId]!;
        } else {
          final businessDoc =
              await _firestore.collection('businesses').doc(businessId).get();
          if (businessDoc.exists) {
            business = Business.fromFirestore(businessDoc);
            businessCache[businessId] = business;
          } else {
            continue; // Skip if business not found
          }
        }

        transactions.add(Transaction.fromFirestore(doc, user, business));
      }

      return transactions;
    } catch (e) {
      debugPrint('Error getting user transactions: $e');
      return [];
    }
  }

  // Get user impact stats
  Future<UserImpactStats?> getUserImpactStats(String userId) async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 800));
      return MockCommunityService().getUserImpactStats();
    }

    try {
      final statsDoc =
          await _firestore
              .collection(userImpactCollection)
              .where('userId', isEqualTo: userId)
              .get();

      if (statsDoc.docs.isEmpty) return null;

      // Get user
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return null;

      final user = User.fromFirestore(userDoc);

      // Get favorite businesses
      final List<dynamic> favoriteBusinessIds =
          statsDoc.docs.first.data()['favoriteBusinessIds'] ?? [];

      List<Business> favoriteBusinesses = [];
      for (String businessId in favoriteBusinessIds) {
        final businessDoc =
            await _firestore.collection('businesses').doc(businessId).get();
        if (businessDoc.exists) {
          favoriteBusinesses.add(Business.fromFirestore(businessDoc));
        }
      }

      return UserImpactStats.fromFirestore(
        statsDoc.docs.first,
        user,
        favoriteBusinesses,
      );
    } catch (e) {
      debugPrint('Error getting user impact stats: $e');
      return null;
    }
  }

  // Helper method to parse business category
  static BusinessCategory _parseBusinessCategory(String category) {
    switch (category.toLowerCase()) {
      case 'restaurant':
        return BusinessCategory.restaurant;
      case 'retail':
        return BusinessCategory.retail;
      case 'service':
        return BusinessCategory.service;
      case 'healthcare':
        return BusinessCategory.healthcare;
      case 'education':
        return BusinessCategory.education;
      case 'entertainment':
        return BusinessCategory.entertainment;
      default:
        return BusinessCategory.other;
    }
  }
}
