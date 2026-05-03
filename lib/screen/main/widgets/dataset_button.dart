import 'package:athena_bus/generated/material_community_icons.dart';
import 'package:athena_bus/hooks/use_bottom_sheet_navigation.dart';
import 'package:athena_bus/providers/bottom_sheet_navigation_provider.dart';
import 'package:athena_bus/widgets/blurred_container.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DatasetButton extends HookConsumerWidget {
  const DatasetButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = useBottomSheetNavigation(ref);

    return Positioned(
      right: 16,
      top: 16,
      child: SafeArea(
        child: BlurredContainer(
          padding: EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(999),
          child: Icon(MaterialCommunityIcons.database_outline),
          onTap: () => navigation.push(DatasetPage(), isModal: true),
        ),
      ),
    );
  }
}
