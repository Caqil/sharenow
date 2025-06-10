// Import services
import '../services/storage_service.dart';
import '../services/permission_service.dart';
//import '../services/notification_service.dart';
import '../services/connection_service.dart';
import '../services/transfer_service.dart';
import '../services/file_service.dart';

// Import router
import '../../app/router.dart';

/// Global variables to hold service instances (simple approach)
class AppServices {
  // Service instances
  static late final StorageService storageService;
  static late final PermissionService permissionService;
  //static late final NotificationService notificationService;
  static late final FileService fileService;
  static late final ConnectionService connectionService;
  static late final TransferService transferService;
  static late final AppRouter router;

  static bool _initialized = false;

  /// Initialize all services with proper dependency order
  static Future<void> initialize() async {
    if (_initialized) return;

    // Initialize services in dependency order
    storageService = StorageService();
    permissionService = PermissionService();
    //notificationService = NotificationService();
    fileService = FileService(permissionService);

    // Services with dependencies
    connectionService = ConnectionService(
      permissionService,
    );

    transferService = TransferService(
        connectionService, fileService, storageService, permissionService);

    // Router
    router = AppRouter();

    // Initialize services
    await fileService.initialize();
    await transferService.initialize();
    //await notificationService.initialize();
    await permissionService.initialize();
    //await notificationService.initialize();
    await connectionService.initialize();

    _initialized = true;
  }

  /// Check if services are initialized
  static bool get isInitialized => _initialized;

  /// Reset services (for testing)
  static void reset() {
    _initialized = false;
  }
}
