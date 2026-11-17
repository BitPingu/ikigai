import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ikigai/models/quest.dart';
import 'package:ikigai/providers/quest_provider.dart';
import 'package:ikigai/widgets/app_button.dart';

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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen header.
              Row(
                children: [
                  // Returns to the previous screen.
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),

                  // Displays the screen title.
                  Expanded(
                    child: Text(
                      widget.questId == null ? 'New quest' : 'Edit quest',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Displays the delete action when editing.
                  if (widget.questId != null)
                    IconButton(
                      onPressed: _confirmDelete,
                      icon: const Icon(Icons.delete_outline),
                      color: Theme.of(context).colorScheme.error,
                    )
                  else
                    const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 32),

              // Displays the quest title input.
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quest title',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: _inputController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _saveQuest(),
                    decoration: const InputDecoration(
                      hintText: 'What do you want to accomplish?',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Give your quest a short, actionable name.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Saves the new quest or updates the existing quest.
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _inputController,
                builder: (context, value, child) {
                  final hasTitle = value.text.trim().isNotEmpty;

                  return SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: widget.questId == null
                          ? 'Create quest'
                          : 'Save changes',
                      onPressed: hasTitle ? _saveQuest : null,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Confirms and handles quest deletion.
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete quest?'),
          content: const Text('Are you sure you want to delete this quest?'),
          actions: [
            TextButton(
              onPressed: () => dialogContext.pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Capture the messenger before navigating away.
                final messenger = ScaffoldMessenger.of(context);

                // Delete the quest.
                ref.read(questProvider).deleteQuest(widget.questId!);

                // Close the dialog and edit screen.
                dialogContext.pop();
                context.pop();

                // Show a deletion confirmation.
                messenger
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Quest deleted.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Creates a new quest or saves changes to an existing quest.
  void _saveQuest() {
    final title = _inputController.text.trim();

    // Prevents saving an empty quest title.
    if (title.isEmpty) return;

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
    } else {
      // Update the existing quest.
      final currentQuest = ref.read(questProvider).getQuest(widget.questId!);

      if (currentQuest == null) return;

      ref
          .read(questProvider)
          .editQuest(
            Quest(
              id: currentQuest.id,
              title: title,
              subtitle: currentQuest.subtitle,
              exp: currentQuest.exp,
              isDone: currentQuest.isDone,
            ),
          );
    }

    // Capture the messenger before navigating away.
    final messenger = ScaffoldMessenger.of(context);

    // Close the screen after saving.
    context.pop();

    // Show a confirmation when editing an existing quest.
    if (widget.questId != null) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Quest updated.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }
}
