import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikigai/models/quest.dart';

class QuestNotifier extends ChangeNotifier {
  // Stores the active quests.
  final List<Quest> _quests = [
    const Quest(
      id: '0',
      exp: 10,
      title: 'Drink water',
      subtitle: '10 EXP',
      isDone: false,
    ),
    const Quest(
      id: '1',
      exp: 100,
      title: 'Get out of bed',
      subtitle: '100 EXP',
      isDone: false,
    ),
    const Quest(
      id: '2',
      exp: 20,
      title: 'Wash my face',
      subtitle: '20 EXP',
      isDone: false,
    ),
  ];

  // Provides read-only access to the current quests.
  List<Quest> get quests => List<Quest>.unmodifiable(_quests);

  // Tracks daily quest progress.
  int _completedQuestCount = 0;

  // Initializes the daily quest total from the initial quest list.
  late int _totalQuestCount = _quests.length;

  int get completedQuestCount => _completedQuestCount;
  int get totalQuestCount => _totalQuestCount;

  // Generates unique IDs for newly created quests.
  int _nextQuestId = 3;

  String generateQuestId() {
    return (_nextQuestId++).toString();
  }

  // Adds a new quest and increases the daily quest total.
  void addQuest(Quest quest) {
    _quests.add(quest);
    _totalQuestCount++;
    notifyListeners();
  }

  // Updates an existing quest using its ID.
  void editQuest(Quest quest) {
    final index = _quests.indexWhere((item) => item.id == quest.id);

    if (index == -1) return;

    _quests[index] = quest;
    notifyListeners();
  }

  // Retrieves a quest by its ID.
  Quest? getQuest(String questId) {
    for (final quest in _quests) {
      if (quest.id == questId) return quest;
    }

    return null;
  }

  // Deletes a quest and adjusts the total if it was still active.
  void deleteQuest(String questId) {
    final index = _quests.indexWhere((quest) => quest.id == questId);

    if (index == -1) return;

    final quest = _quests.removeAt(index);

    // Deleting an active quest reduces the daily quest total.
    if (!quest.isDone) {
      _totalQuestCount--;
    }

    notifyListeners();
  }

  // Removes a completed quest after its completion animation.
  void removeCompletedQuest(String questId) {
    final index = _quests.indexWhere((quest) => quest.id == questId);

    if (index == -1) return;

    _quests.removeAt(index);
    notifyListeners();
  }

  // Marks a quest as completed and updates daily progress.
  void markQuestComplete(String questId) {
    final index = _quests.indexWhere((quest) => quest.id == questId);

    if (index == -1) return;

    final quest = _quests[index];

    // Prevents the same quest from being counted more than once.
    if (quest.isDone) return;

    _quests[index] = Quest(
      id: quest.id,
      title: quest.title,
      subtitle: quest.subtitle,
      exp: quest.exp,
      isDone: true,
    );

    // Increases the completed quest count.
    _completedQuestCount++;

    notifyListeners();
  }
}

// Provides shared access to quest state throughout the app.
final questProvider = ChangeNotifierProvider<QuestNotifier>(
  (ref) => QuestNotifier(),
);
