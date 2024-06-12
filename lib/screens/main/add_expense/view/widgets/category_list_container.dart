import '../../../../../models/category_model.dart';
import 'package:flutter/material.dart';
import 'category_widget.dart';

class CategoryListContainer extends StatelessWidget {
  final bool isExpanded;
  final double containerHeight;
  final Color containerColor;
  final List<CategoryModel> categories;
  final Function(CategoryModel) onCategoryTap;

  const CategoryListContainer({
    super.key,
    required this.isExpanded,
    this.containerHeight = 300.0,
    this.containerColor = Colors.white,
    required this.categories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return isExpanded ? Container(
      width: MediaQuery.of(context).size.width,
      height: containerHeight,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              child: CategoryWidget(
                category: categories[index],
                onTap: () => onCategoryTap(categories[index]),
              ),
            );
          },
        ),
      ),
    )
        : Container();
  }
}