import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

class Navbar extends StatelessWidget {
  final Widget child;

  const Navbar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // Displays the currently selected screen.
      body: child,

      // Provides navigation between the main screens.
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getSelectedIndex(context),
        onDestinationSelected: (int index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/quests');
              break;
            case 2:
              context.go('/character');
              break;
          }
        },

        // Uses the app theme for navigation styling.
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.secondaryContainer,
        elevation: 0,

        // Main navigation destinations.
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.assignment),
            icon: Icon(Icons.assignment_outlined),
            label: 'Quests',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'You',
          ),
        ],
      ),
    );
  }

  // Determines the selected destination based on the current route.
  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    if (location == '/quests' || location.startsWith('/new-quest')) {
      return 1;
    }

    if (location == '/character') return 2;

    return 0;
  }
}
