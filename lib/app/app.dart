import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shareit/app/theme.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

// Core imports
import '../core/constants/app_constants.dart';
import '../core/di/direct_setup.dart';

// Bloc imports
import '../features/settings/bloc/settings_bloc.dart';
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
          create: (context) => SettingsBloc(AppServices.storageService),
        ),

        // Transfer Bloc - handles file transfer operations
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
        //   ),
        // ),

        // Home Bloc - handles home screen state
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(
            AppServices.connectionService,
            AppServices.transferService,
            AppServices.fileService,
            AppServices.storageService,
            AppServices.permissionService,
          ),
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

            // Theme Configuration
            theme: AppTheme.lightTheme(
              primaryColor: settingsState.primaryColor ?? AppTheme.blue,
            ),
            darkTheme: AppTheme.darkTheme(
              primaryColor: settingsState.primaryColor ?? AppTheme.blue,
            ),
            themeMode: settingsState.themeMode,

            // System UI Configuration
            builder: (context, child) {
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: _getSystemUiOverlayStyle(context),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }

  /// Get appropriate system UI overlay style based on current theme
  SystemUiOverlayStyle _getSystemUiOverlayStyle(BuildContext context) {
    final theme = ShadTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
