import '../../objects/dtos/category_dto.dart';
import '../../objects/models/category_model.dart';
import '../database/database.dart';
import '../firebase/firebase.dart';

class CategoryBUS {
  static void addCategory(CategoryModel category) {
    Firebase().categoryList.add(
      CategoryDTO(
        id: category.id,
        name: category.name,
        iconID: category.iconType.id,
        isIncome: category.isIncome,
        red: category.color.red,
        green: category.color.green,
        blue: category.color.blue,
        opacity: category.color.opacity,
        userID: "abc",
      ),
    );
    Database().updateCategoryList();
  }
}