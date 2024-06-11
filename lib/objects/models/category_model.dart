import 'package:flutter/material.dart';

class CategoryModel {
  final int id;
  final String name;
  final IconData icon;
  final int type;
  final Color color;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
    required this.color,
  });

  String getName() {
    return name;
  }

  Color getColor() {
    return color;
  }

  IconData getIcon() {
    return icon;
  }
}