import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../objects/dtos/category_dto.dart';
import '../../objects/models/category_model.dart';
import '../database/database.dart';
import '../firebase/firebase.dart';
import '../../functions/getdata.dart';

class CategoryBUS {
  static void addCategoryToFirestore(CategoryModel category) {
    FirebaseFirestore.instance.collection('categories').orderBy('id', descending: true).limit(1).get().then((snapshot) {
      int maxId = snapshot.docs.first.data()['id'];
      int newId = maxId + 1;

      // Now use newId for the new category
      FirebaseFirestore.instance.collection('categories').add({
        'id': newId,
        'name': category.name,
        'iconID': category.iconType.id,
        'isIncome': category.isIncome,
        'red': category.color.red,
        'green': category.color.green,
        'blue': category.color.blue,
        'opacity': category.color.opacity,
        'userID': GetData.getUID(),
      }).then((_) {
        // Show success toast
        Fluttertoast.showToast(
            msg: "Category added successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
      });
      Database().updateCategoryListFromFirestore();
    });
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

  static void deleteCategoryFromFirestore(int categoryId) {
    FirebaseFirestore.instance.collection('categories')
        .where('id', isEqualTo: categoryId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    }).then((_) {
    // FirebaseFirestore.instance.collection('categories').doc(categoryId.toString()).delete().then((_) {
      Fluttertoast.showToast(
          msg: "Category deleted successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });
    Database().updateCategoryListFromFirestore();
  }

  static void editCategoryInFirestore(CategoryModel category) {
    FirebaseFirestore.instance.collection('categories')
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
  }
}