import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../animations/loading_states.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/borders.dart';
import '../../../constants/file_types.dart';
import '../molecules/file_card.dart';

enum FileGridLayout { grid, list, compact }

enum FileGridState { loading, loaded, empty, error }

class FileGridInfo {
  const FileGridInfo({
    required this.id,
    required this.name,
    required this.size,
    required this.type,
    this.path,
    this.dateModified,
    this.thumbnail,
    this.isSelected = false,
  });

  final String id;
  final String name;
  final String size;
  final FileType type;
  final String? path;
  final DateTime? dateModified;
  final ImageProvider? thumbnail;
  final bool isSelected;

  FileGridInfo copyWith({
    String? id,
    String? name,
    String? size,
    FileType? type,
    String? path,
    DateTime? dateModified,
    ImageProvider? thumbnail,
    bool? isSelected,
  }) {
    return FileGridInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      size: size ?? this.size,
      type: type ?? this.type,
      path: path ?? this.path,
      dateModified: dateModified ?? this.dateModified,
      thumbnail: thumbnail ?? this.thumbnail,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class FileGrid extends StatelessWidget {
  const FileGrid({
    super.key,
    required this.files,
    required this.state,
    this.layout = FileGridLayout.grid,
    this.selectionMode = false,
    this.onFileSelected,
    this.onFileLongPress,
    this.onSelectionChanged,
    this.onRefresh,
    this.onRetry,
    this.emptyTitle = 'No files found',
    this.emptyMessage = 'This folder is empty',
    this.errorMessage = 'Failed to load files',
    this.crossAxisCount,
    this.childAspectRatio,
  });

  final List<FileGridInfo> files;
  final FileGridState state;
  final FileGridLayout layout;
  final bool selectionMode;
  final Function(FileGridInfo)? onFileSelected;
  final Function(FileGridInfo)? onFileLongPress;
  final Function(List<FileGridInfo>)? onSelectionChanged;
  final VoidCallback? onRefresh;
  final VoidCallback? onRetry;
  final String emptyTitle;
  final String emptyMessage;
  final String errorMessage;
  final int? crossAxisCount;
  final double? childAspectRatio;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case FileGridState.loading:
        return _buildLoadingState();
      case FileGridState.loaded:
        return _buildFileGrid(context);
      case FileGridState.empty:
        return _buildEmptyState();
      case FileGridState.error:
        return _buildErrorState();
    }
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoadingSpinner(
            size: 32,
            color: AppColors.primary500,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Loading files...',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileGrid(BuildContext context) {
    if (files.isEmpty) {
      return _buildEmptyState();
    }

    switch (layout) {
      case FileGridLayout.list:
        return _buildListView();
      case FileGridLayout.compact:
        return _buildCompactGrid(context);
      case FileGridLayout.grid:
      default:
        return _buildGridView(context);
    }
  }

  Widget _buildGridView(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final defaultCrossAxisCount = screenWidth > 600 ? 4 : 2;
    final actualCrossAxisCount = crossAxisCount ?? defaultCrossAxisCount;

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: actualCrossAxisCount,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: childAspectRatio ?? 0.85,
      ),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        return FileCard(
          fileName: file.name,
          fileSize: file.size,
          fileType: file.type,
          variant: FileCardVariant.grid,
          thumbnail: file.thumbnail,
          dateModified: file.dateModified,
          isSelected: file.isSelected,
          selectionMode: selectionMode,
          onTap: () => _handleFileSelection(file),
          onLongPress: () => onFileLongPress?.call(file),
          onSelectChanged: (selected) => _handleSelectionToggle(file, selected),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        return FileCard(
          fileName: file.name,
          fileSize: file.size,
          fileType: file.type,
          variant: FileCardVariant.list,
          dateModified: file.dateModified,
          isSelected: file.isSelected,
          selectionMode: selectionMode,
          onTap: () => _handleFileSelection(file),
          onLongPress: () => onFileLongPress?.call(file),
          onSelectChanged: (selected) => _handleSelectionToggle(file, selected),
        );
      },
    );
  }

  Widget _buildCompactGrid(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final defaultCrossAxisCount = screenWidth > 600 ? 6 : 3;
    final actualCrossAxisCount = crossAxisCount ?? defaultCrossAxisCount;

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.sm),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: actualCrossAxisCount,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: childAspectRatio ?? 1.2,
      ),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        return FileCard(
          fileName: file.name,
          fileSize: file.size,
          fileType: file.type,
          variant: FileCardVariant.compact,
          isSelected: file.isSelected,
          selectionMode: selectionMode,
          onTap: () => _handleFileSelection(file),
          onSelectChanged: (selected) => _handleSelectionToggle(file, selected),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: AppBorders.roundedLg,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.folder,
                size: 32,
                color: AppColors.neutral400,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            emptyTitle,
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              emptyMessage,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (onRefresh != null) ...[
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const FaIcon(FontAwesomeIcons.arrowsRotate, size: 16),
              label: const Text('Refresh'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.error100,
              borderRadius: AppBorders.roundedLg,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.triangleExclamation,
                size: 32,
                color: AppColors.error500,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Failed to Load Files',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              errorMessage,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const FaIcon(FontAwesomeIcons.arrowsRotate, size: 16),
              label: const Text('Try Again'),
            ),
          ],
        ],
      ),
    );
  }

  void _handleFileSelection(FileGridInfo file) {
    if (selectionMode) {
      _handleSelectionToggle(file, !file.isSelected);
    } else {
      onFileSelected?.call(file);
    }
  }

  void _handleSelectionToggle(FileGridInfo file, bool selected) {
    final updatedFiles = files.map((f) {
      if (f.id == file.id) {
        return f.copyWith(isSelected: selected);
      }
      return f;
    }).toList();

    onSelectionChanged?.call(updatedFiles);
  }
}

