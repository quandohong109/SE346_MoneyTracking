import 'package:money_tracking/screens/main/add_transaction/view/category/category_screen.dart';

import '../../../../../objects/models/category_model.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const CategoryWidget({
    super.key,
    required this.onEdit,
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
            color: Colors.black,
            width: 1,
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
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          CategoryScreen.newInstanceWithCategory(category: category)
                  ),
                );
                onEdit();
              },
            ),
          ],
        ),
      ),
    );
  }
}