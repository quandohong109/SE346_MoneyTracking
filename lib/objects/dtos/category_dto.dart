class CategoryDTO {
  final int id;
  final String name;
  final int icon;
  final int type;
  final int red;
  final int green;
  final int blue;
  final int opacity;
  final String userID;

  CategoryDTO({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
    required this.red,
    required this.green,
    required this.blue,
    required this.opacity,
    required this.userID,
  });
}