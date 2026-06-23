import 'package:flutter/material.dart';
import 'package:c_editor/data/repository/zombie_repository.dart';
import 'package:c_editor/l10n/resource_names.dart';
import 'package:c_editor/screens/select/zombie_selection_screen.dart';
import 'package:c_editor/widgets/asset_image.dart';

const _kUnknownZombieIcon = 'assets/images/others/unknown.webp';

/// Single zombie-type picker row for custom stage properties.
class StageZombieTypePickerRow extends StatelessWidget {
  const StageZombieTypePickerRow({
    super.key,
    required this.fieldLabel,
    required this.zombieId,
    required this.onChanged,
  });

  final String fieldLabel;
  final String? zombieId;
  final ValueChanged<String> onChanged;

  Future<void> _pickZombie(BuildContext context) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (ctx) => ZombieSelectionScreen(
          onZombieSelected: (id) {
            Navigator.pop(ctx);
            onChanged(id);
          },
          onBack: () => Navigator.pop(ctx),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = ZombieRepository();
    final id = zombieId;
    final info = id == null || id.isEmpty ? null : repo.getZombieById(id);
    final nameKey = id == null || id.isEmpty ? null : repo.getName(id);
    final localized = nameKey == null
        ? null
        : ResourceNames.lookup(context, nameKey);
    final displayName = (localized != null &&
            localized.isNotEmpty &&
            localized != nameKey)
        ? localized
        : (id ?? '—');
    final iconPath = info?.iconAssetPath ?? _kUnknownZombieIcon;

    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => _pickZombie(context),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                fieldLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: AssetImageWidget(
                      assetPath: iconPath,
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                      altCandidates: imageAltCandidates(iconPath),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (id != null && id.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            id,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
