import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../theme.dart';
import '../providers/auth_provider.dart';

// Model to hold profile data
class ProfileData {
  final User user;
  final int postCount;
  final int followerCount;
  final int followingCount;
  final List<DocumentSnapshot> posts;

  ProfileData({
    required this.user,
    required this.postCount,
    required this.followerCount,
    required this.followingCount,
    required this.posts,
  });
}

class PublicProfilePage extends StatefulWidget {
  final String userId;
  const PublicProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _PublicProfilePageState createState() => _PublicProfilePageState();
}

class _PublicProfilePageState extends State<PublicProfilePage> {
  late Future<ProfileData> _profileFuture;
  late String _meUid;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _meUid = Provider.of<AuthProvider>(context, listen: false).currentUserInfo!['uid'];
    _profileFuture = _fetchProfileData();
    _checkIfFollowing();
  }

  Future<void> _checkIfFollowing() async {
    final doc = await FirebaseFirestore.instance
        .collection('users').doc(_meUid)
        .collection('following').doc(widget.userId)
        .get();
    setState(() => _isFollowing = doc.exists);
  }

  Future<void> _followUser() async {
    final users = FirebaseFirestore.instance.collection('users');
    await users.doc(_meUid).collection('following').doc(widget.userId).set({});
    await users.doc(widget.userId).collection('followers').doc(_meUid).set({});
  }

  Future<void> _unfollowUser() async {
    final users = FirebaseFirestore.instance.collection('users');
    await users.doc(_meUid).collection('following').doc(widget.userId).delete();
    await users.doc(widget.userId).collection('followers').doc(_meUid).delete();
  }

  Future<void> _toggleFollow() async {
    if (_isFollowing) {
      await _unfollowUser();
    } else {
      await _followUser();
    }
    if (!mounted) return;
    setState(() => _isFollowing = !_isFollowing);
    Navigator.of(context).pop(true);
  }

  Future<ProfileData> _fetchProfileData() async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(widget.userId);

    final results = await Future.wait([
      userRef.get(),
      FirebaseFirestore.instance.collection('posts')
          .where('authorId', isEqualTo: widget.userId)
          .orderBy('createdAt', descending: true).get(),
      userRef.collection('followers').get(),
      userRef.collection('following').get(),
    ]);

    final userDoc = results[0] as DocumentSnapshot;
    final postsSnap = results[1] as QuerySnapshot;
    final followersSnap = results[2] as QuerySnapshot;
    final followingSnap = results[3] as QuerySnapshot;

    final userModel = User.fromFirestore(userDoc);

    return ProfileData(
      user: userModel,
      postCount: postsSnap.size,
      followerCount: followersSnap.size,
      followingCount: followingSnap.size,
      posts: postsSnap.docs,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileData>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppColors.primaryBackground,
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            backgroundColor: AppColors.primaryBackground,
            appBar: AppBar(
              backgroundColor: AppColors.primaryBackground,
              elevation: 0,
              automaticallyImplyLeading: true,
              title: const Text('Profile'),
            ),
            body: Center(
              child: Text(
                snapshot.error?.toString() ?? 'No data found.',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final profileData = snapshot.data!;
        final user = profileData.user;

        return Scaffold(
          backgroundColor: AppColors.primaryBackground,
          appBar: AppBar(
            backgroundColor: AppColors.primaryBackground,
            elevation: 0,
            automaticallyImplyLeading: true,
            title: Text(user.name ?? 'Profile'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: (user.imageUrl ?? '').isNotEmpty
                          ? NetworkImage(user.imageUrl!)
                          : null,
                      backgroundColor: Colors.grey.shade300,
                      child: (user.imageUrl ?? '').isEmpty
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
                            Text(user.bio!, style: const TextStyle(fontSize: 14)),
                          ],
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _toggleFollow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFollowing ? Colors.grey : AppColors.brandTeal,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(_isFollowing ? 'Unfollow' : 'Follow'),
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
                const Text('Posts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    final postData = profileData.posts[index].data() as Map<String, dynamic>;
                    final postPhotoUrl = postData['imageUrl'] as String;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                        image: postPhotoUrl.isNotEmpty
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
          ),
        );
      },
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
