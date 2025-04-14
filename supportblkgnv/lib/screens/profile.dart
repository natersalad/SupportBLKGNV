import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supportblkgnv/providers/auth_provider.dart';
import 'package:supportblkgnv/screens/profile_details.dart';
import 'package:supportblkgnv/screens/public_profile.dart';
import 'package:supportblkgnv/theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Key _publicProfileKey = UniqueKey();

  // Call this method to force refresh PublicProfilePage.
  void _refreshProfile() {
    setState(() {
      _publicProfileKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userInfo = authProvider.currentUserInfo;
    const String defaultProfileImage =
        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => Scaffold(
                        appBar: AppBar(title: const Text('Profile Details')),
                        body: ProfileDetailsPage(
                          userId: userInfo?['uid'] ?? '',
                        ),
                      ),
                ),
              ).then((_) {
                // Force a refresh every time you come back.
                _refreshProfile();
              });
            },
          ),
        ],
      ),
      body:
          !authProvider.isAuthenticated && !authProvider.isLoading
              ? _buildLoginPrompt(context)
              : PublicProfilePage(
                key: _publicProfileKey,
                userId: userInfo?['uid'] ?? '',
              ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.account_circle,
            size: 80,
            color: AppColors.brandTeal,
          ),
          const SizedBox(height: 16),
          const Text(
            'Not Logged In',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Please log in to view your profile',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            icon: const Icon(Icons.login),
            label: const Text(
              'Log In',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandTeal,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
