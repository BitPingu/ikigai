import 'package:material_ui/material_ui.dart';

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.animatedActionLabel = false,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool animatedActionLabel;

  @override
  Widget build(BuildContext context) {
    final actionTextStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Displays the section title.
        Text(title, style: Theme.of(context).textTheme.titleMedium),

        // Displays an optional label or clickable action beside the title.
        if (actionLabel != null)
          onAction != null
              ? TextButton(onPressed: onAction, child: Text(actionLabel!))
              : animatedActionLabel
              ? AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    actionLabel!,
                    key: ValueKey(actionLabel),
                    style: actionTextStyle,
                  ),
                )
              : Text(actionLabel!, style: actionTextStyle),
      ],
    );
  }
}
