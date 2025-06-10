// lib/shared/pages/splash_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart'; // Add this import

import '../../core/constants/app_constants.dart';
import '../../core/utils/extensions.dart';
import '../../app/router.dart'; // Add this import

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _textAnimationController;
  late AnimationController _progressAnimationController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSplashSequence();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _textAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    // Logo animations
    _logoAnimationController = AnimationController(
      duration:
          const Duration(milliseconds: AppConstants.mediumAnimationDuration),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Text animations
    _textAnimationController = AnimationController(
      duration:
          const Duration(milliseconds: AppConstants.mediumAnimationDuration),
      vsync: this,
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeIn,
    ));

    // Progress animation
    _progressAnimationController = AnimationController(
      duration:
          const Duration(milliseconds: AppConstants.mediumAnimationDuration),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _startSplashSequence() async {
    // Hide status bar for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Start logo animation
    await _logoAnimationController.forward();

    // Delay then start text animation
    await Future.delayed(const Duration(milliseconds: 200));
    await _textAnimationController.forward();

    // Start progress animation
    await Future.delayed(const Duration(milliseconds: 100));
    _progressAnimationController.forward();

    // Wait for all animations to complete
    await Future.delayed(
        const Duration(milliseconds: AppConstants.mediumAnimationDuration));

    // Navigate to home or onboarding
    if (mounted) {
      // Restore system UI
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      // Navigate to the main app using GoRouter
      // FIXED: Use GoRouter navigation instead of Navigator.pushReplacementNamed
      context.go(AppRouter.home);

      // Alternative approaches:
      // AppRouter.goToHome(context); // Using the helper method
      // context.go('/home'); // Direct path
      // context.pushReplacement('/home'); // If you want push replacement behavior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.primary,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.colorScheme.primary,
                context.colorScheme.primaryContainer,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Logo section
              _buildLogoSection(),

              SizedBox(height: AppConstants.defaultPadding),

              // App name and tagline
              _buildTextSection(),

              const Spacer(flex: 2),

              // Loading indicator
              _buildLoadingSection(),

              SizedBox(height: AppConstants.defaultPadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoScaleAnimation, _logoOpacityAnimation]),
      builder: (context, child) {
        return Opacity(
          opacity: _logoOpacityAnimation.value,
          child: Transform.scale(
            scale: _logoScaleAnimation.value,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: context.colorScheme.onPrimary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.share_rounded,
                size: 60,
                color: context.colorScheme.primary,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextSection() {
    return SlideTransition(
      position: _textSlideAnimation,
      child: FadeTransition(
        opacity: _textOpacityAnimation,
        child: Column(
          children: [
            Text(
              AppConstants.appName,
              style: GoogleFonts.roboto(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fast & Secure File Sharing',
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: context.colorScheme.onPrimary.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Column(
          children: [
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                value: _progressAnimation.value,
                backgroundColor: context.colorScheme.onPrimary.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading...',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: context.colorScheme.onPrimary.withOpacity(0.7),
              ),
            ),
          ],
        );
      },
    );
  }
}
