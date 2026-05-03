import 'package:athena_bus/generated/material_community_icons.dart';
import 'package:flutter/widgets.dart';

enum Dataset {
  stops(
    "stops",
    "getStopsW",
    "id, code, desc, descEn, street, streetEn, heading, lng, lat, type, amea, terminal, terminalEn",
    "Στάσεις",
    MaterialCommunityIcons.bus_stop,
  ),
  routes(
    "routes",
    "getRoutes",
    "id, lineId, desc, descEn, type, length",
    "Διαδρομές",
    MaterialCommunityIcons.directions_fork,
  ),
  lines(
    "lines",
    "getLines",
    "id, code, desc, descEn, route1_1, route1_2, route2_1, route2_2, route3_1, route3_2, route4_1, route4_2, route5_1, route5_2, route6_1, route6_2, route7_1, route7_2",
    "Γραμμές",
    MaterialCommunityIcons.chart_timeline_variant,
  )
  ;

  final String table;
  final String endpoint;
  final String columns;
  final String displayName;
  final IconData icon;

  const Dataset(
    this.table,
    this.endpoint,
    this.columns,
    this.displayName,
    this.icon,
  );
}