/// File grid with selection summary
class FileGridWithSelection extends StatelessWidget {
  const FileGridWithSelection({
    super.key,
    required this.files,
    required this.state,
    required this.selectedFiles,
    this.layout = FileGridLayout.grid,
    this.onFileSelected,
    this.onSelectionChanged,
    this.onSelectAll,
    this.onClearSelection,
    this.onRefresh,
    this.onRetry,
  });

  final List<FileGridInfo> files;
  final FileGridState state;
  final List<FileGridInfo> selectedFiles;
  final FileGridLayout layout;
  final Function(FileGridInfo)? onFileSelected;
  final Function(List<FileGridInfo>)? onSelectionChanged;
  final VoidCallback? onSelectAll;
  final VoidCallback? onClearSelection;
  final VoidCallback? onRefresh;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedFiles.isNotEmpty;
    final allSelected =
        selectedFiles.length == files.length && files.isNotEmpty;

    return Column(
      children: [
        // Selection bar
        if (hasSelection)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.primary50,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primary200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '${selectedFiles.length} selected',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary700,
                  ),
                ),
                const Spacer(),
                if (!allSelected && onSelectAll != null)
                  GestureDetector(
                    onTap: onSelectAll,
                    child: Text(
                      'Select All',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primary600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                if (hasSelection && onClearSelection != null) ...[
                  if (!allSelected) const SizedBox(width: AppSpacing.md),
                  GestureDetector(
                    onTap: onClearSelection,
                    child: Text(
                      'Clear',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primary600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

        // File grid
        Expanded(
          child: FileGrid(
            files: files,
            state: state,
            layout: layout,
            selectionMode: true,
            onFileSelected: onFileSelected,
            onSelectionChanged: onSelectionChanged,
            onRefresh: onRefresh,
            onRetry: onRetry,
          ),
        ),
      ],
    );
  }
}

/// File grid presets
class FileGridPresets {
  FileGridPresets._();

  /// Standard file browser grid
  static Widget browser({
    required List<FileGridInfo> files,
    required FileGridState state,
    Function(FileGridInfo)? onFileSelected,
    VoidCallback? onRefresh,
    FileGridLayout layout = FileGridLayout.grid,
  }) {
    return FileGrid(
      files: files,
      state: state,
      layout: layout,
      onFileSelected: onFileSelected,
      onRefresh: onRefresh,
    );
  }

  /// File selection grid with multi-select
  static Widget selection({
    required List<FileGridInfo> files,
    required FileGridState state,
    required List<FileGridInfo> selectedFiles,
    Function(List<FileGridInfo>)? onSelectionChanged,
    VoidCallback? onSelectAll,
    VoidCallback? onClearSelection,
    FileGridLayout layout = FileGridLayout.grid,
  }) {
    return FileGridWithSelection(
      files: files,
      state: state,
      selectedFiles: selectedFiles,
      layout: layout,
      onSelectionChanged: onSelectionChanged,
      onSelectAll: onSelectAll,
      onClearSelection: onClearSelection,
    );
  }

  /// Recent files grid
  static Widget recent({
    required List<FileGridInfo> files,
    required FileGridState state,
    Function(FileGridInfo)? onFileSelected,
    VoidCallback? onRefresh,
  }) {
    return FileGrid(
      files: files,
      state: state,
      layout: FileGridLayout.list,
      onFileSelected: onFileSelected,
      onRefresh: onRefresh,
      emptyTitle: 'No recent files',
      emptyMessage: 'Files you access will appear here',
    );
  }

  /// Image gallery grid
  static Widget gallery({
    required List<FileGridInfo> files,
    required FileGridState state,
    Function(FileGridInfo)? onFileSelected,
    VoidCallback? onRefresh,
  }) {
    final imageFiles = files.where((f) => f.type == FileType.image).toList();

    return FileGrid(
      files: imageFiles,
      state: state,
      layout: FileGridLayout.grid,
      onFileSelected: onFileSelected,
      onRefresh: onRefresh,
      crossAxisCount: 3,
      childAspectRatio: 1.0,
      emptyTitle: 'No images found',
      emptyMessage: 'Take some photos to see them here',
    );
  }
}
