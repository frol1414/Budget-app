import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/finance_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

  String _getRussianMonthName(int month) {
    const months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    return months[month - 1];
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final compareDate = DateTime(date.year, date.month, date.day);

    if (compareDate == today) {
      return 'Сегодня';
    } else if (compareDate == yesterday) {
      return 'Вчера';
    } else {
      final weekday = _getRussianWeekday(date);
      final monthName = _getRussianMonthName(date.month);
      return '$weekday, ${date.day} $monthName';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinanceProvider>();
    final transactions = provider.transactions;

    // Calculate overall balance metrics
    double totalBalance = 0.0;
    double totalIncome = 0.0;
    double totalExpense = 0.0;

    for (var tx in transactions) {
      if (tx.type == TransactionType.income) {
        totalBalance += tx.amount;
        totalIncome += tx.amount;
      } else {
        totalBalance -= tx.amount;
        totalExpense += tx.amount;
      }
    }

    final groupedTransactions = _groupTransactionsByDay(transactions);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16), // Top spacer to compensate for removed header bar

            // Top Balance Card (Inspired by example.webp)
            Container(
              height: 160,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: const Color(0xFF202020), // Charcoal container
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Left stats side
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ОБЩИЙ БАЛАНС',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${totalBalance >= 0 ? "" : "-"}${totalBalance.abs().toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            // Income display
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_upward_rounded,
                                    size: 12,
                                    color: Color(0xFF00C7BD),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Доходы',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 9,
                                      ),
                                    ),
                                    Text(
                                      '${totalIncome.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(width: 24),
                            // Expense display
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_downward_rounded,
                                    size: 12,
                                    color: Color(0xFFEDFF5C),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Расходы',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 9,
                                      ),
                                    ),
                                    Text(
                                      '${totalExpense.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Right decorative graph side
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildCapsule(0.4, const Color(0xFFEDFF5C)),
                        _buildCapsule(0.85, const Color(0xFF00C7BD)),
                        _buildCapsule(0.6, Colors.white.withOpacity(0.3)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Section Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
              child: Text(
                'История',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202020),
                ),
              ),
            ),

            // Scrollable List of Transactions Grouped by Day
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF202020)),
                      ),
                    )
                  : transactions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.hourglass_empty_rounded,
                                size: 64,
                                color: Colors.grey.withOpacity(0.4),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Нет записей о транзакциях',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 120.0),
                          itemCount: groupedTransactions.length,
                          itemBuilder: (context, index) {
                            final date = groupedTransactions.keys.elementAt(index);
                            final dayTransactions = groupedTransactions[date]!;
                            final total = _calculateDailyTotal(dayTransactions);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Day Group Header (Aligned to horizontal offset 32 to match inner text)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _formatDateHeader(date),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '${total >= 0 ? "+" : ""}${total.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: total >= 0
                                              ? const Color(0xFF00C7BD) // Turquoise for income
                                              : const Color(0xFF202020), // Charcoal for expense
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Transactions for this day
                                ...dayTransactions.map((tx) {
                                  final isIncome = tx.type == TransactionType.income;
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.015),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                      leading: Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: tx.category.color.withOpacity(0.12),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          tx.category.icon,
                                          color: tx.category.color,
                                          size: 20,
                                        ),
                                      ),
                                      title: Text(
                                        tx.category.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color(0xFF202020),
                                        ),
                                      ),
                                      trailing: Text(
                                        '${isIncome ? "+" : "-"}${tx.amount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: isIncome
                                              ? const Color(0xFF00C7BD)
                                              : const Color(0xFF202020),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                                const SizedBox(height: 10),
                              ],
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      // FAB button positioned higher to float above bottom tab bar
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 96.0, right: 4.0),
        child: SizedBox(
          width: 58,
          height: 58,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add_transaction');
            },
            backgroundColor: const Color(0xFFEDFF5C), // Lime Yellow
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.add_rounded,
              color: Color(0xFF202020),
              size: 32,
            ),
          ),
        ),
      ),
      // Custom floating bottom navigation bar
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // Floating Bottom Tab Bar with highlighted central "Transactions" tab
  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 68,
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Categories Tab
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add_transaction');
            },
            icon: const Icon(Icons.grid_view_rounded, color: Colors.grey, size: 22),
          ),
          // Highlighted Central "Transactions" Tab (Active)
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF202020),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: Color(0xFFEDFF5C), // Lime Yellow
              size: 22,
            ),
          ),
          // Charts/Analytics Tab (Placeholder)
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bar_chart_rounded, color: Colors.grey, size: 24),
          ),
        ],
      ),
    );
  }

  // Visual capsule builder helper
  Widget _buildCapsule(double heightFactor, Color color) {
    return Container(
      width: 10,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          FractionallySizedBox(
            heightFactor: heightFactor,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
