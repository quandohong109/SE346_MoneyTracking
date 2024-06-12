class CategoryDTO {
  final int id;
  final String name;
  final int iconID;
  final int type;
  final int red;
  final int green;
  final int blue;
  final double opacity;
  final String userID;

  CategoryDTO({
    required this.id,
    required this.name,
    required this.iconID,
    required this.type,
    required this.red,
    required this.green,
    required this.blue,
    required this.opacity,
    required this.userID,
  });
}