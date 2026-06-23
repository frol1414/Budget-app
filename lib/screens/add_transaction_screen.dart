import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../providers/finance_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TransactionType _selectedType = TransactionType.expense; // Expense by default

  void _showNumericKeypad(BuildContext context, Category category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => NumericKeypadSheet(
        category: category,
        transactionType: _selectedType,
        parentContext: context,
      ),
    );
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
                  'Расход',
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
                  'Доход',
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

  @override
  Widget build(BuildContext context) {
    final categories = _selectedType == TransactionType.expense
        ? Category.expenseCategories
        : Category.incomeCategories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Категория'),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              onPressed: () => Navigator.pop(context),
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
              // 1. Selector Income/Expense
              _buildTypeToggle(),
              const SizedBox(height: 20),

              const Text(
                'Выберите категорию транзакции:',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),

              // 2. Categories List (Rounded color block full width)
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return GestureDetector(
                      onTap: () => _showNumericKeypad(context, cat),
                      child: Container(
                        height: 74,
                        margin: const EdgeInsets.symmetric(vertical: 6.0),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: cat.color, // Full width colored block
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: cat.color.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                cat.icon,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              cat.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Numeric Keypad Bottom Sheet Widget
class NumericKeypadSheet extends StatefulWidget {
  final Category category;
  final TransactionType transactionType;
  final BuildContext parentContext;

  const NumericKeypadSheet({
    super.key,
    required this.category,
    required this.transactionType,
    required this.parentContext,
  });

  @override
  State<NumericKeypadSheet> createState() => _NumericKeypadSheetState();
}

class _NumericKeypadSheetState extends State<NumericKeypadSheet> {
  String _amountStr = '0';
  DateTime _selectedDate = DateTime.now();

  void _onKeyPress(String key) {
    setState(() {
      if (key == '⌫') {
        if (_amountStr.length > 1) {
          _amountStr = _amountStr.substring(0, _amountStr.length - 1);
        } else {
          _amountStr = '0';
        }
      } else if (key == '.') {
        if (!_amountStr.contains('.')) {
          _amountStr += '.';
        }
      } else {
        if (_amountStr == '0') {
          _amountStr = key;
        } else {
          // Limit decimal points
          if (_amountStr.contains('.')) {
            final parts = _amountStr.split('.');
            if (parts[1].length >= 2) return;
          }
          // Limit max length
          if (_amountStr.length >= 10) return;
          _amountStr += key;
        }
      }
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF202020),
              onPrimary: Colors.white,
              onSurface: Color(0xFF202020),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDateDisplay() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final compareDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

    if (compareDate == today) {
      return 'Сегодня';
    } else if (compareDate == yesterday) {
      return 'Вчера';
    } else {
      final day = _selectedDate.day.toString().padLeft(2, '0');
      final month = _selectedDate.month.toString().padLeft(2, '0');
      final year = _selectedDate.year.toString();
      return '$day.$month.$year';
    }
  }

  void _submit() {
    final amount = double.tryParse(_amountStr) ?? 0.0;
    if (amount <= 0.0) {
      ScaffoldMessenger.of(widget.parentContext).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, введите сумму больше 0'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final now = DateTime.now();
    final transactionDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      now.hour,
      now.minute,
      now.second,
    );

    final tx = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: widget.category,
      type: widget.transactionType,
      amount: amount,
      date: transactionDate,
    );

    widget.parentContext.read<FinanceProvider>().addTransaction(tx);

    // Close bottom sheet
    Navigator.pop(context);
    // Close AddTransactionScreen
    Navigator.pop(widget.parentContext);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 24,
        right: 24,
        bottom: 24 + bottomInset,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF202020),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 18),

          // Badge and result view
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(widget.category.icon, color: widget.category.color, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      widget.category.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      '$_amountStr \$',
                      style: const TextStyle(
                        color: Color(0xFFEDFF5C), // Lime Yellow text for amount
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 24),

          // Date selection
          GestureDetector(
            onTap: _selectDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, color: Colors.grey, size: 14),
                      const SizedBox(width: 8),
                      Text(
                        'Дата: ${_formatDateDisplay()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Изменить',
                    style: TextStyle(
                      color: Color(0xFF00C7BD),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Keypad (3x4 Grid)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', '⌫'];
              final keyLabel = keys[index];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _onKeyPress(keyLabel),
                  borderRadius: BorderRadius.circular(16),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: keyLabel == '⌫'
                          ? const Icon(Icons.backspace_rounded, color: Colors.white, size: 18)
                          : Text(
                              keyLabel,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // Submit action
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEDFF5C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Внести запись',
                style: TextStyle(
                  color: Color(0xFF202020),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
