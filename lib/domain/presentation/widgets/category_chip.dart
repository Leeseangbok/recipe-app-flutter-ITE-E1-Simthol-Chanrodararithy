// lib/widgets/category_chip.dart
import 'package:flutter/material.dart';
import '../../../data/models/category.dart';

class CategoryChip extends StatelessWidget {
  final Category cat;
  final VoidCallback? onTap;

  const CategoryChip({super.key, required this.cat, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: cat.categoryThumb != null ? CircleAvatar(backgroundImage: NetworkImage(cat.categoryThumb!)) : null,
      label: Text(cat.category),
      onPressed: onTap,
    );
  }
}
