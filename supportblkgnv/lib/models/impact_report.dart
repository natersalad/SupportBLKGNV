class ImpactReport {
  final String id;
  final String title;
  final DateTime reportDate;
  final double totalSpending;
  final int totalTransactions;
  final Map<String, double> spendingByCategory;
  final List<double> monthlySpending;
  final List<String> topBusinesses;

  ImpactReport({
    required this.id,
    required this.title,
    required this.reportDate,
    required this.totalSpending,
    required this.totalTransactions,
    required this.spendingByCategory,
    required this.monthlySpending,
    required this.topBusinesses,
  });

  factory ImpactReport.fromJson(Map<String, dynamic> json) {
    return ImpactReport(
      id: json['id'],
      title: json['title'],
      reportDate: DateTime.parse(json['reportDate']),
      totalSpending: json['totalSpending'],
      totalTransactions: json['totalTransactions'],
      spendingByCategory: Map<String, double>.from(json['spendingByCategory']),
      monthlySpending: List<double>.from(json['monthlySpending']),
      topBusinesses: List<String>.from(json['topBusinesses']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'reportDate': reportDate.toIso8601String(),
      'totalSpending': totalSpending,
      'totalTransactions': totalTransactions,
      'spendingByCategory': spendingByCategory,
      'monthlySpending': monthlySpending,
      'topBusinesses': topBusinesses,
    };
  }

  Map<String, dynamic> toMap() => toJson();
}
