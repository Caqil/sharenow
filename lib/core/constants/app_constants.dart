/// Application-wide constants and configuration values
/// Designed to work seamlessly with shadcn_ui components
class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // ═══════════════════════════════════════════════════════════════════════════════════
  // APP INFORMATION
  // ═══════════════════════════════════════════════════════════════════════════════════

  static const String appName = 'ShareNow';
  static const String appVersion = '1.0.0';
  static const String appPackageName = 'com.shareit.flutter_shareit';
  static const String appDescription =
      'Fast and secure file sharing between devices';

  // ═══════════════════════════════════════════════════════════════════════════════════
  // ANIMATION & TIMING (shadcn-style)
  // ═══════════════════════════════════════════════════════════════════════════════════

  static const int fastAnimationDuration = 150; // Quick transitions
  static const int mediumAnimationDuration = 300; // Standard transitions
  static const int slowAnimationDuration = 500; // Slow transitions
  static const int extraSlowAnimationDuration = 800; // Page transitions

  // Easing curves (shadcn-style)
  static const String defaultEasing = 'ease-in-out';
  static const String fastEasing = 'ease-out';
  static const String slowEasing = 'ease-in';

  // ═══════════════════════════════════════════════════════════════════════════════════
  // SPACING & DIMENSIONS (shadcn design tokens)
  // ═══════════════════════════════════════════════════════════════════════════════════

  // Spacing scale (4px base unit)
  static const double spacing0 = 0.0;
  static const double spacing1 = 4.0; // 0.25rem
  static const double spacing2 = 8.0; // 0.5rem
  static const double spacing3 = 12.0; // 0.75rem
  static const double spacing4 = 16.0; // 1rem
  static const double spacing5 = 20.0; // 1.25rem
  static const double spacing6 = 24.0; // 1.5rem
  static const double spacing8 = 32.0; // 2rem
  static const double spacing10 = 40.0; // 2.5rem
  static const double spacing12 = 48.0; // 3rem
  static const double spacing16 = 64.0; // 4rem
  static const double spacing20 = 80.0; // 5rem

  // Common padding values
  static const double defaultPadding = spacing4; // 16px
  static const double smallPadding = spacing2; // 8px
  static const double mediumPadding = spacing6; // 24px
  static const double largePadding = spacing8; // 32px
  static const double extraLargePadding = spacing12; // 48px

  // Border radius values (shadcn style)
  static const double radiusNone = 0.0;
  static const double radiusSm = 2.0;
  static const double radiusMd = 6.0;
  static const double radiusLg = 8.0;
  static const double radiusXl = 12.0;
  static const double radius2xl = 16.0;
  static const double radius3xl = 24.0;
  static const double radiusFull = 9999.0; // Full rounding

  // Default values
  static const double defaultBorderRadius = radiusLg;
  static const double smallBorderRadius = radiusMd;
  static const double largeBorderRadius = radiusXl;
  static const double circularBorderRadius = radiusFull;

  // Shadow & elevation
  static const double shadowSm = 1.0;
  static const double shadowMd = 3.0;
  static const double shadowLg = 6.0;
  static const double shadowXl = 12.0;
  static const double shadow2xl = 24.0;

  static const double defaultElevation = shadowMd;
  static const double mediumElevation = shadowLg;
  static const double highElevation = shadowXl;

  // Icon sizes
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;
  static const double icon2xl = 48.0;

  static const double defaultIconSize = iconLg;
  static const double smallIconSize = iconSm;
  static const double largeIconSize = iconXl;
  static const double extraLargeIconSize = icon2xl;

  // ═══════════════════════════════════════════════════════════════════════════════════
  // TRANSFER & NETWORK CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════════════

  // File transfer limits
  static const int maxFileSize = 500 * 1024 * 1024; // 500MB per file
  static const int maxBatchSize = 100; // Maximum files per batch
  static const int maxTotalBatchSize = 2 * 1024 * 1024 * 1024; // 2GB total
  static const int defaultChunkSize = 64 * 1024; // 64KB chunks
  static const int largeFileChunkSize = 1024 * 1024; // 1MB for large files

  // Network timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int transferTimeout = 300000; // 5 minutes
  static const int discoveryTimeout = 45000; // 45 seconds
  static const int handshakeTimeout = 10000; // 10 seconds

  // Network configuration
  static const String serviceId = 'com.shareit.flutter_shareit';
  static const String serviceType = '_shareit._tcp';
  static const int discoveryDuration = 30000; // 30 seconds
  static const int advertisingDuration = 60000; // 1 minute
  static const int maxRetryAttempts = 3;
  static const int retryDelayMs = 2000; // 2 seconds

  // Transfer speeds (for UI indicators)
  static const int slowSpeedThreshold = 1024 * 1024; // 1 MB/s
  static const int mediumSpeedThreshold = 10 * 1024 * 1024; // 10 MB/s
  static const int fastSpeedThreshold = 50 * 1024 * 1024; // 50 MB/s

  // ═══════════════════════════════════════════════════════════════════════════════════
  // STORAGE & DATABASE
  // ═══════════════════════════════════════════════════════════════════════════════════

  // Hive box names
  static const String settingsBox = 'app_settings';
  static const String transferHistoryBox = 'transfer_history';
  static const String deviceCacheBox = 'device_cache';
  static const String userPreferencesBox = 'user_preferences';
  static const String fileMetadataBox = 'file_metadata';

  // Storage keys
  static const String keyFirstLaunch = 'first_launch';
  static const String keyUserName = 'user_name';
  static const String keyDeviceName = 'device_name';
  static const String keyDeviceId = 'device_id';
  static const String keyThemeMode = 'theme_mode';
  static const String keyPrimaryColor = 'primary_color';
  static const String keyLanguage = 'language';
  static const String keyAutoAcceptFiles = 'auto_accept_files';
  static const String keyShowNotifications = 'show_notifications';
  static const String keyVibrateOnTransfer = 'vibrate_on_transfer';
  static const String keySaveToGallery = 'save_to_gallery';
  static const String keyCompressionEnabled = 'compression_enabled';
  static const String keyEncryptionEnabled = 'encryption_enabled';
  static const String keyLastBackupDate = 'last_backup_date';
  static const String keyTransferStats = 'transfer_statistics';
  static const String keyPrivacyMode = 'privacy_mode';
  static const String keyDataSaverMode = 'data_saver_mode';

  // Cache limits
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  static const int maxHistoryEntries = 1000;
  static const int maxDeviceCacheEntries = 50;
  static const Duration cacheExpiry = Duration(days: 30);

  // ═══════════════════════════════════════════════════════════════════════════════════
  // FILE TYPES & EXTENSIONS
  // ═══════════════════════════════════════════════════════════════════════════════════

  // Image files
  static const List<String> imageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'bmp',
    'webp',
    'svg',
    'ico',
    'tiff',
    'tif',
    'heic',
    'heif',
    'raw',
    'dng'
  ];

  // Video files
  static const List<String> videoExtensions = [
    'mp4',
    'avi',
    'mov',
    'wmv',
    'flv',
    'webm',
    'mkv',
    '3gp',
    'm4v',
    'mpg',
    'mpeg',
    'ogv',
    'f4v',
    'asf',
    'rm',
    'rmvb'
  ];

  // Audio files
  static const List<String> audioExtensions = [
    'mp3',
    'wav',
    'aac',
    'flac',
    'ogg',
    'wma',
    'm4a',
    'opus',
    'aiff',
    'au',
    '3ga',
    'amr',
    'ac3',
    'eac3'
  ];

  // Document files
  static const List<String> documentExtensions = [
    'pdf',
    'doc',
    'docx',
    'xls',
    'xlsx',
    'ppt',
    'pptx',
    'txt',
    'rtf',
    'odt',
    'ods',
    'odp',
    'pages',
    'numbers',
    'keynote',
    'epub',
    'mobi'
  ];

  // Archive files
  static const List<String> archiveExtensions = [
    'zip',
    'rar',
    '7z',
    'tar',
    'gz',
    'bz2',
    'xz',
    'lzma',
    'cab',
    'iso',
    'dmg',
    'deb',
    'rpm'
  ];

  // Application files
  static const List<String> applicationExtensions = [
    'apk',
    'ipa',
    'exe',
    'msi',
    'dmg',
    'pkg',
    'deb',
    'rpm',
    'appimage'
  ];

  // ═══════════════════════════════════════════════════════════════════════════════════
  // UI STRINGS & MESSAGES
  // ═══════════════════════════════════════════════════════════════════════════════════

  // Error messages
  static const String errorGeneral = 'Something went wrong';
  static const String errorNetwork = 'Connection failed';
  static const String errorPermission = 'Permission required';
  static const String errorFileNotFound = 'File not found';
  static const String errorTransferFailed = 'Transfer failed';
  static const String errorDeviceNotFound = 'Device not found';
  static const String errorConnectionTimeout = 'Connection timeout';
  static const String errorFileTooLarge = 'File too large';
  static const String errorInsufficientSpace = 'Insufficient storage space';
  static const String errorUnsupportedFormat = 'Unsupported file format';

  // Success messages
  static const String successTransferComplete = 'Transfer completed';
  static const String successFilesSaved = 'Files saved successfully';
  static const String successDeviceConnected = 'Device connected';
  static const String successSettingsSaved = 'Settings saved';
  static const String successBackupCreated = 'Backup created';

  // Info messages
  static const String infoScanning = 'Scanning for devices...';
  static const String infoConnecting = 'Connecting to device...';
  static const String infoTransferring = 'Transferring files...';
  static const String infoPreparing = 'Preparing files...';
  static const String infoWaiting = 'Waiting for response...';

  // ═══════════════════════════════════════════════════════════════════════════════════
  // VALIDATION RULES
  // ═══════════════════════════════════════════════════════════════════════════════════

  static const int minUsernameLength = 2;
  static const int maxUsernameLength = 30;
  static const int minDeviceNameLength = 2;
  static const int maxDeviceNameLength = 40;
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;

  // Regex patterns
  static const String usernamePattern = r'^[a-zA-Z0-9_\s-]+$';
  static const String deviceNamePattern = r'^[a-zA-Z0-9_\s-]+$';
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  // ═══════════════════════════════════════════════════════════════════════════════════
  // EXTERNAL LINKS & URLS
  // ═══════════════════════════════════════════════════════════════════════════════════

  static const String privacyPolicyUrl = 'https://sharenow.app/privacy';
  static const String termsOfServiceUrl = 'https://sharenow.app/terms';
  static const String supportUrl = 'https://sharenow.app/support';
  static const String githubUrl = 'https://github.com/sharenow/flutter_shareit';
  static const String websiteUrl = 'https://sharenow.app';
  static const String feedbackUrl = 'https://sharenow.app/feedback';

  // ═══════════════════════════════════════════════════════════════════════════════════
  // FEATURE FLAGS & CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════════════

  static const bool enableQRCodeSharing = true;
  static const bool enableCloudBackup = false;
  static const bool enableBetaFeatures = false;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enableEncryption = true;
  static const bool enableCompression = true;
  static const bool enableNotifications = true;
  static const bool enableVibration = true;

  // Rate limiting
  static const int maxTransfersPerMinute = 15;
  static const int maxConnectionsPerDevice = 5;
  static const int rateLimitWindowMinutes = 1;
  static const int maxConcurrentTransfers = 3;

  // Performance settings
  static const int memoryThresholdMB = 100;
  static const int batteryThresholdPercent = 15;
  static const bool enableBackgroundTransfer = true;
  static const bool enableLowPowerMode = true;
}
