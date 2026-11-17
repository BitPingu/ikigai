import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ikigai/models/quest.dart';
import 'package:ikigai/providers/quest_provider.dart';

class QuestTile extends ConsumerWidget {
  final Quest quest;
  final Animation<double> animation;
  final VoidCallback? onClicked;

  const QuestTile({
    super.key,
    required this.quest,
    required this.animation,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watches this quest for changes, including its completion status.
    // Falls back to the original quest if it has been removed from the provider.
    final currentQuest = ref.watch(
      questProvider.select((notifier) {
        for (final item in notifier.quests) {
          if (item.id == quest.id) return item;
        }

        return quest;
      }),
    );

    // Animates the row's height when it is inserted or removed from the list.
    return SizeTransition(
      sizeFactor: animation,
      child: buildItem(context, currentQuest),
    );
  }

  Widget buildItem(BuildContext context, Quest currentQuest) {
    final colorScheme = Theme.of(context).colorScheme;

    // Provides a Material surface for the row's ink effects.
    return Material(
      color: Colors.transparent,
      child: Row(
        children: [
          // Makes the quest details tappable to open the edit screen.
          Expanded(
            child: InkWell(
              onTap: currentQuest.isDone
                  ? null
                  : () {
                      context.push('/new-quest/${currentQuest.id}');
                    },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 10,
                ),
                child: AnimatedOpacity(
                  // Fades the quest details when completed.
                  opacity: currentQuest.isDone ? 0.55 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Displays the quest title.
                      Text(
                        currentQuest.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: currentQuest.isDone
                              ? colorScheme.onSurfaceVariant
                              : colorScheme.onSurface,
                          decoration: currentQuest.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),

                      // Displays the EXP reward.
                      Text(
                        '${currentQuest.exp} EXP',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Displays the circular quest completion button.
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: currentQuest.isDone ? null : onClicked,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Center(
                child: Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: currentQuest.isDone
                        ? null
                        : Border.all(color: colorScheme.primary, width: 1.5),
                    color: currentQuest.isDone
                        ? colorScheme.primary
                        : Colors.transparent,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.check,
                      key: ValueKey(currentQuest.isDone),
                      color: currentQuest.isDone
                          ? colorScheme.onPrimary
                          : colorScheme.primary,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
