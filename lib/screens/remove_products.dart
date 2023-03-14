import 'package:dreamland/screens/remove_specific_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../storage/SharedPref.dart';
import 'Products.dart';

class ProductsRemovalScreen extends StatefulWidget {
  const ProductsRemovalScreen({Key? key}) : super(key: key);

  @override
  State<ProductsRemovalScreen> createState() => _ProductsRemovalScreenState();
}


class _ProductsRemovalScreenState extends State<ProductsRemovalScreen> {

  List<ProductCategory> productCategory = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      productCategory.add(ProductCategory(name: 'Premium Furniture',value: 'furniture_rug',img: 'https://rajafareed.com/furniture.jpg'));
      productCategory.add(ProductCategory(name: 'Accessories',value: 'accessories',img: 'https://rajafareed.com/screw.jpg'));
      productCategory.add(ProductCategory(name: 'Laminate Flooring + Rugs',value: 'laminate',img: 'https://rajafareed.com/plank.jpg'));
      productCategory.add(ProductCategory(name: 'Carpet + Lino',value: 'carpet',img: 'https://rajafareed.com/carpet.jpg'));
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(productCategory[i].name,style: TextStyle(fontSize: 20,color: Colors.brown,fontWeight: FontWeight.bold),),
                                  ElevatedButton(onPressed: () async {
                                    if(Constants.role=="1"){
                                      Get.to(SpecificProductRemovalScreen(type: productCategory[i].value));
                                    }
                                  },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Constants.role=="1" ? Colors.brown : Colors.grey.withOpacity(0.3)
                                    ),
                                    child: Text('View',style: TextStyle(color: Colors.white,fontSize: 15),),
                                  )
                                ],
                              ),
                            ),
                            Padding(padding: const EdgeInsets.all(10),child:Image.network(productCategory[i].img,height: 100,width: 100,fit: BoxFit.fill,)),
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
