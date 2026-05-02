import 'package:athena_bus/generated/material_community_icons.dart';
import 'package:athena_bus/models/arrival.dart';
import 'package:athena_bus/models/route.dart';
import 'package:athena_bus/widgets/blurred_container.dart';
import 'package:athena_bus/widgets/marquee_plus.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RouteCard extends ConsumerWidget {
  final (Route, String) route;
  final ArrivalRoute arrivals;

  const RouteCard({
    super.key,
    required this.route,
    required this.arrivals,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Route header
          Row(
            spacing: 8,
            children: [
              BlurredContainer(
                color: Colors.white54,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                borderRadius: BorderRadius.circular(8),
                child: Text(
                  route.$2,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 20,
                  child: MarqueePlus(
                    text: route.$1.desc,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    spacing: 8,
                    children: arrivals.arrivals.isNotEmpty
                        ? [
                            Icon(MaterialCommunityIcons.clock, size: 16),
                            Text(
                              "${arrivals.arrivals.first.time} λ.",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ]
                        : [
                            Icon(
                              MaterialCommunityIcons.calendar_month,
                              size: 16,
                            ),
                            Text(
                              arrivals.next ?? '--:--',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                  ),
                  Row(
                    spacing: 8,
                    children: arrivals.arrivals
                        .skip(1)
                        .map(
                          (a) => Row(
                            spacing: 4,
                            children: [
                              Icon(
                                MaterialCommunityIcons.clock_outline,
                                size: 12,
                              ),
                              Text(
                                "${a.time} λ.",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
