import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mock_data_service.dart';
import 'mock_community_service.dart';
import '../models/user.dart'; // Ensure this imports your User model

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

  // Seed Posts created in MockDataService
  final posts = MockDataService.getPosts();
  for (var post in posts) {
    final postDoc = firestore.collection('posts').doc(post.id);
    final postExists = (await postDoc.get()).exists;

    if (!postExists) {
      await postDoc.set(post.toMap());
      print('Added post with id: ${post.id}');

      // Add comments for the post
      for (var comment in post.comments) {
        final commentDoc = postDoc.collection('comments').doc(comment.id);
        final commentExists = (await commentDoc.get()).exists;

        if (!commentExists) {
          await commentDoc.set(comment.toMap());
          print('Added comment with id: ${comment.id} for post: ${post.id}');
        } else {
          print('Comment already exists: ${comment.id} for post: ${post.id}');
        }
      }
    } else {
      print('Post already exists: ${post.id}');
    }
  }

  // --- Seed a Demo Post for the Demo User ---
  final demoPostDoc = firestore.collection('posts').doc('demo-post-123');
  final demoPostSnapshot = await demoPostDoc.get();
  if (!demoPostSnapshot.exists) {
    final demoPostData = {
      'id': 'demo-post-123',
      'authorId': demoUser.id,
      'content': 'This is a demo post from the seeded demo user.',
      'createdAt': DateTime.now().toIso8601String(),
      'imageUrl':
          'https://www.wruf.com/wp-content/uploads/2025/04/040725-UF-Basketball-Championship-ML-26-scaled-e1744107148886.jpg',
      'likes': [],
    };
    await demoPostDoc.set(demoPostData);
    print('Added demo post for demo user');
  } else {
    print('Demo post already exists');
  }

  // --- Seed Community Data from MockCommunityService ---

  // Seed Businesses
  final businesses = MockCommunityService().getBusinesses();
  for (var business in businesses) {
    final businessDoc = firestore.collection('businesses').doc(business.id);
    final businessExists = (await businessDoc.get()).exists;
    if (!businessExists) {
      await businessDoc.set(business.toMap());
      print('Added business: ${business.name}');
    } else {
      print('Business already exists: ${business.name}');
    }
  }

  // Seed Events
  final communityEvents = MockCommunityService().getEvents();
  for (var event in communityEvents) {
    final eventDoc = firestore.collection('events').doc(event.id);
    final eventExists = (await eventDoc.get()).exists;
    if (!eventExists) {
      await eventDoc.set(event.toMap());
      print('Added event: ${event.title}');
    } else {
      print('Event already exists: ${event.title}');
    }
  }

  // Seed Community Goals
  final communityGoals = MockCommunityService().getCommunityGoals();
  for (var goal in communityGoals) {
    final goalDoc = firestore.collection('communityGoals').doc(goal.id);
    final goalExists = (await goalDoc.get()).exists;
    if (!goalExists) {
      await goalDoc.set(goal.toMap());
      print('Added community goal: ${goal.title}');
    } else {
      print('Community goal already exists: ${goal.title}');
    }
  }

  // Seed Impact Reports
  final impactReports = MockCommunityService().getImpactReports();
  for (var report in impactReports) {
    final reportDoc = firestore.collection('impactReports').doc(report.id);
    final reportExists = (await reportDoc.get()).exists;
    if (!reportExists) {
      await reportDoc.set(report.toMap());
      print('Added impact report: ${report.title}');
    } else {
      print('Impact report already exists: ${report.title}');
    }
  }

  print('Database seeding completed.');
}
