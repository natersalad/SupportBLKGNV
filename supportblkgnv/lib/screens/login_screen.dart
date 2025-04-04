import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:supportblkgnv/components/custom_button.dart';
import 'package:supportblkgnv/components/custom_text_field.dart';
import 'package:supportblkgnv/components/social_sign_in_button.dart';
import 'package:supportblkgnv/providers/auth_provider.dart';
import 'package:supportblkgnv/screens/forgot_password_screen.dart';
import 'package:supportblkgnv/screens/register_screen.dart';
import 'package:supportblkgnv/theme.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  bool _rememberMe = false;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    // Set demo credentials for development
    _emailController.text = 'demo@supportblkgnv.com';
    _passwordController.text = 'password123';
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      if (success && mounted) {
        // Navigate to main screen with bottom navigation bar instead of just home
        Navigator.of(context).pushReplacementNamed('/');
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo and welcome animation
                  _buildHeader(),
                  
                  // Error message
                  if (authProvider.errorMessage != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade700),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red.shade700),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              authProvider.errorMessage!,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              authProvider.clearError();
                            },
                          ),
                        ],
                      ),
                    ),
                  
                  // Login form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          label: 'Email',
                          hintText: 'Enter your email address',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email, color: AppColors.brandTeal),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!EmailValidator.validate(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        
                        CustomTextField(
                          label: 'Password',
                          hintText: 'Enter your password',
                          controller: _passwordController,
                          obscureText: true,
                          prefixIcon: const Icon(Icons.lock, color: AppColors.brandTeal),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _signIn(),
                        ),
                        
                        // Remember me & Forgot password
                        _buildRememberForgot(),
                        
                        const SizedBox(height: 24),
                        
                        // Login button
                        CustomButton(
                          text: 'Log In',
                          onPressed: _signIn,
                          isLoading: authProvider.isLoading,
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Demo Login button for development
                        CustomButton(
                          text: 'Demo Login',
                          onPressed: () {
                            _emailController.text = 'demo@supportblkgnv.com';
                            _passwordController.text = 'password123';
                            _signIn();
                          },
                          isPrimary: false,
                          isOutlined: true,
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Or continue with divider
                        _buildDivider(),
                        
                        const SizedBox(height: 24),
                        
                        // Social sign-in buttons
                        SocialSignInButton(
                          platform: SocialPlatform.google,
                          onPressed: () {
                            // TODO: Implement Google sign-in
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        SocialSignInButton(
                          platform: SocialPlatform.facebook,
                          onPressed: () {
                            // TODO: Implement Facebook sign-in
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        SocialSignInButton(
                          platform: SocialPlatform.apple,
                          onPressed: () {
                            // TODO: Implement Apple sign-in
                          },
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Register link
                        _buildRegisterLink(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Column(
      children: [
        // App logo
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Support',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'BLK',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.brandTeal,
              ),
            ),
            Text(
              'GNV',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.accentGold,
              ),
            ),
          ],
        ),
        
        // Animation - Switch to a local asset to avoid network issues
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Icon(
            Icons.handshake,
            size: 120.0,
            color: AppColors.brandTeal,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Welcome text
        Text(
          'Welcome Back!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'Sign in to continue supporting the Black community in Gainesville',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        
        const SizedBox(height: 32),
      ],
    );
  }
  
  Widget _buildRememberForgot() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Remember me
          Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                  activeColor: AppColors.brandTeal,
                  checkColor: AppColors.textWhite,
                  side: BorderSide(color: AppColors.divider),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Remember me',
                style: TextStyle(color: AppColors.textWhite),
              ),
            ],
          ),
          
          // Forgot password
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ForgotPasswordScreen(),
                ),
              );
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: AppColors.brandTeal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.divider,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Or continue with',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.divider,
            thickness: 1,
          ),
        ),
      ],
    );
  }
  
  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account?',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              ),
            );
          },
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: AppColors.brandTeal,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
} 