import '../../../../../objects/models/category_model.dart';
import 'package:flutter/material.dart';

import '../category/edit_category_screen.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const CategoryWidget({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: category.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              category.iconType.icon,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                category.name,
                style: const TextStyle(
                    fontSize: 20
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => EditCategoryScreen.newInstance(category),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}