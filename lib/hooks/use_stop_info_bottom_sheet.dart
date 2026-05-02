import 'package:athena_bus/providers/stops_provider.dart';
import 'package:athena_bus/sheets/stop_info_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void useStopInfoBottomSheet(
  WidgetRef ref,
  GlobalKey<ScaffoldState> scaffoldKey,
) {
  final selectedStop = ref.watch(selectedStopProvider);

  useEffect(() {
    if (selectedStop != null) {
      scaffoldKey.currentState
          ?.showBottomSheet((_) => const StopInfoBottomSheet())
          .closed
          .then((_) {
            Future.delayed(const Duration(milliseconds: 300), () {
              ref.read(selectedStopProvider.notifier).deselect();
            });
          });
    }
    return null;
  }, [selectedStop != null]);
}
