import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ikigai/router/custom_transition_page.dart';
import 'package:ikigai/screens/home_screen.dart';
import 'package:ikigai/screens/quest_screen.dart';
import 'package:ikigai/screens/quests_screen.dart';
import 'package:ikigai/screens/user_screen.dart';
import 'package:ikigai/widgets/navbar.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      // Provides shared navigation across the main screens.
      ShellRoute(
        builder: (context, state, child) => Navbar(child: child),
        routes: [
          // Home dashboard.
          GoRoute(
            path: '/',
            pageBuilder: (context, state) =>
                buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: const HomeScreen(),
                ),
          ),

          // Quest management screen.
          GoRoute(
            path: '/quests',
            pageBuilder: (context, state) =>
                buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: const QuestsScreen(),
                ),
          ),

          // Character profile and progression.
          GoRoute(
            path: '/character',
            pageBuilder: (context, state) =>
                buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: const UserScreen(),
                ),
          ),

          // Creates a new quest.
          GoRoute(
            path: '/new-quest',
            pageBuilder: (context, state) =>
                buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: QuestScreen(),
                ),
          ),

          // Edits an existing quest using its ID.
          GoRoute(
            path: '/new-quest/:questId',
            pageBuilder: (context, state) =>
                buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: QuestScreen(questId: state.pathParameters['questId']),
                ),
          ),
        ],
      ),
    ],
  );
});
