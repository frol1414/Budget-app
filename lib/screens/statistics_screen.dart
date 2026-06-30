import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../providers/finance_provider.dart';
import '../widgets/category_tile.dart';

class StatisticsScreen extends StatefulWidget {
  final bool isEmbedded;
  final VoidCallback? onBack;

  const StatisticsScreen({
    super.key,
    this.isEmbedded = false,
    this.onBack,
  });

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  TransactionType _selectedType = TransactionType.expense;
  DateTime _selectedMonth = DateTime.now();

  String _getEnglishMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Widget _buildTypeToggle() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedType = TransactionType.expense),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _selectedType == TransactionType.expense
                      ? const Color(0xFF202020)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Expense',
                  style: TextStyle(
                    color: _selectedType == TransactionType.expense
                        ? Colors.white
                        : const Color(0xFF202020).withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedType = TransactionType.income),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _selectedType == TransactionType.income
                      ? const Color(0xFF202020)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Income',
                  style: TextStyle(
                    color: _selectedType == TransactionType.income
                        ? Colors.white
                        : const Color(0xFF202020).withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSwitcher() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: IconButton(
            icon: const Icon(Icons.chevron_left_rounded, size: 22),
            onPressed: () {
              setState(() {
                _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
              });
            },
          ),
        ),
        Text(
          '${_getEnglishMonthName(_selectedMonth.month)} ${_selectedMonth.year}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF202020),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: IconButton(
            icon: const Icon(Icons.chevron_right_rounded, size: 22),
            onPressed: () {
              setState(() {
                _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinanceProvider>();
    
    // Filter transactions by type, month and year
    final txs = provider.transactions.where((tx) {
      return tx.type == _selectedType &&
          tx.date.year == _selectedMonth.year &&
          tx.date.month == _selectedMonth.month;
    }).toList();

    // Sum transactions per category
    final Map<String, double> categorySums = {};
    double totalSum = 0.0;
    for (var tx in txs) {
      categorySums[tx.category.id] = (categorySums[tx.category.id] ?? 0.0) + tx.amount;
      totalSum += tx.amount;
    }

    // Filter categories that have transactions for this month and sort by sum descending
    final activeCategories = Category.allCategories.where((cat) {
      return cat.type == (_selectedType == TransactionType.expense
          ? CategoryType.expense
          : CategoryType.income) &&
          categorySums.containsKey(cat.id);
    }).toList();

    activeCategories.sort((a, b) {
      final sumA = categorySums[a.id] ?? 0.0;
      final sumB = categorySums[b.id] ?? 0.0;
      return sumB.compareTo(sumA);
    });

    final isIncome = _selectedType == TransactionType.income;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        centerTitle: true,
        leading: widget.isEmbedded
            ? null
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMonthSwitcher(),
              const SizedBox(height: 16),
              _buildTypeToggle(),
              const SizedBox(height: 20),

              // Total Summary Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF202020),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: (isIncome ? const Color(0xFF00C7BD) : const Color(0xFFEDFF5C)).withOpacity(0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isIncome ? 'TOTAL INCOME FOR MONTH' : 'TOTAL EXPENSES FOR MONTH',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${isIncome ? "+" : "-"}${totalSum.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: isIncome ? const Color(0xFF00C7BD) : const Color(0xFFEDFF5C),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Breakdown by category:',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),

              // Categories List
              Expanded(
                child: activeCategories.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pie_chart_outline_rounded,
                              size: 56,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No transactions for this period',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: 4.0,
                          bottom: widget.isEmbedded ? 120.0 : 20.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.15),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: List.generate(activeCategories.length, (index) {
                              final cat = activeCategories[index];
                              final sum = categorySums[cat.id] ?? 0.0;
                              return Column(
                                children: [
                                  CategoryTile(
                                    category: cat,
                                    isStandalone: false,
                                    trailing: Text(
                                      '${isIncome ? "+" : "-"}${sum.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: isIncome
                                            ? const Color(0xFF00C7BD) // Turquoise
                                            : const Color(0xFF202020), // Charcoal
                                      ),
                                    ),
                                  ),
                                  if (index < activeCategories.length - 1)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Divider(
                                        color: Color(0xFFF4F4F4),
                                        height: 1,
                                        thickness: 1,
                                      ),
                                    ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
