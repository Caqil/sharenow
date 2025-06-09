import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/shadows.dart';
import '../../constants/app_constants.dart';

class AppHoverEffects {
  AppHoverEffects._();

  // Animation durations
  static const Duration fast =
      Duration(milliseconds: AppConstants.shortAnimationDuration);
  static const Duration medium =
      Duration(milliseconds: AppConstants.mediumAnimationDuration);
  static const Duration slow =
      Duration(milliseconds: AppConstants.longAnimationDuration);

  // Hover scale transforms
  static const double scaleNone = 1.0;
  static const double scaleSubtle = 1.02;
  static const double scaleSmall = 1.05;
  static const double scaleMedium = 1.08;
  static const double scaleLarge = 1.12;

  // Hover elevation changes
  static const double elevationNone = 0.0;
  static const double elevationSubtle = 2.0;
  static const double elevationSmall = 4.0;
  static const double elevationMedium = 8.0;
  static const double elevationLarge = 12.0;

  // Hover opacity changes
  static const double opacityFull = 1.0;
  static const double opacityHigh = 0.9;
  static const double opacityMedium = 0.8;
  static const double opacityLow = 0.7;
  static const double opacitySubtle = 0.95;

  // Color hover states
  static const Color primaryHover = AppColors.primary600;
  static const Color secondaryHover = AppColors.neutral300;
  static const Color destructiveHover = AppColors.error600;
  static const Color successHover = AppColors.success600;
  static const Color warningHover = AppColors.warning600;

  // Curve presets
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeOutCubic;
  static const Curve sharpCurve = Curves.easeInOutCubic;
}

/// Hover effect widget for buttons and interactive elements
class HoverEffect extends StatefulWidget {
  const HoverEffect({
    super.key,
    required this.child,
    this.hoverScale = AppHoverEffects.scaleSubtle,
    this.hoverElevation = AppHoverEffects.elevationSubtle,
    this.hoverOpacity = AppHoverEffects.opacityFull,
    this.hoverColor,
    this.duration = AppHoverEffects.medium,
    this.curve = AppHoverEffects.defaultCurve,
    this.enabled = true,
    this.onHover,
  });

  final Widget child;
  final double hoverScale;
  final double hoverElevation;
  final double hoverOpacity;
  final Color? hoverColor;
  final Duration duration;
  final Curve curve;
  final bool enabled;
  final ValueChanged<bool>? onHover;

  @override
  State<HoverEffect> createState() => _HoverEffectState();
}

