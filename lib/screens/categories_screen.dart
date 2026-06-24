import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/finance_provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  CategoryType _selectedType = CategoryType.expense;

  static const List<IconData> availableIcons = [
    Icons.restaurant_rounded,
    Icons.directions_car_rounded,
    Icons.lightbulb_rounded,
    Icons.movie_rounded,
    Icons.shopping_bag_rounded,
    Icons.flight_rounded,
    Icons.healing_rounded,
    Icons.school_rounded,
    Icons.sports_esports_rounded,
    Icons.work_rounded,
    Icons.account_balance_wallet_rounded,
    Icons.card_giftcard_rounded,
  ];

  static const List<Color> availableColors = [
    Colors.amber,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.green,
    Colors.teal,
    Colors.indigo,
    Colors.red,
    Colors.cyan,
    Colors.deepPurple,
    Colors.lime,
  ];

  void _showAddCategorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _AddCategorySheet(
        onAdd: (category) {
          context.read<FinanceProvider>().addCategory(category);
        },
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
              onTap: () => setState(() => _selectedType = CategoryType.expense),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _selectedType == CategoryType.expense
                      ? const Color(0xFF202020)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Expense',
                  style: TextStyle(
                    color: _selectedType == CategoryType.expense
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
              onTap: () => setState(() => _selectedType = CategoryType.income),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _selectedType == CategoryType.income
                      ? const Color(0xFF202020)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Income',
                  style: TextStyle(
                    color: _selectedType == CategoryType.income
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
    final provider = context.watch<FinanceProvider>();
    final categories = provider.categories
        .where((cat) => cat.type == _selectedType)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Inside tab navigation, no leading arrow
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildTypeToggle(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 6.0, bottom: 120.0),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
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
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: cat.color.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          cat.icon,
                          color: cat.color,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        cat.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF202020),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 96.0), // Padding to clear bottom nav bar (68 + 24 + safeArea = 96 approx)
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => _showAddCategorySheet(context),
            icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF202020), size: 20),
            label: const Text(
              'Add Category',
              style: TextStyle(
                color: Color(0xFF202020),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEDFF5C), // Lime Yellow
              elevation: 4,
              shadowColor: const Color(0xFFEDFF5C).withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddCategorySheet extends StatefulWidget {
  final Function(Category) onAdd;

  const _AddCategorySheet({required this.onAdd});

  @override
  State<_AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<_AddCategorySheet> {
  final TextEditingController _nameController = TextEditingController();
  CategoryType _type = CategoryType.expense;
  IconData _selectedIcon = _CategoriesScreenState.availableIcons.first;
  Color _selectedColor = _CategoriesScreenState.availableColors.first;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter category name')),
      );
      return;
    }

    final id = name.toLowerCase().replaceAll(' ', '_');
    final category = Category(
      id: id,
      name: name,
      icon: _selectedIcon,
      color: _selectedColor,
      type: _type,
    );

    widget.onAdd(category);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: 24 + bottomPadding,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF202020), // Charcoal background
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'New Category',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white54, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Category Name Input
          TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Category Name',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.08),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFEDFF5C), width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 16),
          // Category Type Select
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Text('Expense'),
                  selected: _type == CategoryType.expense,
                  onSelected: (val) => setState(() => _type = CategoryType.expense),
                  labelStyle: TextStyle(
                    color: _type == CategoryType.expense ? const Color(0xFF202020) : Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                  selectedColor: const Color(0xFFEDFF5C), // Lime Yellow
                  backgroundColor: Colors.white.withOpacity(0.08),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  showCheckmark: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ChoiceChip(
                  label: const Text('Income'),
                  selected: _type == CategoryType.income,
                  onSelected: (val) => setState(() => _type = CategoryType.income),
                  labelStyle: TextStyle(
                    color: _type == CategoryType.income ? Colors.white : Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                  selectedColor: const Color(0xFF00C7BD), // Turquoise
                  backgroundColor: Colors.white.withOpacity(0.08),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  showCheckmark: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Icon Selection
          const Text(
            'Select Icon',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _CategoriesScreenState.availableIcons.length,
              itemBuilder: (context, index) {
                final icon = _CategoriesScreenState.availableIcons[index];
                final isSelected = icon == _selectedIcon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: Container(
                    width: 44,
                    height: 44,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFEDFF5C) : Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? const Color(0xFF202020) : Colors.white,
                      size: 20,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // Color Selection
          const Text(
            'Select Color',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _CategoriesScreenState.availableColors.length,
              itemBuilder: (context, index) {
                final color = _CategoriesScreenState.availableColors[index];
                final isSelected = color == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected ? Border.all(color: Colors.white, width: 2.5) : null,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          // Create button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _type == CategoryType.expense ? const Color(0xFFEDFF5C) : const Color(0xFF00C7BD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Create Category',
                style: TextStyle(
                  color: _type == CategoryType.expense ? const Color(0xFF202020) : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
