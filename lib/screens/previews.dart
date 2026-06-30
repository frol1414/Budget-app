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
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
}
