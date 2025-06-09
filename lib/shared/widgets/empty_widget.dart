
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum EmptyType { general, search, files, devices, history, favorites }

class EmptyWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final EmptyType type;
  final VoidCallback? onAction;
  final String? actionText;
  final Widget? icon;
  final Widget? illustration;
  final bool showIcon;
  final bool showAction;
  final EdgeInsetsGeometry? padding;

  const EmptyWidget({
    super.key,
    this.title,
    this.message,
    this.type = EmptyType.general,
    this.onAction,
    this.actionText,
    this.icon,
    this.illustration,
    this.showIcon = true,
    this.showAction = true,
    this.padding,
  });

  const EmptyWidget.search({
    super.key,
    this.title,
    this.message,
    this.onAction,
    this.actionText = 'Clear Search',
    this.padding,
  }) : type = EmptyType.search,
       icon = null,
       illustration = null,
       showIcon = true,
       showAction = true;

  const EmptyWidget.files({
    super.key,
    this.title,
    this.message,
    this.onAction,
    this.actionText = 'Browse Files',
    this.padding,
  }) : type = EmptyType.files,
       icon = null,
       illustration = null,
       showIcon = true,
       showAction = true;

  const EmptyWidget.devices({
    super.key,
    this.title,
    this.message,
    this.onAction,
    this.actionText = 'Scan Again',
    this.padding,
  }) : type = EmptyType.devices,
       icon = null,
       illustration = null,
       showIcon = true,
       showAction = true;

  const EmptyWidget.history({
    super.key,
    this.title,
    this.message,
    this.onAction,
    this.actionText = 'Start Transfer',
    this.padding,
  }) : type = EmptyType.history,
       icon = null,
       illustration = null,
       showIcon = true,
       showAction = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final EmptyConfig config = _getEmptyConfig();

    return Padding(
      padding: padding ?? const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showIcon) ...[
              if (illustration != null)
                illustration!
              else
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon != null ? (icon as Icon).icon : config.icon,
                    size: 60,
                    color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                  ),
                )
                    .animate()
                    .scale(
                      duration: 400.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(),
              const SizedBox(height: 32),
            ],
            Text(
              title ?? config.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(delay: 100.ms)
                .slideY(begin: 0.3, end: 0),
            const SizedBox(height: 12),
            Text(
              message ?? config.message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(delay: 200.ms)
                .slideY(begin: 0.3, end: 0),
            if (showAction && onAction != null) ...[
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: onAction,
                icon: Icon(config.actionIcon),
                label: Text(actionText ?? config.actionText),
              )
                  .animate()
                  .fadeIn(delay: 300.ms)
                  .slideY(begin: 0.3, end: 0),
            ],
          ],
        ),
      ),
    );
  }

  EmptyConfig _getEmptyConfig() {
    return switch (type) {
      EmptyType.general => EmptyConfig(
          title: 'Nothing here yet',
          message: 'This area is empty. Start by adding some content.',
          icon: FontAwesomeIcons.inbox,
          actionText: 'Get Started',
          actionIcon: Icons.add,
        ),
      EmptyType.search => EmptyConfig(
          title: 'No results found',
          message: 'Try adjusting your search terms or filters.',
          icon: FontAwesomeIcons.magnifyingGlass,
          actionText: 'Clear Search',
          actionIcon: Icons.clear,
        ),
      EmptyType.files => EmptyConfig(
          title: 'No files selected',
          message: 'Choose files to share with nearby devices.',
          icon: FontAwesomeIcons.folder,
          actionText: 'Browse Files',
          actionIcon: Icons.folder_open,
        ),
      EmptyType.devices => EmptyConfig(
          title: 'No devices found',
          message: 'Make sure other devices are nearby and discoverable.',
          icon: FontAwesomeIcons.wifi,
          actionText: 'Scan Again',
          actionIcon: Icons.refresh,
        ),
      EmptyType.history => EmptyConfig(
          title: 'No transfer history',
          message: 'Your completed transfers will appear here.',
          icon: FontAwesomeIcons.clockRotateLeft,
          actionText: 'Start Transfer',
          actionIcon: Icons.send,
        ),
      EmptyType.favorites => EmptyConfig(
          title: 'No favorites yet',
          message: 'Mark items as favorites to see them here.',
          icon: FontAwesomeIcons.heart,
          actionText: 'Explore',
          actionIcon: Icons.explore,
        ),
    };
  }
}

class EmptyConfig {
  final String title;
  final String message;
  final IconData icon;
  final String actionText;
  final IconData actionIcon;

  EmptyConfig({
    required this.title,
    required this.message,
    required this.icon,
    required this.actionText,
    required this.actionIcon,
  });
}