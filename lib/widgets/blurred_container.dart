import 'dart:ui';
import 'package:flutter/material.dart';

class BlurredContainer extends StatelessWidget {
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
  final BackdropKey? backdropKey;

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
    this.backdropKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: decoration,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        clipBehavior: clipBehavior,
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
    );
  }
}
