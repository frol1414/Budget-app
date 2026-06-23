import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/transaction.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Mock list of 20 transactions
  static final List<Transaction> mockTransactions = [
    // June 23, 2026
    Transaction(
      id: '1',
      category: Category.getById('food'),
      type: TransactionType.expense,
      amount: 15.40,
      date: DateTime(2026, 6, 23, 14, 30),
    ),
    Transaction(
      id: '2',
      category: Category.getById('transport'),
      type: TransactionType.expense,
      amount: 4.50,
      date: DateTime(2026, 6, 23, 10, 15),
    ),
    Transaction(
      id: '3',
      category: Category.getById('salary'),
      type: TransactionType.income,
      amount: 2500.00,
      date: DateTime(2026, 6, 23, 9, 00),
    ),
    
    // June 22, 2026
    Transaction(
      id: '4',
      category: Category.getById('entertainment'),
      type: TransactionType.expense,
      amount: 25.00,
      date: DateTime(2026, 6, 22, 19, 45),
    ),
    Transaction(
      id: '5',
      category: Category.getById('food'),
      type: TransactionType.expense,
      amount: 42.10,
      date: DateTime(2026, 6, 22, 13, 00),
    ),
    Transaction(
      id: '6',
      category: Category.getById('freelance'),
      type: TransactionType.income,
      amount: 150.00,
      date: DateTime(2026, 6, 22, 11, 20),
    ),
    
    // June 21, 2026
    Transaction(
      id: '7',
      category: Category.getById('utilities'),
      type: TransactionType.expense,
      amount: 85.50,
      date: DateTime(2026, 6, 21, 15, 30),
    ),
    Transaction(
      id: '8',
      category: Category.getById('shopping'),
      type: TransactionType.expense,
      amount: 120.00,
      date: DateTime(2026, 6, 21, 11, 00),
    ),

    // June 20, 2026
    Transaction(
      id: '9',
      category: Category.getById('food'),
      type: TransactionType.expense,
      amount: 8.50,
      date: DateTime(2026, 6, 20, 18, 10),
    ),
    Transaction(
      id: '10',
      category: Category.getById('transport'),
      type: TransactionType.expense,
      amount: 2.75,
      date: DateTime(2026, 6, 20, 8, 30),
    ),

    // June 19, 2026
    Transaction(
      id: '11',
      category: Category.getById('investment'),
      type: TransactionType.income,
      amount: 50.00,
      date: DateTime(2026, 6, 19, 14, 00),
    ),
    Transaction(
      id: '12',
      category: Category.getById('entertainment'),
      type: TransactionType.expense,
      amount: 15.00,
      date: DateTime(2026, 6, 19, 20, 00),
    ),

    // June 18, 2026
    Transaction(
      id: '13',
      category: Category.getById('food'),
      type: TransactionType.expense,
      amount: 34.20,
      date: DateTime(2026, 6, 18, 12, 45),
    ),
    Transaction(
      id: '14',
      category: Category.getById('transport'),
      type: TransactionType.expense,
      amount: 5.50,
      date: DateTime(2026, 6, 18, 9, 15),
    ),

    // June 17, 2026
    Transaction(
      id: '15',
      category: Category.getById('shopping'),
      type: TransactionType.expense,
      amount: 45.00,
      date: DateTime(2026, 6, 17, 16, 20),
    ),

    // June 16, 2026
    Transaction(
      id: '16',
      category: Category.getById('freelance'),
      type: TransactionType.income,
      amount: 300.00,
      date: DateTime(2026, 6, 16, 10, 00),
    ),
    Transaction(
      id: '17',
      category: Category.getById('food'),
      type: TransactionType.expense,
      amount: 12.90,
      date: DateTime(2026, 6, 16, 19, 30),
    ),

    // June 15, 2026
    Transaction(
      id: '18',
      category: Category.getById('utilities'),
      type: TransactionType.expense,
      amount: 60.00,
      date: DateTime(2026, 6, 15, 14, 00),
    ),

    // June 14, 2026
    Transaction(
      id: '19',
      category: Category.getById('entertainment'),
      type: TransactionType.expense,
      amount: 9.99,
      date: DateTime(2026, 6, 14, 21, 15),
    ),
    Transaction(
      id: '20',
      category: Category.getById('food'),
      type: TransactionType.expense,
      amount: 22.40,
      date: DateTime(2026, 6, 14, 13, 10),
    ),
  ];

  Map<DateTime, List<Transaction>> _groupTransactionsByDay(List<Transaction> list) {
    final Map<DateTime, List<Transaction>> groups = {};
    for (var tx in list) {
      final dateOnly = DateTime(tx.date.year, tx.date.month, tx.date.day);
      if (!groups.containsKey(dateOnly)) {
        groups[dateOnly] = [];
      }
      groups[dateOnly]!.add(tx);
    }

    final sortedKeys = groups.keys.toList()..sort((a, b) => b.compareTo(a));
    final Map<DateTime, List<Transaction>> sortedGroups = {};
    for (var key in sortedKeys) {
      sortedGroups[key] = groups[key]!..sort((a, b) => b.date.compareTo(a.date));
    }
    return sortedGroups;
  }

  double _calculateDailyTotal(List<Transaction> list) {
    double total = 0.0;
    for (var tx in list) {
      if (tx.type == TransactionType.income) {
        total += tx.amount;
      } else {
        total -= tx.amount;
      }
    }
    return total;
  }

  String _getRussianWeekday(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'понедельник';
      case DateTime.tuesday:
        return 'вторник';
      case DateTime.wednesday:
        return 'среда';
      case DateTime.thursday:
        return 'четверг';
      case DateTime.friday:
        return 'пятница';
      case DateTime.saturday:
        return 'суббота';
      case DateTime.sunday:
        return 'воскресенье';
      default:
        return '';
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day.$month.$year';
  }

  @override
  Widget build(BuildContext context) {
    final groupedTransactions = _groupTransactionsByDay(mockTransactions);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Транзакции',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Empty Block
            Container(
              height: 120,
              width: double.infinity,
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color ?? const Color(0xFF1A1D2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: const Center(
                child: Text(
                  'Пустой блок (баланс / аналитика)',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ),

            // Section Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    'История',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable List of Transactions Grouped by Day
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80.0),
                itemCount: groupedTransactions.length,
                itemBuilder: (context, index) {
                  final date = groupedTransactions.keys.elementAt(index);
                  final dayTransactions = groupedTransactions[date]!;
                  final total = _calculateDailyTotal(dayTransactions);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Day Group Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_formatDate(date)} (${_getRussianWeekday(date)})',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '${total >= 0 ? "+" : ""}${total.toStringAsFixed(2)} \$',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: total >= 0 ? Colors.greenAccent : Colors.redAccent,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Transactions for this day
                      ...dayTransactions.map((tx) {
                        final isIncome = tx.type == TransactionType.income;
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                          child: ListTile(
                            leading: Icon(tx.category.icon, color: tx.category.color),
                            title: Text(
                              tx.category.name,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            trailing: Text(
                              '${isIncome ? "+" : "-"}${tx.amount.toStringAsFixed(2)} \$',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: isIncome ? Colors.greenAccent : Colors.redAccent,
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 12),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Bottom Right FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_transaction');
        },
        tooltip: 'Добавить транзакцию',
        child: const Icon(Icons.add),
      ),
    );
  }
}
