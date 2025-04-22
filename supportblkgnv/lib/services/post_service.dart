import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:supportblkgnv/models/post.dart';
import 'package:supportblkgnv/models/user.dart';
import 'package:supportblkgnv/services/mock_data_service.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String postsCollection = 'posts';
  final String commentsCollection = 'comments';
  
  // For development mode - set to false to use real Firebase data
  final bool _devMode = false;
  
  // Get all posts
  Future<List<Post>> getPosts() async {
    // Use mock data in dev mode
    if (_devMode) {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      return MockDataService.getPosts();
    }
    
    try {
      // Get posts from Firestore
      final postsSnapshot = await _firestore
          .collection(postsCollection)
          .orderBy('createdAt', descending: true)
          .get();
      
      // Map of user IDs to User objects (to avoid duplicate fetches)
      final Map<String, User> userCache = {};
      
      // Process posts
      List<Post> posts = [];
      for (var doc in postsSnapshot.docs) {
        // Get author
        final String authorId = doc.data()['authorId'];
        User author;
        if (userCache.containsKey(authorId)) {
          author = userCache[authorId]!;
        } else {
          // Fetch user from Firestore
          final userDoc = await _firestore.collection('users').doc(authorId).get();
          if (userDoc.exists) {
            author = User.fromFirestore(userDoc);
            userCache[authorId] = author;
          } else {
            // Skip this post if we can't find the author
            continue;
          }
        }
        
        // Get likes
        List<User> likes = [];
        final List<dynamic> likeIds = doc.data()['likeIds'] ?? [];
        for (String userId in likeIds) {
          if (userCache.containsKey(userId)) {
            likes.add(userCache[userId]!);
          } else {
            // Fetch user
            final userDoc = await _firestore.collection('users').doc(userId).get();
            if (userDoc.exists) {
              final user = User.fromFirestore(userDoc);
              userCache[userId] = user;
              likes.add(user);
            }
          }
        }
        
        // Get comments
        List<Comment> comments = [];
        final commentsSnapshot = await _firestore
            .collection(postsCollection)
            .doc(doc.id)
            .collection(commentsCollection)
            .orderBy('createdAt', descending: false)
            .get();
            
        for (var commentDoc in commentsSnapshot.docs) {
          // Get comment author
          final String commentUserId = commentDoc.data()['userId'];
          User commentUser;
          if (userCache.containsKey(commentUserId)) {
            commentUser = userCache[commentUserId]!;
          } else {
            // Fetch user
            final userDoc = await _firestore.collection('users').doc(commentUserId).get();
            if (userDoc.exists) {
              commentUser = User.fromFirestore(userDoc);
              userCache[commentUserId] = commentUser;
            } else {
              // Skip this comment if user not found
              continue;
            }
          }
          
          comments.add(Comment.fromFirestore(commentDoc, commentUser));
        }
        
        // Create post object using the Firestore factory
        posts.add(Post.fromFirestore(doc, author, likes, comments));
      }
      
      return posts;
    } catch (e) {
      debugPrint('Error getting posts: $e');
      // Return empty list on error
      return [];
    }
  }
  
  // Get a single post by ID
  Future<Post?> getPostById(String postId) async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      return MockDataService.getPosts().firstWhere(
        (post) => post.id == postId, 
        orElse: () => MockDataService.getPosts().first
      );
    }
    
    try {
      final doc = await _firestore.collection(postsCollection).doc(postId).get();
      if (!doc.exists) return null;
      
      // Get author
      final String authorId = doc.data()?['authorId'];
      final userDoc = await _firestore.collection('users').doc(authorId).get();
      if (!userDoc.exists) return null;
      
      final author = User.fromFirestore(userDoc);
      
      // Get likes
      List<User> likes = [];
      final List<dynamic> likeIds = doc.data()?['likeIds'] ?? [];
      for (String userId in likeIds) {
        final userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          likes.add(User.fromFirestore(userDoc));
        }
      }
      
      // Get comments
      List<Comment> comments = [];
      final commentsSnapshot = await _firestore
          .collection(postsCollection)
          .doc(postId)
          .collection(commentsCollection)
          .orderBy('createdAt', descending: false)
          .get();
          
      for (var commentDoc in commentsSnapshot.docs) {
        final String commentUserId = commentDoc.data()['userId'];
        final userDoc = await _firestore.collection('users').doc(commentUserId).get();
        if (userDoc.exists) {
          final commentUser = User.fromFirestore(userDoc);
          comments.add(Comment.fromFirestore(commentDoc, commentUser));
        }
      }
      
      return Post.fromFirestore(doc, author, likes, comments);
    } catch (e) {
      debugPrint('Error getting post by ID: $e');
      return null;
    }
  }
  
  // Create new post
  Future<Post?> createPost(User author, String content, {String? imageUrl}) async {
    if (_devMode) {
      // In dev mode, just return a mock post
      await Future.delayed(const Duration(milliseconds: 800));
      
      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      
      final newPost = Post(
        id: newId,
        author: author,
        content: content,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        likes: [],
        comments: [],
      );
      
      return newPost;
    }
    
    try {
      // Create post in Firestore
      final postData = {
        'authorId': author.id,
        'content': content,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'likeIds': [],
      };
      
      final docRef = await _firestore.collection(postsCollection).add(postData);
      
      // Fetch the post we just created
      final doc = await docRef.get();
      
      // Return as a Post object
      return Post.fromFirestore(doc, author, [], []);
    } catch (e) {
      debugPrint('Error creating post: $e');
      return null;
    }
  }
  
  // Toggle like on a post
  Future<bool> toggleLike(String postId, User user) async {
    if (_devMode) {
      // In dev mode, we don't need to do anything
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    }
    
    try {
      // Get post document
      final postDoc = await _firestore.collection(postsCollection).doc(postId).get();
      if (!postDoc.exists) return false;
      
      // Get current likes
      final List<dynamic> currentLikes = postDoc.data()?['likeIds'] ?? [];
      
      // Toggle like
      if (currentLikes.contains(user.id)) {
        // Unlike - remove from array
        await _firestore.collection(postsCollection).doc(postId).update({
          'likeIds': FieldValue.arrayRemove([user.id]),
        });
      } else {
        // Like - add to array
        await _firestore.collection(postsCollection).doc(postId).update({
          'likeIds': FieldValue.arrayUnion([user.id]),
        });
      }
      
      return true;
    } catch (e) {
      debugPrint('Error toggling like: $e');
      return false;
    }
  }
  
  // Add a comment to a post
  Future<Comment?> addComment(String postId, User user, String text) async {
    if (_devMode) {
      // In dev mode, just return a mock comment
      await Future.delayed(const Duration(milliseconds: 500));
      
      final newComment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        user: user,
        text: text,
        createdAt: DateTime.now(),
      );
      
      return newComment;
    }
    
    try {
      // Create comment data
      final commentData = {
        'userId': user.id,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
      };
      
      // Add comment to subcollection
      final docRef = await _firestore
          .collection(postsCollection)
          .doc(postId)
          .collection(commentsCollection)
          .add(commentData);
      
      // Get the comment we just added
      final commentDoc = await docRef.get();
      
      return Comment.fromFirestore(commentDoc, user);
    } catch (e) {
      debugPrint('Error adding comment: $e');
      return null;
    }
  }
  
  // Delete a post
  Future<bool> deletePost(String postId) async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    }
    
    try {
      // Delete all comments first
      final commentsSnapshot = await _firestore
          .collection(postsCollection)
          .doc(postId)
          .collection(commentsCollection)
          .get();
          
      for (var doc in commentsSnapshot.docs) {
        await doc.reference.delete();
      }
      
      // Delete the post
      await _firestore.collection(postsCollection).doc(postId).delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting post: $e');
      return false;
    }
  }
} 