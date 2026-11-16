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
    // Watch this quest for changes, including its completion status.
    // Fall back to the original quest when it has been removed from the provider.
    final currentQuest = ref.watch(
      questProvider.select((notifier) {
        for (final item in notifier.quests) {
          if (item.id == quest.id) return item;
        }

        return quest;
      }),
    );

    return SizeTransition(
      sizeFactor: animation,
      child: buildItem(context, currentQuest),
    );
  }

  Widget buildItem(BuildContext context, Quest currentQuest) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = !isDarkMode
        ? Colors.cyan[50]!
        : Colors.blueGrey[700]!;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12.0),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 2.0,
        ),
        title: Text(
          currentQuest.title,
          style: TextStyle(
            color: !isDarkMode ? Colors.black87 : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${currentQuest.exp} EXP',
          style: TextStyle(color: !isDarkMode ? Colors.black87 : Colors.white),
        ),
        onTap: currentQuest.isDone
            ? null
            : () {
                context.push('/new-quest/${currentQuest.id}');
              },
        trailing: Stack(
          children: [
            // Background layer of the check button.
            Positioned(
              top: 4,
              left: 3,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: !currentQuest.isDone
                      ? Colors.tealAccent[400]
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),

            // Foreground layer containing the check icon.
            Positioned(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: !currentQuest.isDone
                      ? Colors.white
                      : Colors.tealAccent[400],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: IconButton(
                  onPressed: onClicked,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.check,
                      key: ValueKey(currentQuest.isDone),
                      color: !currentQuest.isDone
                          ? Colors.tealAccent[400]
                          : Colors.white,
                      size: 27.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
