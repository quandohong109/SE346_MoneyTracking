import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../objects/dtos/category_dto.dart';
import '../../objects/models/category_model.dart';
import '../database/database.dart';
import '../firebase/firebase.dart';
import '../../functions/getdata.dart';

class CategoryBUS {
  static Future<void> addCategoryToFirestore(CategoryModel category) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('categories').orderBy('id', descending: true).limit(1).get();
      int newId = 1; // Default value
      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data() as Map<String, dynamic>;
        int maxId = data['id'];
        newId = maxId + 1;
      }

      // Now use newId for the new category
      await FirebaseFirestore.instance.collection('categories').add({
        'id': newId,
        'name': category.name,
        'iconID': category.iconType.id,
        'isIncome': category.isIncome,
        'red': category.color.red,
        'green': category.color.green,
        'blue': category.color.blue,
        'opacity': category.color.opacity,
        'userID': GetData.getUID(),
      });

      // Show success toast
      // Fluttertoast.showToast(
      //     msg: "Category added successfully",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.green,
      //     textColor: Colors.white,
      //     fontSize: 16.0
      // );

      await Database().updateCategoryListFromFirestore();
    } catch (e) {
      // If an error occurs, catch it and show an error toast
      throw Exception("An error occurred - Category: ${e.toString()}");
    }
  }

  static Future<void> addCategory(CategoryModel category) async {
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
    await addCategoryToFirestore(category);
    // await Database().updateCategoryList();
    // await Database().updateCategoryListFromFirestore();
  }

  static Future<void> deleteCategoryFromFirestore(int categoryId) async {
    try {
      await FirebaseFirestore.instance.collection('categories')
          .where('id', isEqualTo: categoryId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });

      await Database().updateCategoryListFromFirestore();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> editCategoryInFirestore(CategoryModel category) async {
    try {
      await FirebaseFirestore.instance.collection('categories')
          .where('id', isEqualTo: category.id)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({
            'name': category.name,
            'iconID': category.iconType.id,
            'isIncome': category.isIncome,
            'red': category.color.red,
            'green': category.color.green,
            'blue': category.color.blue,
            'opacity': category.color.opacity,
            'userID': GetData.getUID(),
          });
        }
      });
      // Fluttertoast.showToast(
      //     msg: "Category deleted successfully!",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0
      // );
      await Database().updateCategoryListFromFirestore();
    } catch (e) {
      // If an error occurs, catch it and show an error toast
      throw Exception("An error occurred - Category: ${e.toString()}");    
  }
}