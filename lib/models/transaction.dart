import 'category.dart';

enum TransactionType {
  income,
  expense,
}

class Transaction {
  final String id;
  final Category category;
  final TransactionType type;
  final double amount;
  final DateTime date;

  const Transaction({
    required this.id,
    required this.category,
    required this.type,
    required this.amount,
    required this.date,
  });
}
