import 'package:flutter/material.dart';
import 'package:supportblkgnv/theme.dart';

enum SocialPlatform {
  google,
  facebook,
  apple,
}

class SocialSignInButton extends StatelessWidget {
  final SocialPlatform platform;
  final VoidCallback onPressed;
  final bool isLoading;
  
  const SocialSignInButton({
    Key? key,
    required this.platform,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.0,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cardBackground,
          foregroundColor: AppColors.textWhite,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: AppColors.divider,
              width: 1.0,
            ),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getPlatformColor(),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _getPlatformIcon(),
                  const SizedBox(width: 12.0),
                  Text(
                    'Continue with ${_getPlatformName()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  
  String _getPlatformName() {
    switch (platform) {
      case SocialPlatform.google:
        return 'Google';
      case SocialPlatform.facebook:
        return 'Facebook';
      case SocialPlatform.apple:
        return 'Apple';
    }
  }
  
  Widget _getPlatformIcon() {
    switch (platform) {
      case SocialPlatform.google:
        return Icon(
          Icons.g_mobiledata,
          color: Colors.red.shade500,
          size: 28.0,
        );
      case SocialPlatform.facebook:
        return Icon(
          Icons.facebook,
          color: Colors.blue.shade700,
          size: 28.0,
        );
      case SocialPlatform.apple:
        return const Icon(
          Icons.apple,
          color: Colors.white,
          size: 28.0,
        );
    }
  }
  
  Color _getPlatformColor() {
    switch (platform) {
      case SocialPlatform.google:
        return Colors.red.shade500;
      case SocialPlatform.facebook:
        return Colors.blue.shade700;
      case SocialPlatform.apple:
        return Colors.white;
    }
  }
} 