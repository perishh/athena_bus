import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ItineraryList extends HookWidget {
  final IconData icon;
  final String title;
  final List<String> times;

  const ItineraryList({
    super.key,
    required this.icon,
    required this.title,
    required this.times,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(
      () => FixedExtentScrollController(
        initialItem: getNextClosestTimeIndex(times),
      ),
      [times],
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Colors.black54),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 300,
          child: ListWheelScrollView(
            controller: controller,
            itemExtent: 38,
            physics: const FixedExtentScrollPhysics(),
            perspective: 0.008,
            magnification: 1,
            overAndUnderCenterOpacity: 0.7,
            useMagnifier: false,
            children: times.map((time) {
              return Text(
                time,
                style: TextStyle(fontSize: 18),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

int getNextClosestTimeIndex(List<String> times) {
  if (times.isEmpty) return 0;

  final now = DateTime.now();
  int? closestIndex;
  Duration? minDifference;

  for (int i = 0; i < times.length; i++) {
    // Parse HH:mm into DateTime
    final parts = times[i].split(':');
    final timeDate = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    // Check only future times
    if (timeDate.isAfter(now)) {
      final difference = timeDate.difference(now);

      if (minDifference == null || difference < minDifference) {
        minDifference = difference;
        closestIndex = i;
      }
    }
  }

  return closestIndex ?? 0;
}
