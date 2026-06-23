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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': category.id,
      'type': type.name,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      category: Category.getById(json['categoryId'] ?? ''),
      type: TransactionType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => TransactionType.expense,
      ),
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
    );
  }
}
