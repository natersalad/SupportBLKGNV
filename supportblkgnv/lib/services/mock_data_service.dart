import 'package:supportblkgnv/models/post.dart';
import 'package:supportblkgnv/models/user.dart';

class MockDataService {
  // Sample users
  static final User jane = User(
    id: '1',
    name: 'Jane Smith',
    imageUrl: null, // We'll use default avatar icon in the UI instead
    bio: 'Artist and community organizer',
    accountType: 'individual',
  );

  static final User marcus = User(
    id: '2',
    name: 'Marcus Johnson',
    imageUrl: null, // We'll use default avatar icon in the UI instead
    bio: 'Software engineer and mentor',
    accountType: 'individual',
  );

  static final User blackCoffeeShop = User(
    id: '3',
    name: 'Black Coffee Shop',
    imageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Y29mZmVlJTIwc2hvcHxlbnwwfHwwfHw%3D&w=1000&q=80',
    bio: 'Local coffee shop with a mission to connect community through coffee',
    accountType: 'business',
  );

  static final User techHubBLK = User(
    id: '4',
    name: 'TechHub BLK',
    imageUrl: 'https://images.unsplash.com/photo-1556761175-5973dc0f32e7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    bio: 'Co-working space and tech incubator for Black entrepreneurs',
    accountType: 'business',
  );

  static final User maria = User(
    id: '5',
    name: 'Maria Wallace',
    imageUrl: null, // We'll use default avatar icon in the UI instead
    bio: 'Community activist and educator',
    accountType: 'individual',
  );

  // Sample posts
  static List<Post> getPosts() {
    return [
      Post(
        id: '1',
        author: jane,
        content: 'Just finished my latest art piece celebrating Black history in Gainesville! Exhibition opening next Friday at the Downtown Gallery.',
        imageUrl: 'https://images.unsplash.com/photo-1569946880511-a6c0bd11d108?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YXJ0JTIwZ2FsbGVyeXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        likes: [marcus, maria, blackCoffeeShop],
        comments: [
          Comment(
            id: '1',
            user: marcus,
            text: 'Can\'t wait to see it! Will definitely be there.',
            createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
          ),
          Comment(
            id: '2',
            user: blackCoffeeShop,
            text: 'We\'ll be providing refreshments for the opening. Looking forward to it!',
            createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
          ),
        ],
      ),
      Post(
        id: '2',
        author: blackCoffeeShop,
        content: 'New specialty drinks launching this weekend! First 50 customers get a free BLK GNV sticker. Come support local!',
        imageUrl: 'https://images.unsplash.com/photo-1572286258217-15c6bf18b196?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fGNvZmZlZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        likes: [jane, marcus, maria, techHubBLK],
        comments: [
          Comment(
            id: '3',
            user: maria,
            text: 'Your lattes are amazing! Will be there.',
            createdAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 30)),
          ),
        ],
      ),
      Post(
        id: '3',
        author: techHubBLK,
        content: 'Applications for our summer tech entrepreneurship program are now open! Looking for Black founders with innovative ideas. Scholarship opportunities available.',
        imageUrl: 'https://images.unsplash.com/photo-1557804506-669a67965ba0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YnVzaW5lc3MlMjBtZWV0aW5nfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        likes: [jane, marcus],
        comments: [
          Comment(
            id: '4',
            user: marcus,
            text: 'Is there an age requirement? I have a nephew who would be perfect for this.',
            createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
          ),
          Comment(
            id: '5',
            user: techHubBLK,
            text: 'No age requirements! We welcome young innovators. Send them our way!',
            createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
          ),
        ],
      ),
      Post(
        id: '4',
        author: marcus,
        content: 'Just hosted a coding workshop for high school students at Eastside High. So impressed by the talent and creativity in our community!',
        imageUrl: 'https://images.unsplash.com/photo-1531482615713-2afd69097998?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Y29kaW5nJTIwd29ya3Nob3B8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        likes: [jane, blackCoffeeShop, techHubBLK],
        comments: [
          Comment(
            id: '6',
            user: techHubBLK,
            text: 'Great initiative! Let us know if you need space for future workshops.',
            createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 23)),
          ),
        ],
      ),
      Post(
        id: '5',
        author: maria,
        content: 'Community cleanup this Saturday at Lincoln Park. Bring gloves and water! Lunch provided by local Black-owned restaurants.',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        likes: [jane, marcus, blackCoffeeShop],
        comments: [
          Comment(
            id: '7',
            user: jane,
            text: 'I\'ll be there! Can we bring the kids?',
            createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 12)),
          ),
          Comment(
            id: '8',
            user: maria,
            text: 'Absolutely! Family-friendly event. We\'ll have activities for the kids too.',
            createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 10)),
          ),
        ],
      ),
    ];
  }
} 