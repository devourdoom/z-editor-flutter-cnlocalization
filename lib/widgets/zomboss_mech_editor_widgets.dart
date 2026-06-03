import 'package:flutter/material.dart';
import 'package:c_editor/data/models/zomboss_mech_catalog.dart';
import 'package:c_editor/data/pvz_models/PvzLevelFile.dart';
import 'package:c_editor/data/zomboss_mech_action_utils.dart';
import 'package:c_editor/data/zomboss_mech_l10n.dart';
import 'package:c_editor/l10n/app_localizations.dart';
import 'package:c_editor/theme/app_theme.dart';

/// Accent for custom zomboss mech editor (matches boss / custom tooling).
Color zombossMechAccent(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? pvzPurpleDark : pvzPurpleLight;
}

Color zombossMechActionTagColor(String tag, BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return switch (tag) {
    'movement' => isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0),
    'attack' => isDark ? const Color(0xFFEF9A9A) : const Color(0xFFC62828),
    'spawn' => isDark ? const Color(0xFFA5D6A7) : const Color(0xFF2E7D32),
    'special' => isDark ? const Color(0xFFCE93D8) : const Color(0xFF6A1B9A),
    'retreat' => isDark ? const Color(0xFFB0BEC5) : const Color(0xFF546E7A),
    _ => isDark ? const Color(0xFF90A4AE) : const Color(0xFF455A64),
  };
}

TextStyle zombossMechActionTitleStyle(BuildContext context) {
  return Theme.of(context).textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        height: 1.25,
      );
}

/// Estimated row height for action list layout.
const double kZombossMechActionRowHeight = 62;

bool zombossMechUseImmediateDrag(BuildContext context) {
  switch (Theme.of(context).platform) {
    case TargetPlatform.windows:
    case TargetPlatform.macOS:
    case TargetPlatform.linux:
      return true;
    default:
      return false;
  }
}

/// Drag-and-drop action list for custom zomboss mech phase editors.
class ZombossMechReorderableActionList extends StatefulWidget {
  const ZombossMechReorderableActionList({
    super.key,
    required this.mechId,
    required this.catalog,
    required this.levelFile,
    required this.selectedActions,
    required this.keyPrefix,
    required this.onReorder,
    required this.onRemove,
    required this.onEditCustomAction,
  });

  final String mechId;
  final ZombossMechCatalogEntry catalog;
  final PvzLevelFile levelFile;
  final List<String> selectedActions;
  final String keyPrefix;
  final void Function(int fromIndex, int toIndex) onReorder;
  final void Function(int index) onRemove;
  final ValueChanged<String> onEditCustomAction;

  @override
  State<ZombossMechReorderableActionList> createState() =>
      _ZombossMechReorderableActionListState();
}

class _ZombossMechReorderableActionListState
    extends State<ZombossMechReorderableActionList> {
  Widget _buildDragHandle({
    required BuildContext context,
    required int index,
    required String tag,
    required String label,
    required Color accent,
    required double feedbackWidth,
  }) {
    final feedback = SizedBox(
      width: feedbackWidth,
      child: Material(
        color: Colors.transparent,
        elevation: 4,
        borderRadius: BorderRadius.circular(10),
        child: Opacity(
          opacity: 0.92,
          child: ZombossMechActionRow(
            label: label,
            tag: tag,
            onRemove: () {},
            showRemoveButton: false,
          ),
        ),
      ),
    );

    const handleSize = Size(48, ZombossMechActionRow.controlHeight);
    final placeholder = SizedBox.fromSize(size: handleSize);

    final handle = MouseRegion(
      cursor: SystemMouseCursors.grab,
      child: SizedBox.fromSize(
        size: handleSize,
        child: Center(
          child: Icon(
            Icons.drag_indicator,
            color: accent.withValues(alpha: 0.9),
            size: 28,
          ),
        ),
      ),
    );

    if (zombossMechUseImmediateDrag(context)) {
      return Draggable<int>(
        data: index,
        dragAnchorStrategy: pointerDragAnchorStrategy,
        feedback: feedback,
        childWhenDragging: placeholder,
        child: handle,
      );
    }

    return LongPressDraggable<int>(
      data: index,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: feedback,
      childWhenDragging: placeholder,
      child: handle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final rowWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(widget.selectedActions.length, (actionIndex) {
            final rtid = widget.selectedActions[actionIndex];
            final isCustom = ZombossMechActionUtils.isCustomRtid(rtid);
            final resolved = ZombossMechActionUtils.resolveAction(
              rtid: rtid,
              catalog: widget.catalog,
              levelFile: widget.levelFile,
            );
            final tag = resolved?.tag ?? '';
            final label = ZombossMechL10n.labelForStageRtid(
              context: context,
              mechId: widget.mechId,
              catalog: widget.catalog,
              levelFile: widget.levelFile,
              rtid: rtid,
            );
            final accent = zombossMechActionTagColor(tag, context);

            return DragTarget<int>(
              onWillAcceptWithDetails: (details) => details.data != actionIndex,
              onAcceptWithDetails: (details) =>
                  widget.onReorder(details.data, actionIndex),
              builder: (context, candidateData, rejectedData) {
                return ZombossMechActionListTile(
                  key: ValueKey('${widget.keyPrefix}-$actionIndex-$rtid'),
                  mechId: widget.mechId,
                  catalog: widget.catalog,
                  levelFile: widget.levelFile,
                  rtid: rtid,
                  tag: tag,
                  isDragTarget: candidateData.isNotEmpty,
                  dragHandle: _buildDragHandle(
                    context: context,
                    index: actionIndex,
                    tag: tag,
                    label: label,
                    accent: accent,
                    feedbackWidth: rowWidth,
                  ),
                  onEdit: isCustom
                      ? () => widget.onEditCustomAction(rtid)
                      : null,
                  onRemove: () => widget.onRemove(actionIndex),
                );
              },
            );
          }),
        );
      },
    );
  }
}