class _HoverEffectState extends State<HoverEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _opacityAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.hoverScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _elevationAnimation = Tween<double>(
      begin: 0.0,
      end: widget.hoverElevation,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: widget.hoverOpacity,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    if (!widget.enabled) return;

    setState(() {
      _isHovered = isHovered;
    });

    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    widget.onHover?.call(isHovered);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedOpacity(
              opacity: _opacityAnimation.value,
              duration: widget.duration,
              curve: widget.curve,
              child: Material(
                elevation: _elevationAnimation.value,
                color: widget.hoverColor != null && _isHovered
                    ? widget.hoverColor
                    : Colors.transparent,
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Predefined hover effects for common components
class HoverPresets {
  HoverPresets._();

  /// Subtle hover for cards and containers
  static Widget card({required Widget child, VoidCallback? onTap}) {
    return HoverEffect(
      hoverScale: AppHoverEffects.scaleSubtle,
      hoverElevation: AppHoverEffects.elevationSmall,
      duration: AppHoverEffects.medium,
      curve: AppHoverEffects.smoothCurve,
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }

  /// Button hover with scale and color change
  static Widget button({
    required Widget child,
    VoidCallback? onTap,
    Color? hoverColor,
  }) {
    return HoverEffect(
      hoverScale: AppHoverEffects.scaleSmall,
      hoverElevation: AppHoverEffects.elevationMedium,
      hoverColor: hoverColor ?? AppHoverEffects.primaryHover,
      duration: AppHoverEffects.fast,
      curve: AppHoverEffects.defaultCurve,
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }

  /// Icon hover with subtle scale
  static Widget icon({required Widget child, VoidCallback? onTap}) {
    return HoverEffect(
      hoverScale: AppHoverEffects.scaleMedium,
      hoverOpacity: AppHoverEffects.opacityHigh,
      duration: AppHoverEffects.fast,
      curve: AppHoverEffects.bounceCurve,
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }

  /// List item hover
  static Widget listItem({required Widget child, VoidCallback? onTap}) {
    return HoverEffect(
      hoverScale: AppHoverEffects.scaleNone,
      hoverElevation: AppHoverEffects.elevationSubtle,
      hoverColor: AppColors.lightSurfaceVariant,
      duration: AppHoverEffects.medium,
      curve: AppHoverEffects.smoothCurve,
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }

  /// Floating action button hover
  static Widget fab({required Widget child, VoidCallback? onTap}) {
    return HoverEffect(
      hoverScale: AppHoverEffects.scaleLarge,
      hoverElevation: AppHoverEffects.elevationLarge,
      duration: AppHoverEffects.medium,
      curve: AppHoverEffects.bounceCurve,
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }

  /// Image hover with zoom effect
  static Widget image({required Widget child, VoidCallback? onTap}) {
    return HoverEffect(
      hoverScale: AppHoverEffects.scaleMedium,
      hoverElevation: AppHoverEffects.elevationSmall,
      duration: AppHoverEffects.slow,
      curve: AppHoverEffects.smoothCurve,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: child,
        ),
      ),
    );
  }

  /// Navigation item hover
  static Widget navigation({required Widget child, VoidCallback? onTap}) {
    return HoverEffect(
      hoverScale: AppHoverEffects.scaleSubtle,
      hoverOpacity: AppHoverEffects.opacitySubtle,
      hoverColor: AppColors.primary100,
      duration: AppHoverEffects.fast,
      curve: AppHoverEffects.defaultCurve,
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }
}

/// Advanced hover effects with custom animations
class AdvancedHoverEffects {
  AdvancedHoverEffects._();

  /// Shimmer hover effect
  static Widget shimmer({required Widget child, VoidCallback? onTap}) {
    return _ShimmerHover(
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }

  /// Glow hover effect
  static Widget glow({
    required Widget child,
    VoidCallback? onTap,
    Color glowColor = AppColors.primary500,
  }) {
    return _GlowHover(
      glowColor: glowColor,
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }

  /// Bounce hover effect
  static Widget bounce({required Widget child, VoidCallback? onTap}) {
    return _BounceHover(
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }

  /// Rotate hover effect
  static Widget rotate({required Widget child, VoidCallback? onTap}) {
    return _RotateHover(
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }
}

// Private implementations of advanced hover effects

class _ShimmerHover extends StatefulWidget {
  const _ShimmerHover({required this.child});
  final Widget child;

  @override
  State<_ShimmerHover> createState() => _ShimmerHoverState();
}

class _ShimmerHoverState extends State<_ShimmerHover>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.repeat(),
      onExit: (_) => _controller.stop(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: const [
                  Colors.transparent,
                  Colors.white,
                  Colors.transparent,
                ],
                stops: [
                  (_animation.value - 1).clamp(0.0, 1.0),
                  _animation.value.clamp(0.0, 1.0),
                  (_animation.value + 1).clamp(0.0, 1.0),
                ],
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: widget.child,
          );
        },
      ),
    );
  }
}

class _GlowHover extends StatefulWidget {
  const _GlowHover({required this.child, required this.glowColor});
  final Widget child;
  final Color glowColor;

  @override
  State<_GlowHover> createState() => _GlowHoverState();
}

class _GlowHoverState extends State<_GlowHover>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppHoverEffects.medium,
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor.withOpacity(0.3),
                  blurRadius: _glowAnimation.value,
                  spreadRadius: _glowAnimation.value / 4,
                ),
              ],
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}

class _BounceHover extends StatefulWidget {
  const _BounceHover({required this.child});
  final Widget child;

  @override
  State<_BounceHover> createState() => _BounceHoverState();
}

class _BounceHoverState extends State<_BounceHover>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _bounceAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

class _RotateHover extends StatefulWidget {
  const _RotateHover({required this.child});
  final Widget child;

  @override
  State<_RotateHover> createState() => _RotateHoverState();
}

class _RotateHoverState extends State<_RotateHover>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppHoverEffects.medium,
      vsync: this,
    );
    _rotateAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _rotateAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotateAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}
