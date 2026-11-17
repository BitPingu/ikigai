import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ikigai/models/quest.dart';
import 'package:ikigai/providers/quest_provider.dart';
import 'package:ikigai/widgets/app_button.dart';
import 'package:ikigai/widgets/app_section_header.dart';
import 'package:ikigai/widgets/quest_tile.dart';

class QuestsScreen extends ConsumerStatefulWidget {
  const QuestsScreen({super.key});

  @override
  ConsumerState<QuestsScreen> createState() => _QuestsScreenState();
}

class _QuestsScreenState extends ConsumerState<QuestsScreen> {
  // Controls the animated quest list.
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  // Maintains the quests currently displayed in the animated list.
  late List<Quest> _displayedQuests;

  // Tracks quests waiting for their completion animation to finish.
  final Set<String> _pendingCompletionIds = {};

  // Checks whether any quests are currently displayed.
  bool get _hasDisplayedQuests => _displayedQuests.isNotEmpty;

  // Counts quests that have not yet been completed.
  int get _activeQuestCount =>
      _displayedQuests.where((quest) => !quest.isDone).length;

  @override
  void initState() {
    super.initState();

    // Initialize the displayed list from the quest provider.
    _displayedQuests = List<Quest>.of(ref.read(questProvider).quests);
  }

  @override
  Widget build(BuildContext context) {
    // Listen for changes to the quest list.
    ref.listen(questProvider.select((notifier) => notifier.quests), (
      previous,
      next,
    ) {
      if (previous == null) return;

      // Find quests that were removed from the provider.
      final removedQuests = previous
          .where(
            (oldQuest) => !next.any((newQuest) => newQuest.id == oldQuest.id),
          )
          .toList();

      // Find quests that were added to the provider.
      final addedQuests = next
          .where(
            (newQuest) =>
                !previous.any((oldQuest) => oldQuest.id == newQuest.id),
          )
          .toList();

      // Remove quests in descending index order to preserve list positions.
      removedQuests.sort((a, b) {
        final indexA = _displayedQuests.indexWhere((quest) => quest.id == a.id);
        final indexB = _displayedQuests.indexWhere((quest) => quest.id == b.id);

        return indexB.compareTo(indexA);
      });

      for (final removedQuest in removedQuests) {
        final removedIndex = _displayedQuests.indexWhere(
          (quest) => quest.id == removedQuest.id,
        );

        if (removedIndex == -1) continue;

        final quest = _displayedQuests.removeAt(removedIndex);

        // Clear the pending completion when its quest is removed.
        _pendingCompletionIds.remove(quest.id);

        // Animate the removed quest out of the list.
        _listKey.currentState?.removeItem(
          removedIndex,
          (context, animation) =>
              QuestTile(quest: quest, animation: animation, onClicked: () {}),
          duration: const Duration(milliseconds: 150),
        );
      }

      // Insert new quests in the same order as the provider list.
      for (final addedQuest in addedQuests) {
        final nextIndex = next.indexWhere((quest) => quest.id == addedQuest.id);

        // Find the corresponding position in the displayed list.
        final insertionIndex = next
            .take(nextIndex)
            .where(
              (quest) => _displayedQuests.any(
                (displayedQuest) => displayedQuest.id == quest.id,
              ),
            )
            .length;

        // Insert the new quest into the displayed list.
        _displayedQuests.insert(insertionIndex, addedQuest);

        // Animate the new quest into the list.
        _listKey.currentState?.insertItem(
          insertionIndex,
          duration: const Duration(milliseconds: 150),
        );
      }

      // Update existing quests, including their completion status.
      for (final updatedQuest in next) {
        final index = _displayedQuests.indexWhere(
          (quest) => quest.id == updatedQuest.id,
        );

        if (index != -1) {
          _displayedQuests[index] = updatedQuest;
        }
      }

      setState(() {});
    });

    // Read shared quest progress.
    final completedQuestCount = ref.watch(
      questProvider.select((notifier) => notifier.completedQuestCount),
    );

    final totalQuestCount = ref.watch(
      questProvider.select((notifier) => notifier.totalQuestCount),
    );

    // Calculate daily quest completion progress.
    final progress = totalQuestCount == 0
        ? 1.0
        : (completedQuestCount / totalQuestCount).clamp(0.0, 1.0);

    // Formats the active quest count for the section heading.
    final activeQuestLabel = _activeQuestCount == 0
        ? 'No active quests'
        : '$_activeQuestCount ${_activeQuestCount == 1 ? 'quest' : 'quests'}';

    final colorScheme = Theme.of(context).colorScheme;

    // Determines the progress bar background based on the current theme.
    final progressBackgroundColor =
        Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFDCE5D8)
        : const Color(0xFF3B493C);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen heading.
              Text('Quests', style: Theme.of(context).textTheme.headlineMedium),

