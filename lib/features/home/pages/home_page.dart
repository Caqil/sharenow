import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart'; // Add this import
// REMOVED: import 'package:get_it/get_it.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/di/direct_setup.dart'; // Add this import
import '../../../app/router.dart'; // Add this import
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
    // FIXED: Use AppServices instead of GetIt
    _storageService = AppServices.storageService;
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration:
          const Duration(milliseconds: AppConstants.mediumAnimationDuration),
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
        _getTransferStatistics(),
        _getRecentTransfers(),
      ]);

      if (mounted) {
        setState(() {
          _userName = _storageService.getUserName() ?? 'User';
          _transferStats = futures[0] as Map<String, dynamic>;
          _recentTransfers = futures[1] as List<dynamic>;
          _isLoading = false;
        });

        // Start animations after data is loaded
        _animationController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show error to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load data: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  // Helper method to get transfer statistics
  Future<Map<String, dynamic>> _getTransferStatistics() async {
    try {
      final stats = await _storageService.getTransferStatistics();
      return {
        'totalTransfers': stats.totalTransfers,
        'successfulTransfers': stats.successfulTransfers,
        'failedTransfers': stats.failedTransfers,
        'totalBytesTransferred': stats.totalBytesTransferred,
        'averageTransferSize': stats.averageTransferSize,
        'successRate': stats.successRate,
      };
    } catch (e) {
      return {
        'totalTransfers': 0,
        'successfulTransfers': 0,
        'failedTransfers': 0,
        'totalBytesTransferred': 0,
        'averageTransferSize': 0.0,
        'successRate': 0.0,
      };
    }
  }

  // Helper method to get recent transfers
  Future<List<dynamic>> _getRecentTransfers() async {
    try {
      final transfers = await _storageService.getTransferHistory(limit: 5);
      return transfers.map((transfer) => transfer.toJson()).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Scaffold(
      backgroundColor: context.colorScheme.background,
      body: SafeArea(
        child: _isLoading ? _buildLoadingView() : _buildMainContent(),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildMainContent() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(),
                const SizedBox(height: AppConstants.defaultPadding),
                _buildStatsSection(),
                const SizedBox(height: AppConstants.defaultPadding),
                _buildQuickActionsSection(),
                const SizedBox(height: AppConstants.defaultPadding),
                _buildRecentTransfersSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colorScheme.primary,
            context.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, $_userName!',
            style: context.textTheme.headlineSmall?.copyWith(
              color: context.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ready to share files quickly and securely?',
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onPrimary.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return const StatsCard(
      transferStats: {},
    );
  }

  Widget _buildQuickActionsSection() {
    return QuickActions(
      onActionTapped: (actionType) {
        _handleQuickAction(actionType);
      },
    );
  }

  Widget _buildRecentTransfersSection() {
    return RecentTransfers(
      transfers: _recentTransfers,
      onTransferTapped: (transferId) {
        _handleTransferTapped(transferId);
      },
    );
  }

  void _handleQuickAction(String actionType) {
    switch (actionType) {
      case 'send':
        _navigateToSend();
        break;
      case 'receive':
        _navigateToReceive();
        break;
      case 'browse':
        _navigateToFileBrowser();
        break;
      case 'connect':
        _navigateToConnection();
        break;
      default:
        break;
    }
  }

  void _handleTransferTapped(String transferId) {
    // Navigate to transfer details or progress using GoRouter
    AppRouter.goToTransferProgress(context, transferId);
  }

  void _navigateToSend() {
    AppRouter.goToSend(context);
  }

  void _navigateToReceive() {
    AppRouter.goToReceive(context);
  }

  void _navigateToFileBrowser() {
    AppRouter.goToFileBrowser(context);
  }

  void _navigateToConnection() {
    AppRouter.goToConnection(context);
  }

  void _navigateToHistory() {
    AppRouter.goToHistory(context);
  }
}
