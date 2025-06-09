import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../tokens/colors.dart';
import '../../constants/app_constants.dart';

class AppTapEffects {
  AppTapEffects._();

  static const Duration duration = Duration(milliseconds: 150);
  static const double scaleDown = 0.95;
  static const Curve curve = Curves.easeInOut;
  static const Color rippleColor = AppColors.primary100;
}

/// Basic tap effect with scale and haptic feedback
class TapEffect extends StatefulWidget {
  const TapEffect({
    super.key,
    required this.child,
    required this.onTap,
    this.onLongPress,
    this.scale = AppTapEffects.scaleDown,
    this.enableHaptic = true,
    this.enableRipple = true,
    this.rippleColor,
    this.borderRadius,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scale;
  final bool enableHaptic;
  final bool enableRipple;
  final Color? rippleColor;
  final BorderRadius? borderRadius;
  final bool enabled;

  @override
  State<TapEffect> createState() => _TapEffectState();
}

class _TapEffectState extends State<TapEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTapEffects.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppTapEffects.curve,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enabled) return;
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enabled) return;
    _controller.reverse();
  }

  void _handleTapCancel() {
    if (!widget.enabled) return;
    _controller.reverse();
  }

  void _handleTap() {
    if (!widget.enabled || widget.onTap == null) return;

    if (widget.enableHaptic) {
      HapticFeedback.lightImpact();
    }

    widget.onTap!();
  }

  void _handleLongPress() {
    if (!widget.enabled || widget.onLongPress == null) return;

    if (widget.enableHaptic) {
      HapticFeedback.mediumImpact();
    }

    widget.onLongPress!();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        );
      },
    );

    if (widget.enableRipple) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleTap,
          onLongPress: _handleLongPress,
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          splashColor: widget.rippleColor ?? AppTapEffects.rippleColor,
          highlightColor: (widget.rippleColor ?? AppTapEffects.rippleColor)
              .withOpacity(0.1),
          borderRadius: widget.borderRadius,
          child: child,
        ),
      );
    }

    return GestureDetector(
      onTap: _handleTap,
      onLongPress: _handleLongPress,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: child,
    );
  }
}

/// Quick tap effect presets
class TapPresets {
  TapPresets._();

  /// Button tap
  static Widget button({
    required Widget child,
    required VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return TapEffect(
      onTap: onTap,
      onLongPress: onLongPress,
      scale: 0.95,
      borderRadius: BorderRadius.circular(8),
      child: child,
    );
  }

  /// Card tap
  static Widget card({
    required Widget child,
    required VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return TapEffect(
      onTap: onTap,
      onLongPress: onLongPress,
      scale: 0.98,
      borderRadius: BorderRadius.circular(12),
      child: child,
    );
  }

  /// Icon button tap
  static Widget icon({
    required Widget child,
    required VoidCallback? onTap,
  }) {
    return TapEffect(
      onTap: onTap,
      scale: 0.9,
      borderRadius: BorderRadius.circular(20),
      child: child,
    );
  }

  /// List item tap
  static Widget listItem({
    required Widget child,
    required VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return TapEffect(
      onTap: onTap,
      onLongPress: onLongPress,
      scale: 1.0, // No scale for list items
      enableHaptic: false,
      child: child,
    );
  }

  /// FAB tap
  static Widget fab({
    required Widget child,
    required VoidCallback? onTap,
  }) {
    return TapEffect(
      onTap: onTap,
      scale: 0.9,
      borderRadius: BorderRadius.circular(28),
      child: child,
    );
  }
}
