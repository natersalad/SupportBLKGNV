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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'participants': participants,
    };
  }

  Map<String, dynamic> toMap() => toJson();
}
