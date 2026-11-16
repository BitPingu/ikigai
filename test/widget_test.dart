import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ikigai/main.dart';

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    // Build the app inside Riverpod's ProviderScope.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verify that the app's MaterialApp is rendered.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
