class User {
  final String id;
  final String name;
  final String imageUrl;
  final String bio;
  final String accountType; // 'individual' or 'business'

  User({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.bio,
    required this.accountType,
  });

  bool get isBusiness => accountType == 'business';
} 