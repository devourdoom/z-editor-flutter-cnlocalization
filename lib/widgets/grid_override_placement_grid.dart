import 'package:flutter/material.dart';
import 'package:c_editor/widgets/asset_image.dart';
import 'package:c_editor/widgets/editor_components.dart';

/// Interactive lawn grid for single-item-per-tile override modules.
class GridOverridePlacementGrid extends StatelessWidget {
  const GridOverridePlacementGrid({
    super.key,
    required this.gridRows,
    required this.gridCols,
    required this.selectedCol,
    required this.selectedRow,
    required this.onPrimaryTap,
    this.onRemoveAt,
    this.cellImageAt,
    this.cellImageScaleAt,
    this.maxWidth = 560,
  });

  final int gridRows;
  final int gridCols;
  final int selectedCol;
  final int selectedRow;
  final void Function(int col, int row) onPrimaryTap;
  final void Function(int col, int row)? onRemoveAt;
  final String? Function(int col, int row)? cellImageAt;

  /// Optional per-cell scale multiplier within the cell bounds (default 1).
  final double? Function(int col, int row)? cellImageScaleAt;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final useLongPress = _useLongPressForPlatform(context);

    return scaleTableForDesktop(
      context: context,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: AspectRatio(
          aspectRatio: gridCols / gridRows,
          child: Container(
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? const Color(0xFF31383B)
                  : const Color(0xFFD7ECF1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF6B899A)),
            ),
            child: Column(
              children: List.generate(gridRows, (row) {
                return Expanded(
                  child: Row(
                    children: List.generate(gridCols, (col) {
                      final isSelected =
                          col == selectedCol && row == selectedRow;
                      final imagePath = cellImageAt?.call(col, row);
                      final scale = cellImageScaleAt?.call(col, row) ?? 1.0;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => onPrimaryTap(col, row),
                          onLongPress: useLongPress && onRemoveAt != null
                              ? () => onRemoveAt!(col, row)
                              : null,
                          onSecondaryTap: !useLongPress && onRemoveAt != null
                              ? () => onRemoveAt!(col, row)
                              : null,
                          child: Container(
                            margin: const EdgeInsets.all(0.5),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.colorScheme.primary.withValues(
                                      alpha: 0.2,
                                    )
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : const Color(0xFF6B899A),
                                width: 0.5,
                              ),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: imagePath != null
                                ? LayoutBuilder(
                                    builder: (context, constraints) {
                                      final w = constraints.maxWidth * scale;
                                      final h = constraints.maxHeight * scale;
                                      return Align(
                                        alignment: Alignment.bottomCenter,
                                        child: SizedBox(
                                          width: w,
                                          height: h,
                                          child: AssetImageWidget(
                                            assetPath: imagePath,
                                            width: w,
                                            height: h,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : null,
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

bool _useLongPressForPlatform(BuildContext context) {
  return switch (Theme.of(context).platform) {
    TargetPlatform.iOS => true,
    TargetPlatform.android => true,
    _ => false,
  };
}
