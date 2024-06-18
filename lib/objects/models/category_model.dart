import 'package:flutter/material.dart';
import 'package:money_tracking/objects/models/icon_type.dart';

class CategoryModel {
  final int id;
  final String name;
  final IconType iconType;
  final bool isIncome;
  final Color color;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconType,
    required this.isIncome,
    required this.color,
  });

  IconData? get icon => null;

  String getName() {
    return name;
  }

  Color getColor() {
    return color;
  }

  IconData getIcon() {
    return iconType.icon;
  }
}