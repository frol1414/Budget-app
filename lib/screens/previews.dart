import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import '../repositories/mock_transaction_repository.dart';
import 'home_screen.dart';

@Preview(name: 'Budget App Shell Preview', group: 'Screens')
Widget previewHomeScreen() {
  return ChangeNotifierProvider(
    create: (_) => FinanceProvider(MockTransactionRepository()),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF202020),
          secondary: Color(0xFFEDFF5C),
          tertiary: Color(0xFF00C7BD),
          surface: Colors.white,
          onSurface: Color(0xFF202020),
        ),
      ),
      home: const HomeScreen(),
    ),
  );
}
