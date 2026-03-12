import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/clay_radii.dart';
import '../constants/clay_shadows.dart';
import '../utils/clay_animation_util.dart';

enum ClayButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
}

enum ClayButtonSize {
  small,
  medium,
  large,
}

class ClayButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ClayButtonVariant variant;
  final ClayButtonSize size;
  final double borderRadius;
  final Gradient? gradient;
  final bool isLoading;
  final double minTouchTarget;
  final bool fullWidth;

  const ClayButton({
    super.key,
    required this.child,
    this.onPressed,
    this.variant = ClayButtonVariant.primary,
    this.size = ClayButtonSize.medium,
    this.borderRadius = ClayRadii.button,
    this.gradient,
    this.isLoading = false,
    this.minTouchTarget = 48,
    this.fullWidth = false,
  });

  @override
  State<ClayButton> createState() => _ClayButtonState();
}

class _ClayButtonState extends State<ClayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _squishController;
  late Animation<double> _squishAnimation;

  bool _isRtl = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _squishController = AnimationController(
      vsync: this,
      duration: ClayAnimationUtil.tapSquishDown,
    );
    _squishAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _squishController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isRtl = Directionality.of(context) == TextDirection.rtl;
  }

  @override
  void dispose() {
    _squishController.dispose();
    super.dispose();
  }

  Gradient _getPrimaryGradient() {
    if (widget.gradient != null) {
      return widget.gradient!;
    }
    return const LinearGradient(
      begin: Alignment(-1, -1),
      end: Alignment(1, 1),
      colors: [
        Color(0xFFA78BFA),
        AppColors.primaryAccent,
      ],
    );
  }

  List<BoxShadow> _getShadows(bool isPressed) {
    final rtl = _isRtl;
    if (isPressed) {
      return ClayShadows.pressed(rtl);
    } else if (widget.variant == ClayButtonVariant.primary ||
        widget.variant == ClayButtonVariant.secondary) {
      return ClayShadows.button(rtl);
    } else {
      return [];
    }
  }

  Color _getBackgroundColor() {
    switch (widget.variant) {
      case ClayButtonVariant.primary:
        return Colors.transparent;
      case ClayButtonVariant.secondary:
        return const Color(0xFFF3F4F6);
      case ClayButtonVariant.outline:
      case ClayButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    if (widget.onPressed == null || widget.isLoading) {
      return const Color(0xFF9CA3AF);
    }
    switch (widget.variant) {
      case ClayButtonVariant.primary:
      case ClayButtonVariant.secondary:
        return AppColors.textOnPrimary;
      case ClayButtonVariant.outline:
      case ClayButtonVariant.ghost:
        return AppColors.primaryAccent;
    }
  }

  BoxBorder _getBorder() {
    switch (widget.variant) {
      case ClayButtonVariant.outline:
        return Border.all(
          color: AppColors.primaryAccent,
          width: 2,
        );
      case ClayButtonVariant.primary:
      case ClayButtonVariant.secondary:
      case ClayButtonVariant.ghost:
        return Border.all(
          color: Colors.transparent,
          width: 0,
        );
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      final shouldAnimate = ClayAnimationUtil.shouldAnimate(context);
      if (shouldAnimate) {
        _squishController.forward();
      }
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = false);
      final shouldAnimate = ClayAnimationUtil.shouldAnimate(context);
      if (shouldAnimate) {
        _squishController.duration = ClayAnimationUtil.tapSquishUp;
        _squishController.reverse();
        _squishController.duration = ClayAnimationUtil.tapSquishDown;
      }
    }
  }

  void _handleTapCancel() {
    if (!widget.isLoading) {
      setState(() => _isPressed = false);
      final shouldAnimate = ClayAnimationUtil.shouldAnimate(context);
      if (shouldAnimate) {
        _squishController.duration = ClayAnimationUtil.tapSquishUp;
        _squishController.reverse();
        _squishController.duration = ClayAnimationUtil.tapSquishDown;
      }
    }
  }

  double _getHeight() {
    switch (widget.size) {
      case ClayButtonSize.small:
        return 40;
      case ClayButtonSize.medium:
        return 48;
      case ClayButtonSize.large:
        return 56;
    }
  }

  double _getPadding() {
    switch (widget.size) {
      case ClayButtonSize.small:
        return 12;
      case ClayButtonSize.medium:
        return 16;
      case ClayButtonSize.large:
        return 20;
    }
  }

  @override
  Widget build(BuildContext context) {
    final shadows = _getShadows(_isPressed);
    final backgroundColor = _getBackgroundColor();
    final textColor = _getTextColor();
    final border = _getBorder();
    final height = _getHeight();
    final padding = _getPadding();
    final isDisabled = widget.onPressed == null || widget.isLoading;

    final buttonContent = AnimatedBuilder(
      animation: _squishAnimation,
      builder: (context, child) {
        final scale = isDisabled ? 1.0 : _squishAnimation.value;
        return Transform.scale(
          scale: scale,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              gradient: widget.variant == ClayButtonVariant.primary
                  ? _getPrimaryGradient()
                  : null,
              color: backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: shadows,
              border: border,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: widget.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.textOnPrimary,
                          ),
                        ),
                      )
                    : DefaultTextStyle.merge(
                        style: TextStyle(
                          color: textColor,
                          fontSize: widget.size == ClayButtonSize.small ? 14 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                        child: widget.child,
                      ),
              ),
            ),
          ),
        );
      },
    );

    if (isDisabled) {
      return IgnorePointer(
        child: SizedBox(
          width: widget.fullWidth ? double.infinity : null,
          child: buttonContent,
        ),
      );
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      behavior: HitTestBehavior.opaque,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: widget.minTouchTarget,
        ),
        child: SizedBox(
          width: widget.fullWidth ? double.infinity : null,
          child: buttonContent,
        ),
      ),
    );
  }
}
