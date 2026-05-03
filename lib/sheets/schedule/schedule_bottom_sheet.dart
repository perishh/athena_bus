import 'package:athena_bus/hooks/use_bottom_sheet_navigation.dart';
import 'package:athena_bus/providers/bottom_sheet_navigation_provider.dart';
import 'package:athena_bus/providers/schedule_provider.dart';
import 'package:athena_bus/sheets/schedule/widgets/error_container.dart';
import 'package:athena_bus/sheets/schedule/widgets/header.dart';
import 'package:athena_bus/sheets/schedule/widgets/itinerary_container.dart';
import 'package:athena_bus/sheets/schedule/widgets/schedule_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScheduleBottomSheet extends HookConsumerWidget {
  const ScheduleBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = useBottomSheetNavigation(ref);
    final page = navigation.getCurrentPageAs<SchedulePage>();
    final lineId = page?.lineId;

    if (lineId == null) {
      return const SizedBox.shrink();
    }

    final lineSchedule = ref.watch(lineScheduleProvider(lineId));
    final selectedIndex = useState(0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        lineSchedule.when(
          data: (state) => Column(
            children: [
              Header(line: state.line),
              const SizedBox(height: 16),
              ScheduleTabs(
                days: state.days,
                selectedIndex: selectedIndex,
              ),
              const SizedBox(height: 12),
              ItineraryContainer(
                line: state.line,
                masterLineId: state.line.masterLineId,
                scheduleCode: state.days[selectedIndex.value].code,
              ),
            ],
          ),
          error: (e, st) => ErrorContainer(
            message: 'Σφάλμα φόρτωσης προγράμματος',
            onRetry: () => ref.invalidate(lineScheduleProvider(lineId)),
          ),
          loading: () => const LinearProgressIndicator(),
        ),
      ],
    );
  }
}
