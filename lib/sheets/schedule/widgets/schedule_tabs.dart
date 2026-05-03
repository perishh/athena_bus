import 'package:athena_bus/models/schedule.dart';
import 'package:athena_bus/widgets/blurred_container.dart';
import 'package:flutter/material.dart';

class ScheduleTabs extends StatelessWidget {
  final List<ScheduleDay> days;
  final ValueNotifier<int> selectedIndex;

  const ScheduleTabs({
    super.key,
    required this.days,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex.value == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: BlurredContainer(
              color: isSelected ? Colors.white : Colors.white38,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              borderRadius: BorderRadius.circular(10),
              child: Center(
                child: Text(
                  days[index].desc,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
              onTap: () {
                selectedIndex.value = index;
              },
            ),
          );
        },
      ),
    );
  }
}
