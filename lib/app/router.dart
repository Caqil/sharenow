import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

// Core imports
import '../core/constants/app_constants.dart';

// Feature imports - Home
import '../features/home/pages/home_page.dart';

// Feature imports - Transfer
import '../features/transfer/pages/send_page.dart';
import '../features/transfer/pages/receive_page.dart';
import '../features/transfer/pages/transfer_progress_page.dart';

// Feature imports - File Browser
import '../features/file_browser/pages/file_browser_page.dart';

// Feature imports - Connection
import '../features/connection/pages/connection_page.dart';
import '../features/connection/pages/qr_scanner_page.dart';

// Feature imports - Settings
import '../features/settings/pages/settings_page.dart';
import '../features/settings/pages/about_page.dart';

// Feature imports - History
import '../features/history/pages/history_page.dart';

// Shared imports
import '../shared/pages/splash_page.dart';
import '../shared/pages/error_page.dart';

/// Application router configuration using GoRouter
@lazySingleton
class AppRouter {
  static const String initialRoute = '/';

  // Route paths
  static const String splash = '/';
  static const String home = '/home';
  static const String send = '/send';
  static const String receive = '/receive';
  static const String transferProgress = '/transfer-progress';
  static const String fileBrowser = '/files';
  static const String connection = '/connection';
  static const String qrScanner = '/qr-scanner';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String history = '/history';

  late final GoRouter _router;

  AppRouter() {
    _router = GoRouter(
      initialLocation: initialRoute,
      errorBuilder: (context, state) => ErrorPage(
        error: state.error?.toString() ?? 'Unknown error occurred',
        onRetry: () => context.go(home),
      ),
      routes: [
        // Splash Screen
        GoRoute(
          path: splash,
          name: 'splash',
          builder: (context, state) => const SplashPage(),
        ),

        // Home - Main Dashboard
        GoRoute(
          path: home,
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),

        // Transfer Routes
        GoRoute(
          path: send,
          name: 'send',
          builder: (context, state) => const SendPage(),
        ),

        GoRoute(
          path: receive,
          name: 'receive',
          builder: (context, state) => const ReceivePage(),
        ),

        GoRoute(
          path: transferProgress,
          name: 'transfer-progress',
          builder: (context, state) {
            final transferId = state.uri.queryParameters['transferId'];
            return TransferProgressPage(transferId: transferId);
          },
        ),

        // File Management
        GoRoute(
          path: fileBrowser,
          name: 'files',
          builder: (context, state) {
            final initialPath = state.uri.queryParameters['path'];
            return FileBrowserPage(initialPath: initialPath);
          },
        ),

        // Connection Management
        GoRoute(
          path: connection,
          name: 'connection',
          builder: (context, state) => const ConnectionPage(),
        ),

        GoRoute(
          path: qrScanner,
          name: 'qr-scanner',
          builder: (context, state) => const QRScannerPage(),
        ),

        // History
        GoRoute(
          path: history,
          name: 'history',
          builder: (context, state) => const HistoryPage(),
        ),

        // Settings
        GoRoute(
          path: settings,
          name: 'settings',
          builder: (context, state) => const SettingsPage(),
          routes: [
            // Nested route for About page
            GoRoute(
              path: 'about',
              name: 'about',
              builder: (context, state) => const AboutPage(),
            ),
          ],
        ),
      ],

      // Global route redirect logic
      redirect: (context, state) {
        // You can add authentication checks or onboarding logic here
        // For now, let splash screen handle the initial navigation
        return null;
      },
    );
  }

  /// Get the configured router instance
  GoRouter get router => _router;

  /// Navigation helper methods
  static void goToHome(BuildContext context) {
    context.go(home);
  }

  static void goToSend(BuildContext context) {
    context.push(send);
  }

  static void goToReceive(BuildContext context) {
    context.push(receive);
  }

  static void goToFileBrowser(BuildContext context, {String? path}) {
    final uri = Uri(
      path: fileBrowser,
      queryParameters: path != null ? {'path': path} : null,
    );
    context.push(uri.toString());
  }

  static void goToTransferProgress(BuildContext context, String transferId) {
    final uri = Uri(
      path: transferProgress,
      queryParameters: {'transferId': transferId},
    );
    context.push(uri.toString());
  }

  static void goToConnection(BuildContext context) {
    context.push(connection);
  }

  static void goToQRScanner(BuildContext context) {
    context.push(qrScanner);
  }

  static void goToSettings(BuildContext context) {
    context.push(settings);
  }

  static void goToAbout(BuildContext context) {
    context.push('$settings/about');
  }

  static void goToHistory(BuildContext context) {
    context.push(history);
  }

  /// Go back with fallback to home
  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(home);
    }
  }

  /// Replace current route
  static void replace(BuildContext context, String path) {
    context.pushReplacement(path);
  }

  /// Get current route name
  static String? getCurrentRoute(BuildContext context) {
    final RouteMatch lastMatch =
        GoRouter.of(context).routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : GoRouter.of(context).routerDelegate.currentConfiguration;
    return matchList.last.matchedLocation;
  }

  /// Check if currently on specific route
  static bool isOnRoute(BuildContext context, String route) {
    return getCurrentRoute(context) == route;
  }
}
