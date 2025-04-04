import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supportblkgnv/providers/auth_provider.dart';
import 'package:supportblkgnv/theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userInfo = authProvider.currentUserInfo;
    final size = MediaQuery.of(context).size;
    
    // Generic placeholder image
    const String defaultProfileImage = 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
    
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon')),
              );
            },
          ),
        ],
      ),
      body: !authProvider.isAuthenticated && !authProvider.isLoading
          ? _buildLoginPrompt(context)
          : SingleChildScrollView(
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
                              userInfo?['photoURL'] ?? defaultProfileImage,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // User name
                        Text(
                          userInfo?['displayName'] ?? 'User',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // User email
                        Text(
                          userInfo?['email'] ?? 'email@example.com',
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Edit profile coming soon')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brandTeal,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: const Text('Edit Profile'),
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
                              value: authProvider.isLoggedInWithMockUser ? 'Demo Account' : 'Regular Member',
                            ),
                            InfoItem(
                              icon: Icons.mail,
                              title: 'Email Verified',
                              value: userInfo?['emailVerified'] == true ? 'Yes' : 'No',
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
                                value: '0',
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
                          builder: (context) => AlertDialog(
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
                          await authProvider.signOut();
                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoCard({
    required BuildContext context,
    required List<InfoItem> items,
  }) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              if (i > 0)
                Divider(
                  color: AppColors.divider.withOpacity(0.5),
                  height: 24,
                ),
              Row(
                children: [
                  Icon(
                    items[i].icon,
                    size: 22,
                    color: AppColors.brandTeal,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    items[i].title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    items[i].value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
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
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class InfoItem {
  final IconData icon;
  final String title;
  final String value;
  
  InfoItem({
    required this.icon,
    required this.title,
    required this.value,
  });
}
