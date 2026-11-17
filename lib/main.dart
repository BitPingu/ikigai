import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ikigai/router/router.dart';
import 'package:ikigai/theme/app_theme.dart';

void main() {
  runApp(
    // Provides shared Riverpod state throughout the application.
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      // Uses the application's GoRouter configuration.
      routerConfig: ref.watch(routerProvider),

      // Applies the application's custom themes.
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      // Hides the debug banner.
      debugShowCheckedModeBanner: false,
    );
  }
}
