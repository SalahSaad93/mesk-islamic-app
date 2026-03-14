import 'package:flutter/material.dart';
import 'package:mesk_islamic_app/core/constants/app_colors.dart';
import 'package:mesk_islamic_app/core/constants/app_text_styles.dart';
import 'package:mesk_islamic_app/l10n/app_localizations.dart';

class LocationPermissionDialog extends StatelessWidget {
  const LocationPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.location_on, color: AppColors.primaryAccent),
          const SizedBox(width: 8),
          Text(l10n.locationPermissionTitle, style: AppTextStyles.cardTitle),
        ],
      ),
      content: Text(
        l10n.locationPermissionRationale,
        style: AppTextStyles.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child:
              Text(l10n.cancel, style: TextStyle(color: AppColors.textTertiary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryAccent,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.allow),
        ),
      ],
    );
  }
}
