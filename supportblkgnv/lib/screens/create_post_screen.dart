import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supportblkgnv/providers/auth_provider.dart';
import 'package:supportblkgnv/services/post_service.dart';
import 'package:supportblkgnv/models/user.dart';
import 'package:supportblkgnv/theme.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final PostService _postService = PostService();
  final ImagePicker _picker = ImagePicker();
  
  File? _imageFile;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to pick image: $e';
      });
    }
  }

  Future<void> _submitPost() async {
    // Validate content
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter some content for your post';
      });
      return;
    }

    // Get current user
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userInfo = authProvider.currentUserInfo;
    
    if (userInfo == null) {
      setState(() {
        _errorMessage = 'You must be logged in to create a post';
      });
      return;
    }
    
    // Create a simple User object from the auth information
    final user = User(
      id: userInfo['uid'] ?? 'unknown',
      name: userInfo['displayName'] ?? 'Unknown User',
      imageUrl: userInfo['photoURL'],
      bio: '',
      accountType: 'individual',
    );

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      // Get image URL if image exists
      String? imageUrl;
      if (_imageFile != null) {
        // In dev mode, we'll just pass the local path 
        // In production, we would upload to Firebase Storage first
        imageUrl = _imageFile!.path;
      }

      // Create post
      final newPost = await _postService.createPost(
        user,
        content,
        imageUrl: imageUrl,
      );

      if (newPost != null && mounted) {
        // Post created successfully
        Navigator.pop(context, true); // Return success
      } else {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = 'Failed to create post: $e';
        });
      }
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera, color: AppColors.brandTeal),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.brandTeal),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_imageFile != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Remove photo'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _imageFile = null;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Create Post', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submitPost,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.brandTeal,
                    ),
                  )
                : const Text(
                    'Post',
                    style: TextStyle(
                      color: AppColors.brandTeal,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gradient divider
              Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.brandTeal.withOpacity(0.2),
                      AppColors.brandTeal,
                      AppColors.accentGold,
                      AppColors.brandTeal.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Error message
                    if (_errorMessage != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _errorMessage = null;
                                });
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),

                    // User info with card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: _buildUserInfo(),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Content text field with card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "What's on your mind?",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.brandTeal,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _contentController,
                            maxLines: 5,
                            maxLength: 500,
                            decoration: const InputDecoration(
                              hintText: "Share your thoughts...",
                              border: InputBorder.none,
                              counterStyle: TextStyle(color: AppColors.textWhite),
                            ),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Image preview
                    if (_imageFile != null) ...[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _imageFile!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _imageFile = null;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // Add photo button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _showImageSourceOptions,
                        icon: const Icon(Icons.photo_camera),
                        label: Text(_imageFile == null ? 'Add Photo' : 'Change Photo'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.brandTeal,
                          side: const BorderSide(color: AppColors.brandTeal),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    final authProvider = Provider.of<AuthProvider>(context);
    final userInfo = authProvider.currentUserInfo;

    if (userInfo == null) {
      return const SizedBox.shrink(); // Return empty widget if userInfo is null
    }

    const String defaultProfileImage = 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
            userInfo['photoURL'] ?? defaultProfileImage,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          userInfo['displayName'] ?? 'User',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
} 