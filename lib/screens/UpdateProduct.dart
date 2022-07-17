import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamland/screens/ViewProducts.dart';
import 'package:dreamland/screens/photo_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../Constants/AppConstants.dart';
import '../storage/SharedPref.dart';


class UpdateProduct extends StatefulWidget {
  ProductList plist;
  UpdateProduct({required this.plist});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {

  File imgOne = new File('');
  File imgTwo = new File('');
  File imgThree = new File('');
  var imgURLOne ,imgURLTwo,imgURLThree;

  bool isUploading = false;
  List<File> imgPaths = [];
  List<String> imgPathName = [];
  TextEditingController nameController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController barcodeController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  FirebaseStorage storage = FirebaseStorage.instance;
  late Reference ref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.plist.name;
    priceController.text = widget.plist.price;
    barcodeController.text = widget.plist.code;
    locationController.text = widget.plist.location;
    descriptionController.text = widget.plist.description;
  }
  Constants pref = new Constants();
  var loggedinUser,loggedinUserRole;

  Future uploadMultipleImages() async {

    List<String> _imageUrls = [];

    var user = await Constants.user;
    var role = await Constants.role;


    // var user = await pref.getSession(AppConstants.USER);
    // var role = await pref.getSession(AppConstants.ROLE);
    setState(() {
      loggedinUserRole = role;
      if(loggedinUserRole == '1'){
        loggedinUser = 'Admin';
      }
      else {
        loggedinUser = user;
      }
    });

    try {
      for (int i = 0; i < imgPaths.length; i++) {
        final Reference storageReference = FirebaseStorage.instance.ref().child("imageone/$i");
        if(imgPaths[i].path != '') {
          final UploadTask uploadTask = storageReference.putFile(imgPaths[i]);

          await uploadTask.whenComplete(() async {
            String imageUrl = await storageReference.getDownloadURL();
            _imageUrls.add(imageUrl); //all all the urls to the list
          });
        }
        else{
          setState(() {
            _imageUrls.add('');
          });
        }

      }
      //upload the list of imageUrls to firebase as an array
    var d = {
      'name':nameController.text,
      'price':priceController.text,
      'location':locationController.text,
      'bar':barcodeController.text,
      'description':descriptionController.text,
      'imageURL': _imageUrls.isNotEmpty ? _imageUrls[0] : widget.plist.imgOne,
      'imageURL2': _imageUrls.length > 1 ? _imageUrls[1] : widget.plist.imgTwo,
      'imageURL3': _imageUrls.length > 2 ? _imageUrls[2] : widget.plist.imgThree,
      };

      var collection = FirebaseFirestore.instance.collection('products');
      collection
          .doc(widget.plist.id) // <-- Doc ID where data should be updated.
          .update(d)
      .then((value){
        Fluttertoast.showToast(
            msg: 'Product Updated',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Get.to(()=>ViewProducts(type: widget.plist.category));
        print('success');
      })
      .catchError((err){
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true,
          backgroundColor: Colors.brown,
          title: Text('Update Product'),),
        body: isUploading ? Center(child: CircularProgressIndicator(color: Colors.brown,)) : SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){

                        Get.to(
                            PhotoViewScreen(
                              filePath: imgOne.path,
                              imageLink: widget.plist.imgOne,
                            ));


                        // _getFromGallery('1');
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            color: Colors.white,
                            height: 140,
                            width: 120,
                            child:
                            imgOne.path != ''  ? Image.file(imgOne,height: 140,width: 120,fit: BoxFit.cover,) :
                            widget.plist.imgOne != '' ? Image.network(widget.plist.imgOne,height: 140,width: 120,fit: BoxFit.cover,) :
                            const Center(child: Icon(Icons.add_a_photo,color: Colors.black,),),
                          ),
                          ElevatedButton(onPressed: () async{

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
                                      await _getFromCamera('1');

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



                          }, child: const Text("Change"),style: ElevatedButton.styleFrom(primary: Colors.brown),)
                        ],
                      ),
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: (){
                            Get.to(
                                PhotoViewScreen(
                                  filePath: imgTwo.path,
                                  imageLink: widget.plist.imgTwo,
                                ));

                            // _getFromGallery('2');

                          },
                          child: Container(
                            color: Colors.white,
                            height: 140,
                            width: 120,
                            child:
                            imgTwo.path != ''  ? Image.file(imgTwo,height: 140,width: 120,fit: BoxFit.cover,) :
                            widget.plist.imgTwo != '' ? Image.network(widget.plist.imgTwo,height: 140,width: 120,fit: BoxFit.cover,) :
                            Center(child: Icon(Icons.add_a_photo,color: Colors.black,),),
                          ),
                        ),
                        ElevatedButton(onPressed: () async{

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
                                    await _getFromCamera('2');

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



                        }, child: const Text("Change"),style: ElevatedButton.styleFrom(primary: Colors.brown),)

                      ],
                    ),

                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: (){
                              Get.to(
                                  PhotoViewScreen(
                                    filePath: imgThree.path,
                                    imageLink: widget.plist.imgThree,
                              ));

                            },
                            child: Container(
                              color: Colors.white,
                              height: 140,
                              width: 120,
                              child:

                              imgThree.path != ''  ?
                              Image.file(imgThree,height: 140,width: 120,fit: BoxFit.cover,) :

                              widget.plist.imgThree != '' ?
                              Image.network(widget.plist.imgThree,height: 140,width: 120,fit: BoxFit.cover,)
                                  :
                              const Center(child: Icon(Icons.add_a_photo,color: Colors.black,),),
                            ),
                          ),
                          ElevatedButton(onPressed: () async{

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
                                      await _getFromCamera('3');

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



                          }, child: const Text("Change"),style: ElevatedButton.styleFrom(primary: Colors.brown),)

                        ],
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
                RaisedButton(
                  onPressed: () async {
                  setState(() {
                    if(imgOne.path.isNotEmpty){
                      imgPaths.add(imgOne);
                    }
                    if(imgTwo.path.isNotEmpty){
                      imgPaths.add(imgTwo);
                    }
                    if(imgThree.path.isNotEmpty){
                      imgPaths.add(imgThree);
                    }
                    // List<String> urls = Future.wait(uploadFiles(imgPaths)) as List<String>;
                    uploadMultipleImages();
                    //   uploadImage(true,true,true, nameController.text, quantityController.text, priceController.text, barcodeController.text,
                    //         locationController.text, descriptionController.text);

                    setState(() {
                      isUploading = true;
                    });
                  });


                },
                  color: Colors.brown,
                  child: Text('UPDATE',style: TextStyle(color: Colors.white,fontSize: 18),),
                )
              ],
            ),),
        )
    );
  }

  _getFromGallery(f) async {

    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    // return;

    // PickedFile? pickedFile = await ;
    if (pickedFile != null) {
      print("settinh state");
      setState(() {
        if(f == '1') {
          imgOne = File(pickedFile!.path);
        }else if(f =='2'){
          imgTwo = File(pickedFile!.path);
        }
        else if(f =='3'){
          imgThree = File(pickedFile!.path);
        }
      });
    }
    else{
      print("nullllllllll");
    }

    // setState((){});
  }

  _getFromCamera(f) async {

    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    // return;

    // PickedFile? pickedFile = await ;
    if (pickedFile != null) {
      print("settinh state");
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
    else{
      print("nullllllllll");
    }

    // setState((){});
  }


}
