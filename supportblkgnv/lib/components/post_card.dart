import 'package:flutter/material.dart';
import 'package:supportblkgnv/models/post.dart';
import 'package:supportblkgnv/models/user.dart';
import 'package:supportblkgnv/theme.dart';
import 'package:supportblkgnv/utils/date_formatter.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLiked = false;
  bool _showComments = false;

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
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(widget.post.author.imageUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.post.author.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
                        DateFormatter.formatTimeAgo(widget.post.createdAt),
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
              child: Image.network(
                widget.post.imageUrl!,
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
              ),
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
                      onTap: () {
                        setState(() {
                          _isLiked = !_isLiked;
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              _isLiked 
                                  ? Icons.favorite 
                                  : Icons.favorite_border,
                              color: _isLiked 
                                  ? accentColor 
                                  : null,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(widget.post.likes.length.toString()),
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
                                widget.post.likes[i].imageUrl,
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
            ...widget.post.comments.map((comment) => _buildCommentTile(comment, accentColor)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    child: Icon(Icons.person, size: 20),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle: TextStyle(
                          color: AppColors.textWhite.withOpacity(0.5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[800],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: accentColor,
                    ),
                    onPressed: () {
                      // Send comment
                    },
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
            backgroundImage: NetworkImage(comment.user.imageUrl),
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
                      DateFormatter.formatTimeAgo(comment.createdAt),
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
} 