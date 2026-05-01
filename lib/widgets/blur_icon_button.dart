import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BlurIconButton extends HookWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double sigma;
  final Color tintColor;
  final BackdropKey? backdropKey;
  final double elevation;
  final EdgeInsetsGeometry? margin;

  const BlurIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 24,
    this.sigma = 4,
    this.backdropKey,
    this.elevation = 0,
    this.margin,
    this.tintColor = Colors.white54,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.15 * (elevation / 6).clamp(0, 1),
                  ),
                  blurRadius: elevation,
                  offset: Offset(0, elevation / 2),
                ),
              ]
            : null,
      ),
      child: ClipOval(
        clipBehavior: Clip.hardEdge,
        child: GestureDetector(
          onTap: onPressed,
          child: BackdropFilter(
            backdropGroupKey: backdropKey,
            filter: ImageFilter.blur(
              sigmaX: sigma,
              sigmaY: sigma,
            ),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: tintColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: size, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
