import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Responsive.getPadding(context),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xxl),
                
                // Logo and Welcome Section
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: AppColors.goldGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGold.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.diamond,
                          size: 60,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Welcome to Digi Gold',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Your digital gold investment journey starts here',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppSpacing.xxl),
                
                // Login Form
                Text(
                  'Login to your account',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                
                CustomTextField(
                  label: 'Mobile Number',
                  hint: 'Enter your mobile number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone,
                  validator: _validatePhone,
                ),
                
                const SizedBox(height: AppSpacing.xl),
                
                // Login Button
                CustomButton(
                  text: 'Send OTP',
                  onPressed: _isLoading ? null : _handleSendOTP,
                  isLoading: _isLoading,
                  isFullWidth: true,
                  type: ButtonType.primary,
                ),
                
                const SizedBox(height: AppSpacing.lg),
                
                // Alternative Login Options
                Center(
                  child: Column(
                    children: [
                      Text(
                        'or',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Demo Login Button (Temporary)
                      GradientButton(
                        text: 'Demo Login (Skip OTP)',
                        onPressed: _handleDemoLogin,
                        gradient: AppColors.goldGreenGradient,
                        icon: Icons.play_arrow,
                        isFullWidth: true,
                      ),

                      const SizedBox(height: AppSpacing.md),

                      CustomButton(
                        text: 'Login with Biometric',
                        onPressed: _handleBiometricLogin,
                        type: ButtonType.outline,
                        icon: Icons.fingerprint,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppSpacing.xxl),
                
                // Register Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: _navigateToRegister,
                        child: Text(
                          'Register',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryGold,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppSpacing.xl),
                
                // Terms and Privacy
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Text(
                      'By continuing, you agree to our Terms of Service and Privacy Policy',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }
    if (value.length != 10) {
      return 'Please enter a valid 10-digit mobile number';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Please enter only numbers';
    }
    return null;
  }

  void _handleSendOTP() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Navigate to OTP screen
      _navigateToOTP();
    }
  }

  void _handleDemoLogin() {
    // Navigate directly to home screen for demo purposes
    _navigateToHome();
  }

  void _handleBiometricLogin() {
    // TODO: Implement biometric authentication
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Biometric login will be implemented'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _navigateToRegister() {
    // TODO: Navigate to registration screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registration screen will be implemented'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _navigateToOTP() {
    // TODO: Navigate to OTP verification screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('OTP sent to ${_phoneController.text}'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _navigateToHome() {
    // Navigate to home screen (we'll import this from main.dart)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }
}
