import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikigai/models/quest.dart';

class QuestNotifier extends ChangeNotifier {
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

  List<Quest> get quests => List<Quest>.unmodifiable(_quests);

  int _nextQuestId = 3;

  String generateQuestId() {
    return (_nextQuestId++).toString();
  }

  void addQuest(Quest quest) {
    _quests.add(quest);
    notifyListeners();
  }

  void editQuest(Quest quest) {
    final index = _quests.indexWhere((item) => item.id == quest.id);

    if (index == -1) return;

    _quests[index] = quest;
    notifyListeners();
  }

  Quest? getQuest(String questId) {
    for (final quest in _quests) {
      if (quest.id == questId) return quest;
    }

    return null;
  }

  void deleteQuest(String questId) {
    final initialLength = _quests.length;

    _quests.removeWhere((quest) => quest.id == questId);

    if (_quests.length != initialLength) {
      notifyListeners();
    }
  }

  void completeQuest(String questId) {
    final index = _quests.indexWhere((quest) => quest.id == questId);

    if (index == -1) return;

    _quests.removeAt(index);
    notifyListeners();
  }

  void markQuestComplete(String questId) {
    final index = _quests.indexWhere((quest) => quest.id == questId);
    if (index == -1) return;

    final quest = _quests[index];

    if (quest.isDone) return;

    _quests[index] = Quest(
      id: quest.id,
      title: quest.title,
      subtitle: quest.subtitle,
      exp: quest.exp,
      isDone: true,
    );

    notifyListeners();
  }
}

final questProvider = ChangeNotifierProvider<QuestNotifier>(
  (ref) => QuestNotifier(),
);
