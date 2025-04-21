import 'package:flutter/material.dart';
import 'package:supportblkgnv/components/custom_app_bar.dart';
import 'package:supportblkgnv/components/post_card.dart';
import 'package:supportblkgnv/models/post.dart';
import 'package:supportblkgnv/screens/create_post_screen.dart';
import 'package:supportblkgnv/screens/public_profile.dart';
import 'package:supportblkgnv/services/post_service.dart';
import 'package:supportblkgnv/theme.dart';
import 'package:provider/provider.dart';
import 'package:supportblkgnv/providers/auth_provider.dart';


class HomeScreen extends StatefulWidget {
  final bool showFloatingActionButton;
  
  const HomeScreen({
    Key? key, 
    this.showFloatingActionButton = true,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Post> _posts = [];
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();
  final PostService _postService = PostService();

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      final posts = await _postService.getPosts();
      
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading posts: ${e.toString()}'),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _refreshFeed() async {
    await _loadPosts();
  }

  void _handleChatPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chat feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
  
  void _handleCreatePost() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserInfo = authProvider.currentUserInfo;
    
    if (currentUserInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to create a post'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    // Navigate to CreatePostScreen and refresh posts when returning
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreatePostScreen()),
    );
    
    if (result == true && mounted) {
      _refreshFeed();
    }
  }
  
  void _updatePost(Post updatedPost) {
    setState(() {
      final index = _posts.indexWhere((post) => post.id == updatedPost.id);
      if (index != -1) {
        _posts[index] = updatedPost;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: CustomAppBar(onChatPressed: _handleChatPressed),
      body: _isLoading 
          ? _buildLoadingIndicator()
          : _buildPostsList(),
      floatingActionButton: widget.showFloatingActionButton ? FloatingActionButton(
        onPressed: _handleCreatePost,
        backgroundColor: AppColors.brandTeal,
        child: const Icon(Icons.add),
      ) : null,
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.brandTeal,
      ),
    );
  }

  Widget _buildPostsList() {
    return RefreshIndicator(
      onRefresh: _refreshFeed,
      color: AppColors.brandTeal,
      backgroundColor: AppColors.cardBackground,
      child: _posts.isEmpty 
          ? _buildEmptyState()
          : ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                return PostCard(
                  post: _posts[index],
                  onPostUpdated: _updatePost,
                  onProfileTap: (userId) {
                    Navigator.pushNamed(
                      context,
                      '/public_profile',
                      arguments: userId,
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.feed_outlined,
            size: 80,
            color: AppColors.textWhite.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No posts yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to post something!',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textWhite.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _handleCreatePost,
            icon: const Icon(Icons.add),
            label: const Text('Create Post'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandTeal,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
} 