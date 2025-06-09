import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/di/direct_setup.dart';

// App widget
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeHive();

  _setupErrorHandling();
  await _initializeDependencies();

  runApp(const ShareItApp());
}

Future<void> _initializeHive() async {
  try {
    await Hive.initFlutter();

    if (kDebugMode) {
      debugPrint('✅ Hive initialized successfully');
    }
  } catch (error, stackTrace) {
    if (kDebugMode) {
      debugPrint('❌ Failed to initialize Hive: $error');
      debugPrint('Stack trace: $stackTrace');
    }
    rethrow;
  }
}

/// Initialize dependencies based on chosen approach
Future<void> _initializeDependencies() async {
  try {
    await AppServices.initialize();
    if (kDebugMode) {
      debugPrint('✅ Dependencies initialized successfully');
    }
  } catch (error, stackTrace) {
    if (kDebugMode) {
      debugPrint('❌ Failed to initialize dependencies: $error');
      debugPrint('Stack trace: $stackTrace');
    }
    rethrow;
  }
}

/// Setup global error handling for uncaught exceptions
void _setupErrorHandling() {
  // Handle Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      // In debug mode, show the error details
      FlutterError.presentError(details);
    } else {
      // In release mode, log the error (you could send to crash reporting service)
      debugPrint('Flutter Error: ${details.exception}');
      debugPrint('Stack trace: ${details.stack}');
    }
  };

  // Handle platform-level errors (outside of Flutter framework)
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) {
      debugPrint('Platform Error: $error');
      debugPrint('Stack trace: $stack');
    } else {
      // In release mode, you could send this to a crash reporting service
      debugPrint('Uncaught platform error: $error');
    }
    return true; // Indicates that the error has been handled
  };

  if (kDebugMode) {
    debugPrint('✅ Error handling configured');
  }
}
