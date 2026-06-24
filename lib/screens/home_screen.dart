import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/finance_provider.dart';
import 'categories_screen.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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

  String _getEnglishWeekday(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }

  String _getEnglishMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final compareDate = DateTime(date.year, date.month, date.day);

    if (compareDate == today) {
      return 'Today';
    } else if (compareDate == yesterday) {
      return 'Yesterday';
    } else {
      final weekday = _getEnglishWeekday(date);
      final monthName = _getEnglishMonthName(date.month);
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
      extendBody: true, // Extends the body under the floating bottom navigation bar
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Persistent layout, tab-controlled
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          // Page 0: History (HomeScreen content wrapped in Stack to enable list scroll-under)
          _buildHistoryPage(context, provider, transactions, groupedTransactions, totalBalance, totalIncome, totalExpense),

          // Page 1: Categories
          const CategoriesScreen(),
        ],
      ),
      // FAB button floats above the persistent bottom nav bar, visible only on tab 0
      floatingActionButton: AnimatedScale(
        scale: _currentPage == 0 ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0, right: 4.0),
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
      ),
      // Persistent floating bottom navigation bar
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // History Tab Page with Scroll-Under Layout
  Widget _buildHistoryPage(
    BuildContext context,
    FinanceProvider provider,
    List<Transaction> transactions,
    Map<DateTime, List<Transaction>> groupedTransactions,
    double totalBalance,
    double totalIncome,
    double totalExpense,
  ) {
    // Calculate stats specifically for the current month
    final now = DateTime.now();
    final currentMonthTransactions = transactions.where((tx) =>
        tx.date.month == now.month && tx.date.year == now.year).toList();

    double monthBalance = 0.0;
    double monthIncome = 0.0;
    double monthExpense = 0.0;

    for (var tx in currentMonthTransactions) {
      if (tx.type == TransactionType.income) {
        monthBalance += tx.amount;
        monthIncome += tx.amount;
      } else {
        monthBalance -= tx.amount;
        monthExpense += tx.amount;
      }
    }

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          // 1. Scrollable List of Transactions Grouped by Day
          Positioned.fill(
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
                              'No transaction records',
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
                        padding: const EdgeInsets.only(
                          top: 200.0, // Height of card container (160 + top padding 16 + bottom padding 16 + 8px gap)
                          bottom: 120.0, // Bottom padding to clear nav bar
                        ),
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

                              // Consolidated Transactions Card for this day
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.24),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: List.generate(dayTransactions.length, (txIndex) {
                                    final tx = dayTransactions[txIndex];
                                    final isIncome = tx.type == TransactionType.income;

                                    return Column(
                                      children: [
                                        ListTile(
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
                                        // Divider between adjacent transactions of the same day
                                        if (txIndex < dayTransactions.length - 1)
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
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
          ),

          // 2. Floating Header Card (With colored shadow and transparent background)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.transparent, // Transparent background so list is visible in margins
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Container(
                height: 160,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF202020), // Charcoal container
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 20,
                    ),
                    // Beautiful colored shadow (glow using lime-yellow secondary color)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                    ),
                    // Extra strong shadow at the bottom for a strong 3D lift effect
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 10), // Strong shadow pushing up
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
                            'TOTAL BALANCE IN ${_getEnglishMonthName(now.month).toUpperCase()}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.55),
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${monthBalance >= 0 ? "" : "-"}${monthBalance.abs().toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                            // Income display (Increased sizes)
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_upward_rounded,
                                    size: 14,
                                    color: Color(0xFF00C7BD),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Income',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.55),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      monthIncome.toStringAsFixed(0),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(width: 24),
                            // Expense display (Increased sizes)
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_downward_rounded,
                                    size: 14,
                                    color: Color(0xFFEDFF5C),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Expenses',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.55),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      monthExpense.toStringAsFixed(0),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
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
          ),
        ),
          // 3. Opaque mask at the very top of the SafeArea to hide items scrolling above the card's top margin
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 16,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ],
      ),
    );
  }

  // Floating Bottom Tab Bar with highlighted active tab
  Widget _buildBottomNavBar(BuildContext context) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double pageOffset = 0.0;
        if (_pageController.hasClients) {
          pageOffset = _pageController.page ?? _currentPage.toDouble();
        } else {
          pageOffset = _currentPage.toDouble();
        }

        // Clamp values to prevent out-of-bounds index interpolation during overscroll
        final double categoryFactor = pageOffset.clamp(0.0, 1.0);
        final double historyFactor = (1.0 - pageOffset).clamp(0.0, 1.0);

        final categoryIconColor = Color.lerp(Colors.grey, const Color(0xFFEDFF5C), categoryFactor)!;
        final categoryBgColor = Color.lerp(Colors.transparent, const Color(0xFF202020), categoryFactor)!;

        final historyIconColor = Color.lerp(Colors.grey, const Color(0xFFEDFF5C), historyFactor)!;
        final historyBgColor = Color.lerp(Colors.transparent, const Color(0xFF202020), historyFactor)!;

        return Container(
          color: Colors.transparent, // Ensures the scaffold's bottom navbar area has no gray background
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 12),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                // Soft dark shadow going up to separate from list content
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
                // Soft dark shadow going down to give a 3D lift/floating effect
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Categories Tab
                GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                    );
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: categoryBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.grid_view_rounded,
                      color: categoryIconColor,
                      size: 22,
                    ),
                  ),
                ),

                // Central "Transactions" Tab (Active when history list is visible)
                GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                    );
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: historyBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      color: historyIconColor,
                      size: 22,
                    ),
                  ),
                ),

                // Charts Tab (Placeholder)
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bar_chart_rounded, color: Colors.grey, size: 24),
                ),
              ],
            ),
          ),
        );
      },
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
