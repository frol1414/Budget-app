import 'package:flutter/material.dart';

enum CategoryType {
  income,
  expense,
}

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final CategoryType type;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });

  // Predefined categories
  static const List<Category> expenseCategories = [
    Category(
      id: 'food',
      name: 'Food',
      icon: Icons.restaurant,
      color: Colors.amber,
      type: CategoryType.expense,
    ),
    Category(
      id: 'transport',
      name: 'Transport',
      icon: Icons.directions_car,
      color: Colors.blue,
      type: CategoryType.expense,
    ),
    Category(
      id: 'utilities',
      name: 'Utilities',
      icon: Icons.lightbulb,
      color: Colors.orange,
      type: CategoryType.expense,
    ),
    Category(
      id: 'entertainment',
      name: 'Entertainment',
      icon: Icons.movie,
      color: Colors.purple,
      type: CategoryType.expense,
    ),
    Category(
      id: 'shopping',
      name: 'Shopping',
      icon: Icons.shopping_bag,
      color: Colors.pink,
      type: CategoryType.expense,
    ),
  ];

  static const List<Category> incomeCategories = [
    Category(
      id: 'salary',
      name: 'Salary',
      icon: Icons.account_balance_wallet,
      color: Colors.green,
      type: CategoryType.income,
    ),
    Category(
      id: 'freelance',
      name: 'Freelance',
      icon: Icons.computer,
      color: Colors.teal,
      type: CategoryType.income,
    ),
    Category(
      id: 'investment',
      name: 'Investments',
      icon: Icons.trending_up,
      color: Colors.indigo,
      type: CategoryType.income,
    ),
  ];

  static const List<Category> allCategories = [
    ...expenseCategories,
    ...incomeCategories,
  ];

  static Category getById(String id) {
    return allCategories.firstWhere(
      (cat) => cat.id == id,
      orElse: () => Category(
        id: id,
        name: id,
        icon: Icons.payment,
        color: Colors.grey,
        type: CategoryType.expense,
      ),
    );
  }
}
