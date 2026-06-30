import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isStandalone;

  const CategoryTile({
    super.key,
    required this.category,
    this.onTap,
    this.trailing,
    this.isStandalone = true,
  });

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: category.color.withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(
          category.icon,
          color: category.color,
          size: 20,
        ),
      ),
      title: Text(
        category.name,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Color(0xFF202020),
        ),
      ),
      trailing: trailing ?? const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Color(0xFF202020),
        size: 16,
      ),
    );

    if (!isStandalone) {
      return tile;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
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
      child: tile,
    );
  }
}
