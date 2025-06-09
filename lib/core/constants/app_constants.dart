// App-wide constants
// lib/core/constants/app_constants.dart

/// Application-wide constants and configuration values
/// This file contains all the static configuration values used throughout the app
class AppConstants {
  AppConstants._(); // Private constructor to prevent instantiation

  // ═══════════════════════════════════════════════════════════════════════════════════
  // APP INFORMATION
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Application name displayed in UI
  static const String appName = 'ShareIt Pro';

  /// Current application version
  static const String appVersion = '1.0.0';

  /// Build number for app stores
  static const String appBuildNumber = '1';

  /// Unique package identifier
  static const String appPackageName = 'com.shareitpro.app';

  /// Application description for stores
  static const String appDescription =
      'Ultra-fast file sharing with modern design';

  /// Developer information
  static const String developerName = 'ShareIt Pro Team';
  static const String developerEmail = 'support@shareitpro.com';
  static const String supportUrl = 'https://shareitpro.com/support';
  static const String privacyPolicyUrl = 'https://shareitpro.com/privacy';
  static const String termsOfServiceUrl = 'https://shareitpro.com/terms';

  /// App Store URLs
  static const String appStoreUrl = 'https://apps.apple.com/app/shareit-pro';
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=$appPackageName';
  static const String githubUrl = 'https://github.com/shareitpro/app';

  // ═══════════════════════════════════════════════════════════════════════════════════
  // NETWORK CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Default port for HTTP server
  static const int defaultPort = 8080;

  /// Maximum port number to try
  static const int maxPort = 8090;

  /// Connection establishment timeout (seconds)
  static const int connectionTimeout = 30;

  /// File transfer timeout (seconds)
  static const int transferTimeout = 300;

  /// Device discovery timeout (seconds)
  static const int discoveryTimeout = 15;

  /// Maximum retry attempts for failed operations
  static const int maxRetryAttempts = 3;

  /// Maximum concurrent file transfers
  static const int maxConcurrentTransfers = 5;

  /// Network scanning interval (milliseconds)
  static const int networkScanInterval = 5000;

  /// Keep-alive interval for connections (seconds)
  static const int keepAliveInterval = 10;

  // ═══════════════════════════════════════════════════════════════════════════════════
  // FILE TRANSFER CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Size of each file chunk during transfer (1MB)
  static const int chunkSize = 1024 * 1024;

  /// Maximum file size allowed for transfer (5GB)
  static const int maxFileSize = 5 * 1024 * 1024 * 1024;

  /// Maximum number of files in one transfer batch
  static const int maxBatchSize = 1000;

  /// Interval for progress updates (milliseconds)
  static const int progressUpdateInterval = 100;

  /// Interval for speed calculation updates (milliseconds)
  static const int speedCalculationInterval = 1000;

  /// Buffer size for file operations (64KB)
  static const int fileBufferSize = 64 * 1024;

  /// Minimum free space required for transfers (100MB)
  static const int minFreeSpaceRequired = 100 * 1024 * 1024;

  // ═══════════════════════════════════════════════════════════════════════════════════
  // STORAGE CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Default download folder name
  static const String defaultDownloadFolder = 'ShareItPro';

  /// Temporary files folder
  static const String tempFolder = 'temp';

  /// Thumbnail cache folder
  static const String thumbnailFolder = 'thumbnails';

  /// Application logs folder
  static const String logFolder = 'logs';

  /// Maximum number of history items to keep
  static const int maxHistoryItems = 1000;

  /// Maximum cache size (100MB)
  static const int maxCacheSize = 100 * 1024 * 1024;

  /// Cache cleanup threshold (80% of max size)
  static const double cacheCleanupThreshold = 0.8;

  /// Thumbnail maximum size (200KB)
  static const int maxThumbnailSize = 200 * 1024;

  // ═══════════════════════════════════════════════════════════════════════════════════
  // DATABASE CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Main Hive database box name
  static const String hiveBoxName = 'shareit_pro_db';

  /// Settings storage box
  static const String settingsBoxName = 'settings';

  /// Transfer history storage box
  static const String historyBoxName = 'transfer_history';

  /// Known devices storage box
  static const String devicesBoxName = 'known_devices';

  /// Favorite files storage box
  static const String favoritesBoxName = 'favorite_files';

  /// User preferences box
  static const String preferencesBoxName = 'preferences';

  /// Statistics and analytics box
  static const String analyticsBoxName = 'analytics';

  // ═══════════════════════════════════════════════════════════════════════════════════
  // ANIMATION & UI CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Fast animation duration (milliseconds)
  static const int shortAnimationDuration = 200;

