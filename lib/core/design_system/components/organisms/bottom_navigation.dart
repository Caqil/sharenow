import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/borders.dart';
import '../../tokens/shadows.dart';

class BottomNavigationTab {
  const BottomNavigationTab({
    required this.icon,
    required this.label,
    required this.page,
    this.badge,
  });

  final IconData icon;
  final String label;
  final Widget page;
  final String? badge;
}

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onIndexChanged,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
  });

  final List<BottomNavigationTab> tabs;
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Content area
        Expanded(
          child: IndexedStack(
            index: currentIndex,
            children: tabs.map((tab) => tab.page).toList(),
          ),
        ),
        // Bottom navigation bar
        Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.lightSurface,
            border: Border(
              top: BorderSide(
                color: AppColors.lightBorder,
                width: 1,
              ),
            ),
            boxShadow: AppShadows.elevation3,
          ),
          child: SafeArea(
            top: false,
            child: ShadTabs<int>(
              value: currentIndex,
              onChanged: onIndexChanged,
              tabBarConstraints: const BoxConstraints(
                minHeight: 60,
                maxHeight: 60,
              ),
              decoration: ShadDecoration(
                color: backgroundColor ?? AppColors.lightSurface,
              ),
              gap: AppSpacing.xs,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              scrollable: false,
              restorationId: 'bottom_navigation',
              tabs: tabs.asMap().entries.map((entry) {
                final index = entry.key;
                final tab = entry.value;
                return ShadTab(
                  value: index,
                  child: AnimatedBottomNavigationItem(
                    icon: tab.icon,
                    label: tab.label,
                    isSelected: index == currentIndex,
                    badge: tab.badge,
                    color: selectedColor,
                    onTap: () => onIndexChanged(index),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.heroTag,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String? label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: backgroundColor ?? AppColors.primary500,
        foregroundColor: foregroundColor ?? Colors.white,
        heroTag: heroTag,
        icon: FaIcon(icon, size: 20),
        label: Text(
          label!,
          style: AppTypography.bodyMedium.copyWith(
            color: foregroundColor ?? Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? AppColors.primary500,
      foregroundColor: foregroundColor ?? Colors.white,
      heroTag: heroTag,
      child: FaIcon(icon, size: 24),
    );
  }
}

class BottomNavigationPresets {
  BottomNavigationPresets._();

  static List<BottomNavigationTab> mainTabs({
    required Widget homePage,
    required Widget sendPage,
    required Widget receivePage,
    required Widget historyPage,
    required Widget settingsPage,
    String? transferCount,
  }) {
    return [
      BottomNavigationTab(
        icon: FontAwesomeIcons.house,
        label: 'Home',
        page: homePage,
      ),
      BottomNavigationTab(
        icon: FontAwesomeIcons.arrowUp,
        label: 'Send',
        page: sendPage,
      ),
      BottomNavigationTab(
        icon: FontAwesomeIcons.arrowDown,
        label: 'Receive',
        page: receivePage,
      ),
      BottomNavigationTab(
        icon: FontAwesomeIcons.clockRotateLeft,
        label: 'History',
        page: historyPage,
        badge: transferCount,
      ),
      BottomNavigationTab(
        icon: FontAwesomeIcons.gear,
        label: 'Settings',
        page: settingsPage,
      ),
    ];
  }

  static List<BottomNavigationTab> fileBrowserTabs({
    required Widget allFilesPage,
    required Widget documentsPage,
    required Widget imagesPage,
    required Widget videosPage,
    required Widget audiosPage,
    String? selectedCount,
  }) {
    return [
      BottomNavigationTab(
        icon: FontAwesomeIcons.folder,
        label: 'All',
        page: allFilesPage,
        badge: selectedCount,
      ),
      BottomNavigationTab(
        icon: FontAwesomeIcons.fileLines,
        label: 'Docs',
        page: documentsPage,
      ),
      BottomNavigationTab(
        icon: FontAwesomeIcons.image,
        label: 'Images',
        page: imagesPage,
      ),
      BottomNavigationTab(
        icon: FontAwesomeIcons.video,
        label: 'Videos',
        page: videosPage,
      ),
      BottomNavigationTab(
        icon: FontAwesomeIcons.music,
        label: 'Audio',
        page: audiosPage,
      ),
    ];
  }

  static List<BottomNavigationTab> transferTabs({
    required Widget activePage,
    required Widget queuePage,
    required Widget completedPage,
    String? activeCount,
    String? queueCount,
  }) {
    return [
      BottomNavigationTab(
        icon: FontAwesomeIcons.arrowsRotate,
        label: 'Active',
        page: activePage,
        badge: activeCount,
      ),
      BottomNavigationTab(
        icon: FontAwesomeIcons.clock,
        label: 'Queue',
        page: queuePage,
        badge: queueCount,
      ),
      BottomNavigationTab(
        icon: FontAwesomeIcons.circleCheck,
        label: 'Completed',
        page: completedPage,
      ),
    ];
  }
}

class AppBottomNavigationWithFAB extends StatelessWidget {
  const AppBottomNavigationWithFAB({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.fabIcon,
    required this.onFabPressed,
    this.fabLabel,
    this.fabHeroTag,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
  });

  final List<BottomNavigationTab> tabs;
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final IconData fabIcon;
  final VoidCallback onFabPressed;
  final String? fabLabel;
  final Object? fabHeroTag;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBottomNavigation(
        tabs: tabs,
        currentIndex: currentIndex,
        onIndexChanged: onIndexChanged,
        backgroundColor: backgroundColor,
        selectedColor: selectedColor,
        unselectedColor: unselectedColor,
      ),
      floatingActionButton: AppFloatingActionButton(
        onPressed: onFabPressed,
        icon: fabIcon,
        label: fabLabel,
        heroTag: fabHeroTag,
        backgroundColor: backgroundColor,
        foregroundColor: selectedColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class AnimatedBottomNavigationItem extends StatelessWidget {
  const AnimatedBottomNavigationItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badge,
    this.color,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String? badge;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final itemColor = isSelected
        ? (color ?? AppColors.primary500)
        : AppColors.textSecondaryLight;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? itemColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: AppBorders.roundedLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: FaIcon(
                    icon,
                    size: 20,
                    color: itemColor,
                  ),
                ),
                if (badge != null)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: AnimatedScale(
                      scale: isSelected ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.error500,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          badge!,
                          style: AppTypography.caption.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: AppSpacing.xs),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: AppTypography.caption.copyWith(
                color: itemColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
