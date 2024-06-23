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
      final categories = await FirebaseFirestore.instance
          .collection('categories')
          .orderBy('id', descending: true)
          .limit(1)
          .get();

      int maxId = categories.docs.first.data()['id'];
      int newId = maxId + 1;

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

      await Database().updateCategoryListFromFirestore();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

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
    addCategoryToFirestore(category);
    // Database().updateCategoryList();
    // Database().updateCategoryListFromFirestore();
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

      await Database().updateCategoryListFromFirestore();
    }
    catch (e) {
      throw Exception(e.toString());
    }
  }
}