              const SizedBox(height: 8),

              Text(
                'Complete quests and earn EXP as you progress.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

              // Displays daily quest progress.
              AppSectionHeader(
                title: 'Daily progress',
                actionLabel:
                    '$completedQuestCount / $totalQuestCount completed',
                animatedActionLabel: true,
              ),

              const SizedBox(height: 12),

              // Animates changes to daily quest progress.
              TweenAnimationBuilder<double>(
                tween: Tween<double>(end: progress),
                duration: const Duration(milliseconds: 250),
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: progressBackgroundColor,
                    color: colorScheme.primary,
                  );
                },
              ),

              const SizedBox(height: 24),

              // Displays the active quest count beside the section heading.
              AppSectionHeader(
                title: 'Active quests',
                actionLabel: activeQuestLabel,
              ),

              const SizedBox(height: 4),

              // Displays the animated quest list and its empty state.
              Expanded(
                child: Container(
                  // Uses the warm screen background instead of separate white cards.
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Stack(
                    children: [
                      // Keeps the animated list mounted when it has no items.
                      AnimatedList.separated(
                        key: _listKey,
                        initialItemCount: _displayedQuests.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index, animation) {
                          final quest = _displayedQuests[index];

                          return QuestTile(
                            key: ValueKey(quest.id),
                            quest: quest,
                            animation: animation,
                            onClicked: () => _completeQuest(quest),
                          );
                        },
                        separatorBuilder: (context, index, animation) {
                          return SizeTransition(
                            sizeFactor: animation,
                            child: const Divider(
                              height: 1,
                              thickness: 0.5,
                              color: Color(0xFFEAE6DB),
                            ),
                          );
                        },
                        removedSeparatorBuilder: (context, index, animation) {
                          return SizeTransition(
                            sizeFactor: animation,
                            child: const Divider(
                              height: 1,
                              thickness: 0.5,
                              color: Color(0xFFEAE6DB),
                            ),
                          );
                        },
                      ),

                      // Shows the empty state when there are no displayed quests.
                      AnimatedOpacity(
                        opacity: _hasDisplayedQuests ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 250),
                        child: AnimatedScale(
                          scale: _hasDisplayedQuests ? 0.95 : 1.0,
                          duration: const Duration(milliseconds: 250),
                          child: IgnorePointer(
                            ignoring: _hasDisplayedQuests,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.task_alt,
                                    size: 44,
                                    color: colorScheme.primary,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No active quests',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Your next adventure starts with a new quest.',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Creates a new quest.
              Align(
                alignment: Alignment.centerRight,
                child: AppButton(
                  label: 'Add a quest',
                  icon: Icons.add,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => context.push('/new-quest'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Handles quest completion and its delayed removal from the list.
  void _completeQuest(Quest quest) {
    // Prevents the same quest from being completed more than once.
    if (quest.isDone || _pendingCompletionIds.contains(quest.id)) return;

    _pendingCompletionIds.add(quest.id);

    // Keep a reference to the notifier for the delayed completion.
    final questNotifier = ref.read(questProvider);

    // Update the quest so its completion state can animate.
    questNotifier.markQuestComplete(quest.id);

    // Show a completion confirmation.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Quest completed! Gained ${quest.exp} EXP.'),
          behavior: SnackBarBehavior.floating,
        ),
      );

    // Remove the quest after its completion animation.
    Future.delayed(const Duration(milliseconds: 250), () {
      questNotifier.removeCompletedQuest(quest.id);
    });
  }
}
