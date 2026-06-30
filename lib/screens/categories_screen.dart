import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/finance_provider.dart';
import '../widgets/category_tile.dart';

class CategoriesScreen extends StatefulWidget {
  final bool isEmbedded;
  final VoidCallback? onBack;

  const CategoriesScreen({
    super.key,
    this.isEmbedded = false,
    this.onBack,
  });

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  CategoryType _selectedType = CategoryType.expense;

  static const List<IconData> availableIcons = [
    Icons.restaurant,
    Icons.directions_car,
    Icons.lightbulb,
    Icons.movie,
    Icons.shopping_bag,
    Icons.flight,
    Icons.local_hospital,
    Icons.school,
    Icons.sports_esports,
    Icons.work,
    Icons.home,
    Icons.pets,
    Icons.fitness_center,
    Icons.card_giftcard,
    Icons.account_balance_wallet,
    Icons.computer,
    Icons.trending_up,
    Icons.attach_money,
    Icons.payment,
    Icons.music_note,
    Icons.spa,
    Icons.brush,
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
    Color(0xFFFF5C75),
    Color(0xFFFFB25C),
    Color(0xFF5CFFB2),
    Color(0xFF5CB8FF),
    Color(0xFFB25CFF),
    Color(0xFFEDFF5C),
    Color(0xFF5C6BFF),
    Color(0xFF90A4AE),
  ];

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

  void _showAddCategorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AddCategorySheet(
        parentContext: context,
        initialType: _selectedType,
        icons: availableIcons,
        colors: availableColors,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Read all categories from provider/model
    final provider = context.watch<FinanceProvider>();
    final List<Category> all = Category.allCategories;
    final List<Category> categories = all.where((c) => c.type == _selectedType).toList();

    return PopScope(
      canPop: !widget.isEmbedded,
      onPopInvoked: (didPop) {
        if (didPop) return;
        widget.onBack?.call();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Categories'),
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
                _buildTypeToggle(),
                const SizedBox(height: 20),
                const Text(
                  'Manage your categories:',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      top: 6.0,
                      bottom: widget.isEmbedded ? 140.0 : 80.0,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      return CategoryTile(
                        category: cat,
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: cat.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            cat.type.name.toUpperCase(),
                            style: TextStyle(
                              color: cat.color,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
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
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: widget.isEmbedded ? 90.0 : 16.0),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton.icon(
                onPressed: () => _showAddCategorySheet(context),
                icon: const Icon(Icons.add_rounded, color: Color(0xFF202020)),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 4,
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class AddCategorySheet extends StatefulWidget {
  final BuildContext parentContext;
  final CategoryType initialType;
  final List<IconData> icons;
  final List<Color> colors;

  const AddCategorySheet({
    super.key,
    required this.parentContext,
    required this.initialType,
    required this.icons,
    required this.colors,
  });

  @override
  State<AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<AddCategorySheet> {
  final TextEditingController _nameController = TextEditingController();
  late CategoryType _type;
  late IconData _selectedIcon;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
    _selectedIcon = widget.icons.first;
    _selectedColor = widget.colors.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter category name'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final id = 'custom_${name.toLowerCase().replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}';
    final category = Category(
      id: id,
      name: name,
      icon: _selectedIcon,
      color: _selectedColor,
      type: _type,
    );

    widget.parentContext.read<FinanceProvider>().addCategory(category);
    Navigator.pop(context);

    ScaffoldMessenger.of(widget.parentContext).showSnackBar(
      SnackBar(
        content: Text('Category "$name" created!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'New Category',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.white10, height: 24),

            // 1. Type selection toggle
            const Text(
              'Category Type',
              style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              height: 44,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _type = CategoryType.expense),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _type == CategoryType.expense
                              ? Colors.white.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Expense',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _type = CategoryType.income),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _type == CategoryType.income
                              ? Colors.white.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Income',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Name input
            const Text(
              'Category Name',
              style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter category name',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                fillColor: Colors.white.withOpacity(0.06),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Color selector
            const Text(
              'Select Color',
              style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.colors.length,
                itemBuilder: (context, index) {
                  final col = widget.colors[index];
                  final isSelected = col.value == _selectedColor.value;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = col),
                    child: Container(
                      width: 36,
                      height: 36,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: col,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white, size: 16)
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 4. Icon selector
            const Text(
              'Select Icon',
              style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 52,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.icons.length,
                itemBuilder: (context, index) {
                  final icon = widget.icons[index];
                  final isSelected = icon == _selectedIcon;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = icon),
                    child: Container(
                      width: 44,
                      height: 44,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? _selectedColor : Colors.white.withOpacity(0.06),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: isSelected ? Colors.white : Colors.white60,
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // 5. Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEDFF5C), // Lime Yellow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Create Category',
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
      ),
    );
  }
}
