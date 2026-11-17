import 'package:material_ui/material_ui.dart';

import 'package:ikigai/widgets/app_card.dart';
import 'package:ikigai/widgets/app_progress_bar.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Screen heading.
                Text(
                  'Your profile',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                // Character profile.
                AppCard(
                  child: Column(
                    children: [
                      // Character portrait and details.
                      Row(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.person,
                              size: 42,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Character name and level.
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gavin',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  'Level 2 Adventurer',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Experience progress.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '75 / 100 EXP',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '25 EXP to next level',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      AppProgressBar(value: 0.75),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Character attributes section heading.
                Text(
                  'Attributes',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // Character attribute list.
                AppCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      _buildAttributeRow(
                        context,
                        title: 'Strength',
                        value: 10,
                        icon: Icons.fitness_center,
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Color(0xFFEAE6DB),
                      ),
                      _buildAttributeRow(
                        context,
                        title: 'Vitality',
                        value: 10,
                        icon: Icons.favorite_outline,
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Color(0xFFEAE6DB),
                      ),
                      _buildAttributeRow(
                        context,
                        title: 'Intelligence',
                        value: 10,
                        icon: Icons.psychology_outlined,
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Color(0xFFEAE6DB),
                      ),
                      _buildAttributeRow(
                        context,
                        title: 'Creativity',
                        value: 10,
                        icon: Icons.palette_outlined,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builds a row displaying an individual character attribute.
  Widget _buildAttributeRow(
    BuildContext context, {
    required String title,
    required int value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(
            value.toString(),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
