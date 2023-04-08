import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamland/screens/UpdateProduct.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../Model/product_sale_log.dart';
import '../storage/SharedPref.dart';
import '../utils/global_functions.dart';
import 'AdminDashboard.dart';
import 'Products.dart';

class SpecificProductRemovalScreen extends StatefulWidget {
  var type;
  SpecificProductRemovalScreen({this.type});

  @override
  State<SpecificProductRemovalScreen> createState() => _SpecificProductRemovalScreenState();
}
class ProductList{
  var id;
  var name;
  var category;
  var price;
  var quantity;
  var packtype;
  var location;
  var code;
  var description;
  var imgOne;
  var imgTwo;
  var imgThree;

  ProductList({this.id, this.name, this.category, this.price, this.quantity,
    this.packtype, this.location,this.code,this.description, this.imgOne, this.imgTwo, this.imgThree});
}

class _SpecificProductRemovalScreenState extends State<SpecificProductRemovalScreen> {

  List<ProductList> productList = [];
  TextEditingController quantityController = new TextEditingController();
  TextEditingController searchController = new TextEditingController();


  getProducts() async {
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection('products');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    for(var a in querySnapshot.docs){
      if(a['category'] == widget.type){
        setState(() {
          productList.add(
            ProductList(
                id:a['id'],
                name:a['name'] ?? '',
                category:a['category'] ?? '',
                price:a['price'] ?? '',
                quantity:a['quantity'] ?? '',
                packtype:a['type'] ?? '',
                location:a['location'] ?? '',
                code: a['bar'] ?? '',
                description: a['description'] ?? '',
                imgOne:a['imageURL'] ?? '',
                imgTwo:a['imageURL2'] ?? '',
                imgThree:a['imageURL3'] ?? ''),
          );
        });
      }
    }
  }


  removeProductDialogue(String qty,String id, ProductList product){
    print("qty: $qty");
    showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (BuildContext ctx) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: AlertDialog(
              elevation: 10,
              content:  TextField(
                controller: quantityController,
                decoration: InputDecoration(
                  labelText: "Remaining Quantity $qty",),keyboardType: TextInputType.number,),
              actions: [
                TextButton(
                    onPressed: ()  {

                      if(double.parse(qty) > 0){
                        var total = double.parse(qty) -
                            double.parse(quantityController.text);
                        FirebaseFirestore.instance
                            .collection('products')
                            .doc(id)
                            .update({'quantity': total.toString()}).then(
                                (value) {
                          Navigator.pop(context);
                          setState(() {
                            productList.clear();
                            getProducts();
                          });
                        });
                        Get.snackbar("Success", "Product Removed",backgroundColor: Colors.white);
                        addLog(product,double.parse(quantityController.text).toInt());
                      }
                      else {
                        Get.snackbar("Error", "Not enough remaining quantity",backgroundColor: Colors.white);
                        // (SnackBar(content: Text()));
                      }                    },
                    child: const Text('Remove',style: TextStyle(color: Colors.brown),)),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close',style: TextStyle(color: Colors.brown)))
              ],
            ),
          );
        });

  }

  productCard(i){

    if(productList[i].name.toString().contains("LIDYA")){
      print("barcode is: ");
      print(productList[i].code.toString());
    }


    if (searchController.text.isEmpty || productList[i].name.toString().toLowerCase().contains(searchController.text.toLowerCase()) ||

        productList[i].code.toString().toLowerCase().contains(searchController.text.toLowerCase())

    || productList[i].code.toString() == searchController.text

    ) {
      return Card(
        elevation: 5,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.network(
                    productList[i].imgOne.toString().isEmpty
                        ? "https://www.oberlo.com/media/1603957118-winning-products.jpg?fit=max&fm=jpg&w=1824"
                        : productList[i].imgOne,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name : ' + productList[i].name),
                      Text('Quantity : ' + productList[i].quantity),
                      Text('Price : ' + productList[i].price),
                      Text('Location : ' + productList[i].location),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Barcode : '),
                          Text((productList[i].code.toString().isEmpty ? "EMPTY" : productList[i].code),
                            style: TextStyle(color: productList[i].code.toString().isEmpty ? Colors.red : null),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     quantityDialog('0.0', productList[i].id);
                    //   },
                    //   child: Text(
                    //     'Set Quantity',
                    //     style:
                    //     TextStyle(color: Colors.white, fontSize: 15),
                    //   ),
                    // ),
                    ElevatedButton(
                      onPressed: () async {
                        removeProductDialogue(
                            productList[i].quantity, productList[i].id, productList[i]);
                      },
                      child: const Text(
                        'Remove Product',
                        style:
                        TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    // Flexible(
                    //   child: ElevatedButton(
                    //     onPressed: () async {
                    //       // Get.to(UpdateProduct(plist: productList[i]));
                    //     },
                    //     child: Text(
                    //       'Update Product',
                    //       style: TextStyle(
                    //           color: Colors.white, fontSize: 15),
                    //     ),
                    //   ),
                    // ),
                  ],
                ))
          ],
        ),
      );
    }

    return SizedBox();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true,
            backgroundColor: Colors.brown,
            leading: InkWell(
                onTap: (){
                  Get.off(const AdminDashboard());
                },
                child: const Icon(Icons.arrow_back)),
            title: TextField(
              controller: searchController,
              onChanged: (v){
                setState((){});
              },
              style: const TextStyle(color: Colors.white,fontSize: 16),
              decoration: const InputDecoration(hintText: 'Search Here',hintStyle: TextStyle(color: Colors.white,fontSize: 16),border: InputBorder.none),
            ),
          actions: [
            InkWell(
                onTap: () async{
                  try{
                    String result = await FlutterBarcodeScanner.scanBarcode("black", "Cancel", true, ScanMode.BARCODE);
                    if(result!='-1')
                    {
                      searchController.text = result;
                      setState(() {});
                    }
                  }
                  catch(e){
                    print(e);
                  }
                  // print("result: $result");

                },
                child: const Icon(Icons.qr_code, size: 30,)),
            20.horizontalSpace,
          ]


        ),

        body:Container(
            color: Colors.white,
            child: ListView.builder(
                itemCount: productList.length,
                itemBuilder: (BuildContext ctx,int i){
                  return productCard(i);
                })
        ));
  }


  Future<void> addLog(ProductList product, int quantity) async{
    Map<String,dynamic> userMap = await getMyUserMap(FirebaseAuth.instance.currentUser!.uid);
    String uuid = Uuid().v4();
    ProductSaleLog productSaleLog = ProductSaleLog(userId: FirebaseAuth.instance.currentUser!.uid, userName: userMap['name'], quantitySold: quantity, dateTime: DateTime.now(), category: product.category,saleId: uuid, productName: product.name,);
    await FirebaseFirestore.instance.collection("product_sale_logs").add(productSaleLog.toJson());
    return;
  }



}
