import os

def create_file(path, description):
    """Create a Dart file with a basic comment indicating its purpose."""
    with open(path, 'w') as f:
        f.write(f"// {description}\n")

def create_folder_structure():
    """Create the folder structure and Dart files for the project."""
    # Base directory
    base_dir = "lib"
    os.makedirs(base_dir, exist_ok=True)

    # Root level file
    create_file(os.path.join(base_dir, "main.dart"), "Main entry point of the application")

    # app directory
    app_dir = os.path.join(base_dir, "app")
    os.makedirs(app_dir, exist_ok=True)
    create_file(os.path.join(app_dir, "app.dart"), "Main ShadApp")
    create_file(os.path.join(app_dir, "router.dart"), "GoRouter setup")
    create_file(os.path.join(app_dir, "theme.dart"), "App themes")

    # core directory
    core_dir = os.path.join(base_dir, "core")
    
    # core/constants
    constants_dir = os.path.join(core_dir, "constants")
    os.makedirs(constants_dir, exist_ok=True)
    create_file(os.path.join(constants_dir, "app_constants.dart"), "App-wide constants")
    create_file(os.path.join(constants_dir, "file_types.dart"), "File type definitions")
    create_file(os.path.join(constants_dir, "connection_types.dart"), "Connection method types")

    # core/services
    services_dir = os.path.join(core_dir, "services")
    os.makedirs(services_dir, exist_ok=True)
    create_file(os.path.join(services_dir, "file_service.dart"), "File operations")
    create_file(os.path.join(services_dir, "transfer_service.dart"), "Core transfer logic")
    create_file(os.path.join(services_dir, "connection_service.dart"), "Network connections")
    create_file(os.path.join(services_dir, "permission_service.dart"), "Permissions")
    create_file(os.path.join(services_dir, "storage_service.dart"), "Local storage")

    # core/models
    models_dir = os.path.join(core_dir, "models")
    os.makedirs(models_dir, exist_ok=True)
    create_file(os.path.join(models_dir, "file_model.dart"), "File entities")
    create_file(os.path.join(models_dir, "device_model.dart"), "Device entities")
    create_file(os.path.join(models_dir, "transfer_model.dart"), "Transfer entities")

    # core/utils
    utils_dir = os.path.join(core_dir, "utils")
    os.makedirs(utils_dir, exist_ok=True)
    create_file(os.path.join(utils_dir, "extensions.dart"), "Dart extensions")
    create_file(os.path.join(utils_dir, "helpers.dart"), "Helper functions")
    create_file(os.path.join(utils_dir, "validators.dart"), "Input validation")

    # features directory
    features_dir = os.path.join(base_dir, "features")

    # features/home
    home_dir = os.path.join(features_dir, "home")
    os.makedirs(os.path.join(home_dir, "bloc"), exist_ok=True)
    os.makedirs(os.path.join(home_dir, "pages"), exist_ok=True)
    os.makedirs(os.path.join(home_dir, "widgets"), exist_ok=True)
    create_file(os.path.join(home_dir, "bloc", "home_bloc.dart"), "Home BLoC")
    create_file(os.path.join(home_dir, "bloc", "home_event.dart"), "Home events")
    create_file(os.path.join(home_dir, "bloc", "home_state.dart"), "Home states")
    create_file(os.path.join(home_dir, "pages", "home_page.dart"), "Home page")
    create_file(os.path.join(home_dir, "widgets", "stats_card.dart"), "Stats card widget")
    create_file(os.path.join(home_dir, "widgets", "quick_actions.dart"), "Quick actions widget")
    create_file(os.path.join(home_dir, "widgets", "recent_transfers.dart"), "Recent transfers widget")

    # features/file_browser
    file_browser_dir = os.path.join(features_dir, "file_browser")
    os.makedirs(os.path.join(file_browser_dir, "bloc"), exist_ok=True)
    os.makedirs(os.path.join(file_browser_dir, "pages"), exist_ok=True)
    os.makedirs(os.path.join(file_browser_dir, "widgets"), exist_ok=True)
    create_file(os.path.join(file_browser_dir, "bloc", "file_browser_bloc.dart"), "File browser BLoC")
    create_file(os.path.join(file_browser_dir, "bloc", "file_browser_event.dart"), "File browser events")
    create_file(os.path.join(file_browser_dir, "bloc", "file_browser_state.dart"), "File browser states")
    create_file(os.path.join(file_browser_dir, "pages", "file_browser_page.dart"), "File browser page")
    create_file(os.path.join(file_browser_dir, "widgets", "file_grid.dart"), "File grid widget")
    create_file(os.path.join(file_browser_dir, "widgets", "file_card.dart"), "File card widget")
    create_file(os.path.join(file_browser_dir, "widgets", "file_type_tabs.dart"), "File type tabs widget")

    # features/transfer
    transfer_dir = os.path.join(features_dir, "transfer")
    os.makedirs(os.path.join(transfer_dir, "bloc"), exist_ok=True)
    os.makedirs(os.path.join(transfer_dir, "pages"), exist_ok=True)
    os.makedirs(os.path.join(transfer_dir, "widgets"), exist_ok=True)
    create_file(os.path.join(transfer_dir, "bloc", "transfer_bloc.dart"), "Transfer BLoC")
    create_file(os.path.join(transfer_dir, "bloc", "transfer_event.dart"), "Transfer events")
    create_file(os.path.join(transfer_dir, "bloc", "transfer_state.dart"), "Transfer states")
    create_file(os.path.join(transfer_dir, "pages", "send_page.dart"), "Send page")
    create_file(os.path.join(transfer_dir, "pages", "receive_page.dart"), "Receive page")
    create_file(os.path.join(transfer_dir, "pages", "transfer_progress_page.dart"), "Transfer progress page")
    create_file(os.path.join(transfer_dir, "widgets", "device_list.dart"), "Device list widget")
    create_file(os.path.join(transfer_dir, "widgets", "device_card.dart"), "Device card widget")
    create_file(os.path.join(transfer_dir, "widgets", "transfer_progress.dart"), "Transfer progress widget")
    create_file(os.path.join(transfer_dir, "widgets", "qr_code_widget.dart"), "QR code widget")

    # features/connection
    connection_dir = os.path.join(features_dir, "connection")
    os.makedirs(os.path.join(connection_dir, "bloc"), exist_ok=True)
    os.makedirs(os.path.join(connection_dir, "pages"), exist_ok=True)
    os.makedirs(os.path.join(connection_dir, "widgets"), exist_ok=True)
    create_file(os.path.join(connection_dir, "bloc", "connection_bloc.dart"), "Connection BLoC")
    create_file(os.path.join(connection_dir, "bloc", "connection_event.dart"), "Connection events")
    create_file(os.path.join(connection_dir, "bloc", "connection_state.dart"), "Connection states")
    create_file(os.path.join(connection_dir, "pages", "connection_page.dart"), "Connection page")
    create_file(os.path.join(connection_dir, "widgets", "connection_methods.dart"), "Connection methods widget")
    create_file(os.path.join(connection_dir, "widgets", "network_info.dart"), "Network info widget")
    create_file(os.path.join(connection_dir, "widgets", "speed_test.dart"), "Speed test widget")

    # features/history
    history_dir = os.path.join(features_dir, "history")
    os.makedirs(os.path.join(history_dir, "bloc"), exist_ok=True)
    os.makedirs(os.path.join(history_dir, "pages"), exist_ok=True)
    os.makedirs(os.path.join(history_dir, "widgets"), exist_ok=True)
    create_file(os.path.join(history_dir, "bloc", "history_bloc.dart"), "History BLoC")
    create_file(os.path.join(history_dir, "bloc", "history_event.dart"), "History events")
    create_file(os.path.join(history_dir, "bloc", "history_state.dart"), "History states")
    create_file(os.path.join(history_dir, "pages", "history_page.dart"), "History page")
    create_file(os.path.join(history_dir, "widgets", "history_list.dart"), "History list widget")
    create_file(os.path.join(history_dir, "widgets", "history_card.dart"), "History card widget")
    create_file(os.path.join(history_dir, "widgets", "history_filters.dart"), "History filters widget")

    # features/settings
    settings_dir = os.path.join(features_dir, "settings")
    os.makedirs(os.path.join(settings_dir, "bloc"), exist_ok=True)
    os.makedirs(os.path.join(settings_dir, "pages"), exist_ok=True)
    os.makedirs(os.path.join(settings_dir, "widgets"), exist_ok=True)
    create_file(os.path.join(settings_dir, "bloc", "settings_bloc.dart"), "Settings BLoC")
    create_file(os.path.join(settings_dir, "bloc", "settings_event.dart"), "Settings events")
    create_file(os.path.join(settings_dir, "bloc", "settings_state.dart"), "Settings states")
    create_file(os.path.join(settings_dir, "pages", "settings_page.dart"), "Settings page")
    create_file(os.path.join(settings_dir, "pages", "about_page.dart"), "About page")
    create_file(os.path.join(settings_dir, "widgets", "settings_group.dart"), "Settings group widget")
    create_file(os.path.join(settings_dir, "widgets", "settings_tile.dart"), "Settings tile widget")
    create_file(os.path.join(settings_dir, "widgets", "theme_selector.dart"), "Theme selector widget")

    # shared directory
    shared_dir = os.path.join(base_dir, "shared")

    # shared/widgets
    shared_widgets_dir = os.path.join(shared_dir, "widgets")
    os.makedirs(shared_widgets_dir, exist_ok=True)
    create_file(os.path.join(shared_widgets_dir, "app_button.dart"), "Custom button widget")
    create_file(os.path.join(shared_widgets_dir, "app_card.dart"), "Custom card widget")
    create_file(os.path.join(shared_widgets_dir, "app_progress.dart"), "Progress indicators")
    create_file(os.path.join(shared_widgets_dir, "loading_widget.dart"), "Loading states widget")
    create_file(os.path.join(shared_widgets_dir, "error_widget.dart"), "Error states widget")
    create_file(os.path.join(shared_widgets_dir, "empty_widget.dart"), "Empty states widget")

    # shared/constants
    shared_constants_dir = os.path.join(shared_dir, "constants")
    os.makedirs(shared_constants_dir, exist_ok=True)
    create_file(os.path.join(shared_constants_dir, "colors.dart"), "App colors")
    create_file(os.path.join(shared_constants_dir, "typography.dart"), "Text styles")
    create_file(os.path.join(shared_constants_dir, "spacing.dart"), "Spacing values")
    create_file(os.path.join(shared_constants_dir, "borders.dart"), "Border radius")

    # shared/utils
    shared_utils_dir = os.path.join(shared_dir, "utils")
    os.makedirs(shared_utils_dir, exist_ok=True)
    create_file(os.path.join(shared_utils_dir, "format_utils.dart"), "Text formatting utilities")
    create_file(os.path.join(shared_utils_dir, "file_utils.dart"), "File utilities")
    create_file(os.path.join(shared_utils_dir, "permission_utils.dart"), "Permission helpers")

if __name__ == "__main__":
    create_folder_structure()
    print("Folder structure and Dart files created successfully!")