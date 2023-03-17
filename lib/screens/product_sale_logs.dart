import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamland/Model/product_sale_log.dart';
import 'package:flutter/material.dart';

class ProductSaleLogs extends StatelessWidget {
  const ProductSaleLogs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products Sale Logs"),
      ),
      body: FutureBuilder(
          future:
              FirebaseFirestore.instance.collection('product_sale_logs').get(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List<ProductSaleLog> logsList = snapshot.data!.docs
                .map((e) => ProductSaleLog.fromJson(e.data()))
                .toList();

            if(logsList.isEmpty){
              print("isEmpty");
              return const Center(
                child: Text("Nothing to show :)", style: TextStyle(color: Colors.black, ),),
              );
            }

            return ListView.builder(
                itemCount: logsList.length,
                itemBuilder: (context, index) {
                  return _buildSingleLogTile(logsList[index]);
                });
          }),
    );
  }

  _buildSingleLogTile(ProductSaleLog productSaleLog) {
    return ListTile(
      title: Text(
          "${productSaleLog.userName} sold ${productSaleLog.quantitySold} ${productSaleLog.category} "),
    );
  }
}
