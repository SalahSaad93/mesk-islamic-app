import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/clay_radii.dart';
import '../constants/clay_shadows.dart';

/// @deprecated Use ClayCard instead. This is a temporary compatibility alias.
class IslamicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final double elevation;

  @Deprecated('Use ClayCard instead. This will be removed in a future version.')
  const IslamicCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? ClayRadii.card;
    final bgColor = backgroundColor ?? AppColors.surface;
    final shadows = elevation > 0
        ? [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: elevation * 3,
              offset: Offset(0, elevation),
            ),
          ]
        : ClayShadows.surface();

    final cardContent = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1)
            : null,
        boxShadow: shadows,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Material(
          color: Colors.transparent,
          child: onTap != null
              ? Padding(
                  padding: padding ?? const EdgeInsets.all(16),
                  child: child,
                )
              : InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(radius),
                  child: Padding(
                    padding: padding ?? const EdgeInsets.all(16),
                    child: child,
                  ),
                ),
        ),
      ),
    );

    return cardContent;
  }
}
