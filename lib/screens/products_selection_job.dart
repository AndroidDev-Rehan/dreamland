
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../products_selection_controller.dart';

import 'AddJob.dart';

class JobProductsSelection extends StatefulWidget {
  const JobProductsSelection({Key? key}) : super(key: key);

  @override
  State<JobProductsSelection> createState() => _JobProductsSelectionState();
}

class _JobProductsSelectionState extends State<JobProductsSelection> {

  String? selectedCategory;
  final List<CategoryOptions> _categoryOptions = [];

  // final List<String> selectedProducts = [];

  @override
  void initState(){
    super.initState();
    _categoryOptions.add(
         CategoryOptions(name: 'Furniture & Rug', value: 'furniture_rug'));
    _categoryOptions.add(
         CategoryOptions(name: 'Accessories', value: 'accessories'));
    _categoryOptions.add(
         CategoryOptions(name: 'Laminate', value: 'laminate'));
    _categoryOptions.add(
         CategoryOptions(name: 'Carpet + Lino', value: 'carpet'));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text("Products Selection"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: FutureBuilder(
          future: _getProducts(),
          builder: (context,snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text('Select Product Category'),
                      value: selectedCategory,
                      style: const TextStyle(color: Colors.black),
                      items: _categoryOptions.map((CategoryOptions value) {
                        return DropdownMenuItem<String>(
                          value: value.value,
                          child: Text(value.name),
                        );
                      }).toList(),
                      onChanged: (v) {
                        print(v);
                        setState(() {
                          selectedCategory = v;
                        });
                      },
                    )),
                const SizedBox(
                  height: 20,
                ),
                Obx(() => _buildSelectedProductsList()),
                const SizedBox(
                  height: 30,
                ),
                const Text("ADD PRODUCTS: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                const SizedBox(
                  height: 10,
                ),
                selectedCategory!=null ? TextFormField(
                  onChanged: (v){
                    ProductSelectionController.searchedText.value = v;
                  },
                  // controller: searchController,
                  decoration: InputDecoration(
                    label: const Text("Search Product"),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.brown),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.brown),
                        borderRadius: BorderRadius.circular(10)

                    ),
                    disabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.brown),
                        borderRadius: BorderRadius.circular(10)

                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.brown),
                        borderRadius: BorderRadius.circular(10)

                    ),

                  ),

                ) : SizedBox(),
                const SizedBox(
                  height: 10,
                ),

                Expanded(
                    child: ListView.builder(
                        itemCount: ProductSelectionController.allProducts.length,
                        itemBuilder: (context, index){

                          TextEditingController quantityController = TextEditingController();

                          if(ProductSelectionController.allProducts[index].category!=selectedCategory){
                            return const SizedBox();
                          }

                          if(ProductSelectionController.searchedText.value.isNotEmpty && (!(ProductSelectionController.allProducts[index].name.toString().toLowerCase().contains(ProductSelectionController.searchedText.value.toLowerCase()))) ){
                            return const SizedBox();
                          }

                          return Obx(() => Container(
                            child:
                            ProductSelectionController.searchedText.value.isNotEmpty && (!(ProductSelectionController.allProducts[index].name.toString().toLowerCase().contains(ProductSelectionController.searchedText.value.toLowerCase()))) ?
                            SizedBox() :
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(ProductSelectionController.allProducts[index].name ?? "",style: const TextStyle(color: Colors.black),),
                                  const Spacer(),
                                  InkWell(
                                      onTap: (){
                                        print(ProductSelectionController.allProducts[index].quantity);
                                        showDialog(context: context, builder: (context){
                                          return AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextFormField(
                                                  decoration: const InputDecoration(
                                                    label: Text("Enter Quantity"),
                                                    border: OutlineInputBorder(),
                                                    focusedBorder: OutlineInputBorder(),
                                                    disabledBorder: OutlineInputBorder(),
                                                    enabledBorder: OutlineInputBorder(),
                                                    isDense: true,
                                                    // contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: )
                                                  ),
                                                  controller: quantityController ,
                                                ),
                                                SizedBox(height: 10,),
                                                Text("Max Quantity is ${ProductSelectionController.allProducts[index].quantity ?? 0.0}")
                                              ],
                                            ),
                                            actions: [
                                              InkWell(

                                                  child: const Text("Cancel"),
                                              onTap: (){
                                                Navigator.pop(context);
                                              },
                                              ),
                                              const SizedBox(width: 30,),
                                              InkWell(
                                                  child: const Text("OK"),
                                              onTap: (){
                                                    if (quantityController.text.trim().isEmpty){
                                                      Fluttertoast.showToast(msg: "Enter Quantity");
                                                      return;
                                                    }
                                                    if ( double.parse(quantityController.text ?? "0.0") > double.parse(ProductSelectionController.allProducts[index].quantity ?? "0.0") ){
                                                      print("object");
                                                      Fluttertoast.showToast(msg: "Max Quantity is ${ProductSelectionController.allProducts[index].quantity ?? 0.0}");
                                                    }
                                                    else{
                                                      ProductSelectionController.selectedProducts.add((ProductSelectionController.allProducts[index].name ?? "") + " x ${quantityController.text}");
                                                      Fluttertoast.showToast(msg: "Product Added");
                                                      Navigator.pop(context);

                                                    }
                                              },
                                              ),
                                              SizedBox(width: 30,),

                                            ],
                                          );
                                        });

                                        // ProductSelectionController.selectedProducts.add(ProductSelectionController.allProducts[index].name ?? "");
                                        // setState((){});
                                      },
                                      child: const Icon(Icons.add, size: 30,)),
                                  const SizedBox(width: 20,),
                                ],
                              ),
                            ),
                          ));
                        }),
                ),


              ],
            );
          }
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: ElevatedButton(
              onPressed: (){
                Get.back();
              },
              child: const Text("         SAVE         "),
            ),
          )
        ],
      ),
    );
  }


  Future<void> _getProducts() async{
    print("get products called");
    if (ProductSelectionController.allProducts.isNotEmpty){
      print("filled already, returning");

      return;
    }
    QuerySnapshot<Map<String,dynamic>> snapshot = await FirebaseFirestore.instance.collection("products").get();
    print("docs length ${snapshot.docs.length}");

    ProductSelectionController.allProducts = snapshot.docs.map((QueryDocumentSnapshot<Map<String,dynamic>> snapshot) {
      Map a = snapshot.data();
      return ProductModel(id: a['id'],name: a['name'], quantity: a['quantity'], category: a["category"] ?? "");
    }).toList();

    print("all product array length: ${ProductSelectionController.allProducts.length}");
  }


  Widget _buildSelectedProductsList(){

    if (ProductSelectionController.selectedProducts.isEmpty){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text("Selected Products: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          SizedBox(height: 4,),
          Text("No Products Selected"),
        ],
      );
    }

    List<Text> texts = [];
    for (int i=0; i<ProductSelectionController.selectedProducts.length;i++){
      texts.add(Text( (i!=ProductSelectionController.selectedProducts.length-1) ? "${ProductSelectionController.selectedProducts[i]}, " : ProductSelectionController.selectedProducts[i]));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Selected Products: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
        const SizedBox(height: 4,),
        Wrap(
          alignment: WrapAlignment.start,
          children: texts,
        ),
      ],
    );
  }

}
