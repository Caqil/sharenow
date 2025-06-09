import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class AppPageTransitions {
  AppPageTransitions._();

  static const Duration duration =
      Duration(milliseconds: AppConstants.pageTransitionDuration);
  static const Curve curve = Curves.easeInOut;
  static const Curve materialCurve = Curves.fastOutSlowIn;

  // Slide directions
  static const Offset slideLeft = Offset(-1.0, 0.0);
  static const Offset slideRight = Offset(1.0, 0.0);
  static const Offset slideUp = Offset(0.0, -1.0);
  static const Offset slideDown = Offset(0.0, 1.0);
}

/// Slide transition
class SlidePageTransition<T> extends PageRouteBuilder<T> {
  SlidePageTransition({
    required this.child,
    this.direction = AppPageTransitions.slideRight,
    this.duration = AppPageTransitions.duration,
    super.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween<Offset>(
              begin: direction,
              end: Offset.zero,
            ).chain(CurveTween(curve: AppPageTransitions.curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );

  final Widget child;
  final Offset direction;
  final Duration duration;
}

/// Fade transition
class FadePageTransition<T> extends PageRouteBuilder<T> {
  FadePageTransition({
    required this.child,
    this.duration = AppPageTransitions.duration,
    super.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity:
                  animation.drive(CurveTween(curve: AppPageTransitions.curve)),
              child: child,
            );
          },
        );

  final Widget child;
  final Duration duration;
}

/// Scale transition for modals
class ScalePageTransition<T> extends PageRouteBuilder<T> {
  ScalePageTransition({
    required this.child,
    this.duration = AppPageTransitions.duration,
    super.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween<double>(begin: 0.8, end: 1.0)
                .chain(CurveTween(curve: Curves.elasticOut));

            return ScaleTransition(
              scale: animation.drive(tween),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        );

  final Widget child;
  final Duration duration;
}

/// Slide and fade combined
class SlideFadePageTransition<T> extends PageRouteBuilder<T> {
  SlideFadePageTransition({
    required this.child,
    this.direction = AppPageTransitions.slideRight,
    this.duration = AppPageTransitions.duration,
    super.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final slideTween = Tween<Offset>(
              begin: direction,
              end: Offset.zero,
            ).chain(CurveTween(curve: AppPageTransitions.materialCurve));

            return SlideTransition(
              position: animation.drive(slideTween),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        );

  final Widget child;
  final Offset direction;
  final Duration duration;
}

/// Easy-to-use transition methods
class AppTransitions {
  AppTransitions._();

  /// Forward navigation (slide left)
  static Route<T> slideLeft<T>(Widget child, [RouteSettings? settings]) {
    return SlidePageTransition<T>(
      child: child,
      direction: AppPageTransitions.slideLeft,
      settings: settings,
    );
  }

  /// Back navigation (slide right)
  static Route<T> slideRight<T>(Widget child, [RouteSettings? settings]) {
    return SlidePageTransition<T>(
      child: child,
      direction: AppPageTransitions.slideRight,
      settings: settings,
    );
  }

  /// Modal presentation (slide up)
  static Route<T> slideUp<T>(Widget child, [RouteSettings? settings]) {
    return SlidePageTransition<T>(
      child: child,
      direction: AppPageTransitions.slideUp,
      settings: settings,
    );
  }

  /// Fade for overlays
  static Route<T> fade<T>(Widget child, [RouteSettings? settings]) {
    return FadePageTransition<T>(
      child: child,
      settings: settings,
    );
  }

  /// Scale for dialogs
  static Route<T> scale<T>(Widget child, [RouteSettings? settings]) {
    return ScalePageTransition<T>(
      child: child,
      settings: settings,
    );
  }

  /// Default app transition
  static Route<T> defaultTransition<T>(Widget child,
      [RouteSettings? settings]) {
    return SlideFadePageTransition<T>(
      child: child,
      settings: settings,
    );
  }

  /// No transition
  static Route<T> none<T>(Widget child, [RouteSettings? settings]) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          child,
      settings: settings,
    );
  }
}
