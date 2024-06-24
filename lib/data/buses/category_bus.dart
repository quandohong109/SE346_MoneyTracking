import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_tracking/functions/custom_exception.dart';

import '../../objects/dtos/category_dto.dart';
import '../../objects/models/category_model.dart';
import '../database/database.dart';
import '../firebase/firebase.dart';
import '../../functions/getdata.dart';

class CategoryBUS {
  static Future<void> addCategory(CategoryModel category) async {
    try {
      if (Database().categoryList.any((existingCategory) => existingCategory.name == category.name)) {
        throw CustomException('Category name already exists');
      }
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(
          'categories').orderBy('id', descending: true).limit(1).get();
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
      await Database().updateCategoryListFromFirestore();
    } on Exception {
      rethrow;
    }
  }

  static Future<void> deleteCategory(int categoryId) async {
    try {
      QuerySnapshot transactionSnapshot = await FirebaseFirestore.instance.collection('transactions')
          .where('categoryId', isEqualTo: categoryId)
          .get();
      if (transactionSnapshot.docs.isNotEmpty) {
        throw Exception("Category is in use");
      }
      await FirebaseFirestore.instance.collection('categories')
          .where('id', isEqualTo: categoryId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
      await Database().updateCategoryListFromFirestore();
    } on Exception {
      rethrow;
    }
  }

  static Future<void> updateCategory(CategoryModel category) async {
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
    } on Exception {
      rethrow;
    }
  }
}