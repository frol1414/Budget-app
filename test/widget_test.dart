import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_starter_app/repositories/mock_transaction_repository.dart';
import 'package:flutter_starter_app/providers/finance_provider.dart';
import 'package:flutter_starter_app/screens/home_screen.dart';

void main() {
  testWidgets('Navigate to Categories tab and check for errors', (WidgetTester tester) async {
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

    // Find the Categories navigation icon
    final categoriesTab = find.byIcon(Icons.grid_view_rounded);
    expect(categoriesTab, findsOneWidget);

    // Tap on Categories navigation icon
    await tester.tap(categoriesTab);
    await tester.pumpAndSettle();

    // Verify CategoriesScreen is shown (it has a title text "Categories")
    expect(find.text('Categories'), findsOneWidget);
  });
}
