import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/services/storage_service.dart';
import '../../../shared/widgets/app_button.dart';
import '../widgets/stats_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/recent_transfers.dart';

/// Home page of the ShareNow application
///
/// Displays main dashboard with transfer statistics, quick actions,
/// and recent transfer history with consistent Material 3 theming
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late final StorageService _storageService;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  bool _isLoading = true;
  Map<String, dynamic> _transferStats = {};
  List<dynamic> _recentTransfers = [];
  String _userName = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _setupAnimations();
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeServices() {
    _storageService = GetIt.instance<StorageService>();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: AppConstants.mediumAnimationDuration),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  Future<void> _loadData() async {
    try {
      // Load user data and statistics
      final futures = await Future.wait([
        _storageService.getTransferStatisticsMap(),
        _storageService.getRecentTransfers(limit: 5),
      ]);

      if (mounted) {
        setState(() {
          _userName = _storageService.getUserName() ?? 'User';
          _transferStats = futures[0] as Map<String, dynamic>? ?? {};
          _recentTransfers = futures[1] as List<dynamic>? ?? [];
          _isLoading = false;
        });
        _animationController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        context.showErrorSnackBar('Failed to load data');
      }
    }
  }

  Future<void> _refreshData() async {
    HapticFeedback.lightImpact();
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_isLoading) {
      return _buildLoadingState();
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeSection(),
                      SizedBox(height: AppConstants.sectionSpacing),
                      _buildStatsSection(),
                      SizedBox(height: AppConstants.sectionSpacing),
                      _buildQuickActions(),
                      SizedBox(height: AppConstants.sectionSpacing),
                      _buildRecentTransfers(),
                      SizedBox(height: context.mediaQuery.padding.bottom),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: context.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading your dashboard...',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: context.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          left: AppConstants.defaultPadding,
          bottom: 16,
        ),
        title: Text(
          'ShareNow',
          style: context.textTheme.headlineSmall?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.colorScheme.primaryContainer.withOpacity(0.1),
                context.colorScheme.surface,
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Navigate to settings
            HapticFeedback.lightImpact();
          },
          icon: Icon(
            Icons.settings_outlined,
            color: context.colorScheme.onSurface,
          ),
          tooltip: 'Settings',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    final hour = DateTime.now().hour;
    String greeting;

    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colorScheme.primaryContainer,
            context.colorScheme.primaryContainer.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting, $_userName! 👋',
            style: context.textTheme.headlineSmall?.copyWith(
              color: context.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ready to share files with nearby devices?',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onPrimaryContainer.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.analytics_outlined,
              color: context.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Your Statistics',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        StatsCard(
          transferStats: _transferStats,
          onStatsUpdated: _refreshData,
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.bolt_outlined,
              color: context.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Quick Actions',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        QuickActions(
          onActionTapped: (actionType) {
            HapticFeedback.lightImpact();
            // Handle action navigation
            _handleQuickAction(actionType);
          },
        ),
      ],
    );
  }

  Widget _buildRecentTransfers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.history,
                  color: context.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recent Transfers',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            if (_recentTransfers.isNotEmpty)
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  // Navigate to full history
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        RecentTransfers(
          transfers: _recentTransfers,
          onTransferTapped: (transfer) {
            HapticFeedback.lightImpact();
            // Navigate to transfer details
          },
          onRefresh: _refreshData,
        ),
      ],
    );
  }

  void _handleQuickAction(String actionType) {
    switch (actionType) {
      case 'send':
        // Navigate to file picker
        break;
      case 'receive':
        // Navigate to receive screen
        break;
      case 'scan':
        // Navigate to QR scanner
        break;
      case 'devices':
        // Navigate to nearby devices
        break;
      default:
        context.showErrorSnackBar('Action not implemented yet');
    }
  }
}
