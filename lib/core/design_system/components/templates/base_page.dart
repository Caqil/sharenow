import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/borders.dart';
import '../../tokens/shadows.dart';

class BasePage extends StatelessWidget {
  const BasePage({
    super.key,
    required this.child,
    this.title,
    this.backgroundColor,
    this.appBarBackgroundColor,
    this.leading,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.showAppBar = true,
    this.automaticallyImplyLeading = true,
    this.centerTitle = false,
    this.resizeToAvoidBottomInset,
    this.padding,
    this.safeArea = true,
  });

  final Widget child;
  final String? title;
  final Color? backgroundColor;
  final Color? appBarBackgroundColor;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool showAppBar;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final bool? resizeToAvoidBottomInset;
  final EdgeInsetsGeometry? padding;
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    Widget pageChild = child;

    // Apply padding if specified
    if (padding != null) {
      pageChild = Padding(
        padding: padding!,
        child: pageChild,
      );
    }

    // Apply safe area if enabled
    if (safeArea) {
      pageChild = SafeArea(child: pageChild);
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.lightBackground,
      appBar: showAppBar ? _buildAppBar(context) : null,
      body: pageChild,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      backgroundColor: appBarBackgroundColor ?? AppColors.lightSurface,
      foregroundColor: AppColors.textPrimaryLight,
      elevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      actions: actions,
      titleTextStyle: AppTypography.titleMedium.copyWith(
        fontWeight: FontWeight.w600,
      ),
      shape: Border(
        bottom: BorderSide(
          color: AppColors.lightBorder,
          width: 1,
        ),
      ),
    );
  }
}

/// Base page with custom app bar
class BasePageWithCustomAppBar extends StatelessWidget {
  const BasePageWithCustomAppBar({
    super.key,
    required this.child,
    required this.appBar,
    this.backgroundColor,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset,
    this.padding,
    this.safeArea = true,
  });

  final Widget child;
  final PreferredSizeWidget appBar;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool? resizeToAvoidBottomInset;
  final EdgeInsetsGeometry? padding;
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    Widget pageChild = child;

    if (padding != null) {
      pageChild = Padding(padding: padding!, child: pageChild);
    }

    if (safeArea) {
      pageChild = SafeArea(child: pageChild);
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.lightBackground,
      appBar: appBar,
      body: pageChild,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}

/// Base page with search functionality
class BasePageWithSearch extends StatelessWidget {
  const BasePageWithSearch({
    super.key,
    required this.child,
    required this.onSearch,
    this.title,
    this.searchHint = 'Search...',
    this.backgroundColor,
    this.leading,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.automaticallyImplyLeading = true,
    this.padding,
    this.safeArea = true,
  });

  final Widget child;
  final ValueChanged<String> onSearch;
  final String? title;
  final String searchHint;
  final Color? backgroundColor;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool automaticallyImplyLeading;
  final EdgeInsetsGeometry? padding;
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: title,
      backgroundColor: backgroundColor,
      leading: leading,
      actions: [
        IconButton(
          onPressed: () => _showSearch(context),
          icon: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 20),
        ),
        ...?actions,
      ],
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      automaticallyImplyLeading: automaticallyImplyLeading,
      padding: padding,
      safeArea: safeArea,
      child: child,
    );
  }

  void _showSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: _SearchDelegate(
        onSearch: onSearch,
        searchHint: searchHint,
      ),
    );
  }
}

class _SearchDelegate extends SearchDelegate<String> {
  _SearchDelegate({
    required this.onSearch,
    required this.searchHint,
  });

  final ValueChanged<String> onSearch;
  final String searchHint;

  @override
  String get searchFieldLabel => searchHint;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, ''),
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    close(context, query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

/// Page presets for file transfer app
class BasePagePresets {
  BasePagePresets._();

  /// Standard app page
  static Widget standard({
    required Widget child,
    required String title,
    List<Widget>? actions,
    Widget? floatingActionButton,
    VoidCallback? onBack,
  }) {
    return BasePage(
      title: title,
      actions: actions,
      floatingActionButton: floatingActionButton,
      leading: onBack != null
          ? IconButton(
              onPressed: onBack,
              icon: FaIcon(FontAwesomeIcons.arrowLeft, size: 20),
            )
          : null,
      padding: EdgeInsets.all(AppSpacing.lg),
      child: child,
    );
  }

  /// Settings page
  static Widget settings({
    required Widget child,
    String title = 'Settings',
    VoidCallback? onBack,
  }) {
    return BasePage(
      title: title,
      leading: onBack != null
          ? IconButton(
              onPressed: onBack,
              icon: FaIcon(FontAwesomeIcons.arrowLeft, size: 20),
            )
          : null,
      child: child,
    );
  }

  /// File browser page
  static Widget fileBrowser({
    required Widget child,
    required String title,
    required ValueChanged<String> onSearch,
    VoidCallback? onBack,
    Widget? floatingActionButton,
  }) {
    return BasePageWithSearch(
      title: title,
      onSearch: onSearch,
      searchHint: 'Search files...',
      leading: onBack != null
          ? IconButton(
              onPressed: onBack,
              icon: FaIcon(FontAwesomeIcons.arrowLeft, size: 20),
            )
          : null,
      floatingActionButton: floatingActionButton,
      child: child,
    );
  }

  /// Transfer page
  static Widget transfer({
    required Widget child,
    required String title,
    List<Widget>? actions,
    VoidCallback? onClose,
  }) {
    return BasePage(
      title: title,
      actions: actions,
      leading: onClose != null
          ? IconButton(
              onPressed: onClose,
              icon: FaIcon(FontAwesomeIcons.xmark, size: 20),
            )
          : null,
      backgroundColor: AppColors.lightSurfaceVariant,
      child: child,
    );
  }

  /// Full screen page (no app bar)
  static Widget fullScreen({
    required Widget child,
    Color? backgroundColor,
    Widget? floatingActionButton,
  }) {
    return BasePage(
      showAppBar: false,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      child: child,
    );
  }

  /// Onboarding page
  static Widget onboarding({
    required Widget child,
    Color? backgroundColor,
  }) {
    return BasePage(
      showAppBar: false,
      backgroundColor: backgroundColor ?? AppColors.primary50,
      safeArea: false,
      child: child,
    );
  }

  /// Dashboard page
  static Widget dashboard({
    required Widget child,
    required String title,
    Widget? avatar,
    List<Widget>? actions,
    Widget? bottomNavigationBar,
  }) {
    return BasePage(
      backgroundColor: AppColors.lightSurfaceVariant,
      appBarBackgroundColor: AppColors.lightSurface,
      leading: avatar != null
          ? Padding(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: avatar,
            )
          : null,
      title: title,
      actions: actions,
      automaticallyImplyLeading: false,
      bottomNavigationBar: bottomNavigationBar,
      padding: EdgeInsets.all(AppSpacing.md),
      child: child,
    );
  }
}
