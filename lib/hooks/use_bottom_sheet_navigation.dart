import 'package:athena_bus/providers/bottom_sheet_navigation_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BottomSheetNavigationController {
  final BottomSheetNavigation _notifier;
  final List<BottomSheetPage> _state;
  final DraggableScrollableController _controller;
  const BottomSheetNavigationController(
    this._notifier,
    this._state,
    this._controller,
  );

  T? getCurrentPageAs<T extends BottomSheetPage>() {
    if (_state.isNotEmpty && _state.last is T) {
      return _state.last as T;
    }
    return null;
  }

  void pushOrReplace(BottomSheetPage page) {
    _notifier.pushOrReplace(page);
  }

  void push(BottomSheetPage page, {bool isModal = false}) {
    _notifier.push(page, isModal: isModal);
  }

  void pop() {
    if (_state.length == 1) {
      _controller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _notifier.pop();
    }
  }

  void clear() {
    _notifier.clear();
  }
}

BottomSheetNavigationController useBottomSheetNavigation(WidgetRef ref) {
  final notifier = ref.watch(bottomSheetNavigationProvider.notifier);
  final state = ref.watch(bottomSheetNavigationProvider);
  final controller = ref.watch(sheetControllerProvider);

  return BottomSheetNavigationController(notifier, state, controller);
}
