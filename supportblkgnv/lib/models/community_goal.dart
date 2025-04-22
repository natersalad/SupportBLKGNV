import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityGoal {
  final String id;
  final String title;
  final String description;
  final double targetAmount;
  final double currentAmount;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> participants;

  CommunityGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetAmount,
    required this.currentAmount,
    required this.startDate,
    required this.endDate,
    required this.participants,
  });

  double get progressPercentage => currentAmount / targetAmount;
  bool get isCompleted => currentAmount >= targetAmount;
  bool get isActive =>
      DateTime.now().isBefore(endDate) && DateTime.now().isAfter(startDate);

  factory CommunityGoal.fromJson(Map<String, dynamic> json) {
    return CommunityGoal(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      targetAmount: json['targetAmount'],
      currentAmount: json['currentAmount'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      participants: List<String>.from(json['participants']),
    );
  }
  
  // Create CommunityGoal from Firestore document
  factory CommunityGoal.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return CommunityGoal(
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
      participants: List<String>.from(data['participants'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'participants': participants,
    };
  }

  Map<String, dynamic> toMap() => toJson();
}
