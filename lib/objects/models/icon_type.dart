import 'package:flutter/material.dart';

class IconType {
  final int id;
  final IconData icon;

  IconType({
    required this.id,
    required this.icon
  });

  IconData getIcon() {
    return icon;
  }
}