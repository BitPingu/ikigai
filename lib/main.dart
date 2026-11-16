import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/router.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      // Configures app navigation.
      routerConfig: ref.watch(routerProvider),

      // Configures the light and dark themes.
      theme: ThemeData(colorSchemeSeed: Colors.tealAccent),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,

      // Hides the debug banner.
      debugShowCheckedModeBanner: false,
    );
  }
}
