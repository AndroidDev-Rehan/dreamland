import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamland/Model/product_sale_log.dart';
import 'package:flutter/material.dart';

class ProductSaleLogs extends StatelessWidget {
  const ProductSaleLogs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('product_sale_logs').get(),
        builder: (context,index) {
          return ListView.builder(

              itemBuilder: (context,index){

              }
              );
        }
      ),
    );
  }

  _buildSingleLogTile(ProductSaleLog productSaleLog){
    return ListTile(
      title: Text("${productSaleLog.userName} sold ${productSaleLog.quantitySold}"),
    );
  }

}
