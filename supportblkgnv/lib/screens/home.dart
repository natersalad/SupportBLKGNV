import 'package:flutter/material.dart';
import 'package:supportblkgnv/components/custom_app_bar.dart';
import 'package:supportblkgnv/components/post_card.dart';
import 'package:supportblkgnv/models/post.dart';
import 'package:supportblkgnv/services/mock_data_service.dart';
import 'package:supportblkgnv/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Post> _posts;
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    // Simulate loading from a service
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _posts = MockDataService.getPosts();
      _isLoading = false;
    });
  }

  Future<void> _refreshFeed() async {
    setState(() {
      _isLoading = true;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: CustomAppBar(onChatPressed: _handleChatPressed),
      body: _isLoading 
          ? _buildLoadingIndicator()
          : _buildPostsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new post
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Create post feature coming soon!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        backgroundColor: AppColors.brandTeal,
        child: const Icon(Icons.add),
      ),
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
                return PostCard(post: _posts[index]);
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
            onPressed: () {
              // Create post
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Create post feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
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