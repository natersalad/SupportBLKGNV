import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mock_data_service.dart';
import 'mock_community_service.dart';
import '../models/user.dart'; // Ensure this imports your User model
import 'dart:math';

// Utility function to ensure document ID is valid
String ensureValidDocId(String? id, String prefix) {
  if (id == null || id.isEmpty) {
    // Generate a timestamp-based ID with a prefix
    return '$prefix-${DateTime.now().millisecondsSinceEpoch}-${(1000 + (10000 * Random().nextDouble()).toInt())}';
  }
  return id;
}

Future<void> seedDatabase() async {
  // Initialize Firebase (ensure firebase_options.dart is configured if needed)
  await Firebase.initializeApp();
  final firestore = FirebaseFirestore.instance;

  // Create a demo user with id "demo-user-123"
  final demoUser = User(
    id: 'demo-user-123',
    name: 'Demo User',
    imageUrl:
        'https://play-lh.googleusercontent.com/7axrc7mjvO4-XtQziN5qY3gF_VGxS6PZRDSt7m_T5j07fLHz2eoh4xyItmTJ5smPxbk',
    bio: 'This is a demo user seeded for development.',
    accountType: 'individual',
  );

  // Seed Users (add the demoUser to the list)
  final users = [
    demoUser,
    MockDataService.jane,
    MockDataService.marcus,
    MockDataService.blackCoffeeShop,
    MockDataService.techHubBLK,
    MockDataService.maria,
  ];

  for (var user in users) {
    final userDoc = firestore.collection('users').doc(user.id);
    final userExists = (await userDoc.get()).exists;

    if (!userExists) {
      await userDoc.set(user.toMap());
      print('Added user: ${user.name}');
    } else {
      print('User already exists: ${user.name}');
    }
  }

  try {
    // Seed Posts created in MockDataService
    final posts = MockDataService.getPosts();
    for (var post in posts) {
      // Ensure valid post ID
      final postId = ensureValidDocId(post.id, 'post');
      
      final postDoc = firestore.collection('posts').doc(postId);
      final postExists = (await postDoc.get()).exists;

      if (!postExists) {
        await postDoc.set(post.toMap());
        print('Added post with id: $postId');

        // Add comments for the post
        for (var comment in post.comments) {
          // Ensure valid comment ID
          final commentId = ensureValidDocId(comment.id, 'comment');
          
          final commentDoc = postDoc.collection('comments').doc(commentId);
          final commentExists = (await commentDoc.get()).exists;

          if (!commentExists) {
            await commentDoc.set(comment.toMap());
            print('Added comment with id: $commentId for post: $postId');
          } else {
            print('Comment already exists: $commentId for post: $postId');
          }
        }
      } else {
        print('Post already exists: $postId');
      }
    }
  } catch (e) {
    print('Error seeding posts: $e');
  }

  try {
    // --- Seed a Demo Post for the Demo User ---
    final demoPostDoc = firestore.collection('posts').doc('demo-post-123');
    final demoPostSnapshot = await demoPostDoc.get();
    if (!demoPostSnapshot.exists) {
      final demoPostData = {
        'authorId': demoUser.id,
        'content': 'This is a demo post from the seeded demo user.',
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'imageUrl':
            'https://www.wruf.com/wp-content/uploads/2025/04/040725-UF-Basketball-Championship-ML-26-scaled-e1744107148886.jpg',
        'likeIds': [],
      };
      await demoPostDoc.set(demoPostData);
      print('Added demo post for demo user');
    } else {
      print('Demo post already exists');
    }
  } catch (e) {
    print('Error seeding demo post: $e');
  }

  try {
    // --- Seed Community Data from MockCommunityService ---

    // Seed Businesses
    final businesses = MockCommunityService().getBusinesses();
    for (var business in businesses) {
      // Ensure valid business ID
      final businessId = ensureValidDocId(business.id, 'business');
      
      final businessDoc = firestore.collection('businesses').doc(businessId);
      final businessExists = (await businessDoc.get()).exists;
      if (!businessExists) {
        await businessDoc.set(business.toMap());
        print('Added business: ${business.name}');
      } else {
        print('Business already exists: ${business.name}');
      }
    }
  } catch (e) {
    print('Error seeding businesses: $e');
  }

  try {
    // Seed Events
    final communityEvents = MockCommunityService().getEvents();
    for (var event in communityEvents) {
      // Ensure valid event ID
      final eventId = ensureValidDocId(event.id, 'event');
      
      final eventDoc = firestore.collection('events').doc(eventId);
      final eventExists = (await eventDoc.get()).exists;
      if (!eventExists) {
        await eventDoc.set(event.toMap());
        print('Added event: ${event.title}');
      } else {
        print('Event already exists: ${event.title}');
      }
    }
  } catch (e) {
    print('Error seeding events: $e');
  }

  try {
    // Seed Community Goals
    final communityGoals = MockCommunityService().getCommunityGoals();
    for (var goal in communityGoals) {
      // Ensure valid goal ID
      final goalId = ensureValidDocId(goal.id, 'goal');
      
      final goalDoc = firestore.collection('community_goals').doc(goalId);
      final goalExists = (await goalDoc.get()).exists;
      if (!goalExists) {
        await goalDoc.set(goal.toMap());
        print('Added community goal: ${goal.title}');
      } else {
        print('Community goal already exists: ${goal.title}');
      }
    }
  } catch (e) {
    print('Error seeding community goals: $e');
  }

  try {
    // Seed Impact Reports
    final impactReport = MockCommunityService().getCommunityImpactReport();
    if (impactReport != null) {
      // Ensure valid report ID
      final reportId = ensureValidDocId(impactReport.id, 'report');
      
      final reportDoc = firestore.collection('impact_reports').doc(reportId);
      final reportExists = (await reportDoc.get()).exists;
      if (!reportExists) {
        await reportDoc.set(impactReport.toMap());
        print('Added impact report');
      } else {
        print('Impact report already exists');
      }
    }
  } catch (e) {
    print('Error seeding impact report: $e');
  }

  print('Database seeding completed.');
}
