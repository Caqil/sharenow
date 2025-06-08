import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../tokens/colors.dart';

enum AppIconSize { xs, sm, md, lg, xl }

class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    super.key,
    this.size = AppIconSize.md,
    this.color,
    this.semanticLabel,
  });

  final IconData icon;
  final AppIconSize size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      icon,
      size: _getSize(),
      color: color,
      semanticLabel: semanticLabel,
    );
  }

  double _getSize() {
    switch (size) {
      case AppIconSize.xs:
        return 12.0;
      case AppIconSize.sm:
        return 14.0;
      case AppIconSize.md:
        return 16.0;
      case AppIconSize.lg:
        return 20.0;
      case AppIconSize.xl:
        return 24.0;
    }
  }
}
