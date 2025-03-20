import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class ProfileData {
  final DocumentSnapshot userDoc;
  final int postCount;
  final int followerCount;
  final int followingCount;
  final List<DocumentSnapshot> posts;

  ProfileData({
    required this.userDoc,
    required this.postCount,
    required this.followerCount,
    required this.followingCount,
    required this.posts,
  });
}

class _ProfilePageState extends State<ProfilePage> {
  // hardcoded user documentID (for testing rn)
  // TODO - get user documentID from authentication (waiting for nico for profile creation)
  final String testUserID = 'testUser';

  late Future<ProfileData> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _setupProfile();
  }

  Future<ProfileData> _setupProfile() async {
    await _createTestUser(); // wont have to do this after Authentication is implemented
    return await _fetchProfileData();
  }

  // creating the test user in the database, if not already created
  Future<void> _createTestUser() async {
    DocumentReference userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(testUserID);
    DocumentSnapshot userDoc = await userRef.get();

    if (!userDoc.exists) {
      await userRef.set({
        'username': 'testUser',
        'firstName': 'John',
        'lastName': 'Doe',
        'email': 'john.doe@example.com',
        'photoUrl':
            'https://www.shutterstock.com/image-photo/smiling-african-american-millennial-businessman-600nw-1437938108.jpg',
        'bio': 'This is a test user.',
        'country': 'USA',
        'timestamp': FieldValue.serverTimestamp(),
      });

      await userRef.collection('followers').doc('follower1').set({
        'username': 'followerUser',
        'timestamp': FieldValue.serverTimestamp(),
      });

      await userRef.collection('following').doc('following1').set({
        'username': 'followingUser',
        'timestamp': FieldValue.serverTimestamp(),
      });

      final postsRef = FirebaseFirestore.instance.collection('posts');
      await postsRef.add({
        'ownerId': testUserID,
        'photoUrl':
            'https://media.istockphoto.com/id/1156838737/photo/aerial-ben-hill-griffin-stadium-university-of-florida-gainesville.jpg?s=612x612&w=0&k=20&c=xZwti5mb17kizW-vRXz4mMTmdRQk1Z7naAJRI4b8S1Q%3D',
        'timestamp': FieldValue.serverTimestamp(),
      });
      await postsRef.add({
        'ownerId': testUserID,
        'photoUrl':
            'https://cdn.vox-cdn.com/thumbor/2hXFijZnCq4KEaCJXoAgRjP6Jec=/1400x1400/filters:format(jpeg)/cdn.vox-cdn.com/uploads/chorus_asset/file/22907785/1344335571.jpg',
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Fetches:
  ///   - The user document.
  ///   - Post count.
  ///   - Followers count.
  ///   - Following count.
  ///   - The actual posts (for display in a grid).
  Future<ProfileData> _fetchProfileData() async {
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(testUserID);

    // Perform multiple queries in parallel with Future.wait.
    final userDocFuture = userRef.get();
    final postsQueryFuture =
        FirebaseFirestore.instance
            .collection('posts')
            .where('ownerId', isEqualTo: testUserID)
            .orderBy('timestamp', descending: true)
            .get();
    final followersQueryFuture = userRef.collection('followers').get();
    final followingQueryFuture = userRef.collection('following').get();

    final results = await Future.wait([
      userDocFuture,
      postsQueryFuture,
      followersQueryFuture,
      followingQueryFuture,
    ]);

    final userDoc = results[0] as DocumentSnapshot;
    final postsSnapshot = results[1] as QuerySnapshot;
    final followersSnapshot = results[2] as QuerySnapshot;
    final followingSnapshot = results[3] as QuerySnapshot;

    return ProfileData(
      userDoc: userDoc,
      postCount: postsSnapshot.size,
      followerCount: followersSnapshot.size,
      followingCount: followingSnapshot.size,
      posts: postsSnapshot.docs,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(testUserID)
                  .get(),
          builder: (context, snapshot) {
            String appBarTitle = 'Profile Page';
            return Text(appBarTitle);
          },
        ),
        centerTitle: true,
        actions: [
          // Placeholder "Log Out" button.
          TextButton(
            onPressed: () {
              // TODO: Implement actual log-out if you have Firebase Auth.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Log Out tapped!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: FutureBuilder<ProfileData>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // show a loading spinner while waiting for the data
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // display an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            // show a message if no data is found
            return Center(child: Text('No data found.'));
          }

          final profileData = snapshot.data!;
          if (!profileData.userDoc.exists) {
            return Center(child: Text('User not found.'));
          }

          // extract the data from the doc
          final userMap = profileData.userDoc.data() as Map<String, dynamic>;
          final username = userMap['username'] as String;
          final firstName = userMap['firstName'] as String;
          final lastName = userMap['lastName'] as String;
          final email = userMap['email'] as String;
          final photoUrl = userMap['photoUrl'] as String;
          final bio = userMap['bio'] as String;
          final country = userMap['country'] as String;

          // for the post/follow/following counts
          final postCount = profileData.postCount;
          final followerCount = profileData.followerCount;
          final followingCount = profileData.followingCount;

          // the user's posts for the grid
          final posts = profileData.posts;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with profile picture and name.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // profile picture
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          photoUrl.toString().isNotEmpty
                              ? NetworkImage(photoUrl)
                              : null,
                      backgroundColor: Colors.grey.shade300,
                      child:
                          photoUrl.toString().isEmpty
                              ? Icon(Icons.person, size: 40)
                              : null,
                    ),
                    SizedBox(width: 20),
                    // user info column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // username
                          Text(
                            username,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // full name
                          Text(
                            '$firstName $lastName',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // email
                          Text(
                            email,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          // country
                          if (country.isNotEmpty) ...[
                            Text(
                              'Country: $country',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                          // bio
                          if (bio.isNotEmpty) ...[
                            SizedBox(height: 8),
                            Text(bio, style: TextStyle(fontSize: 14)),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // row with post/follow/following counts
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCountColumn('POSTS', postCount),
                    _verticalDivider(),
                    _buildCountColumn('FOLLOWERS', followerCount),
                    _verticalDivider(),
                    _buildCountColumn('FOLLOWING', followingCount),
                  ],
                ),
                SizedBox(height: 16),

                // edit Profile button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: implement edit profile screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Edit Profile tapped!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(minimumSize: Size(150, 40)),
                    child: Text('Edit Profile'),
                  ),
                ),
                SizedBox(height: 16),

                // section title
                Text(
                  'Posts',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),

                // grid of posts
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final postData =
                        posts[index].data() as Map<String, dynamic>;
                    final postPhotoUrl = postData['photoUrl'] as String;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                        image:
                            postPhotoUrl.isNotEmpty
                                ? DecorationImage(
                                  image: NetworkImage(postPhotoUrl),
                                  fit: BoxFit.cover,
                                )
                                : null,
                      ),
                      child:
                          postPhotoUrl.isEmpty
                              ? Center(child: Text("No Image"))
                              : null,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // helpers to build the count columns
  Widget _buildCountColumn(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(label),
      ],
    );
  }

  // helper to build vertical divider between count columns
  Widget _verticalDivider() {
    return Container(height: 30, width: 1, color: Colors.grey);
  }
}
