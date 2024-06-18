import '../../objects/dtos/category_dto.dart';
import '../../objects/models/category_model.dart';
import '../database/database.dart';
import '../firebase/firebase.dart';
import '../../functions/getdata.dart';

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
        userID: GetData.getUID(),
      ),
    );
    Database().updateCategoryList();
  }
}

//Task: Push new categories to Firestore

//Task: Delete a category from Firestore