import 'package:money_tracking/objects/dtos/category_dto.dart';

class Firebase {
  static final Firebase _firebase = Firebase._internal();

  factory Firebase() {
    return _firebase;
  }

  Firebase._internal();

  List<CategoryDTO> categoryList = [];
}