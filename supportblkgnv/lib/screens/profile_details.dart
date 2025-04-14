import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../theme.dart';
import '../providers/auth_provider.dart';

class ProfileDetailsPage extends StatefulWidget {
  final String userId;

  const ProfileDetailsPage({super.key, required this.userId});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
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

  Widget _buildProfileDetails(BuildContext context, ProfileData profileData) {
    const String defaultProfileImage =
        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';

    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile header with image and name
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Profile image with glow effect
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brandTeal.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.primaryBackground,
                    backgroundImage: NetworkImage(
                      profileData.user.imageUrl ?? defaultProfileImage,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // User name
                Text(
                  profileData.user.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // User email
                Text(
                  'email@example.com', //TODO put this in the user model,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 20),
                // Edit profile button
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/edit_profile').then((
                        shouldRefresh,
                      ) {
                        if (shouldRefresh == true) {
                          // Refresh the profile data
                          setState(() {
                            _profileFuture = _setupProfile();
                          });
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandTeal,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Account Info Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Account Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brandTeal,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoCard(
                  context: context,
                  items: [
                    InfoItem(
                      icon: Icons.verified_user,
                      title: 'Account Type',
                      value: 'Regular Member',
                    ),
                    InfoItem(
                      icon: Icons.mail,
                      title: 'Email Verified',
                      value: 'No', //TODO put this in the user model,
                    ),
                    InfoItem(
                      icon: Icons.calendar_today,
                      title: 'Member Since',
                      value: 'April 2023',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Activity Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Activity Stats',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brandTeal,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        icon: Icons.article,
                        value: '${profileData.postCount}',
                        label: 'Posts',
                        color: AppColors.accentGold,
                      ),
                      _buildStatItem(
                        icon: Icons.comment,
                        value: '0',
                        label: 'Comments',
                        color: AppColors.brandTeal,
                      ),
                      _buildStatItem(
                        icon: Icons.favorite,
                        value: '0',
                        label: 'Likes',
                        color: Colors.redAccent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Logout Button
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                final bool? confirm = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        backgroundColor: AppColors.cardBackground,
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                );
                if (confirm == true) {
                  final authProvider = Provider.of<AuthProvider>(
                    context,
                    listen: false,
                  );
                  await authProvider.signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required List<InfoItem> items,
  }) {
    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children:
              items
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(item.icon, color: AppColors.brandTeal),
                          const SizedBox(width: 10),
                          Text(
                            '${item.title}: ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(item.value),
                        ],
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileData>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: Text('No data')));
        }
        return Scaffold(
          backgroundColor: AppColors.primaryBackground,
          body: _buildProfileDetails(context, snapshot.data!),
        );
      },
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
  final List<DocumentSnapshot> posts; // Consider converting to a typed model

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
