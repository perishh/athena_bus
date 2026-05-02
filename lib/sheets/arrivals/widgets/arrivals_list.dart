import 'package:athena_bus/generated/material_community_icons.dart';
import 'package:athena_bus/models/arrival.dart';
import 'package:athena_bus/models/route.dart';
import 'package:athena_bus/sheets/arrivals/widgets/route_card.dart';
import 'package:flutter/material.dart' hide Route;

class ArrivalsList extends StatelessWidget {
  final List<(Route, String)> routes;
  final List<ArrivalRoute> arrivals;

  const ArrivalsList({
    super.key,
    required this.routes,
    required this.arrivals,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = View.of(context).padding.bottom;

    if (arrivals.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            spacing: 8,
            children: [
              const Icon(
                MaterialCommunityIcons.bus_stop_covered,
                size: 40,
                color: Colors.black38,
              ),
              Text(
                'Δεν υπάρχουν αφίξεις αυτή τη στιγμή',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.4,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: bottom),
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemCount: arrivals.length,
        itemBuilder: (context, index) => RouteCard(
          route: routes.firstWhere(
            (r) => r.$1.id == int.parse(arrivals[index].route),
            orElse: () => (
              Route(
                id: -1,
                desc: 'Άγνωστη διαδρομή',
                descEn: 'Unknown Route',
                lineId: -1,
                type: 0,
                length: 0,
              ),
              arrivals[index].route,
            ),
          ),
          arrivals: arrivals[index],
        ),
      ),
    );
  }
}
