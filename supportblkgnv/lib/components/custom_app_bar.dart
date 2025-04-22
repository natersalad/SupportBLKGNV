import 'package:flutter/material.dart';
import 'package:supportblkgnv/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onChatPressed;
  final VoidCallback? onSearchPressed; // ← new optional callback

  const CustomAppBar({
    Key? key,
    required this.onChatPressed,
    this.onSearchPressed,             // ← accept it here
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.primaryBackground,
      title: Row(
        children: const [
          Text(
            'Support',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: AppColors.textWhite,
            ),
          ),
          Text(
            'BLK',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: AppColors.brandTeal,
            ),
          ),
          Text(
            'GNV',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: AppColors.accentGold,
            ),
          ),
        ],
      ),
      actions: [
        // only show search icon if a handler was provided
        if (onSearchPressed != null)
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.brandTeal),
            onPressed: onSearchPressed,
          ),

        IconButton(
          icon: const Icon(
            Icons.chat_bubble_outline,
            color: AppColors.brandTeal,
          ),
          onPressed: onChatPressed,
        ),
      ],
    );
  }
}
