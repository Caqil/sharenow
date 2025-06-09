import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/extensions.dart';

/// Quick actions widget for the home page
///
/// Provides easy access to main app functions with consistent theming
class QuickActions extends StatefulWidget {
  final Function(String actionType) onActionTapped;

  const QuickActions({
    super.key,
    required this.onActionTapped,
  });

  @override
  State<QuickActions> createState() => _QuickActionsState();
}

class _QuickActionsState extends State<QuickActions>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _itemAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration:
          const Duration(milliseconds: AppConstants.mediumAnimationDuration),
      vsync: this,
    );

    final actions = _getQuickActions();

    // Create staggered animations for each action
    _itemAnimations = List.generate(actions.length, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.3 + (index * 0.1),
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    _slideAnimations = List.generate(actions.length, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.3 + (index * 0.1),
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final actions = _getQuickActions();

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(
          color: context.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding:  EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildActionsGrid(actions),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.bolt,
            color: context.colorScheme.onSecondaryContainer,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Actions',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.onSurface,
                ),
              ),
              Text(
                'Start sharing instantly',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionsGrid(List<QuickAction> actions) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.isTablet ? 4 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _itemAnimations[index],
              child: SlideTransition(
                position: _slideAnimations[index],
                child: _buildActionCard(actions[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildActionCard(QuickAction action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          widget.onActionTapped(action.actionType);
        },
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                action.color.withOpacity(0.15),
                action.color.withOpacity(0.05),
              ],
            ),
            borderRadius:
                BorderRadius.circular(AppConstants.defaultBorderRadius),
            border: Border.all(
              color: action.color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: action.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    action.icon,
                    color: action.color,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  action.label,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  action.description,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<QuickAction> _getQuickActions() {
    return [
      QuickAction(
        icon: Icons.send_outlined,
        label: 'Send Files',
        description: 'Share files to nearby devices',
        actionType: 'send',
        color: context.colorScheme.primary,
      ),
      const QuickAction(
        icon: Icons.download_outlined,
        label: 'Receive',
        description: 'Accept incoming files',
        actionType: 'receive',
        color: Color(0xFF4CAF50),
      ),
      const QuickAction(
        icon: Icons.qr_code_scanner_outlined,
        label: 'Scan QR',
        description: 'Connect using QR code',
        actionType: 'scan',
        color: Color(0xFFFF9800),
      ),
      const QuickAction(
        icon: Icons.devices_outlined,
        label: 'Devices',
        description: 'View nearby devices',
        actionType: 'devices',
        color: Color(0xFF9C27B0),
      ),
    ];
  }
}

/// Data class for quick action items
class QuickAction {
  final IconData icon;
  final String label;
  final String description;
  final String actionType;
  final Color color;

  const QuickAction({
    required this.icon,
    required this.label,
    required this.description,
    required this.actionType,
    required this.color,
  });
}
