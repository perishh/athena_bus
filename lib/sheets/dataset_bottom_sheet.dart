import 'package:athena_bus/generated/material_community_icons.dart';
import 'package:athena_bus/providers/backdrop_key_provider.dart';
import 'package:athena_bus/widgets/blur_icon_button.dart';
import 'package:athena_bus/widgets/blurred_container.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DatasetBottomSheet extends HookConsumerWidget {
  const DatasetBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backdropKey = ref.watch(backdropKeyProvider);
    final bottom = MediaQuery.paddingOf(context).bottom;

    return BlurredContainer(
      backdropKey: backdropKey,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: Row(
              spacing: 24,
              children: [
                Icon(MaterialCommunityIcons.database, size: 32),
                Text(
                  "Δεδομένα",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              spacing: 16,
              children: [
                BlurredContainer(
                  backdropKey: backdropKey,
                  color: Colors.white.withAlpha(35),
                  padding: EdgeInsets.all(8),
                  borderRadius: BorderRadius.circular(999),
                  child: Icon(MaterialCommunityIcons.bus_stop, size: 32),
                ),
                Expanded(
                  child: Text(
                    "Στάσεις",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                BlurIconButton(
                  icon: MaterialCommunityIcons.cloud_download_outline,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          SizedBox(height: bottom),
        ],
      ),
    );
  }
}
