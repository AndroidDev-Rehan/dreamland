
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  var category;
  AddProduct({this.category});
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  File imgOne = new File('');
  File imgTwo = new File('');
  File imgThree = new File('');
  var imgURLOne ,imgURLTwo,imgURLThree;
  TextEditingController nameController = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController barcodeController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  List<File> imgPaths = [];
  List<String> imgURLs = [];

  FirebaseStorage storage = FirebaseStorage.instance;
  late Reference ref;
  bool isUploading = false;


  Future uploadMultipleImages(name,quantity,price,barcode,location,description) async {

    List<String> _imageUrls = [];

    try {
      for (int i = 0; i < imgPaths.length; i++) {
        final Reference storageReference = FirebaseStorage.instance.ref().child("imageone/$i");
      if(imgPaths[i].existsSync()) {
        final UploadTask uploadTask = storageReference.putFile(imgPaths[i]);

        await uploadTask.whenComplete(() async {
          String imageUrl = await storageReference.getDownloadURL();
          _imageUrls.add(imageUrl); //all all the urls to the list
        });
      }

      }
      //upload the list of imageUrls to firebase as an array
      String id = FirebaseFirestore.instance.collection('products').doc().id;

        var collection = FirebaseFirestore.instance
            .collection('products')
            .id;
        FirebaseFirestore.instance
            .collection('products')
            .doc(id)
            .set({
          'id': id,
          'name': name,
          'price': price,
          'quantity': quantity,
          'type': widget.category == 'carpet' ? 'Meters' : 'Boxes',
          'location': location,
          'description': description,
          'category': widget.category,
          'bar': barcode,
          'imageURL': _imageUrls.length > 0 ? _imageUrls[0] : '',
          'imageURL2': _imageUrls.length > 1 ? _imageUrls[1] : '',
          'imageURL3': _imageUrls.length > 2 ? _imageUrls[2] : '',
          'createdAt': DateTime.now().toString()
          //'uid':user.uid
        })
            .then((value) {


          //  Navigator.pop(context);
          Fluttertoast.showToast(
              msg: 'Product Added',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.brown,
              textColor: Colors.white,
              fontSize: 16.0
          );
          Navigator.pop(context);
          print('success');
        }).catchError((err) {
          Fluttertoast.showToast(
              msg: err.message!,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.brown,
              textColor: Colors.white,
              fontSize: 16.0
          );
          print(err);
        });
      setState(() {
        isUploading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  uploadImage(var iOne,var iTwo,var iThree,name,quantity,price,barcode,location,description) async {





    if(iOne){
      FirebaseStorage storage1 = FirebaseStorage.instance;
      Reference ref1 = storage1.ref().child("image1/");
      UploadTask uploadTask1 = ref1.putFile(imgOne);
      await uploadTask1.then((res1) async {
      var i1 = await res1.ref.getDownloadURL();
          setState(() {
          imgURLOne =  i1;
          print(imgURLOne);
          });
      });
    }
    if(iTwo){
      FirebaseStorage storage2 = FirebaseStorage.instance;

      Reference ref2 = storage2.ref().child("image1/");
      UploadTask uploadTask2 = ref2.putFile(imgTwo);
      await uploadTask2.then((res2) async {
        var i2 = await res2.ref.getDownloadURL();
        setState(() {
          imgURLTwo = i2;
        });
      });
    }

    if(iThree){
      FirebaseStorage storage3 = FirebaseStorage.instance;
      Reference ref3 = storage3.ref().child("image1/");
      UploadTask uploadTask3 = ref3.putFile(imgThree);
     await uploadTask3.then((res3) async{
        var i3 = await res3.ref.getDownloadURL();
        setState(() {
          imgURLThree = i3;
        });
      });
    }
    print(imgURLOne);
    print(imgURLTwo);
    print(imgURLThree);
    // // 123
    // if(imgOne.path != '' && imgURLOne != null && imgTwo.path != '' && imgURLTwo != null  && imgThree.path != '' && imgURLThree != null){
    //   sendRequest(name, quantity, price, barcode, location, description);
    //
    // }
    // //12
    // else if(imgOne.path != '' && imgURLOne != null && imgTwo.path != '' && imgURLTwo != null && imgThree.path == '' && imgURLThree == null){
    //   sendRequest(name, quantity, price, barcode, location, description);
    //
    // }
    // // 13
    // if(imgOne.path != '' && imgURLOne != null && imgTwo.path == '' && imgURLTwo == null && imgThree.path != '' && imgURLThree != null){
    //   sendRequest(name, quantity, price, barcode, location, description);
    //
    // }
    // // 23
    // if(imgOne.path == '' && imgURLOne == null && imgTwo.path != '' && imgURLTwo != null && imgThree.path != '' && imgURLThree != null){
    //   sendRequest(name, quantity, price, barcode, location, description);
    //
    // }
    // // 1
    // if(imgOne.path != '' && imgURLOne != null && imgTwo.path == '' && imgURLTwo == null && imgThree.path == '' && imgURLThree == null){
    //   sendRequest(name, quantity, price, barcode, location, description);
    // }
    // //2
    // if(imgOne.path == '' && imgURLOne == null && imgTwo.path != '' &&  imgURLTwo != null && imgThree.path == ''  && imgURLThree == null) {
    //   sendRequest(name, quantity, price, barcode, location, description);
    //
    // }
    // //3
    // if(imgOne.path == '' && imgURLOne == null && imgURLTwo == null && imgTwo.path == '' && imgThree.path != '' && imgURLThree != null){
    //   sendRequest(name, quantity, price, barcode, location, description);
    // }


  }

  sendRequest(name,quantity,price,barcode,location,description){

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
        backgroundColor: Colors.brown,
        title: Text('Add Product'),),
      body: isUploading ? Center(child: CircularProgressIndicator(color: Colors.brown,)) : SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: ()async{
                      await showModalBottomSheet(context: context, builder: (context){
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () async{
                                Navigator.pop(context);
                                await _getFromGallery('1');

                              },
                              child: ListTile(
                                title: Text(
                                    "From Gallery"
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async{
                                Navigator.pop(context);
                                await _getFromGallery('1', camera: true);

                              },
                              child: ListTile(
                                title: Text(
                                    "From Camera"
                                ),
                              ),
                            ) ,


                          ],
                        );
                      });
                    },
                    child: Container(
                      color: Colors.white,
                      height: 140,
                      width: 120,
                      child: imgOne.path != ''  ? Image.file(imgOne,height: 140,width: 120,fit: BoxFit.cover,) : Center(child: Icon(Icons.add_a_photo,color: Colors.black,),),
                    ),
                  ),

                  InkWell(
                    onTap: ()async{
                      await showModalBottomSheet(context: context, builder: (context){
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () async{
                                Navigator.pop(context);
                                await _getFromGallery('2');

                              },
                              child: ListTile(
                                title: Text(
                                    "From Gallery"
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async{
                                Navigator.pop(context);
                                await _getFromGallery('2', camera: true);

                              },
                              child: ListTile(
                                title: Text(
                                    "From Camera"
                                ),
                              ),
                            ) ,


                          ],
                        );
                      });


                    },
                    child: Container(
                      color: Colors.white,
                      height: 140,
                      width: 120,
                      child: imgTwo.path != ''  ? Image.file(imgTwo,height: 140,width: 120,fit: BoxFit.cover,) : Center(child: Icon(Icons.add_a_photo,color: Colors.black,),),
                    ),
                  ),

                  InkWell(
                    onTap: () async{
                      await showModalBottomSheet(context: context, builder: (context){
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () async{
                                Navigator.pop(context);
                                await _getFromGallery('3');

                              },
                              child: ListTile(
                                title: Text(
                                    "From Gallery"
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async{
                                Navigator.pop(context);
                                await _getFromGallery('3', camera: true);

                              },
                              child: ListTile(
                                title: Text(
                                    "From Camera"
                                ),
                              ),
                            ) ,


                          ],
                        );
                      });

                    },
                    child: Container(
                      color: Colors.white,
                      height: 140,
                      width: 120,
                      child: imgThree.path != ''  ? Image.file(imgThree,height: 140,width: 120,fit: BoxFit.cover,) : Center(child: Icon(Icons.add_a_photo,color: Colors.black,),),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15,),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: 'Enter Product Name',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: widget.category == 'carpet' ? 'Enter Quantity (Meters)' : 'Enter Quantity (Boxes)',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Enter Price',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: barcodeController,
                decoration: InputDecoration(
                    labelText: 'Enter Barcode',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                    labelText: 'Enter Location',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    labelText: 'Enter Description',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              SizedBox(height: 10,),
              RaisedButton(onPressed: () async {
                setState(() {
                    imgPaths.add(imgOne);
                    imgPaths.add(imgTwo);
                    imgPaths.add(imgThree);
                  // List<String> urls = Future.wait(uploadFiles(imgPaths)) as List<String>;
    uploadMultipleImages(nameController.text, quantityController.text, priceController.text, barcodeController.text,
                              locationController.text, descriptionController.text);
                //   uploadImage(true,true,true, nameController.text, quantityController.text, priceController.text, barcodeController.text,
                //         locationController.text, descriptionController.text);

                  setState(() {
                    isUploading = true;
                  });
                });


              },
                color: Colors.brown,
                child: Text('ADD',style: TextStyle(color: Colors.white,fontSize: 18),),
              )
            ],
          ),),
      )
    );
  }


  _getFromGallery(f,{bool camera = false}) async {




    PickedFile? pickedFile = await ImagePicker().getImage(
      source: camera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 600,
    );
    if (pickedFile != null) {
      setState(() {
        if(f == '1') {
          imgOne = File(pickedFile.path);
        }else if(f =='2'){
          imgTwo = File(pickedFile.path);
        }
        else if(f =='3'){
          imgThree = File(pickedFile.path);
        }
        });
    }
  }

}


