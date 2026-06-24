import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_starter_app/repositories/mock_transaction_repository.dart';
import 'package:flutter_starter_app/providers/finance_provider.dart';
import 'package:flutter_starter_app/screens/home_screen.dart';

void main() {
  testWidgets('Navigate to Categories and Stats tabs and check for errors', (WidgetTester tester) async {
    final repository = MockTransactionRepository();
    final provider = FinanceProvider(repository);

    await tester.pumpWidget(
      ChangeNotifierProvider<FinanceProvider>.value(
        value: provider,
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Test Navigation to Categories
    final categoriesTab = find.byIcon(Icons.grid_view_rounded);
    expect(categoriesTab, findsOneWidget);
    await tester.tap(categoriesTab);
    await tester.pumpAndSettle();
    expect(find.text('Categories'), findsOneWidget);

    // 2. Test Navigation to Analytics/Stats
    final statsTab = find.byIcon(Icons.bar_chart_rounded);
    expect(statsTab, findsOneWidget);
    await tester.tap(statsTab);
    await tester.pumpAndSettle();
    expect(find.text('Analytics'), findsOneWidget);
  });
}
