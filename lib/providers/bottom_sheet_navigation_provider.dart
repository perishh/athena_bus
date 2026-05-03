import 'package:athena_bus/models/stop.dart';
import 'package:athena_bus/sheets/arrivals/arrivals_bottom_sheet.dart';
import 'package:athena_bus/sheets/dataset/dataset_bottom_sheet.dart';
import 'package:athena_bus/sheets/schedule/schedule_bottom_sheet.dart';
import 'package:flutter/widgets.dart' hide Route;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bottom_sheet_navigation_provider.g.dart';

abstract class BottomSheetPage {
  bool _isModal = false;

  BottomSheetPage();

  Widget build();
}

class ArrivalsPage extends BottomSheetPage {
  final Stop stop;

  ArrivalsPage(this.stop);

  @override
  Widget build() => ArrivalsBottomSheet();
}

class DatasetPage extends BottomSheetPage {
  @override
  Widget build() => const DatasetBottomSheet();
}

class SchedulePage extends BottomSheetPage {
  final int lineId;

  SchedulePage(this.lineId);

  @override
  Widget build() => const ScheduleBottomSheet();
}

@Riverpod(keepAlive: true)
class BottomSheetNavigation extends _$BottomSheetNavigation {
  @override
  List<BottomSheetPage> build() {
    return [];
  }

  void push(BottomSheetPage page, {bool isModal = false}) {
    page._isModal = isModal;

    final newState = [...state];
    if (state.isNotEmpty && state.last._isModal) {
      newState.removeLast();
    }
    newState.add(page);
    state = newState;
  }

  void pop() {
    if (state.isNotEmpty) {
      state = state.sublist(0, state.length - 1);
    }
  }

  void pushOrReplace(BottomSheetPage page) {
    final newState = [...state];
    if (state.isNotEmpty && state.last.runtimeType == page.runtimeType) {
      newState.removeLast();
    }
    newState.add(page);
    state = newState;
  }

  void clear() {
    state = [];
  }
}

@Riverpod(keepAlive: true)
DraggableScrollableController sheetController(Ref ref) =>
    DraggableScrollableController();
