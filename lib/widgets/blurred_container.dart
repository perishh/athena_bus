import 'dart:ui';
import 'package:athena_bus/providers/backdrop_key_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BlurredContainer extends HookConsumerWidget {
  final Widget child;
  final double sigma;
  final Color color;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final Clip clipBehavior;
  final VoidCallback? onTap;

  const BlurredContainer({
    super.key,
    this.sigma = 5.0,
    this.color = const Color.fromARGB(200, 255, 255, 255),
    this.decoration,
    this.padding,
    this.margin,
    this.borderRadius,
    this.width,
    this.height,
    this.alignment,
    this.clipBehavior = Clip.hardEdge,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backdropKey = ref.watch(backdropKeyProvider);
    return Container(
      margin: margin,
      decoration: decoration,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        clipBehavior: clipBehavior,
        child: GestureDetector(
          onTap: onTap,
          child: BackdropFilter(
            backdropGroupKey: backdropKey,
            filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: Container(
              width: width,
              height: height,
              padding: padding,
              alignment: alignment,
              decoration: BoxDecoration(color: color),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
