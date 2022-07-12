import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamland/screens/UpdateProduct.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Products.dart';

class ViewProducts extends StatefulWidget {
  var type;
  ViewProducts({this.type});

  @override
  State<ViewProducts> createState() => _ViewProductsState();
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
class _ViewProductsState extends State<ViewProducts> {

  List<ProductList> productList = [];
  TextEditingController quantityController = new TextEditingController();
  getProducts() async {
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection('products');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    for(var a in querySnapshot.docs){
      if(a['category'] == widget.type){
        setState(() {
          productList.add(ProductList(
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
              imgThree:a['imageURL3'] ?? ''));
        });
      }
    }
  }


  quantityDialog(qty,id){
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
          labelText: qty == '0.0' ? 'Add Quantity' : qty,),keyboardType: TextInputType.number,),
              actions: [
                TextButton(
                    onPressed: ()  {
                        var total = double.parse(qty) + double.parse(quantityController.text);
                        FirebaseFirestore.instance.collection('products').doc(id).
                        update({'quantity': total.toString()})
                        .then((value) {
                          Navigator.pop(context);
                          setState(() {
                            productList.clear();
                            getProducts();
                          });


                        });

                    },
                    child: const Text('Save',style: TextStyle(color: Colors.brown),)),
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
    return Card(
      elevation: 5,
      child: Column(
        children: [
          Row(
            children: [
              Image.network(productList[i].imgOne,height: 100,width: 100,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text('Name : '+productList[i].name),
                Text('Quantity : '+productList[i].quantity),
                Text('Price : '+productList[i].price),
                Text('Location : '+productList[i].location),

              ],)
            ],
          ),
          Padding(padding: EdgeInsets.only(left: 5,right: 5),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RaisedButton(onPressed: () async {
                quantityDialog('0.0',productList[i].id);
              },
                color: Colors.brown,
                child: Text('Set Quantity',style: TextStyle(color: Colors.white,fontSize: 15),),
              ),
              RaisedButton(onPressed: () async {
                quantityDialog(productList[i].quantity,productList[i].id);
              },
                color: Colors.brown,
                child: Text('Update Quantity',style: TextStyle(color: Colors.white,fontSize: 15),),
              ),
              RaisedButton(onPressed: () async {
                Get.to(UpdateProduct(plist: productList[i]));
              },
                color: Colors.brown,
                child: Text('Update Product',style: TextStyle(color: Colors.white,fontSize: 15),),
              ),
            ],
          )
          )
        ],
      ),
    );
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

        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Get.to(()=>Products());
            },
            icon: Icon(Icons.arrow_back,color: Colors.white,),
          ),

          centerTitle: true,
          backgroundColor: Colors.brown,
          title: Text('Products'),),
        body:Container(
            color: Colors.white,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: productList.length,
                itemBuilder: (BuildContext ctx,int i){
                  return productCard(i);
                })
        ));
  }
}
