import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum ErrorType { general, network, notFound, permission, timeout }

class AppErrorWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final ErrorType type;
  final VoidCallback? onRetry;
  final String? retryText;
  final VoidCallback? onAction;
  final String? actionText;
  final Widget? icon;
  final bool showIcon;
  final EdgeInsetsGeometry? padding;

  const AppErrorWidget({
    super.key,
    this.title,
    this.message,
    this.type = ErrorType.general,
    this.onRetry,
    this.retryText,
    this.onAction,
    this.actionText,
    this.icon,
    this.showIcon = true,
    this.padding,
  });

  const AppErrorWidget.network({
    super.key,
    this.title,
    this.message,
    this.onRetry,
    this.retryText = 'Retry',
    this.onAction,
    this.actionText,
    this.padding,
  })  : type = ErrorType.network,
        icon = null,
        showIcon = true;

  const AppErrorWidget.notFound({
    super.key,
    this.title,
    this.message,
    this.onRetry,
    this.retryText,
    this.onAction,
    this.actionText = 'Go Back',
    this.padding,
  })  : type = ErrorType.notFound,
        icon = null,
        showIcon = true;

  const AppErrorWidget.permission({
    super.key,
    this.title,
    this.message,
    this.onRetry,
    this.retryText,
    this.onAction,
    this.actionText = 'Open Settings',
    this.padding,
  })  : type = ErrorType.permission,
        icon = null,
        showIcon = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final ErrorConfig config = _getErrorConfig();

    return Padding(
      padding: padding ?? const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showIcon) ...[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon != null ? (icon as Icon).icon : config.icon,
                  size: 40,
                  color: colorScheme.onErrorContainer,
                ),
              )
                  .animate()
                  .scale(
                    duration: 300.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(),
              const SizedBox(height: 24),
            ],
            Text(
              title ?? config.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.3, end: 0),
            const SizedBox(height: 12),
            Text(
              message ?? config.message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (onRetry != null) ...[
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: Text(retryText ?? 'Try Again'),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0),
                  if (onAction != null) const SizedBox(width: 12),
                ],
                if (onAction != null)
                  OutlinedButton.icon(
                    onPressed: onAction,
                    icon: Icon(config.actionIcon),
                    label: Text(actionText ?? config.actionText),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ErrorConfig _getErrorConfig() {
    return switch (type) {
      ErrorType.general => ErrorConfig(
          title: 'Oops! Something went wrong',
          message: 'An unexpected error occurred. Please try again.',
          icon: FontAwesomeIcons.triangleExclamation,
          actionText: 'Contact Support',
          actionIcon: Icons.support_agent,
        ),
      ErrorType.network => ErrorConfig(
          title: 'Connection Problem',
          message: 'Please check your internet connection and try again.',
          icon: FontAwesomeIcons.wifi,
          actionText: 'Settings',
          actionIcon: Icons.settings,
        ),
      ErrorType.notFound => ErrorConfig(
          title: 'Not Found',
          message:
              'The content you\'re looking for doesn\'t exist or has been moved.',
          icon: FontAwesomeIcons.magnifyingGlass,
          actionText: 'Go Back',
          actionIcon: Icons.arrow_back,
        ),
      ErrorType.permission => ErrorConfig(
          title: 'Permission Required',
          message:
              'This feature requires additional permissions to work properly.',
          icon: FontAwesomeIcons.lock,
          actionText: 'Open Settings',
          actionIcon: Icons.settings,
        ),
      ErrorType.timeout => ErrorConfig(
          title: 'Request Timeout',
          message: 'The request took too long to complete. Please try again.',
          icon: FontAwesomeIcons.clock,
          actionText: 'Check Connection',
          actionIcon: Icons.network_check,
        ),
    };
  }
}

class ErrorConfig {
  final String title;
  final String message;
  final IconData icon;
  final String actionText;
  final IconData actionIcon;

  ErrorConfig({
    required this.title,
    required this.message,
    required this.icon,
    required this.actionText,
    required this.actionIcon,
  });
}
