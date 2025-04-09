import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../theme.dart';
import '../providers/auth_provider.dart';
import 'profile.dart';

//
// PUBLIC PROFILE VIEW
// (Displays any user's public profile based on the passed userID.)
//
class PublicProfilePage extends StatefulWidget {
  final String userId; // the ID of the user whose public profile to show

  const PublicProfilePage({super.key, required this.userId});

  @override
  State<PublicProfilePage> createState() => _PublicProfilePageState();
}

class _PublicProfilePageState extends State<PublicProfilePage> {
  late Future<ProfileData> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _setupProfile();
  }

  Future<ProfileData> _setupProfile() async {
    // If needed, you could also create a test user here
    // For production use, assume the user exists.
    return await _fetchProfileData();
  }

  Future<ProfileData> _fetchProfileData() async {
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId);

    // Perform multiple queries in parallel with Future.wait.
    final userDocFuture = userRef.get();
    final postsQueryFuture =
        FirebaseFirestore.instance
            .collection('posts')
            .where('authorId', isEqualTo: widget.userId)
            .orderBy('createdAt', descending: true)
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

    // converting the raw user data into a UserModel type
    final userModel = User.fromFirestore(userDoc);

    return ProfileData(
      user: userModel,
      postCount: postsSnapshot.size,
      followerCount: followersSnapshot.size,
      followingCount: followingSnapshot.size,
      posts: postsSnapshot.docs,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: FutureBuilder<ProfileData>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No data found.'));
          }

          final profileData = snapshot.data!;
          final user = profileData.user;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with profile picture and user info.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          (user.imageUrl ?? '').isNotEmpty
                              ? NetworkImage(user.imageUrl!)
                              : null,
                      backgroundColor: Colors.grey.shade300,
                      child:
                          (user.imageUrl ?? '').isEmpty
                              ? const Icon(Icons.person, size: 40)
                              : null,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name ?? 'No Username',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if ((user.bio ?? '').isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              user.bio!,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCountColumn('POSTS', profileData.postCount),
                    _verticalDivider(),
                    _buildCountColumn('FOLLOWERS', profileData.followerCount),
                    _verticalDivider(),
                    _buildCountColumn('FOLLOWING', profileData.followingCount),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Posts',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: profileData.posts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final postData =
                        profileData.posts[index].data() as Map<String, dynamic>;
                    final postPhotoUrl = postData['imageUrl'] as String;
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

  Widget _buildCountColumn(String label, int count) {
    return Column(
      children: [
        Text(
          '$count',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7)),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withOpacity(0.7),
    );
  }
}

//
// A simple model to carry profile data
//
class ProfileData {
  final User user;
  final int postCount;
  final int followerCount;
  final int followingCount;
  final List<DocumentSnapshot>
  posts; // TODO: Consider converting this to a typed model

  ProfileData({
    required this.user,
    required this.postCount,
    required this.followerCount,
    required this.followingCount,
    required this.posts,
  });
}

class InfoItem {
  final IconData icon;
  final String title;
  final String value;

  InfoItem({required this.icon, required this.title, required this.value});
}
