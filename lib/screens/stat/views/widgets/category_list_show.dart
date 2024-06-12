import 'package:flutter/cupertino.dart';
import 'package:money_tracking/screens/stat/views/widgets/category_widget.dart';
import '../../../../objects/models/category_model.dart';
import 'package:flutter/material.dart';


class CategoryListShow extends StatelessWidget {
  final double containerHeight;
  final Color containerColor;
  final List<CategoryModel> categories;
  final Function(CategoryModel) onCategoryTap;
  const CategoryListShow({
    super.key,
    this.containerHeight = 300.0,
    this.containerColor = Colors.white,
    required this.categories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: containerHeight,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(5),
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
    );
  }
}