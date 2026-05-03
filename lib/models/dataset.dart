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
    "",
    "",
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
