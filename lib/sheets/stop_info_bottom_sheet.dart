import 'package:athena_bus/generated/material_community_icons.dart';
import 'package:athena_bus/providers/backdrop_key_provider.dart';
import 'package:athena_bus/providers/stops_provider.dart';
import 'package:athena_bus/widgets/blur_icon_button.dart';
import 'package:athena_bus/widgets/blurred_container.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StopInfoBottomSheet extends HookConsumerWidget {
  const StopInfoBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stop = ref.watch(selectedStopProvider);
    final backdropKey = ref.watch(backdropKeyProvider);
    final bottom = View.of(context).padding.bottom;

    if (stop == null) {
      return const SizedBox.shrink();
    }

    return BlurredContainer(
      backdropKey: backdropKey,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            spacing: 16,
            children: [
              const Icon(MaterialCommunityIcons.bus_stop, size: 32),
              Expanded(
                child: Text(
                  stop.desc,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              BlurIconButton(
                icon: MaterialCommunityIcons.close,
                size: 20,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Info rows
          _InfoRow(
            icon: MaterialCommunityIcons.identifier,
            label: "Κωδικός",
            value: stop.code,
          ),
          if (stop.street != null && stop.street!.isNotEmpty)
            _InfoRow(
              icon: MaterialCommunityIcons.road_variant,
              label: "Οδός",
              value: stop.street!,
            ),
          if (stop.descEn != null && stop.descEn!.isNotEmpty)
            _InfoRow(
              icon: MaterialCommunityIcons.translate,
              label: "Αγγλική ονομασία",
              value: stop.descEn!,
            ),
          _InfoRow(
            icon: MaterialCommunityIcons.wheelchair_accessibility,
            label: "Προσβάσιμο",
            value: stop.amea ? "Ναι" : "Όχι",
          ),

          SizedBox(height: bottom),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        spacing: 12,
        children: [
          Icon(icon, size: 20, color: Colors.black54),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
