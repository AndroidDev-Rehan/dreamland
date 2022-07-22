

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamland/screens/AddJob.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ProductSelectionController extends GetxController{
  static List<ProductModel> allProducts = [];
  static RxList<String> selectedProducts = <String>[].obs;

  static Rx<String> searchedText = "".obs;

  static List<String> selectedProductIds = [];
  static Map<String,String> quantityMap = {};

  static minusProducts() async{

    for (int i=0; i<selectedProductIds.length; i++){
      await FirebaseFirestore.instance.collection("products").doc(selectedProductIds[i]).update(
          {
            "quantity" : quantityMap[selectedProductIds[i]]
          }
      );
    }
  }

}

