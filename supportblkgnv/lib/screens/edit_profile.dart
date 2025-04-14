import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // We'll obtain the current user id from AuthProvider
  late String _userId;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _photoUrlController = TextEditingController();

  bool _loading = false;
  bool _isBusiness = false; // false = individual, true = business

  bool _didLoadUserData = false;

  // Loads current user data from Firestore using the current user's id.
  Future<void> _loadUserData() async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_userId).get();

    if (userDoc.exists) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      final user = User.fromFirestore(userDoc);
      setState(() {
        _nameController.text = data['name'] ?? '';
        _photoUrlController.text = user.imageUrl ?? '';
        _bioController.text = data['bio'] ?? '';
        _isBusiness =
            (data['accountType'] ?? '').toString().toLowerCase() == 'business';
      });
    }
  }

  // Saves profile changes to Firestore for name, photo URL, account type, and bio.
  Future<void> _saveProfile() async {
    setState(() {
      _loading = true;
    });

    await FirebaseFirestore.instance.collection('users').doc(_userId).update({
      'name': _nameController.text.trim(),
      'bio': _bioController.text.trim(),
      'imageUrl': _photoUrlController.text.trim(),
      'accountType': _isBusiness ? 'business' : 'individual',
    });

    setState(() {
      _loading = false;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile updated!')));
    Navigator.pop(context, true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoadUserData) {
      // Get the current user's id from AuthProvider.
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      // Assuming AuthProvider.getCurrentUserInfo returns a map with key 'uid'
      _userId = authProvider.currentUserInfo?['uid'] ?? '';
      if (_userId.isNotEmpty) {
        _loadUserData();
      }
      _didLoadUserData = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile'), centerTitle: true),
      backgroundColor: AppColors.primaryBackground,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Picture URL field.
                      Text(
                        'Profile Picture URL',
                        style: TextStyle(color: AppColors.textWhite),
                      ),
                      TextField(
                        controller: _photoUrlController,
                        style: const TextStyle(color: AppColors.textWhite),
                        decoration: InputDecoration(
                          hintText: 'Enter new photo URL',
                          hintStyle: TextStyle(
                            color: AppColors.textWhite.withAlpha(153),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textWhite),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Name field.
                      Text(
                        'Name',
                        style: TextStyle(color: AppColors.textWhite),
                      ),
                      TextField(
                        controller: _nameController,
                        style: const TextStyle(color: AppColors.textWhite),
                        decoration: InputDecoration(
                          hintText: 'Enter your full name',
                          hintStyle: TextStyle(
                            color: AppColors.textWhite.withAlpha(153),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textWhite),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Account Type switch
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Business Account',
                          style: TextStyle(color: AppColors.textWhite),
                        ),
                        subtitle: Text(
                          _isBusiness ? 'Business' : 'Individual',
                          style: TextStyle(
                            color: AppColors.textWhite.withAlpha(153),
                          ),
                        ),
                        value: _isBusiness,
                        onChanged: (value) {
                          setState(() {
                            _isBusiness = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      // Bio field at the bottom.
                      Text('Bio', style: TextStyle(color: AppColors.textWhite)),
                      TextField(
                        controller: _bioController,
                        style: const TextStyle(color: AppColors.textWhite),
                        maxLength: 200,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Enter your bio',
                          hintStyle: TextStyle(
                            color: AppColors.textWhite.withAlpha(153),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textWhite),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textWhite),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textWhite),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: ElevatedButton(
                          onPressed: _saveProfile,
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
