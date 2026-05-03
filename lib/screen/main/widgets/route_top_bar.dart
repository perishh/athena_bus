import 'package:athena_bus/generated/material_community_icons.dart';
import 'package:athena_bus/hooks/use_bottom_sheet_navigation.dart';
import 'package:athena_bus/providers/bottom_sheet_navigation_provider.dart';
import 'package:athena_bus/providers/selected_route_provider.dart';
import 'package:athena_bus/widgets/blurred_container.dart';
import 'package:athena_bus/widgets/marquee_plus.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RouteTopBar extends HookConsumerWidget {
  const RouteTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedRouteProvider);
    final navigation = useBottomSheetNavigation(ref);

    if (selected == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 0,
      left: 8,
      right: 8,
      child: SafeArea(
        child: BlurredContainer(
          borderRadius: BorderRadius.circular(16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: const EdgeInsets.only(top: 8),
          child: Row(
            spacing: 8,
            children: [
              BlurredContainer(
                color: Colors.white54,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                borderRadius: BorderRadius.circular(8),
                child: Text(
                  selected.$2,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 20,
                  child: MarqueePlus(
                    text: selected.$1.desc,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              BlurredContainer(
                color: Colors.white54,
                padding: const EdgeInsets.all(6),
                borderRadius: BorderRadius.circular(999),
                onTap: () =>
                    navigation.pushOrReplace(SchedulePage(selected.$1.lineId)),
                child: const Icon(
                  MaterialCommunityIcons.calendar_clock,
                  size: 18,
                ),
              ),
              BlurredContainer(
                color: Colors.white54,
                padding: const EdgeInsets.all(6),
                borderRadius: BorderRadius.circular(999),
                onTap: () {
                  ref.read(selectedRouteProvider.notifier).deselect();
                },
                child: const Icon(
                  MaterialCommunityIcons.close,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
