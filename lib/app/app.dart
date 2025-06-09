import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

// Core imports
import '../core/constants/app_constants.dart';
import '../core/services/storage_service.dart';
import '../core/services/transfer_service.dart';
import '../core/services/connection_service.dart';
import '../core/services/permission_service.dart';
import '../core/services/notification_service.dart';

// Theme imports
import '../core/theme/app_theme.dart';

// Router imports
import '../core/router/app_router.dart';

// Bloc imports
import '../features/settings/bloc/settings_bloc.dart';
import '../features/transfer/bloc/transfer_bloc.dart';
import '../features/connection/bloc/connection_bloc.dart';
import '../features/home/bloc/home_bloc.dart';

// Dependency injection
import '../injection_container.dart';

/// Root application widget that configures the entire app
class ShareItApp extends StatelessWidget {
  const ShareItApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Configure system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // Set preferred orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiBlocProvider(
      providers: [
        // Settings Bloc - handles app-wide settings including theme
        BlocProvider<SettingsBloc>(
          create: (context) =>
              getIt<SettingsBloc>()..add(const SettingsEvent.initialize()),
        ),

        // Transfer Bloc - handles file transfer operations
        BlocProvider<TransferBloc>(
          create: (context) => getIt<TransferBloc>(),
        ),

        // Connection Bloc - handles device discovery and connections
        BlocProvider<ConnectionBloc>(
          create: (context) =>
              getIt<ConnectionBloc>()..add(const ConnectionEvent.initialize()),
        ),

        // Home Bloc - handles home screen state
        BlocProvider<HomeBloc>(
          create: (context) =>
              getIt<HomeBloc>()..add(const HomeEvent.loadData()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (previous, current) {
          // Only rebuild when theme-related settings change
          return previous.themeMode != current.themeMode ||
              previous.primaryColor != current.primaryColor;
        },
        builder: (context, settingsState) {
          return ShadApp.materialRouter(
            // App Identity
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,

            // Routing Configuration
            routerConfig: getIt<AppRouter>().router,

            // Shadcn UI Theme Configuration
            theme: AppTheme.lightTheme(
              primaryColor: settingsState.primaryColor,
            ),
            darkTheme: AppTheme.darkTheme(
              primaryColor: settingsState.primaryColor,
            ),

            // Material Theme Configuration (for fallback compatibility)
            materialTheme: AppTheme.materialLightTheme(
              primaryColor: settingsState.primaryColor,
            ),
            materialDarkTheme: AppTheme.materialDarkTheme(
              primaryColor: settingsState.primaryColor,
            ),

            // Theme mode
            themeMode: _mapThemeMode(settingsState.themeMode),

            // Localization (if needed in future)
            // locale: settingsState.locale,
            // supportedLocales: AppConstants.supportedLocales,
            // localizationsDelegates: AppLocalizations.localizationsDelegates,

            // App Builder - wraps entire app with global configurations
            builder: (context, child) {
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: _getSystemUiOverlayStyle(context),
                child: MediaQuery(
                  // Ensure text doesn't scale beyond reasonable limits
                  data: MediaQuery.of(context).copyWith(
                    textScaler: MediaQuery.of(context).textScaler.clamp(
                          minScaleFactor: 0.8,
                          maxScaleFactor: 1.3,
                        ),
                  ),
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Map internal theme mode to Flutter's ThemeMode
  ThemeMode _mapThemeMode(String themeMode) {
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Get system UI overlay style based on current theme
  SystemUiOverlayStyle _getSystemUiOverlayStyle(BuildContext context) {
    final shadTheme = ShadTheme.of(context);
    final isLight = shadTheme.brightness == Brightness.light;

    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarBrightness: isLight ? Brightness.light : Brightness.dark,
      statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
      systemNavigationBarIconBrightness:
          isLight ? Brightness.dark : Brightness.light,
    );
  }
}

/// Global app configuration and initialization
class AppConfig {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize dependency injection
    await configureDependencies();

    // Initialize core services
    await _initializeServices();

    // Configure system settings
    await _configureSystemSettings();
  }

  /// Initialize all core services
  static Future<void> _initializeServices() async {
    try {
      // Initialize storage service first (others may depend on it)
      final storageService = getIt<StorageService>();
      await storageService.initialize();

      // Initialize permission service
      final permissionService = getIt<PermissionService>();
      await permissionService.initialize();

      // Initialize notification service
      final notificationService = getIt<NotificationService>();
      await notificationService.initialize();

      // Initialize connection service
      final connectionService = getIt<ConnectionService>();
      await connectionService.initialize();

      // Transfer service is lazy-initialized when first used
    } catch (e) {
      // Log error but don't prevent app from starting
      debugPrint('Failed to initialize some services: $e');
    }
  }

  /// Configure system-level settings
  static Future<void> _configureSystemSettings() async {
    // Configure system chrome
    await SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Enable edge-to-edge
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
  }
}

/// Error boundary widget for handling app-level errors
class AppErrorBoundary extends StatefulWidget {
  final Widget child;

  const AppErrorBoundary({
    super.key,
    required this.child,
  });

  @override
  State<AppErrorBoundary> createState() => _AppErrorBoundaryState();
}

class _AppErrorBoundaryState extends State<AppErrorBoundary> {
  bool hasError = false;
  Object? error;

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return ShadApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Color(0xFFDC2626), // red
                ),
                const SizedBox(height: 16),
                const Text(
                  'Something went wrong',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please restart the app',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 24),
                ShadButton(
                  onPressed: () {
                    setState(() {
                      hasError = false;
                      error = null;
                    });
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return widget.child;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Reset error state when dependencies change
    if (hasError) {
      setState(() {
        hasError = false;
        error = null;
      });
    }
  }

  /// Handle errors that occur during widget building
  void _handleError(Object error, StackTrace stackTrace) {
    setState(() {
      hasError = true;
      this.error = error;
    });

    // Log error for debugging
    debugPrint('App Error: $error');
    debugPrint('Stack Trace: $stackTrace');
  }
}
