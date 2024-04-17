import 'package:flutter/material.dart';

class DropdownIconContainer extends StatelessWidget {
  final bool isExpanded;
  final double containerHeight;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final Color selectedColor;
  final Color unselectedColor;
  final List<IconData> iconTypes;
  final Function(IconData) onIconSelected;
  final IconData? selectedIcon;
  final Color containerColor;

  const DropdownIconContainer({
    super.key,
    required this.isExpanded,
    required this.iconTypes,
    required this.onIconSelected,
    required this.selectedIcon,
    this.containerHeight = 150.0,
    this.crossAxisCount = 4,
    this.mainAxisSpacing = 5.0,
    this.crossAxisSpacing = 5.0,
    this.selectedColor = Colors.green,
    this.unselectedColor = Colors.grey,
    this.containerColor = Colors.white,
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
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
          ),
          itemCount: iconTypes.length,
          itemBuilder: (context, int i) {
            return GestureDetector(
              onTap: () => onIconSelected(iconTypes[i]),
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: selectedIcon == iconTypes[i]
                        ? selectedColor
                        : unselectedColor,
                  ),
                  color: selectedIcon == iconTypes[i]
                      ? selectedColor
                      : containerColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  iconTypes[i],
                  size: 30,
                ),
              ),
            );
          },
        ),
      ),
    )
        : Container();
  }
}
