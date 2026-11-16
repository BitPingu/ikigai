import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikigai/router/custom_transition_page.dart';
import 'package:ikigai/screens/home_screen.dart';
import 'package:ikigai/screens/quest_screen.dart';
import 'package:ikigai/screens/user_screen.dart';
import 'package:ikigai/widgets/navbar.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) => Navbar(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) =>
                buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: const HomeScreen(),
                ),
          ),
          GoRoute(
            path: '/user',
            pageBuilder: (context, state) =>
                buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: const UserScreen(),
                ),
          ),
          GoRoute(
            path: '/new-quest',
            pageBuilder: (context, state) =>
                buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: QuestScreen(),
                ),
          ),
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
