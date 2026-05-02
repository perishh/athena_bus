import 'package:athena_bus/generated/material_community_icons.dart';
import 'package:athena_bus/providers/arrivals_provider.dart';
import 'package:athena_bus/sheets/arrivals/widgets/arrivals_list.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:athena_bus/providers/stops_provider.dart';
import 'package:athena_bus/widgets/blurred_container.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ArrivalsBottomSheet extends HookConsumerWidget {
  const ArrivalsBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useDraggableScrollableController();
    final stop = ref.watch(selectedStopProvider);

    if (stop == null) {
      return const SizedBox.shrink();
    }

    final state = ref.watch(arrivalsProvider(stop.id));

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        return true;
      },
      child: DraggableScrollableSheet(
        controller: controller,
        initialChildSize: 0.3,
        minChildSize: 0.1,
        maxChildSize: 0.8,
        snap: true,
        snapSizes: [0.1, 0.3, 0.5, 0.8],
        builder: (context, scrollController) => BlurredContainer(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          width: double.infinity,
          padding: const EdgeInsets.only(top: 16),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    spacing: 16,
                    children: [
                      const Icon(MaterialCommunityIcons.bus_stop, size: 32),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stop.desc,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                height: 1.1,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (stop.street != null)
                              Text('επί της ${stop.street!}'),
                          ],
                        ),
                      ),
                      BlurredContainer(
                        color: Colors.white54,
                        padding: const EdgeInsets.all(8),
                        borderRadius: BorderRadius.circular(999),
                        child: Icon(MaterialCommunityIcons.close),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                state.when(
                  data: (state) => Column(
                    children: [
                      SizedBox(
                        height: 32,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.lines.length,
                          itemBuilder: (context, index) {
                            return BlurredContainer(
                              key: ValueKey(state.lines.elementAt(index)),
                              margin: EdgeInsets.only(
                                right: 8,
                                left: index == 0 ? 16 : 0,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white54,
                              child: Center(
                                child: Text(
                                  state.lines.elementAt(index),
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        margin: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Expanded(child: Text("Τελευταία ενημέρωση")),
                            state.loading
                                ? SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(),
                                  )
                                : Text(
                                    DateFormat(
                                      "HH:mm",
                                    ).format(state.lastFetched),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      ArrivalsList(
                        routes: state.routes,
                        arrivals: state.arrivals,
                      ),
                    ],
                  ),
                  error: (e, st) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Column(
                        spacing: 12,
                        children: [
                          const Icon(
                            MaterialCommunityIcons.alert_circle_outline,
                            size: 40,
                            color: Colors.black54,
                          ),
                          Text(
                            'Σφάλμα φόρτωσης αφίξεων\n$e\n$st',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          FilledButton.tonalIcon(
                            onPressed: () =>
                                ref.invalidate(arrivalsProvider(stop.id)),
                            icon: const Icon(
                              MaterialCommunityIcons.refresh,
                              size: 18,
                            ),
                            label: const Text('Επανάληψη'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  loading: () => const LinearProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
