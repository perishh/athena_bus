import 'package:athena_bus/generated/material_community_icons.dart';
import 'package:athena_bus/hooks/use_bottom_sheet_navigation.dart';
import 'package:athena_bus/providers/arrivals_provider.dart';
import 'package:athena_bus/providers/bottom_sheet_navigation_provider.dart';
import 'package:athena_bus/sheets/arrivals/widgets/arrivals_list.dart';
import 'package:intl/intl.dart';
import 'package:athena_bus/widgets/blurred_container.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ArrivalsBottomSheet extends HookConsumerWidget {
  const ArrivalsBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = useBottomSheetNavigation(ref);
    final stop = navigation.getCurrentPageAs<ArrivalsPage>()?.stop;

    if (stop == null) {
      return const SizedBox.shrink();
    }

    final state = ref.watch(arrivalsProvider(stop.id));

    return Column(
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
                    if (stop.street != null) Text('επί της ${stop.street!}'),
                  ],
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
                      key: ValueKey(
                        'arrival-${state.lines.elementAt(index)}',
                      ),
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
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    Row(
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
                    if (state.error)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 16,
                          children: [
                            Icon(MaterialCommunityIcons.alert_circle),
                            Text(
                              "Τα δεδομένα ενδέχεται να είναι ανακριβή.",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
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
                    onPressed: () => ref.invalidate(arrivalsProvider(stop.id)),
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
    );
  }
}
