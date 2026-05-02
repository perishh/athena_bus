import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'arrivals_sheet_controller_provider.g.dart';

@Riverpod(keepAlive: true)
DraggableScrollableController arrivalsSheetController(Ref ref) =>
    DraggableScrollableController();
