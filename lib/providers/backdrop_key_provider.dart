import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backdrop_key_provider.g.dart';

@Riverpod(keepAlive: true)
BackdropKey backdropKey(Ref ref) {
  return BackdropKey();
}