  /// Standard animation duration (milliseconds)
  static const int mediumAnimationDuration = 300;

  /// Slow animation duration (milliseconds)
  static const int longAnimationDuration = 500;

  /// Page transition duration (milliseconds)
  static const int pageTransitionDuration = 350;

  /// List item animation stagger (milliseconds)
  static const int staggerAnimationDelay = 50;

  /// Splash screen minimum duration (milliseconds)
  static const int splashScreenDuration = 2000;

  // ═══════════════════════════════════════════════════════════════════════════════════
  // UI LAYOUT CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Default border radius for UI elements
  static const double defaultBorderRadius = 12.0;

  /// Small border radius for compact elements
  static const double smallBorderRadius = 8.0;

  /// Large border radius for prominent elements
  static const double largeBorderRadius = 16.0;

  /// Card elevation for material design
  static const double cardElevation = 2.0;

  /// Maximum width for responsive design (tablets/desktop)
  static const double maxContentWidth = 600.0;

  /// Minimum touch target size (accessibility)
  static const double minTouchTargetSize = 48.0;

  // ═══════════════════════════════════════════════════════════════════════════════════
  // GRID & LAYOUT CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Default grid columns for mobile
  static const int defaultGridCrossAxisCount = 2;

  /// Grid columns for tablet screens
  static const int tabletGridCrossAxisCount = 3;

  /// Grid columns for desktop screens
  static const int desktopGridCrossAxisCount = 4;

  /// Spacing between grid items
  static const double gridSpacing = 16.0;

  /// Aspect ratio for file grid items
  static const double fileGridAspectRatio = 0.85;

  /// Aspect ratio for device grid items
  static const double deviceGridAspectRatio = 1.2;

  // ═══════════════════════════════════════════════════════════════════════════════════
  // QR CODE CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// QR code display size
  static const double qrCodeSize = 200.0;

  /// QR code version for data capacity
  static const int qrCodeVersion = 4;

  /// URL scheme for QR codes
  static const String qrCodePrefix = 'shareitpro://';

  /// QR code scanning timeout (seconds)
  static const int qrScanTimeout = 30;

  /// QR code generation timeout (seconds)
  static const int qrGenerationTimeout = 10;

  // ═══════════════════════════════════════════════════════════════════════════════════
  // HOTSPOT CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Default WiFi hotspot SSID prefix
  static const String defaultHotspotSSID = 'ShareItPro_';

  /// Default WiFi hotspot password
  static const String defaultHotspotPassword = 'shareit123';

  /// WiFi channel for hotspot (recommended: 6 or 11)
  static const int hotspotChannel = 6;

  /// Maximum devices that can connect to hotspot
  static const int maxHotspotClients = 8;

  /// Hotspot auto-disable timeout (minutes)
  static const int hotspotAutoDisableTimeout = 10;

  // ═══════════════════════════════════════════════════════════════════════════════════
  // SECURITY CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// AES encryption key size for secure transfers
  static const int encryptionKeySize = 256;

  /// Device authentication token expiry (hours)
  static const int authTokenExpiry = 24;

  /// Maximum failed authentication attempts
  static const int maxAuthAttempts = 3;

  /// Security lockout duration after failed attempts (minutes)
  static const int securityLockoutDuration = 15;

  // ═══════════════════════════════════════════════════════════════════════════════════
  // PERFORMANCE CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Maximum memory usage for file operations (50MB)
  static const int maxMemoryUsage = 50 * 1024 * 1024;

  /// Background task timeout (seconds)
  static const int backgroundTaskTimeout = 600;

  /// Image compression quality (0-100)
  static const int imageCompressionQuality = 85;

  /// Maximum concurrent network operations
  static const int maxConcurrentNetworkOps = 10;

  // ═══════════════════════════════════════════════════════════════════════════════════
  // NOTIFICATION CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Transfer progress notification update interval (seconds)
  static const int notificationUpdateInterval = 2;

  /// Notification channel ID for transfers
  static const String transferNotificationChannelId = 'transfer_progress';

  /// Notification channel ID for general updates
  static const String generalNotificationChannelId = 'general_updates';

  // ═══════════════════════════════════════════════════════════════════════════════════
  // FEATURE FLAGS
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Enable WiFi Direct functionality
  static const bool enableWifiDirect = true;

  /// Enable WiFi Hotspot functionality
  static const bool enableHotspot = true;

  /// Enable Bluetooth transfers
  static const bool enableBluetooth = true;

  /// Enable QR code sharing
  static const bool enableQRSharing = true;

  /// Enable file compression
  static const bool enableFileCompression = true;

  /// Enable file encryption (future feature)
  static const bool enableFileEncryption = false;

