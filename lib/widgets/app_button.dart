import 'package:material_ui/material_ui.dart';

// Defines the available visual styles for app buttons.
enum AppButtonVariant { primary, secondary }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    // Determines which button styling to apply.
    final isPrimary = variant == AppButtonVariant.primary;

    return FilledButton(
      // Disables the button while an operation is loading.
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        // Uses the primary color for primary buttons and the surface color
        // for secondary buttons.
        backgroundColor: isPrimary
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surface,
        foregroundColor: isPrimary
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.primary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),

        // Gives the button rounded corners with a subtle border on secondary buttons.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isPrimary
              ? BorderSide.none
              : BorderSide(
                  color: Theme.of(context).brightness == Brightness.light
                      ? const Color(0xFFEAE6DB)
                      : const Color(0xFF414B40),
                ),
        ),
      ),

      // Shows a loading indicator or the button's icon and label.
      child: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Displays an optional icon before the button label.
                if (icon != null) ...[
                  Icon(icon, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(label),
              ],
            ),
    );
  }
}
