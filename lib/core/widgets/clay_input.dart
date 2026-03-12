import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/clay_radii.dart';
import '../constants/clay_shadows.dart';

class ClayInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final double borderRadius;
  final ClayShadowLevel shadowLevel;
  final ClayShadowLevel focusShadowLevel;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSuffixIconTap;
  final String? Function(String)? validator;
  final int? maxLines;
  final bool readOnly;
  final int? maxLength;

  const ClayInput({
    super.key,
    this.controller,
    this.hintText,
    this.borderRadius = ClayRadii.button,
    this.shadowLevel = ClayShadowLevel.pressed,
    this.focusShadowLevel = ClayShadowLevel.surface,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSuffixIconTap,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.maxLength,
  });

  @override
  State<ClayInput> createState() => _ClayInputState();
}

class _ClayInputState extends State<ClayInput> {
  bool _isFocused = false;
  bool _isRtl = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isRtl = Directionality.of(context) == TextDirection.rtl;
  }

  @override
  Widget build(BuildContext context) {
    final shadows = _isFocused
        ? ClayShadows.getShadowForLevel(widget.focusShadowLevel, _isRtl)
        : ClayShadows.getShadowForLevel(widget.shadowLevel, _isRtl);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: shadows,
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        onChanged: widget.onChanged,
        validator: widget.validator as FormFieldValidator<String>?,
        maxLines: widget.maxLines,
        readOnly: widget.readOnly,
        maxLength: widget.maxLength,
        onTap: () => setState(() => _isFocused = true),
        onTapOutside: (_) => setState(() => _isFocused = false),
        style: AppTextStyles.bodyLarge,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.surface,
          hintText: widget.hintText,
          hintStyle: AppTextStyles.bodySmall,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          prefixIcon: widget.prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: widget.prefixIcon,
                )
              : null,
          suffixIcon: widget.suffixIcon != null
              ? GestureDetector(
                  onTap: widget.onSuffixIconTap,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: widget.suffixIcon,
                  ),
                )
              : null,
          counterText: '',
        ),
      ),
    );
  }
}