  /// Enable cloud sync (future feature)
  static const bool enableCloudSync = false;

  /// Enable analytics collection
  static const bool enableAnalytics = true;

  /// Enable crash reporting
  static const bool enableCrashReporting = true;

  /// Enable beta features
  static const bool enableBetaFeatures = false;

  // ═══════════════════════════════════════════════════════════════════════════════════
  // ERROR MESSAGES
  // ═══════════════════════════════════════════════════════════════════════════════════

  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  static const String networkErrorMessage =
      'Network connection failed. Please check your connection.';
  static const String permissionErrorMessage =
      'Permission required to continue.';
  static const String fileNotFoundMessage = 'File not found or has been moved.';
  static const String transferFailedMessage =
      'Transfer failed. Please try again.';
  static const String storageFullMessage =
      'Not enough storage space available.';
  static const String connectionTimeoutMessage =
      'Connection timed out. Please try again.';
  static const String deviceNotFoundMessage = 'No devices found nearby.';
  static const String invalidFileMessage = 'Invalid or corrupted file.';
  static const String securityErrorMessage = 'Security verification failed.';

  // ═══════════════════════════════════════════════════════════════════════════════════
  // SUCCESS MESSAGES
  // ═══════════════════════════════════════════════════════════════════════════════════

  static const String transferCompleteMessage =
      'Transfer completed successfully!';
  static const String connectionEstablishedMessage =
      'Connected to device successfully!';
  static const String filesSavedMessage = 'Files saved to downloads folder.';
  static const String settingsSavedMessage = 'Settings saved successfully.';
  static const String devicePairedMessage = 'Device paired successfully.';
  static const String qrCodeGeneratedMessage =
      'QR code generated successfully.';

  // ═══════════════════════════════════════════════════════════════════════════════════
  // ANALYTICS EVENTS
  // ═══════════════════════════════════════════════════════════════════════════════════

  static const String eventAppStart = 'app_start';
  static const String eventAppBackground = 'app_background';
  static const String eventAppForeground = 'app_foreground';
  static const String eventFileSelect = 'file_select';
  static const String eventDeviceConnect = 'device_connect';
  static const String eventDeviceDisconnect = 'device_disconnect';
  static const String eventTransferStart = 'transfer_start';
  static const String eventTransferComplete = 'transfer_complete';
  static const String eventTransferFailed = 'transfer_failed';
  static const String eventTransferCancelled = 'transfer_cancelled';
  static const String eventQRGenerate = 'qr_generate';
  static const String eventQRScan = 'qr_scan';
  static const String eventSettingsChange = 'settings_change';
  static const String eventErrorOccurred = 'error_occurred';
  static const String eventFeatureUsed = 'feature_used';

  // ═══════════════════════════════════════════════════════════════════════════════════
  // BREAKPOINTS FOR RESPONSIVE DESIGN
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Mobile breakpoint (phones)
  static const double mobileBreakpoint = 480.0;

  /// Tablet breakpoint
  static const double tabletBreakpoint = 768.0;

  /// Desktop breakpoint
  static const double desktopBreakpoint = 1024.0;

  /// Large desktop breakpoint
  static const double largeDesktopBreakpoint = 1440.0;

  // ═══════════════════════════════════════════════════════════════════════════════════
  // UTILITY METHODS
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Check if the app is in debug mode
  static bool get isDebugMode {
    bool debugMode = false;
    assert(debugMode = true);
    return debugMode;
  }

  /// Get timeout for specific operation type
  static int getTimeoutForOperation(String operationType) {
    switch (operationType.toLowerCase()) {
      case 'connection':
        return connectionTimeout;
      case 'transfer':
        return transferTimeout;
      case 'discovery':
        return discoveryTimeout;
      case 'qr_scan':
        return qrScanTimeout;
      default:
        return connectionTimeout;
    }
  }

  /// Get appropriate grid count based on screen width
  static int getGridCount(double screenWidth) {
    if (screenWidth >= desktopBreakpoint) {
      return desktopGridCrossAxisCount;
    } else if (screenWidth >= tabletBreakpoint) {
      return tabletGridCrossAxisCount;
    } else {
      return defaultGridCrossAxisCount;
    }
  }

  /// Check if screen size is mobile
  static bool isMobile(double screenWidth) => screenWidth < tabletBreakpoint;

  /// Check if screen size is tablet
  static bool isTablet(double screenWidth) =>
      screenWidth >= tabletBreakpoint && screenWidth < desktopBreakpoint;

  /// Check if screen size is desktop
  static bool isDesktop(double screenWidth) => screenWidth >= desktopBreakpoint;
}
