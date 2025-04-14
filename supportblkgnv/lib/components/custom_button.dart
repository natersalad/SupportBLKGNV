import 'package:flutter/material.dart';
import 'package:supportblkgnv/theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isPrimary;
  final bool isOutlined;
  final double width;
  final double height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final BorderRadius? borderRadius;
  final Widget? icon;
  
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isPrimary = true,
    this.isOutlined = false,
    this.width = double.infinity,
    this.height = 56.0,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.borderRadius,
    this.icon,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final Color btnColor = backgroundColor ?? (isPrimary 
        ? AppColors.brandTeal
        : isOutlined 
            ? Colors.transparent 
            : Colors.grey[800]!);
            
    final Color txtColor = textColor ?? (isOutlined 
        ? AppColors.brandTeal 
        : AppColors.textWhite);
        
    final BorderRadius radius = borderRadius ?? BorderRadius.circular(8.0);
    
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: padding ?? const EdgeInsets.symmetric(vertical: 12.0),
          backgroundColor: btnColor,
          foregroundColor: txtColor,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: isOutlined 
                ? BorderSide(color: AppColors.brandTeal, width: 2.0) 
                : BorderSide.none,
          ),
          elevation: isOutlined ? 0 : 2,
        ),
        child: isLoading
            ? _buildLoadingIndicator()
            : _buildButtonContent(),
      ),
    );
  }
  
  Widget _buildLoadingIndicator() {
    return SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(
          isOutlined ? AppColors.brandTeal : AppColors.textWhite
        ),
      ),
    );
  }
  
  Widget _buildButtonContent() {
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize ?? 16.0,
            ),
          ),
        ],
      );
    }
    
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: fontSize ?? 16.0,
      ),
    );
  }
} 