// App-wide constants
// lib/core/constants/app_constants.dart
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'ShareIt Pro';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String appPackageName = 'com.shareitpro.app';
  static const String appDescription = 'Ultra-fast file sharing with modern design';
  
  // Developer Information
  static const String developerName = 'ShareIt Pro Team';
  static const String developerEmail = 'support@shareitpro.com';
  static const String appStoreUrl = 'https://apps.apple.com/app/shareit-pro';
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=$appPackageName';
  static const String githubUrl = 'https://github.com/shareitpro/app';
  
  // Network Configuration
  static const int defaultPort = 8080;
  static const int maxPort = 8090;
  static const int connectionTimeout = 30; // seconds
  static const int transferTimeout = 300; // seconds
  static const int discoveryTimeout = 10; // seconds
  static const int retryAttempts = 3;
  static const int maxConcurrentTransfers = 5;
  
  // File Transfer Configuration
  static const int chunkSize = 1024 * 1024; // 1MB chunks
  static const int maxFileSize = 5 * 1024 * 1024 * 1024; // 5GB max file size
  static const int maxBatchSize = 1000; // max files in one transfer
  static const int progressUpdateInterval = 100; // milliseconds
  static const int speedCalculationInterval = 1000; // milliseconds
  
  // Storage Configuration
  static const String defaultDownloadFolder = 'ShareItPro';
  static const String tempFolder = 'temp';
  static const String thumbnailFolder = 'thumbnails';
  static const String logFolder = 'logs';
  static const int maxHistoryItems = 1000;
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  
  // Database Configuration
  static const String hiveBoxName = 'shareit_pro_db';
  static const String settingsBoxName = 'settings';
  static const String historyBoxName = 'transfer_history';
  static const String devicesBoxName = 'known_devices';
  static const String favoritesBoxName = 'favorite_files';
  
  // Animation Durations
  static const int shortAnimationDuration = 200; // milliseconds
  static const int mediumAnimationDuration = 300; // milliseconds
  static const int longAnimationDuration = 500; // milliseconds
  static const int pageTransitionDuration = 350; // milliseconds
  
  // UI Configuration
  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;
  static const double cardElevation = 2.0;
  static const double maxWidth = 600.0; // max width for responsive design
  
  // Grid Configuration
  static const int defaultGridCrossAxisCount = 2;
  static const int tabletGridCrossAxisCount = 3;
  static const int desktopGridCrossAxisCount = 4;
  static const double gridSpacing = 16.0;
  
  // QR Code Configuration
  static const double qrCodeSize = 200.0;
  static const int qrCodeVersion = 4;
  static const String qrCodePrefix = 'shareitpro://';
  
  // Hotspot Configuration
  static const String defaultHotspotSSID = 'ShareItPro_';
  static const String defaultHotspotPassword = 'shareit123';
  static const int hotspotChannel = 6;
  
  // Error Messages
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Network connection failed. Please check your connection.';
  static const String permissionErrorMessage = 'Permission required to continue.';
  static const String fileNotFoundMessage = 'File not found or has been moved.';
  static const String transferFailedMessage = 'Transfer failed. Please try again.';
  
  // Success Messages
  static const String transferCompleteMessage = 'Transfer completed successfully!';
  static const String connectionEstablishedMessage = 'Connected to device successfully!';
  static const String filesSavedMessage = 'Files saved to downloads folder.';
  
  // Feature Flags
  static const bool enableWifiDirect = true;
  static const bool enableHotspot = true;
  static const bool enableBluetooth = true;
  static const bool enableQRSharing = true;
  static const bool enableFileCompression = true;
  static const bool enableFileEncryption = false; // Future feature
  static const bool enableCloudSync = false; // Future feature
  
  // Analytics Events
  static const String eventAppStart = 'app_start';
  static const String eventFileSelect = 'file_select';
  static const String eventDeviceConnect = 'device_connect';
  static const String eventTransferStart = 'transfer_start';
  static const String eventTransferComplete = 'transfer_complete';
  static const String eventQRScan = 'qr_scan';
  static const String eventSettingsChange = 'settings_change';
}
