import 'package:supportblkgnv/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final User user;
  final String text;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.user,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': user.id,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static Comment fromMap(Map<String, dynamic> map, User user) {
    return Comment(
      id: map['id'],
      user: user,
      text: map['text'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
  
  factory Comment.fromFirestore(DocumentSnapshot doc, User user) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Comment(
      id: doc.id,
      user: user,
      text: data['text'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}

class Post {
  final String id;
  final User author;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final List<User> likes;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.author,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.likes,
    required this.comments,
  });

  Map<String, dynamic> toMap() {
    return {
      'authorId': author.id,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'likeIds': likes.map((user) => user.id).toList(),
      // Comments are stored in a subcollection, not in the post document
    };
  }

  // Create Post from Firestore document
  factory Post.fromFirestore(
    DocumentSnapshot doc, 
    User author, 
    List<User> likes,
    List<Comment> comments
  ) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Post(
      id: doc.id,
      author: author,
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'],
      createdAt: data['createdAt'] is Timestamp 
        ? (data['createdAt'] as Timestamp).toDate() 
        : DateTime.now(),
      likes: likes,
      comments: comments,
    );
  }

  // This factory method is kept for backwards compatibility
  static Future<Post> fromMap(
    Map<String, dynamic> map, 
    User author, 
    List<User> likeUsers,
    List<Comment> resolvedComments
  ) async {
    return Post(
      id: map['id'],
      author: author,
      content: map['content'],
      imageUrl: map['imageUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      likes: likeUsers,
      comments: resolvedComments,
    );
  }
} 