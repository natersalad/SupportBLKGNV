import 'package:supportblkgnv/models/user.dart';

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
} 