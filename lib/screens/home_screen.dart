import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:ikigai/providers/quest_provider.dart';
import 'package:ikigai/widgets/app_card.dart';
import 'package:ikigai/widgets/app_progress_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final String greeting;
  late final String date;

  @override
  void initState() {
    super.initState();

    // Determine the current date and time of day.
    final now = DateTime.now();
    date = DateFormat.MMMMEEEEd().format(now);

    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      greeting = 'morning';
    } else if (hour >= 12 && hour < 17) {
      greeting = 'afternoon';
    } else if (hour >= 17 && hour < 22) {
      greeting = 'evening';
    } else {
      greeting = 'night';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Read shared daily quest progress.
    final completedQuestCount = ref.watch(
      questProvider.select((notifier) => notifier.completedQuestCount),
    );

    final totalQuestCount = ref.watch(
      questProvider.select((notifier) => notifier.totalQuestCount),
    );

    // Read the current quests from the provider.
    final quests = ref.watch(
      questProvider.select((notifier) => notifier.quests),
    );

    // Get up to three active quests for the dashboard preview.
    final activeQuests = quests
        .where((quest) => !quest.isDone)
        .take(3)
        .toList();

    // Calculate daily quest completion progress.
    final progress = totalQuestCount == 0
        ? 1.0
        : (completedQuestCount / totalQuestCount).clamp(0.0, 1.0);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting.
                Text(
                  'Good $greeting, Gavin!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // Current date.
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 20),

                // Character progression card.
                AppCard(
                  padding: const EdgeInsets.all(16),
                  onTap: () => context.push('/character'),
                  child: Row(
                    children: [
                      // Character portrait placeholder.
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(18),
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

                      // Character level and experience.
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Level and profile navigation.
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'LEVEL 1',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'View profile',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 18,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 2),

                            Text(
                              'Adventurer',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              '0 / 100 EXP',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),

                            const SizedBox(height: 8),

                            AppProgressBar(value: 0),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Daily quests section heading.
                Text(
                  "Today's quests",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // Daily quest progress and active quest card.
                AppCard(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  onTap: () => context.push('/quests'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Completion count and navigation.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$completedQuestCount / $totalQuestCount completed',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          Row(
                            children: [
                              Text(
                                'View all',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icons.chevron_right,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Animated daily quest progress indicator.
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(end: progress),
                        duration: const Duration(milliseconds: 250),
                        builder: (context, value, child) {
                          return AppProgressBar(value: value);
                        },
                      ),

                      const SizedBox(height: 12),

                      // Display active quests or an empty state.
                      if (activeQuests.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'No active quests. Great work!',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      else
                        ...activeQuests.asMap().entries.map((entry) {
                          final index = entry.key;
                          final quest = entry.value;

                          return Column(
                            children: [
                              // Quest details.
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.circle_outlined,
                                      size: 20,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        quest.title,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ),
                                    Text(
                                      '+${quest.exp} EXP',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),

                              // Separate quests with a subtle divider.
                              if (index < activeQuests.length - 1)
                                const Divider(
                                  height: 1,
                                  thickness: 0.5,
                                  color: Color(0xFFEAE6DB),
                                ),
                            ],
                          );
                        }),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Adventure section heading.
                Text(
                  'Your adventures',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // Dungeon and expedition previews.
                Row(
                  children: [
                    Expanded(
                      child: AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.shield_outlined,
                              size: 32,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Dungeons',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Coming soon',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.explore_outlined,
                              size: 32,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Expeditions',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Coming soon',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
