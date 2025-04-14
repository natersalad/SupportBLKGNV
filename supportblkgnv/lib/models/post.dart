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
      'id': id,
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
      'id': id,
      'authorId': author.id,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'likeIds': likes.map((user) => user.id).toList(),
    };
  }

  // This is a factory constructor that won't be fully implemented yet
  // as it requires the user service to resolve user objects from IDs
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