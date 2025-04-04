import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String? imageUrl;
  final String bio;
  final String accountType; // 'individual' or 'business'

  User({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.bio,
    required this.accountType,
  });

  bool get isBusiness => accountType == 'business';
  
  // Convert User to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'bio': bio,
      'accountType': accountType,
    };
  }
  
  // Create User from Firestore document
  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return User(
      id: doc.id,
      name: data['name'] ?? 'Unknown',
      imageUrl: data['imageUrl'],
      bio: data['bio'] ?? '',
      accountType: data['accountType'] ?? 'individual',
    );
  }
  
  // Create User from Map
  factory User.fromMap(Map<String, dynamic> map, String id) {
    return User(
      id: id,
      name: map['name'] ?? 'Unknown',
      imageUrl: map['imageUrl'],
      bio: map['bio'] ?? '',
      accountType: map['accountType'] ?? 'individual',
    );
  }
} 