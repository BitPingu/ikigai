import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ikigai/models/quest.dart';
import 'package:ikigai/providers/quest_provider.dart';

class QuestScreen extends ConsumerStatefulWidget {
  final String? questId;

  const QuestScreen({super.key, this.questId});

  @override
  ConsumerState<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends ConsumerState<QuestScreen> {
  late final TextEditingController _inputController;

  @override
  void initState() {
    super.initState();

    // Initialize the controller with the existing quest title when editing.
    final quest = widget.questId == null
        ? null
        : ref.read(questProvider).getQuest(widget.questId!);

    _inputController = TextEditingController(text: quest?.title ?? '');
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the current quest when editing.
    final currentQuest = widget.questId == null
        ? null
        : ref.watch(
            questProvider.select(
              (notifier) => notifier.getQuest(widget.questId!),
            ),
          );

    // Handle cases where the quest has already been deleted.
    if (widget.questId != null && currentQuest == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('This quest no longer exists.'),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Go back'),
              ),
            ],
          ),
        ),
      );
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 80.0),

          // Screen header.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 60.0),
              Text(
                widget.questId == null ? 'New quest!' : 'Edit quest',
                style: TextStyle(
                  color: !isDarkMode ? Colors.black87 : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              widget.questId != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: IconButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              content: const Text(
                                'Are you sure you want to delete this quest?',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    dialogContext.pop();
                                  },
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Capture the messenger before navigating away.
                                    final messenger = ScaffoldMessenger.of(
                                      context,
                                    );

                                    // Delete the quest.
                                    ref
                                        .read(questProvider)
                                        .deleteQuest(widget.questId!);

                                    // Close the dialog and edit screen.
                                    dialogContext.pop();
                                    context.pop();

                                    // Show a deletion confirmation.
                                    messenger
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 12),
                                              const Text(
                                                'Quest deleted.',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          backgroundColor: Colors.lightBlue,
                                          duration: const Duration(seconds: 2),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        snackBarAnimationStyle:
                                            const AnimationStyle(
                                              duration: Duration(
                                                milliseconds: 300,
                                              ),
                                              reverseDuration: Duration(
                                                milliseconds: 300,
                                              ),
                                            ),
                                      );
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            );
                          },
                        ),
                        icon: Icon(
                          Icons.delete,
                          size: 24.0,
                          color: Colors.red[700],
                        ),
                      ),
                    )
                  : const SizedBox(width: 60.0),
            ],
          ),

          // Quest input container.
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 26.0,
              vertical: 16.0,
            ),
            padding: const EdgeInsets.only(bottom: 6.0),
            decoration: BoxDecoration(
              color: !isDarkMode ? Colors.white : Colors.grey[800],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: [
                // Close button.
                Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.close, size: 20.0),
                    ),
                    const SizedBox(width: 3.0),
                  ],
                ),

                // Quest title input.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    controller: _inputController,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: !isDarkMode ? Colors.black87 : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: 'What do you want to do?',
                      hintStyle: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 6.0),

                // Save button.
                Row(
                  children: [
                    const Spacer(),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _inputController,
                      builder: (context, value, child) {
                        final hasTitle = value.text.trim().isNotEmpty;

                        return TextButton(
                          style: hasTitle
                              ? ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.tealAccent[400],
                                  ),
                                  foregroundColor: const WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                )
                              : null,
                          onPressed: hasTitle
                              ? () {
                                  final title = _inputController.text.trim();

                                  if (widget.questId == null) {
                                    // Create a new quest.
                                    final provider = ref.read(questProvider);

                                    provider.addQuest(
                                      Quest(
                                        id: provider.generateQuestId(),
                                        title: title,
                                        subtitle: '10 EXP',
                                        exp: 10,
                                        isDone: false,
                                      ),
                                    );

                                    context.pop();
                                  } else {
                                    // Capture the messenger before navigating away.
                                    final messenger = ScaffoldMessenger.of(
                                      context,
                                    );

                                    // Update the existing quest.
                                    ref
                                        .read(questProvider)
                                        .editQuest(
                                          Quest(
                                            id: widget.questId!,
                                            title: title,
                                            subtitle: currentQuest!.subtitle,
                                            exp: currentQuest.exp,
                                            isDone: currentQuest.isDone,
                                          ),
                                        );

                                    context.pop();

                                    // Show an update confirmation.
                                    messenger
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 12),
                                              const Text(
                                                'Quest updated.',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          backgroundColor: Colors.lightBlue,
                                          duration: const Duration(seconds: 2),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        snackBarAnimationStyle:
                                            const AnimationStyle(
                                              duration: Duration(
                                                milliseconds: 300,
                                              ),
                                              reverseDuration: Duration(
                                                milliseconds: 300,
                                              ),
                                            ),
                                      );
                                  }
                                }
                              : null,
                          child: const Text(
                            'Save',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 6.0),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
