import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/clay_radii.dart';
import '../constants/clay_shadows.dart';
import '../utils/clay_animation_util.dart';

class ClayCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final ClayShadowLevel shadowLevel;
  final Color backgroundColor;
  final bool glassEffect;
  final VoidCallback? onTap;
  final bool liftOnTap;
  final double? minHeight;

  const ClayCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin = EdgeInsets.zero,
    this.borderRadius = ClayRadii.card,
    this.shadowLevel = ClayShadowLevel.surface,
    this.backgroundColor = AppColors.surface,
    this.glassEffect = false,
    this.onTap,
    this.liftOnTap = true,
    this.minHeight,
  });

  @override
  State<ClayCard> createState() => _ClayCardState();
}

class _ClayCardState extends State<ClayCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _liftController;
  late Animation<double> _liftAnimation;

  bool _isRtl = false;

  @override
  void initState() {
    super.initState();
    _liftController = AnimationController(
      vsync: this,
      duration: ClayAnimationUtil.cardLift,
    );
    _liftAnimation = CurvedAnimation(
      parent: _liftController,
      curve: Curves.easeOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isRtl = Directionality.of(context) == TextDirection.rtl;
  }

  @override
  void dispose() {
    _liftController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null && widget.liftOnTap) {
      final shouldAnimate = ClayAnimationUtil.shouldAnimate(context);
      if (shouldAnimate) {
        _liftController.forward();
      }
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap != null && widget.liftOnTap) {
      final shouldAnimate = ClayAnimationUtil.shouldAnimate(context);
      if (shouldAnimate) {
        _liftController.reverse();
      }
    }
  }

  void _handleTapCancel() {
    if (widget.liftOnTap) {
      final shouldAnimate = ClayAnimationUtil.shouldAnimate(context);
      if (shouldAnimate) {
        _liftController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final shadows = ClayShadows.getShadowForLevel(widget.shadowLevel, _isRtl);

    final cardContent = Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: shadows,
      ),
      child: widget.glassEffect
          ? Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.highlightColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: widget.padding,
                  child: widget.child,
                ),
              ],
            )
          : Padding(
              padding: widget.padding,
              child: widget.child,
            ),
    );

    if (widget.onTap == null) {
      return cardContent;
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _liftAnimation,
        builder: (context, child) {
          final offsetY = widget.liftOnTap
              ? -2.0 * _liftAnimation.value
              : 0.0;
          return Transform.translate(
            offset: Offset(0, offsetY),
            child: child,
          );
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: (widget.minHeight ?? 48).toDouble(),
          ),
          child: cardContent,
        ),
      ),
    );
  }
}
