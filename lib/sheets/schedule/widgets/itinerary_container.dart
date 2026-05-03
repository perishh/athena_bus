import 'package:athena_bus/generated/material_community_icons.dart';
import 'package:athena_bus/models/line.dart';
import 'package:athena_bus/providers/schedule_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'error_container.dart';
import 'itinerary_list.dart';

class ItineraryContainer extends HookConsumerWidget {
  final Line line;
  final int masterLineId;
  final String scheduleCode;

  const ItineraryContainer({
    super.key,
    required this.line,
    required this.masterLineId,
    required this.scheduleCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itinerary = ref.watch(
      scheduleItineraryProvider(
        masterLineId: masterLineId,
        lineId: line.id,
        scheduleCode: scheduleCode,
      ),
    );

    return itinerary.when(
      data: (schedule) {
        if (schedule.come.isEmpty && schedule.go.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              spacing: 8,
              children: [
                const Icon(
                  MaterialCommunityIcons.calendar_blank_outline,
                  size: 40,
                  color: Colors.black38,
                ),
                Text(
                  'Δεν υπάρχουν δρομολόγια',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          );
        }

        return Row(
          children: [
            Expanded(
              child: ItineraryList(
                key: ValueKey('come_${masterLineId}_$scheduleCode'),
                icon: MaterialCommunityIcons.arrow_right_bold,
                title: 'ΑΠΟ',
                times: schedule.come,
              ),
            ),
            Expanded(
              child: ItineraryList(
                key: ValueKey('go_${masterLineId}_$scheduleCode'),
                icon: MaterialCommunityIcons.arrow_left_bold,
                title: 'ΠΡΟΣ',
                times: schedule.go,
              ),
            ),
          ],
        );
      },
      error: (e, st) => ErrorContainer(
        message: 'Σφάλμα φόρτωσης δρομολογίων',
        onRetry: () => ref.invalidate(
          scheduleItineraryProvider(
            masterLineId: masterLineId,
            lineId: line.id,
            scheduleCode: scheduleCode,
          ),
        ),
      ),
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
