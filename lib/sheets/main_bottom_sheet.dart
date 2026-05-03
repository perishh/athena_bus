import 'package:athena_bus/hooks/use_bottom_sheet_navigation.dart';
import 'package:athena_bus/providers/bottom_sheet_navigation_provider.dart';
import 'package:athena_bus/widgets/blurred_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainBottomSheet extends HookConsumerWidget {
  const MainBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(sheetControllerProvider);
    final navigation = useBottomSheetNavigation(ref);

    final currentPage = navigation.getCurrentPageAs<BottomSheetPage>();

    if (currentPage == null) {
      return const SizedBox.shrink();
    }

    useEffect(() {
      Future.microtask(
        () {
          controller.animateTo(
            0.3,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        },
      );
      return null;
    }, []);

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent <= 0.0) {
          navigation.clear();
        }
        return true;
      },
      child: DraggableScrollableSheet(
        controller: controller,
        initialChildSize: 0.005,
        minChildSize: 0.0,
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
            child: currentPage.build(),
          ),
        ),
      ),
    );
  }
}
