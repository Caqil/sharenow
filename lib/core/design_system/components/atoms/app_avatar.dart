import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../constants/file_types.dart';
import '../../tokens/colors.dart';

enum AppAvatarSize { sm, md, lg, xl }

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.src,
    this.size = AppAvatarSize.md,
    this.backgroundColor,
    this.placeholder,
    this.onTap,
  });

  const AppAvatar.image({
    super.key,
    required ImageProvider this.src,
    this.size = AppAvatarSize.md,
    this.onTap,
  })  : placeholder = null,
        backgroundColor = null;

   AppAvatar.initials({
    super.key,
    required String initials,
    this.size = AppAvatarSize.md,
    this.backgroundColor,
    this.onTap,
  })  : src = null,
        placeholder = _InitialsWidget(initials);

   AppAvatar.icon({
    super.key,
    required IconData icon,
    this.size = AppAvatarSize.md,
    this.backgroundColor,
    Color? iconColor,
    this.onTap,
  })  : src = null,
        placeholder = _IconWidget(icon, iconColor);

  final Object? src;
  final AppAvatarSize size;
  final Color? backgroundColor;
  final Widget? placeholder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final avatarSize = Size(_getSize(), _getSize());

    Widget avatar = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary500,
        shape: BoxShape.circle,
      ),
      child: ShadAvatar(
        src ?? '',
        size: avatarSize,
        placeholder: placeholder ?? _defaultPlaceholder(),
        backgroundColor: backgroundColor ?? AppColors.primary500,
        fit: BoxFit.cover,
      ),
    );

    if (onTap != null) {
      avatar = GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    return SizedBox(
      width: _getSize(),
      height: _getSize(),
      child: avatar,
    );
  }

  Widget _defaultPlaceholder() {
    return Center(
      child: FaIcon(
        FontAwesomeIcons.user,
        size: _getIconSize(),
        color: Colors.white,
      ),
    );
  }

  double _getSize() {
    switch (size) {
      case AppAvatarSize.sm:
        return 32.0;
      case AppAvatarSize.md:
        return 40.0;
      case AppAvatarSize.lg:
        return 48.0;
      case AppAvatarSize.xl:
        return 64.0;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppAvatarSize.sm:
        return 14.0;
      case AppAvatarSize.md:
        return 16.0;
      case AppAvatarSize.lg:
        return 20.0;
      case AppAvatarSize.xl:
        return 24.0;
    }
  }

  double _getFontSize() {
    switch (size) {
      case AppAvatarSize.sm:
        return 12.0;
      case AppAvatarSize.md:
        return 14.0;
      case AppAvatarSize.lg:
        return 16.0;
      case AppAvatarSize.xl:
        return 20.0;
    }
  }
}

// Helper widgets for placeholders
class _InitialsWidget extends StatelessWidget {
  const _InitialsWidget(this.initials);
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _IconWidget extends StatelessWidget {
  const _IconWidget(this.icon, this.color);
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FaIcon(
        icon,
        size: 16.0,
        color: color ?? Colors.white,
      ),
    );
  }
}

/// Avatar presets for file transfer app
class AvatarPresets {
  AvatarPresets._();

  /// Device avatar with device type icon
  static Widget device({
    required String deviceName,
    AppAvatarSize size = AppAvatarSize.md,
    VoidCallback? onTap,
  }) {
    final initials = _getDeviceInitials(deviceName);
    return AppAvatar.initials(
      initials: initials,
      size: size,
      backgroundColor: AppColors.secondary500,
      onTap: onTap,
    );
  }

  /// File type avatar
  static Widget fileType({
    required FileType type,
    AppAvatarSize size = AppAvatarSize.md,
    VoidCallback? onTap,
  }) {
    return AppAvatar.icon(
      icon: type.icon,
      size: size,
      backgroundColor: type.color,
      iconColor: Colors.white,
      onTap: onTap,
    );
  }

  /// User avatar with initials
  static Widget user({
    required String name,
    AppAvatarSize size = AppAvatarSize.md,
    ImageProvider? image,
    VoidCallback? onTap,
  }) {
    if (image != null) {
      return AppAvatar.image(
        src: image,
        size: size,
        onTap: onTap,
      );
    }

    return AppAvatar.initials(
      initials: _getUserInitials(name),
      size: size,
      backgroundColor: AppColors.primary500,
      onTap: onTap,
    );
  }

  /// Connection status avatar
  static Widget connectionStatus({
    required bool isConnected,
    AppAvatarSize size = AppAvatarSize.md,
    VoidCallback? onTap,
  }) {
    return AppAvatar.icon(
      icon: isConnected ? FontAwesomeIcons.link : FontAwesomeIcons.linkSlash,
      size: size,
      backgroundColor: isConnected ? AppColors.success500 : AppColors.error500,
      iconColor: Colors.white,
      onTap: onTap,
    );
  }

  /// Transfer direction avatar
  static Widget transferDirection({
    required bool isSending,
    AppAvatarSize size = AppAvatarSize.md,
    VoidCallback? onTap,
  }) {
    return AppAvatar.icon(
      icon: isSending ? FontAwesomeIcons.arrowUp : FontAwesomeIcons.arrowDown,
      size: size,
      backgroundColor: isSending ? AppColors.info500 : AppColors.success500,
      iconColor: Colors.white,
      onTap: onTap,
    );
  }

  static String _getDeviceInitials(String deviceName) {
    final words = deviceName.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return deviceName.length >= 2
        ? deviceName.substring(0, 2).toUpperCase()
        : deviceName.toUpperCase();
  }

  static String _getUserInitials(String name) {
    final words = name.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}
