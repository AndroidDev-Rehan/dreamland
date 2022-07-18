import 'package:dreamland/screens/AddProduct.dart';
import 'package:dreamland/screens/ViewProducts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../storage/SharedPref.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}
class ProductCategory{
  var name;
  var value;
  var img;
  ProductCategory({this.name,this.value,this.img});
}
class _ProductsState extends State<Products> {

  List<ProductCategory> productCategory = [];

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      productCategory.add(ProductCategory(name: 'Premium Furniture',value: 'furniture_rug',img: 'https://rajafareed.com/furniture.jpg'));
      productCategory.add(ProductCategory(name: 'Accessories',value: 'accessories',img: 'https://rajafareed.com/screw.jpg'));
      productCategory.add(ProductCategory(name: 'Laminate Flooring + Rugs',value: 'laminate',img: 'https://rajafareed.com/plank.jpg'));
      productCategory.add(ProductCategory(name: 'Carpet',value: 'carpet',img: 'https://rajafareed.com/carpet.jpg'));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          centerTitle: true,
          backgroundColor: Colors.brown,
          title: Text('Products'),),
        body:Padding(padding: EdgeInsets.all(10),
    child: ListView.builder(
    shrinkWrap: true,
    itemCount: productCategory.length,
    itemBuilder: (BuildContext ctx,int i){
      return Card(
        elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 1,),
            Column(
              children: [

                Text(productCategory[i].name,style: TextStyle(fontSize: 20,color: Colors.brown,fontWeight: FontWeight.bold),),
                Row(children: [
                  RaisedButton(onPressed: () async {
                    if(Constants.role=="1"){
                                          Get.to(AddProduct(
                                              category:
                                                  productCategory[i].value));
                                        }
                                      },
                    color: Constants.role=="1" ? Colors.brown : Colors.grey.withOpacity(0.3),
                    child: Text('Add',style: TextStyle(color: Colors.white,fontSize: 15),),
                  ),
                  SizedBox(width: 5,),
                  RaisedButton(onPressed: () async {
                    Get.to(ViewProducts(type: productCategory[i].value));
                  },
                    color: Colors.brown,
                    child: Text('View',style: TextStyle(color: Colors.white,fontSize: 15),),
                  ),
                ],)
              ],
            ),
            Padding(padding: EdgeInsets.all(10),child:Image.network(productCategory[i].img,height: 100,width: 100,fit: BoxFit.fill,)),
            SizedBox(width: 10,)
          ],
        ),
      ],
      ),
      );
    })
    
    )
    );
  }
}
