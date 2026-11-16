import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ikigai/models/quest.dart';
import 'package:ikigai/providers/quest_provider.dart';
import 'package:ikigai/widgets/quest_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomeScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  late List<Quest> _displayedQuests;
  late final String greeting;
  late final String date;
  late final String imgPath;

  int _completedQuestCount = 0;
  late int _totalQuestCount;

  String? _pendingCompletionId;

  @override
  void initState() {
    super.initState();

    // Initialize the displayed quests from the provider.
    _displayedQuests = List<Quest>.of(ref.read(questProvider).quests);

    _totalQuestCount = _displayedQuests.length;

    // Determine the current date and time of day.
    final now = DateTime.now();
    date = DateFormat.MMMMEEEEd().format(now);

    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      greeting = 'morning';
      imgPath = 'images/morning.jpg';
    } else if (hour >= 12 && hour < 17) {
      greeting = 'afternoon';
      imgPath = 'images/afternoon.jpg';
    } else if (hour >= 17 && hour < 22) {
      greeting = 'evening';
      imgPath = 'images/evening.jpg';
    } else {
      greeting = 'night';
      imgPath = 'images/night.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for changes to the quest list.
    ref.listen(questProvider.select((notifier) => notifier.quests), (
      previous,
      next,
    ) {
      if (previous == null) return;

      // Find a quest that was removed from the provider.
      final removedQuest = previous.cast<Quest?>().firstWhere(
        (oldQuest) =>
            oldQuest != null &&
            !next.any((newQuest) => newQuest.id == oldQuest.id),
        orElse: () => null,
      );

      // Find a quest that was added to the provider.
      final addedQuest = next.cast<Quest?>().firstWhere(
        (newQuest) =>
            newQuest != null &&
            !previous.any((oldQuest) => oldQuest.id == newQuest.id),
        orElse: () => null,
      );

      if (removedQuest != null) {
        // Find the removed quest in the displayed list by ID.
        final removedIndex = _displayedQuests.indexWhere(
          (quest) => quest.id == removedQuest.id,
        );

        if (removedIndex == -1) return;

        final quest = _displayedQuests.removeAt(removedIndex);

        // Deletions should not count as completed quests.
        if (_pendingCompletionId == quest.id) {
          _pendingCompletionId = null;
        } else if (_totalQuestCount > 0) {
          _totalQuestCount--;
        }

        // Animate the removed quest out of the list.
        _listKey.currentState?.removeItem(
          removedIndex,
          (context, animation) =>
              QuestTile(quest: quest, animation: animation, onClicked: () {}),
          duration: const Duration(milliseconds: 150),
        );

        setState(() {});
      } else if (addedQuest != null) {
        // Find the new quest's position in the provider list.
        final nextIndex = next.indexWhere((quest) => quest.id == addedQuest.id);

        // Determine its corresponding position in the displayed list.
        final insertionIndex = next
            .take(nextIndex)
            .where(
              (quest) => _displayedQuests.any(
                (displayedQuest) => displayedQuest.id == quest.id,
              ),
            )
            .length;

        // Add the new quest to the displayed list.
        _displayedQuests.insert(insertionIndex, addedQuest);

        _totalQuestCount++;

        // Animate the new quest into the list.
        _listKey.currentState?.insertItem(
          insertionIndex,
          duration: const Duration(milliseconds: 150),
        );

        setState(() {});
      } else {
        // Update existing quests by ID without replacing the displayed list.
        for (final updatedQuest in next) {
          final index = _displayedQuests.indexWhere(
            (quest) => quest.id == updatedQuest.id,
          );

          if (index != -1) {
            _displayedQuests[index] = updatedQuest;
          }
        }

        setState(() {});
      }
    });

    final quests = _displayedQuests;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDarkMode ? Colors.white : Colors.black87;

    // Calculate daily quest completion progress.
    final progress = _totalQuestCount == 0
        ? 1.0
        : (_completedQuestCount / _totalQuestCount).clamp(0.0, 1.0);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header, greeting, and date.
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ikigai',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () => context.push('/user'),
                          icon: const Icon(Icons.person_outline),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Greeting.
                    Text(
                      'Good $greeting, Gavin!',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                    ),

                    const SizedBox(height: 4),

                    // Current date.
                    Text(
                      date,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),

              // Full-width time-of-day image.
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  imgPath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // Daily quest information and quest list.
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Daily quest count.
                    Center(
                      child: Text(
                        quests.length > 1
                            ? '${quests.length} quests left for today! Keep it up!'
                            : quests.length == 1
                            ? '1 quest left for today! Almost there!'
                            : 'All quests complete! Good job!',
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Quest progress indicator.
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(end: progress),
                        duration: const Duration(milliseconds: 150),
                        builder: (context, value, child) {
                          return LinearProgressIndicator(
                            value: value,
                            color: Colors.cyanAccent[400],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Animated quest list.
                    AnimatedList.separated(
                      key: _listKey,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      initialItemCount: quests.length,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      itemBuilder: (context, index, animation) {
                        final quest = quests[index];

                        return QuestTile(
                          quest: quest,
                          animation: animation,
                          onClicked: () {
                            // Prevent the same quest from being completed multiple times.
                            if (quest.isDone) return;

                            // Track the quest completion.
                            _completedQuestCount++;
                            _pendingCompletionId = quest.id;

                            // Update the quest so its check button can animate.
                            ref.read(questProvider).markQuestComplete(quest.id);

                            // Show a completion confirmation.
                            ScaffoldMessenger.of(this.context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Quest completed! Gained ${quest.exp} EXP.',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: Colors.lightGreen,
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                snackBarAnimationStyle: const AnimationStyle(
                                  duration: Duration(milliseconds: 300),
                                  reverseDuration: Duration(milliseconds: 300),
                                ),
                              );

                            // Remove the completed quest after its color animation.
                            Future.delayed(
                              const Duration(milliseconds: 250),
                              () {
                                if (!mounted) return;

                                ref.read(questProvider).completeQuest(quest.id);
                              },
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index, animation) =>
                          const SizedBox(height: 6),
                      removedSeparatorBuilder: (context, index, animation) =>
                          const SizedBox(height: 6),
                    ),

                    const SizedBox(height: 12),

                    // Add quest button.
                    Center(
                      child: TextButton.icon(
                        onPressed: () => context.push('/new-quest'),
                        icon: const Icon(Icons.add),
                        label: const Text('Add a quest'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Floating action button for creating a quest.
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.tealAccent[400],
        onPressed: () => context.push('/new-quest'),
        child: const Icon(Icons.add, color: Colors.white, size: 27),
      ),
    );
  }
}
