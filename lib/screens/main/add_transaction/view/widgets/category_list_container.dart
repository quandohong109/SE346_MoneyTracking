import '../../../../../objects/models/category_model.dart';
import 'package:flutter/material.dart';
import 'category_widget.dart';

class CategoryListContainer extends StatelessWidget {
  final bool isExpanded;
  final Color containerColor;
  final List<CategoryModel> categories;
  final Function(CategoryModel) onCategoryTap;
  final VoidCallback onEditTap;

  const CategoryListContainer({
    super.key,
    required this.isExpanded,
    this.containerColor = Colors.white,
    required this.categories,
    required this.onCategoryTap,
    required this.onEditTap
  });

  @override
  Widget build(BuildContext context) {
    return isExpanded ?
    categories.isEmpty
        ? Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        color: containerColor,
        child: const Center(child: Text("There is no category yet.")))
        : ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 300.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15.0)
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: categories.map((category) {
              return CategoryWidget(
                category: category,
                onTap: () => onCategoryTap(category),
                onEdit: () => onEditTap(),
              );
            }).toList(),
          ),
        ),
      ),
    )
        : Container();
  }
}