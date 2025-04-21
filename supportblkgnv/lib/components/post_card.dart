import 'package:flutter/material.dart';
import 'dart:io';
import 'package:supportblkgnv/models/post.dart';
import 'package:supportblkgnv/models/user.dart';
import 'package:supportblkgnv/theme.dart';
import 'package:supportblkgnv/utils/date_formatter.dart';
import 'package:supportblkgnv/services/post_service.dart';
import 'package:provider/provider.dart';
import 'package:supportblkgnv/providers/auth_provider.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final Function(Post)? onPostUpdated;
  final void Function(String userId)? onProfileTap;

  const PostCard({
    Key? key,
    required this.post,
    this.onPostUpdated,
    this.onProfileTap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final PostService _postService = PostService();
  bool _isLiked = false;
  bool _showComments = false;
  bool _isLiking = false;
  late List<User> _likes;
  String _commentText = '';
  bool _isAddingComment = false;
  late TextEditingController _commentController;
  
  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _likes = List.from(widget.post.likes);
    
    // Check if current user has liked the post
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserInfo = authProvider.currentUserInfo;
    
    if (currentUserInfo != null) {
      final String uid = currentUserInfo['uid'];
      _isLiked = _likes.any((user) => user.id == uid);
    }
  }
  
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // Like/unlike post
  Future<void> _toggleLike() async {
    if (_isLiking) return;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserInfo = authProvider.currentUserInfo;
    
    if (currentUserInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You need to be logged in to like posts'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    setState(() => _isLiking = true);
    
    try {
      // Get current user
      final String uid = currentUserInfo['uid'];
      final String name = currentUserInfo['displayName'] ?? 'User';
      
      // Create a temporary user object
      final currentUser = User(
        id: uid,
        name: name,
        imageUrl: currentUserInfo['photoURL'],
        bio: '',
        accountType: 'individual',
      );
      
      // Call the post service
      final success = await _postService.toggleLike(widget.post.id, currentUser);
      
      if (success) {
        setState(() {
          if (_isLiked) {
            // Remove user from likes
            _likes.removeWhere((user) => user.id == uid);
          } else {
            // Add user to likes
            _likes.add(currentUser);
          }
          _isLiked = !_isLiked;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() => _isLiking = false);
    }
  }
  
  // Add a comment
  Future<void> _addComment() async {
    if (_commentText.trim().isEmpty || _isAddingComment) return;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserInfo = authProvider.currentUserInfo;
    
    if (currentUserInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You need to be logged in to comment'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    setState(() => _isAddingComment = true);
    
    try {
      // Get current user
      final String uid = currentUserInfo['uid'];
      final String name = currentUserInfo['displayName'] ?? 'User';
      
      // Create a temporary user object
      final currentUser = User(
        id: uid,
        name: name,
        imageUrl: currentUserInfo['photoURL'],
        bio: '',
        accountType: 'individual',
      );
      
      // Call the post service
      final comment = await _postService.addComment(
        widget.post.id, 
        currentUser, 
        _commentText.trim()
      );
      
      if (comment != null) {
        // Clear comment text
        _commentController.clear();
        setState(() {
          _commentText = '';
          // TODO: Update the post with the new comment
          // Will need to coordinate with the parent widget
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() => _isAddingComment = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isBusiness = widget.post.author.isBusiness;
    final Color glowColor = isBusiness 
        ? AppColors.businessPurpleGlow 
        : AppColors.individualBlueGlow;
    final Color accentColor = isBusiness 
        ? AppColors.businessPurple 
        : AppColors.individualBlue;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: glowColor,
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: accentColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                InkWell(
                  onTap: widget.onProfileTap == null
                      ? null
                      : () => widget.onProfileTap!(widget.post.author.id),
                  borderRadius: BorderRadius.circular(24),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      widget.post.author.imageUrl ?? 'https://via.placeholder.com/40',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: widget.onProfileTap == null
                                ? null
                                : () => widget.onProfileTap!(widget.post.author.id),
                            child: Text(
                              widget.post.author.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (isBusiness) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.verified,
                              color: accentColor,
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                      Text(
                        "${widget.post.createdAt.day}/${widget.post.createdAt.month}/${widget.post.createdAt.year}",
                        style: TextStyle(
                          color: AppColors.textWhite.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // Show post options
                  },
                ),
              ],
            ),
          ),
          
          // Post content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              widget.post.content,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          
          // Post image (if any)
          if (widget.post.imageUrl != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: _buildPostImage(widget.post.imageUrl!),
            ),
          ],
          
          // Post actions
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: _isLiking ? null : _toggleLike,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            _isLiking
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  _isLiked 
                                      ? Icons.favorite 
                                      : Icons.favorite_border,
                                  color: _isLiked 
                                      ? accentColor 
                                      : null,
                                  size: 20,
                                ),
                            const SizedBox(width: 4),
                            Text(_likes.length.toString()),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _showComments = !_showComments;
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.chat_bubble_outline,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(widget.post.comments.length.toString()),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    // Share post
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.share,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Likes summary
          if (widget.post.likes.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    height: 20,
                    child: Stack(
                      children: [
                        for (int i = 0; i < min(3, widget.post.likes.length); i++)
                          Positioned(
                            left: i * 15.0,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundImage: NetworkImage(
                                widget.post.likes[i].imageUrl ?? 'https://via.placeholder.com/40',
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getLikesSummary(widget.post.likes),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textWhite.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: AppColors.divider,
              height: 1,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
          ],
          
          // Comments section
          if (_showComments && widget.post.comments.isNotEmpty) ...[
            const Divider(height: 16, thickness: 0.5),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comments (${widget.post.comments.length})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...widget.post.comments.map((comment) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: comment.user.imageUrl != null
                              ? NetworkImage(comment.user.imageUrl!)
                              : null,
                          child: comment.user.imageUrl == null
                              ? Icon(Icons.person, size: 16)
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                comment.text,
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "${comment.createdAt.day}/${comment.createdAt.month}/${comment.createdAt.year}",
                                style: TextStyle(
                                  color: AppColors.textWhite.withOpacity(0.6),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                  
                  // Add comment button
                  TextButton.icon(
                    icon: const Icon(Icons.add_comment, size: 14),
                    label: const Text('Add Comment'),
                    onPressed: () => _showCommentDialog(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentTile(Comment comment, Color accentColor) {
    final isBusiness = comment.user.isBusiness;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(comment.user.imageUrl ?? 'https://via.placeholder.com/40'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    if (isBusiness) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.verified,
                        color: isBusiness ? AppColors.businessPurple : accentColor,
                        size: 12,
                      ),
                    ],
                    const SizedBox(width: 4),
                    Text(
                      "${comment.createdAt.day}/${comment.createdAt.month}/${comment.createdAt.year}",
                      style: TextStyle(
                        color: AppColors.textWhite.withOpacity(0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  comment.text,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getLikesSummary(List<User> likes) {
    if (likes.isEmpty) {
      return "No likes yet";
    } else if (likes.length == 1) {
      return "Liked by ${likes[0].name}";
    } else if (likes.length == 2) {
      return "Liked by ${likes[0].name} and ${likes[1].name}";
    } else {
      return "Liked by ${likes[0].name} and ${likes.length - 1} others";
    }
  }
  
  int min(int a, int b) {
    return a < b ? a : b;
  }

  void _showCommentDialog(BuildContext context) {
    final commentController = TextEditingController();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userInfo = authProvider.currentUserInfo;
    
    if (userInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to comment')),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text('Add Comment'),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(
            hintText: 'Write your comment...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (commentController.text.trim().isEmpty) {
                return;
              }
              
              // Create a simple User object
              final user = User(
                id: userInfo['uid'] ?? 'unknown',
                name: userInfo['displayName'] ?? 'Unknown User',
                imageUrl: userInfo['photoURL'],
                bio: '',
                accountType: 'individual',
              );
              
              // Submit comment
              final postService = PostService();
              final newComment = await postService.addComment(
                widget.post.id,
                user,
                commentController.text.trim(),
              );
              
              if (newComment != null) {
                // Update post with new comment
                final updatedPost = Post(
                  id: widget.post.id,
                  author: widget.post.author,
                  content: widget.post.content,
                  imageUrl: widget.post.imageUrl,
                  createdAt: widget.post.createdAt,
                  likes: widget.post.likes,
                  comments: [...widget.post.comments, newComment],
                );
                
                if (widget.onPostUpdated != null) {
                  widget.onPostUpdated!(updatedPost);
                }
                Navigator.pop(context);
              }
            },
            child: const Text('Post', style: TextStyle(color: AppColors.brandTeal)),
          ),
        ],
      ),
    );
  }

  Widget _buildPostImage(String imageUrl) {
    // Check if the image is a local file path or a network URL
    if (imageUrl.startsWith('http')) {
      // Network image
      return Image.network(
        imageUrl,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 200,
            color: Colors.grey[800],
            child: const Center(
              child: Icon(Icons.error),
            ),
          );
        },
      );
    } else {
      // Local file path
      try {
        final file = File(imageUrl);
        return Image.file(
          file,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[800],
              child: const Center(
                child: Icon(Icons.error),
              ),
            );
          },
        );
      } catch (e) {
        return Container(
          width: double.infinity,
          height: 200,
          color: Colors.grey[800],
          child: const Center(
            child: Text('Failed to load image'),
          ),
        );
      }
    }
  }
} 