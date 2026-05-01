import 'package:athena_bus/generated/material_community_icons.dart';
import 'package:athena_bus/providers/backdrop_key_provider.dart';
import 'package:athena_bus/providers/dataset_manager_provider.dart';
import 'package:athena_bus/widgets/blur_icon_button.dart';
import 'package:athena_bus/widgets/blurred_container.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DatasetBottomSheet extends HookConsumerWidget {
  const DatasetBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backdropKey = ref.watch(backdropKeyProvider);
    final datasetManager = ref.watch(datasetManagerProvider);
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
          datasetManager.when(
            data: (manager) => Container(
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  manager.stopsStatus == DatasetStatus.downloading
                      ? Container(
                          margin: EdgeInsets.only(right: 8),
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(),
                        )
                      : BlurIconButton(
                          icon:
                              manager.stopsStatus == DatasetStatus.notDownloaded
                              ? MaterialCommunityIcons.cloud_download_outline
                              : manager.stopsStatus == DatasetStatus.downloaded
                              ? MaterialCommunityIcons.check
                              : MaterialCommunityIcons.alert_octagon,
                          onPressed:
                              manager.stopsStatus ==
                                      DatasetStatus.notDownloaded ||
                                  manager.stopsStatus == DatasetStatus.error
                              ? () => ref
                                    .read(datasetManagerProvider.notifier)
                                    .downloadStops()
                              : null,
                        ),
                ],
              ),
            ),
            loading: () => LinearProgressIndicator(),
            error: (e, _) => Text("Σφάλμα: $e"),
          ),
          SizedBox(height: bottom),
        ],
      ),
    );
  }
}
