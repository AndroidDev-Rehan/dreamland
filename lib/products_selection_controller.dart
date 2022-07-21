

import 'package:dreamland/screens/AddJob.dart';
import 'package:get/get.dart';

class ProductSelectionController extends GetxController{
  static List<ProductModel> allProducts = [];
  static RxList<String> selectedProducts = <String>[].obs;

}