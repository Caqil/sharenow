import os

def create_directory(path):
    os.makedirs(path, exist_ok=True)

def create_file(path, comment=""):
    with open(path, 'w') as f:
        if comment:
            f.write(f"// {comment}\n")

def create_structure():
    # Root directory
    create_directory("lib")

    # Main files
    create_file("lib/main.dart")

    # App directory
    create_directory("lib/app")
    create_file("lib/app/app.dart", "Main ShadApp setup")
    create_file("lib/app/app_bloc_observer.dart", "BLoC observer")
    create_file("lib/app/app_router.dart", "GoRouter configuration")

    # Core directory
    create_directory("lib/core")

    # Design System
    create_directory("lib/core/design_system/theme")
    create_file("lib/core/design_system/theme/app_theme.dart", "ShadThemeData configuration")
    create_file("lib/core/design_system/theme/color_scheme.dart", "ShadColorScheme setup")
    create_file("lib/core/design_system/theme/typography.dart", "ShadTextTheme setup")
    create_file("lib/core/design_system/theme/component_theme.dart", "Component customizations")

    create_directory("lib/core/design_system/tokens")
    create_file("lib/core/design_system/tokens/colors.dart", "Color design tokens")
    create_file("lib/core/design_system/tokens/spacing.dart", "Spacing scale")
    create_file("lib/core/design_system/tokens/typography.dart", "Text style tokens")
    create_file("lib/core/design_system/tokens/shadows.dart", "Shadow tokens")
    create_file("lib/core/design_system/tokens/borders.dart", "Border radius tokens")

    create_directory("lib/core/design_system/components/atoms")
    create_file("lib/core/design_system/components/atoms/app_button.dart", "Custom ShadButton wrapper")
    create_file("lib/core/design_system/components/atoms/app_icon.dart", "FontAwesome icon wrapper")
    create_file("lib/core/design_system/components/atoms/app_avatar.dart", "ShadAvatar wrapper")
    create_file("lib/core/design_system/components/atoms/app_badge.dart", "ShadBadge wrapper")
    create_file("lib/core/design_system/components/atoms/app_card.dart", "ShadCard wrapper")
    create_file("lib/core/design_system/components/atoms/app_progress.dart", "ShadProgress wrapper")

    create_directory("lib/core/design_system/components/molecules")
    create_file("lib/core/design_system/components/molecules/file_card.dart", "File display card")
    create_file("lib/core/design_system/components/molecules/device_card.dart", "Device info card")
    create_file("lib/core/design_system/components/molecules/transfer_card.dart", "Transfer progress card")
    create_file("lib/core/design_system/components/molecules/stat_card.dart", "Statistics card")
    create_file("lib/core/design_system/components/molecules/connection_banner.dart", "Connection status banner")
    create_file("lib/core/design_system/components/molecules/speed_card.dart", "Speed monitoring card")

    create_directory("lib/core/design_system/components/organisms")
    create_file("lib/core/design_system/components/organisms/bottom_navigation.dart", "ShadTabs bottom nav")
    create_file("lib/core/design_system/components/organisms/file_grid.dart", "File grid layout")
    create_file("lib/core/design_system/components/organisms/device_list.dart", "Device discovery list")
    create_file("lib/core/design_system/components/organisms/transfer_queue.dart", "Transfer queue display")
    create_file("lib/core/design_system/components/organisms/qr_scanner_view.dart", "QR scanner with overlay")
    create_file("lib/core/design_system/components/organisms/settings_form.dart", "Settings form layout")

    create_directory("lib/core/design_system/components/templates")
    create_file("lib/core/design_system/components/templates/base_page.dart", "Standard page layout")
    create_file("lib/core/design_system/components/templates/modal_page.dart", "ShadSheet modal template")
    create_file("lib/core/design_system/components/templates/loading_state.dart", "Loading page template")
    create_file("lib/core/design_system/components/templates/error_state.dart", "Error page template")

    create_directory("lib/core/design_system/animations")
    create_file("lib/core/design_system/animations/page_transitions.dart", "Custom route transitions")
    create_file("lib/core/design_system/animations/hover_effects.dart", "Hover micro-interactions")
    create_file("lib/core/design_system/animations/tap_effects.dart", "Tap feedback animations")
    create_file("lib/core/design_system/animations/loading_states.dart", "Loading animations")

    create_directory("lib/core/design_system/responsive")
    create_file("lib/core/design_system/responsive/breakpoints.dart", "Responsive breakpoints")
    create_file("lib/core/design_system/responsive/responsive_layout.dart", "Responsive wrapper")
    create_file("lib/core/design_system/responsive/platform_layout.dart", "Platform-specific layouts")

    # Services
    create_directory("lib/core/services/connection")
    create_file("lib/core/services/connection/connection_manager.dart", "Smart connection selector")
    create_file("lib/core/services/connection/hotspot_service.dart", "WiFi hotspot (fastest)")
    create_file("lib/core/services/connection/wifi_direct_service.dart", "WiFi Direct")
    create_file("lib/core/services/connection/nearby_service.dart", "Nearby Connections")
    create_file("lib/core/services/connection/bluetooth_service.dart", "Bluetooth fallback")

    create_directory("lib/core/services/transfer")
    create_file("lib/core/services/transfer/transfer_engine.dart", "Core transfer logic")
    create_file("lib/core/services/transfer/progress_tracker.dart", "Progress monitoring")
    create_file("lib/core/services/transfer/speed_calculator.dart", "Speed calculations")
    create_file("lib/core/services/transfer/file_chunker.dart", "File chunking")

    create_directory("lib/core/services/storage")
    create_file("lib/core/services/storage/hive_service.dart", "Local storage")
    create_file("lib/core/services/storage/preferences_service.dart", "SharedPreferences")
    create_file("lib/core/services/storage/file_service.dart", "File operations")

    create_directory("lib/core/services/device")
    create_file("lib/core/services/device/device_info_service.dart", "Device information")
    create_file("lib/core/services/device/permission_service.dart", "Permission handling")
    create_file("lib/core/services/device/network_info_service.dart", "Network information")

    # Router
    create_directory("lib/core/router")
    create_file("lib/core/router/app_router.dart", "GoRouter setup")
    create_file("lib/core/router/route_config.dart", "Route definitions")
    create_file("lib/core/router/route_guards.dart", "Route protection")

    # Dependency Injection
    create_directory("lib/core/di")
    create_file("lib/core/di/injection.dart", "GetIt dependency injection")

    # Constants
    create_directory("lib/core/constants")
    create_file("lib/core/constants/app_constants.dart", "App-wide constants")
    create_file("lib/core/constants/file_types.dart", "File type definitions")
    create_file("lib/core/constants/connection_types.dart", "Connection method types")

    # Models
    create_directory("lib/core/models")
    create_file("lib/core/models/app_file.dart", "File model")
    create_file("lib/core/models/device_info.dart", "Device information model")
    create_file("lib/core/models/transfer_session.dart", "Transfer session model")
    create_file("lib/core/models/connection_info.dart", "Connection details model")
    create_file("lib/core/models/app_settings.dart", "Settings model")

    # Enums
    create_directory("lib/core/enums")
    create_file("lib/core/enums/connection_status.dart", "Connection states")
    create_file("lib/core/enums/transfer_status.dart", "Transfer states")
    create_file("lib/core/enums/file_type.dart", "File type enum")
    create_file("lib/core/enums/device_type.dart", "Device type enum")

    # Extensions
    create_directory("lib/core/extensions")
    create_file("lib/core/extensions/context_extensions.dart", "BuildContext extensions")
    create_file("lib/core/extensions/string_extensions.dart", "String utilities")
    create_file("lib/core/extensions/file_extensions.dart", "File utilities")
    create_file("lib/core/extensions/datetime_extensions.dart", "DateTime formatting")

    # Utils
    create_directory("lib/core/utils")
    create_file("lib/core/utils/file_utils.dart", "File operations")
    create_file("lib/core/utils/permission_utils.dart", "Permission helpers")
    create_file("lib/core/utils/format_utils.dart", "Formatting utilities")
    create_file("lib/core/utils/validation_utils.dart", "Input validation")
    create_file("lib/core/utils/haptic_utils.dart", "Haptic feedback")

    # Features
    create_directory("lib/features")

    # Onboarding
    create_directory("lib/features/onboarding/presentation/pages")
    create_file("lib/features/onboarding/presentation/pages/splash_page.dart", "Animated splash screen")
    create_file("lib/features/onboarding/presentation/pages/welcome_page.dart", "Welcome introduction")
    create_file("lib/features/onboarding/presentation/pages/permissions_page.dart", "Permission requests")
    create_file("lib/features/onboarding/presentation/pages/setup_complete_page.dart", "Setup completion")

    create_directory("lib/features/onboarding/presentation/widgets")
    create_file("lib/features/onboarding/presentation/widgets/onboarding_slider.dart", "Page indicator slider")
    create_file("lib/features/onboarding/presentation/widgets/permission_card.dart", "Permission explanation")
    create_file("lib/features/onboarding/presentation/widgets/feature_showcase.dart", "Feature highlights")
    create_file("lib/features/onboarding/presentation/widgets/completion_animation.dart", "Success animation")

    create_directory("lib/features/onboarding/presentation/cubit")
    create_file("lib/features/onboarding/presentation/cubit/onboarding_cubit.dart")
    create_file("lib/features/onboarding/presentation/cubit/onboarding_state.dart")

    create_directory("lib/features/onboarding/domain/entities")
    create_file("lib/features/onboarding/domain/entities/onboarding_step.dart")

    create_directory("lib/features/onboarding/domain/usecases")
    create_file("lib/features/onboarding/domain/usecases/check_first_launch.dart")
    create_file("lib/features/onboarding/domain/usecases/complete_onboarding.dart")

    # Home
    create_directory("lib/features/home/presentation/pages")
    create_file("lib/features/home/presentation/pages/home_page.dart", "Main dashboard")

    create_directory("lib/features/home/presentation/widgets")
    create_file("lib/features/home/presentation/widgets/hero_section.dart", "Welcome hero section")
    create_file("lib/features/home/presentation/widgets/quick_actions.dart", "Send/Receive buttons")
    create_file("lib/features/home/presentation/widgets/stats_overview.dart", "Usage statistics")
    create_file("lib/features/home/presentation/widgets/recent_transfers.dart", "Recent activity")
    create_file("lib/features/home/presentation/widgets/device_status.dart", "Connection status")
    create_file("lib/features/home/presentation/widgets/speed_test_card.dart", "Network speed test")

    create_directory("lib/features/home/presentation/cubit")
    create_file("lib/features/home/presentation/cubit/home_cubit.dart")
    create_file("lib/features/home/presentation/cubit/home_state.dart")

    create_directory("lib/features/home/domain/entities")
    create_file("lib/features/home/domain/entities/home_stats.dart")

    create_directory("lib/features/home/domain/usecases")
    create_file("lib/features/home/domain/usecases/get_home_stats.dart")

    # Send
    create_directory("lib/features/send/presentation/pages")
    create_file("lib/features/send/presentation/pages/file_picker_page.dart", "File selection")
    create_file("lib/features/send/presentation/pages/device_discovery_page.dart", "Find devices")
    create_file("lib/features/send/presentation/pages/connection_setup_page.dart", "Setup connection")
    create_file("lib/features/send/presentation/pages/send_progress_page.dart", "Transfer progress")

    create_directory("lib/features/send/presentation/widgets")
    create_file("lib/features/send/presentation/widgets/file_type_tabs.dart", "ShadTabs for file types")
    create_file("lib/features/send/presentation/widgets/file_grid_view.dart", "File selection grid")
    create_file("lib/features/send/presentation/widgets/selected_files_bar.dart", "Selection summary")
    create_file("lib/features/send/presentation/widgets/device_scanner.dart", "Device discovery")
    create_file("lib/features/send/presentation/widgets/connection_methods.dart", "Connection options")
    create_file("lib/features/send/presentation/widgets/qr_code_display.dart", "QR sharing")
    create_file("lib/features/send/presentation/widgets/transfer_progress.dart", "Progress visualization")

    create_directory("lib/features/send/presentation/cubit")
    create_file("lib/features/send/presentation/cubit/send_cubit.dart")
    create_file("lib/features/send/presentation/cubit/send_state.dart")

    create_directory("lib/features/send/domain/entities")
    create_file("lib/features/send/domain/entities/file_item.dart")
    create_file("lib/features/send/domain/entities/send_session.dart")

    create_directory("lib/features/send/domain/usecases")
    create_file("lib/features/send/domain/usecases/scan_files.dart")
    create_file("lib/features/send/domain/usecases/discover_devices.dart")
    create_file("lib/features/send/domain/usecases/send_files.dart")

    # Receive
    create_directory("lib/features/receive/presentation/pages")
    create_file("lib/features/receive/presentation/pages/receive_mode_page.dart", "Receive options")
    create_file("lib/features/receive/presentation/pages/qr_scanner_page.dart", "QR code scanner")
    create_file("lib/features/receive/presentation/pages/incoming_files_page.dart", "File preview/accept")
    create_file("lib/features/receive/presentation/pages/receive_progress_page.dart", "Download progress")

    create_directory("lib/features/receive/presentation/widgets")
    create_file("lib/features/receive/presentation/widgets/receive_options.dart", "Receive method cards")
    create_file("lib/features/receive/presentation/widgets/qr_scanner_overlay.dart", "Camera overlay")
    create_file("lib/features/receive/presentation/widgets/incoming_preview.dart", "File preview dialog")
    create_file("lib/features/receive/presentation/widgets/accept_dialog.dart", "ShadDialog accept/reject")
    create_file("lib/features/receive/presentation/widgets/download_progress.dart", "Progress indicators")
    create_file("lib/features/receive/presentation/widgets/save_location.dart", "Directory selector")

    create_directory("lib/features/receive/presentation/cubit")
    create_file("lib/features/receive/presentation/cubit/receive_cubit.dart")
    create_file("lib/features/receive/presentation/cubit/receive_state.dart")

    create_directory("lib/features/receive/domain/entities")
    create_file("lib/features/receive/domain/entities/receive_request.dart")
    create_file("lib/features/receive/domain/entities/download_session.dart")

    create_directory("lib/features/receive/domain/usecases")
    create_file("lib/features/receive/domain/usecases/start_receive_mode.dart")
    create_file("lib/features/receive/domain/usecases/scan_qr_code.dart")
    create_file("lib/features/receive/domain/usecases/receive_files.dart")

    # History
    create_directory("lib/features/history/presentation/pages")
    create_file("lib/features/history/presentation/pages/history_page.dart", "Transfer history")

    create_directory("lib/features/history/presentation/widgets")
    create_file("lib/features/history/presentation/widgets/history_timeline.dart", "Timeline view")
    create_file("lib/features/history/presentation/widgets/history_filters.dart", "ShadSelect filters")
    create_file("lib/features/history/presentation/widgets/transfer_history_card.dart", "History item")
    create_file("lib/features/history/presentation/widgets/history_stats.dart", "Statistics cards")
    create_file("lib/features/history/presentation/widgets/export_options.dart", "Export functionality")

    create_directory("lib/features/history/presentation/cubit")
    create_file("lib/features/history/presentation/cubit/history_cubit.dart")
    create_file("lib/features/history/presentation/cubit/history_state.dart")

    create_directory("lib/features/history/domain/entities")
    create_file("lib/features/history/domain/entities/transfer_history.dart")

    create_directory("lib/features/history/domain/usecases")
    create_file("lib/features/history/domain/usecases/get_history.dart")
    create_file("lib/features/history/domain/usecases/export_history.dart")

    # Settings
    create_directory("lib/features/settings/presentation/pages")
    create_file("lib/features/settings/presentation/pages/settings_page.dart", "Main settings")
    create_file("lib/features/settings/presentation/pages/appearance_page.dart", "Theme settings")
    create_file("lib/features/settings/presentation/pages/transfer_settings_page.dart", "Transfer options")
    create_file("lib/features/settings/presentation/pages/about_page.dart", "App information")

    create_directory("lib/features/settings/presentation/widgets")
    create_file("lib/features/settings/presentation/widgets/settings_section.dart", "Settings group")
    create_file("lib/features/settings/presentation/widgets/theme_selector.dart", "ShadRadioGroup theme")
    create_file("lib/features/settings/presentation/widgets/language_selector.dart", "ShadSelect language")
    create_file("lib/features/settings/presentation/widgets/transfer_options.dart", "Transfer settings")
    create_file("lib/features/settings/presentation/widgets/privacy_controls.dart", "Privacy switches")
    create_file("lib/features/settings/presentation/widgets/about_section.dart", "App info cards")

    create_directory("lib/features/settings/presentation/cubit")
    create_file("lib/features/settings/presentation/cubit/settings_cubit.dart")
    create_file("lib/features/settings/presentation/cubit/settings_state.dart")

    create_directory("lib/features/settings/domain/entities")
    create_file("lib/features/settings/domain/entities/user_settings.dart")

    create_directory("lib/features/settings/domain/usecases")
    create_file("lib/features/settings/domain/usecases/get_settings.dart")
    create_file("lib/features/settings/domain/usecases/update_settings.dart")

    # Connection
    create_directory("lib/features/connection/presentation/pages")
    create_file("lib/features/connection/presentation/pages/connection_methods_page.dart", "Method selection")
    create_file("lib/features/connection/presentation/pages/hotspot_setup_page.dart", "Hotspot configuration")
    create_file("lib/features/connection/presentation/pages/wifi_direct_page.dart", "WiFi Direct setup")
    create_file("lib/features/connection/presentation/pages/troubleshoot_page.dart", "Connection help")

    create_directory("lib/features/connection/presentation/widgets")
    create_file("lib/features/connection/presentation/widgets/method_selection_cards.dart", "Connection cards")
    create_file("lib/features/connection/presentation/widgets/speed_test_widget.dart", "Speed testing")
    create_file("lib/features/connection/presentation/widgets/network_analyzer.dart", "Network information")
    create_file("lib/features/connection/presentation/widgets/hotspot_controls.dart", "Hotspot UI controls")
    create_file("lib/features/connection/presentation/widgets/wifi_scanner.dart", "WiFi network scanner")
    create_file("lib/features/connection/presentation/widgets/troubleshoot_guide.dart", "Help content")

    create_directory("lib/features/connection/presentation/cubit")
    create_file("lib/features/connection/presentation/cubit/connection_cubit.dart")
    create_file("lib/features/connection/presentation/cubit/connection_state.dart")

    create_directory("lib/features/connection/domain/entities")
    create_file("lib/features/connection/domain/entities/connection_method.dart")
    create_file("lib/features/connection/domain/entities/speed_test_result.dart")

    create_directory("lib/features/connection/domain/usecases")
    create_file("lib/features/connection/domain/usecases/test_connection_speed.dart")
    create_file("lib/features/connection/domain/usecases/analyze_network.dart")

    # Shared
    create_directory("lib/shared/widgets/common")
    create_file("lib/shared/widgets/common/loading_overlay.dart", "App-wide loading")
    create_file("lib/shared/widgets/common/error_boundary.dart", "Error handling")
    create_file("lib/shared/widgets/common/network_banner.dart", "Network status")
    create_file("lib/shared/widgets/common/permission_gate.dart", "Permission wrapper")
    create_file("lib/shared/widgets/common/adaptive_widget.dart", "Platform adaptive")

    create_directory("lib/shared/widgets/feedback")
    create_file("lib/shared/widgets/feedback/success_toast.dart", "ShadToast success")
    create_file("lib/shared/widgets/feedback/error_toast.dart", "ShadToast error")
    create_file("lib/shared/widgets/feedback/loading_indicator.dart", "Loading states")
    create_file("lib/shared/widgets/feedback/haptic_feedback.dart", "Haptic responses")

    create_directory("lib/shared/widgets/layout")
    create_file("lib/shared/widgets/layout/responsive_container.dart", "Responsive wrapper")
    create_file("lib/shared/widgets/layout/safe_area_wrapper.dart", "Safe area handling")
    create_file("lib/shared/widgets/layout/keyboard_aware_wrapper.dart", "Keyboard avoidance")

    create_directory("lib/shared/mixins")
    create_file("lib/shared/mixins/loading_mixin.dart", "Loading state mixin")
    create_file("lib/shared/mixins/error_handling_mixin.dart", "Error handling mixin")
    create_file("lib/shared/mixins/validation_mixin.dart", "Validation mixin")

if __name__ == "__main__":
    create_structure()
    print("Folder structure created successfully!")