/// Action row for phase lists (drag handle + title + action buttons).
class ZombossMechActionListTile extends StatelessWidget {
  const ZombossMechActionListTile({
    super.key,
    required this.mechId,
    required this.catalog,
    required this.levelFile,
    required this.rtid,
    required this.tag,
    required this.onRemove,
    this.onEdit,
    this.dragHandle,
    this.isDragTarget = false,
  });

  final String mechId;
  final ZombossMechCatalogEntry catalog;
  final PvzLevelFile levelFile;
  final String rtid;
  final String tag;
  final VoidCallback onRemove;
  final VoidCallback? onEdit;
  final Widget? dragHandle;
  final bool isDragTarget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ZombossMechActionRow(
        label: ZombossMechL10n.labelForStageRtid(
          context: context,
          mechId: mechId,
          catalog: catalog,
          levelFile: levelFile,
          rtid: rtid,
        ),
        tag: tag,
        onRemove: onRemove,
        onEdit: onEdit,
        dragHandle: dragHandle,
        isDragTarget: isDragTarget,
      ),
    );
  }
}

/// Retreat action row: always shows the action + swap button (no delete).
class ZombossMechRetreatActionTile extends StatelessWidget {
  const ZombossMechRetreatActionTile({
    super.key,
    required this.mechId,
    required this.catalog,
    required this.levelFile,
    required this.rtid,
    required this.tag,
    required this.onSwap,
    this.onEdit,
  });

  final String mechId;
  final ZombossMechCatalogEntry catalog;
  final PvzLevelFile levelFile;
  final String rtid;
  final String tag;
  final VoidCallback onSwap;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ZombossMechActionRow(
      label: ZombossMechL10n.labelForStageRtid(
        context: context,
        mechId: mechId,
        catalog: catalog,
        levelFile: levelFile,
        rtid: rtid,
      ),
      tag: tag,
      onRemove: () {},
      onEdit: onEdit,
      showRemoveButton: false,
      trailing: IconButton(
        visualDensity: VisualDensity.compact,
        icon: const Icon(Icons.swap_horiz, size: 22),
        tooltip: l10n?.zombossMechEditRetreatAction ?? 'Choose retreat action',
        onPressed: onSwap,
      ),
    );
  }
}

/// Shared layout for action / retreat rows.
class ZombossMechActionRow extends StatelessWidget {
  const ZombossMechActionRow({
    super.key,
    required this.label,
    required this.tag,
    required this.onRemove,
    this.onEdit,
    this.dragHandle,
    this.isDragTarget = false,
    this.showRemoveButton = true,
    this.trailing,
    this.mutedLabel = false,
  });

  final String label;
  final String tag;
  final VoidCallback onRemove;
  final VoidCallback? onEdit;
  final Widget? dragHandle;
  final bool isDragTarget;
  final bool showRemoveButton;
  final Widget? trailing;
  final bool mutedLabel;

  static const controlHeight = 52.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = zombossMechActionTagColor(tag, context);
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: accent.withValues(alpha: isDragTarget ? 0.7 : 0.35),
          width: isDragTarget ? 2 : 1,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(10),
                ),
              ),
            ),
            ?dragHandle,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Text(
                  label,
                  style: mutedLabel
                      ? theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        )
                      : zombossMechActionTitleStyle(context),
                ),
              ),
            ),
            SizedBox(
              height: controlHeight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (onEdit != null)
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.edit_outlined, size: 22),
                      tooltip: l10n?.edit ?? 'Edit',
                      onPressed: onEdit,
                    ),
                  if (trailing != null)
                    Center(child: trailing)
                  else if (showRemoveButton)
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.close, size: 22),
                      tooltip: l10n?.remove ?? 'Remove',
                      onPressed: onRemove,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
