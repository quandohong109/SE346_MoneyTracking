import '../../../../../objects/models/category_model.dart';
import 'package:flutter/material.dart';
import 'category_widget.dart';

class CategoryListContainer extends StatelessWidget {
  final bool isExpanded;
  final Color containerColor;
  final List<CategoryModel> categories;
  final Function(CategoryModel) onCategoryTap;

  const CategoryListContainer({
    super.key,
    required this.isExpanded,
    this.containerColor = Colors.white,
    required this.categories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return isExpanded ? ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 300.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: categories.isEmpty
              ? const Center(child: Text("There is no category yet."))
              : Wrap(
            children: categories.map((category) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: CategoryWidget(
                  category: category,
                  onTap: () => onCategoryTap(category),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    )
        : Container();
  }
}