import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shareit/app/theme.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

// Core imports
import '../core/constants/app_constants.dart';
import '../core/di/direct_setup.dart';

// Bloc imports
import '../features/home/bloc/home_event.dart';
import '../features/settings/bloc/settings_bloc.dart';
import '../features/settings/bloc/settings_event.dart';
import '../features/settings/bloc/settings_state.dart';
import '../features/transfer/bloc/transfer_bloc.dart';
import '../features/connection/bloc/connection_bloc.dart';
import '../features/home/bloc/home_bloc.dart';

/// Root application widget that configures the entire app
class ShareItApp extends StatelessWidget {
  const ShareItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Settings Bloc - handles app-wide settings including theme
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(AppServices.storageService)
            ..add(const SettingsInitializeEvent()),
        ),

        // // Transfer Bloc - handles file transfer operations
        // BlocProvider<TransferBloc>(
        //   create: (context) => TransferBloc(
        //     AppServices.transferService,
        //     AppServices.connectionService,
        //     AppServices.storageService,
        //   ),
        // ),

        // // Connection Bloc - handles device discovery and connections
        // BlocProvider<ConnectionBloc>(
        //   create: (context) => ConnectionBloc(
        //     AppServices.connectionService,
        //     AppServices.storageService,
        //   )..add(const ConnectionEvent.initialize()),
        // ),

        // Home Bloc - handles home screen state
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(
            AppServices.connectionService,
            AppServices.transferService,
            AppServices.fileService,
            AppServices.storageService,
            AppServices.permissionService,
          )..add(const HomeInitializeEvent()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (previous, current) {
          // Only rebuild when theme-related settings change
          return previous.themeMode != current.themeMode ||
              previous.primaryColor != current.primaryColor;
        },
        builder: (context, settingsState) {
          return ShadApp.router(
            // App Identity
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,

            // Routing Configuration
            routerConfig: AppServices.router.router,

            darkTheme: AppTheme.darkTheme(
              primaryColor: settingsState.primaryColor ?? AppTheme.blue,
            ),
            themeMode: settingsState.themeMode,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('es', 'ES'),
              Locale('fr', 'FR'),
              Locale('de', 'DE'),
              Locale('zh', 'CN'),
              Locale('ja', 'JP'),
            ],

            // Builder for system UI configuration and responsive design
            builder: (context, child) {
              return MediaQuery(
                // Ensure text scaling doesn't break UI
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(
                    MediaQuery.of(context)
                        .textScaler
                        .scale(1.0)
                        .clamp(0.8, 1.3),
                  ),
                ),
                child: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: _getSystemUiOverlayStyle(context),
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Get system UI overlay style based on current theme
  SystemUiOverlayStyle _getSystemUiOverlayStyle(BuildContext context) {
    final isDark = context.isDarkMode;

    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
    );
  }
}

/// Global app configuration and initialization helpers
class AppConfig {
  AppConfig._(); // Private constructor to prevent instantiation

  /// Check if the app is fully initialized
  static bool get isInitialized => AppServices.isInitialized;

  /// Get app version info
  static String get appVersion => AppConstants.appVersion;

  /// Get app name
  static String get appName => AppConstants.appName;

  /// Configure system-level settings (called from main.dart)
  static Future<void> configureSystemSettings() async {
    try {
      // Configure system chrome
      SystemChrome.setSystemUIOverlayStyle(
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
    } catch (e) {
      // Log error but don't prevent app from starting
      debugPrint('Failed to configure system settings: $e');
    }
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
  StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Application Error')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Something went wrong',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  error?.toString() ?? 'Unknown error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      hasError = false;
                      error = null;
                      stackTrace = null;
                    });
                  },
                  child: const Text('Retry'),
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
        stackTrace = null;
      });
    }
  }

  /// Handle errors in the widget tree
  void handleError(Object error, StackTrace stackTrace) {
    setState(() {
      hasError = true;
      this.error = error;
      this.stackTrace = stackTrace;
    });
  }
}
