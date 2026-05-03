import 'package:athena_bus/generated/material_community_icons.dart';
import 'package:athena_bus/hooks/use_bottom_sheet_navigation.dart';
import 'package:athena_bus/models/line.dart';
import 'package:athena_bus/widgets/blurred_container.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Header extends HookConsumerWidget {
  final Line line;

  const Header({super.key, required this.line});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = useBottomSheetNavigation(ref);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        spacing: 16,
        children: [
          const Icon(MaterialCommunityIcons.calendar_clock, size: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                        line.code,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        line.desc,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          BlurredContainer(
            color: Colors.white54,
            padding: const EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(999),
            child: const Icon(MaterialCommunityIcons.close),
            onTap: () => navigation.pop(),
          ),
        ],
      ),
    );
  }
}
