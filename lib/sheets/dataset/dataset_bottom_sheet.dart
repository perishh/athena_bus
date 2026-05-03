import 'package:athena_bus/generated/material_community_icons.dart';
import 'package:athena_bus/hooks/use_bottom_sheet_navigation.dart';
import 'package:athena_bus/models/dataset.dart';
import 'package:athena_bus/providers/dataset_manager_provider.dart';
import 'package:athena_bus/widgets/blurred_container.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DatasetBottomSheet extends HookConsumerWidget {
  const DatasetBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final datasetManager = ref.watch(datasetManagerProvider);
    final navigation = useBottomSheetNavigation(ref);
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            spacing: 24,
            children: [
              Icon(MaterialCommunityIcons.database, size: 32),
              Expanded(
                child: Text(
                  "Δεδομένα",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              BlurredContainer(
                color: Colors.white54,
                padding: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(999),
                child: Icon(MaterialCommunityIcons.close),
                onTap: () {
                  navigation.pop();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        datasetManager.when(
          data: (state) => Column(
            spacing: 12,
            children: Dataset.values.map((dataset) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  spacing: 16,
                  children: [
                    BlurredContainer(
                      color: Colors.white.withAlpha(35),
                      padding: EdgeInsets.all(8),
                      borderRadius: BorderRadius.circular(999),
                      child: Icon(dataset.icon, size: 24),
                    ),
                    Expanded(
                      child: Text(
                        dataset.displayName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    state[dataset] == DatasetStatus.downloading
                        ? Container(
                            margin: EdgeInsets.only(right: 8),
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(),
                          )
                        : BlurredContainer(
                            padding: EdgeInsets.all(8),
                            borderRadius: BorderRadius.circular(999),
                            color: Colors.white38,
                            onTap:
                                state[dataset] == DatasetStatus.notDownloaded ||
                                    state[dataset] == DatasetStatus.error
                                ? () => ref
                                      .read(datasetManagerProvider.notifier)
                                      .download(dataset)
                                : null,
                            child: Icon(
                              state[dataset] == DatasetStatus.notDownloaded
                                  ? MaterialCommunityIcons
                                        .cloud_download_outline
                                  : state[dataset] == DatasetStatus.downloaded
                                  ? MaterialCommunityIcons.check
                                  : MaterialCommunityIcons.alert_octagon,
                            ),
                          ),
                  ],
                ),
              );
            }).toList(),
          ),
          loading: () => LinearProgressIndicator(),
          error: (e, _) => Text("Σφάλμα: $e"),
        ),
        SizedBox(height: bottom),
      ],
    );
  }
}
