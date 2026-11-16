class Quest {
  final String id;
  final String title;
  final String subtitle;
  final int exp;
  final bool isDone;

  const Quest({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.exp,
    required this.isDone,
  });
}
