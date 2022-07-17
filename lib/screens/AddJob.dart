import 'dart:io';
import 'dart:math';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../Constants/AppConstants.dart';
import '../storage/SharedPref.dart';
import 'AdminDashboard.dart';

class AddJob extends StatefulWidget {
  const AddJob({Key? key}) : super(key: key);

  @override
  State<AddJob> createState() => _AddJobState();
}
class CategoryOptions{
  var name;
  var value;
  CategoryOptions({this.name,this.value});
}
class ProductModel{
    var id;
    var name;
    var quantity;
    ProductModel({this.id,this.name,this.quantity});
}
class _AddJobState extends State<AddJob> {
  bool isUploading = false;
  File imgOne = new File('');
  File imgTwo = new File('');
  File imgThree = new File('');
  File imgBill = new File('');

  List<File> imgPaths = [];

  List<String> imgURLs = [];
  List<CategoryOptions> _categoryOptions = [];
  List<String> _products = [];
  List<String> jobTypes = [];
  List<ProductModel> _productModel = [];
  var selectedJobStatus = 'Select Job Status';

  var selectedCategory;
  var selectedProduct;
  var productQuantity;
  var prodID;

  TextEditingController jobTitleController = new TextEditingController();
  TextEditingController employerNameController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController postCodeController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController phoneController2 = new TextEditingController();

  TextEditingController measurementDateController = new TextEditingController();
  TextEditingController fittingDateController = new TextEditingController();
  TextEditingController customNoteController = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();
  Constants pref = new Constants();
  var loggedinUser,loggedinUserRole;


  Future<void> uploadMultipleImages() async {

    List<String> _imageUrls = [];
    var user = Constants.user;
    var role = Constants.role;
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
        final Reference storageReference = FirebaseStorage.instance.ref().child(const Uuid().v4());
        if(imgPaths[i].existsSync()) {
          final UploadTask uploadTask = storageReference.putFile(imgPaths[i]);

          await uploadTask.whenComplete(() async {
            String imageUrl = await storageReference.getDownloadURL();
            _imageUrls.add(imageUrl); //all all the urls to the list
          });
        }

      }
      //upload the list of imageUrls to firebase as an array

      String id = FirebaseFirestore.instance.collection('addjob').doc().id;

      await FirebaseFirestore.instance
          .collection('addjob')
      .doc(id)
          .set({
        'id': id,
        'author':nameController.text, // author
        'jobtitle': jobTitleController.text, // job title
        'product': selectedProduct, //product
        'quantity': quantityController.text, // quantity
        'title': postCodeController.text, // post code
        'bar': phoneController.text, // phone number
        'phone2' : phoneController2.text,
        'emplo': employerNameController.text, // employer name
        'customn': customNoteController.text, // custom note
        'datef': fittingDateController.text, // date fitting
        'descri': measurementDateController.text, // date measure
        'des': addressController.text, // address
        'status': selectedJobStatus, // address

        ///TODO: GREATER THAN OR EQUAL TO CONDITION

        'billURL': _imageUrls.length > 0 ? _imageUrls[0] : '',
        'imageURL': _imageUrls.length > 1 ? _imageUrls[1] : '',
        'imageURL2': _imageUrls.length > 2 ? _imageUrls[2] : '',
        'imageURL3': _imageUrls.length > 3 ? _imageUrls[3] : '',
        'createdAt': getUKDateTime().toString(),
        'user':loggedinUser,

        //'uid':user.uid
      })
          .then((value) {

        addLog(id,'Created');

        new Future.delayed(new Duration(milliseconds: 10),(){
          addLog(id,selectedJobStatus);
        });
        var total = double.parse(productQuantity) - double.parse(quantityController.text);
        FirebaseFirestore.instance.collection('products').doc(prodID).
        update({'quantity': total.toString()})
            .then((value) {
              print("id is $id");
          Fluttertoast.showToast(
              msg: 'Job Added',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.brown,
              textColor: Colors.white,
              fontSize: 16.0
          );
              Fluttertoast.showToast(
                  msg: id,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.brown,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
          Get.to(
            AdminDashboard()
          );
          print('success');

        });


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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      jobTypes.add('Select Job Status');
      jobTypes.add('Booked');
      jobTypes.add('Hold');
      jobTypes.add('In Progress');
      jobTypes.add('Unpaid');
      jobTypes.add('Completed');
      jobTypes.add('Delivery Booked');
      jobTypes.add('Delivery Complete');
      _categoryOptions.add(
          new CategoryOptions(name: 'Furniture & Rug', value: 'furniture_rug'));
      _categoryOptions.add(
          new CategoryOptions(name: 'Accessories', value: 'accessories'));
      _categoryOptions.add(
          new CategoryOptions(name: 'Laminate', value: 'laminate'));
      _categoryOptions.add(
          new CategoryOptions(name: 'Carpet + Lino', value: 'carpet'));
    });
  }

  addLog(jid,m){
    String id = FirebaseFirestore.instance.collection('logs').doc().id;
    FirebaseFirestore.instance
        .collection('logs')
        .add({
      'date':DateTime.now().toString(),
      'employee':loggedinUser,
      'id':id,
      'jobid':jid,
      'status':m
    })
        .then((value){
      print('success');
    }).catchError((err){
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Job'),
        backgroundColor: Colors.brown,

      ),
      body: isUploading
          ? Center(child: CircularProgressIndicator(color: Colors.brown,))
          :
      SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async{
                        showAlertDialog(context,'bill');

                      },
                      child: Container(
                        color: Colors.white,
                        height: 140,
                        width: 120,
                        child: imgBill.path != ''
                            ? Image.file(
                          imgBill, height: 140, width: 120, fit: BoxFit.cover,)
                            : Center(child: Icon(
                          Icons.sticky_note_2_outlined, color: Colors.black,),),
                      ),
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: () {
                        showAlertDialog(context,'1');
                      },
                      child: Container(
                        color: Colors.white,
                        height: 140,
                        width: 120,
                        child: imgOne.path != ''
                            ? Image.file(
                          imgOne, height: 140, width: 120, fit: BoxFit.cover,)
                            : Center(child: Icon(
                          Icons.add_a_photo, color: Colors.black,),),
                      ),
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: () {
                        showAlertDialog(context,'2');
                      },
                      child: Container(
                        color: Colors.white,
                        height: 140,
                        width: 120,
                        child: imgTwo.path != ''
                            ? Image.file(
                          imgTwo, height: 140, width: 120, fit: BoxFit.cover,)
                            : Center(child: Icon(
                          Icons.add_a_photo, color: Colors.black,),),
                      ),
                    ),

                    SizedBox(width: 10,),
                    InkWell(
                      onTap: () {
                        showAlertDialog(context,'3');
                      },
                      child: Container(
                        color: Colors.white,
                        height: 140,
                        width: 120,
                        child: imgThree.path != ''
                            ? Image.file(
                          imgThree, height: 140, width: 120, fit: BoxFit.cover,)
                            : Center(child: Icon(
                          Icons.add_a_photo, color: Colors.black,),),
                      ),
                    ),
                  ],
                ),

              ),
              SizedBox(height: 15,),
              TextField(
                controller: jobTitleController,
                decoration: InputDecoration(
                    labelText: 'Job Title',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              SizedBox(height: 15,),
              TextField(
                controller: employerNameController,
                decoration: InputDecoration(
                    labelText: 'Employer Name',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              SizedBox(height: 15,),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),

              SizedBox(height: 15,),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                    labelText: 'Address',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              SizedBox(height: 15,),
              TextField(
                controller: postCodeController,
                decoration: InputDecoration(
                    labelText: 'Post Code',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),

              SizedBox(height: 15,),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),

              SizedBox(height: 15,),
              TextField(
                controller: phoneController2,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Phone Number 2',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),



              SizedBox(height: 15,),
              TextField(
                controller: measurementDateController,
                readOnly: true,
                onTap: () {
                  _pickDateDialog('m');
                },
                decoration: InputDecoration(
                    labelText: 'Date Measurement',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),

              SizedBox(height: 15,),
              TextField(
                controller: fittingDateController,
                readOnly: true,
                onTap: () {
                  _pickDateDialog('f');
                },
                decoration: InputDecoration(
                    labelText: 'Date Fitting',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              SizedBox(height: 15,),
              TextField(
                controller: customNoteController,
                decoration: InputDecoration(
                    labelText: 'Custom Note',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),

              SizedBox(height: 15,),
              Container(width: MediaQuery
                  .of(context)
                  .size
                  .width - 40, child:
              DropdownButton<String>(
                isExpanded: true,
                hint: Text('Select Product Category'),
                value: selectedCategory,
                style: TextStyle(color: Colors.black),
                items: _categoryOptions.map((CategoryOptions value) {
                  return DropdownMenuItem<String>(
                    value: value.value,
                    child: Text(value.name),
                  );
                }).toList(),
                onChanged: (v) {
                  print(v);
                  setState(() {
                    _products.clear();
                    _productModel.clear();
                    selectedProduct = null;
                    selectedCategory = v!;
                    fillProducts(selectedCategory);
                  });
                },
              )),


              SizedBox(height: 15,),
              Container(width: MediaQuery
                  .of(context)
                  .size
                  .width - 40, child:

              DropdownSearch<String>(
                mode: Mode.DIALOG,
                showSearchBox: true,
                items: _products,
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Products",
                  hintText: "Select Product",
                ),
                onChanged: (v){
                    setState(() {
                      selectedProduct = v;
                      getQuantity(selectedProduct);
                    });
                },
                selectedItem: selectedProduct,
              ),

              ),

              SizedBox(height: 15,),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffix: productQuantity != null ? Text('Max Quantity ($productQuantity)') : Text(' '),
                    labelText: 'Quantity',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.brown),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),

              SizedBox(height: 15,),
              Container(width: MediaQuery
                  .of(context)
                  .size
                  .width - 40, child:
              DropdownButton<String>(
                isExpanded: true,
                hint: Text('Select Job Status'),
                value: selectedJobStatus,
                style: TextStyle(color: Colors.black),
                items: jobTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (v) {
                  setState(() {
                    selectedJobStatus = v!;
                  });
                },
              )),

              SizedBox(height: 10,),

              RaisedButton(onPressed: () async {
                setState(() {

                  if(jobTitleController.text.isEmpty){
                    Fluttertoast.showToast(
                        msg: 'Please Enter Job Title',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.brown,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }

                else if(employerNameController.text.isEmpty){
                    Fluttertoast.showToast(
                        msg: 'Please Enter Employer Name',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.brown,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }


                  else if(nameController.text.isEmpty){
                    Fluttertoast.showToast(
                        msg: 'Please Enter Name',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.brown,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                  else if(addressController.text.isEmpty){
                    Fluttertoast.showToast(
                        msg: 'Please Enter Address',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.brown,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                  else if(postCodeController.text.isEmpty){
                    Fluttertoast.showToast(
                        msg: 'Please Enter Post Code',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.brown,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                  else if(phoneController.text.isEmpty){
                    Fluttertoast.showToast(
                        msg: 'Please Enter Phone Number',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.brown,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                  else if(measurementDateController.text.isEmpty){
                    Fluttertoast.showToast(
                        msg: 'Please Select Measurement Date',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.brown,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                  else if(fittingDateController.text.isEmpty){
                    Fluttertoast.showToast(
                        msg: 'Please Select Fitting Date',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.brown,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                  else if(customNoteController.text.isEmpty){
                    Fluttertoast.showToast(
                        msg: 'Please Enter Custom Note',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.brown,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }

                  else if(selectedCategory == null){
                    Fluttertoast.showToast(
                        msg: 'Please Select Product Category',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.brown,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }

                  else if(selectedProduct == null){
                    Fluttertoast.showToast(
                        msg: 'Please Select Product',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.brown,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }

                 else if(double.parse(quantityController.text) > double.parse(productQuantity ?? "0.0")){
                    Fluttertoast.showToast(
                        msg: 'Quantity is higher. Max Available Quanity is $productQuantity',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.brown,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                  else if(selectedJobStatus == 'Select Job Status'){
                    Fluttertoast.showToast(
                        msg: 'Please Select Job Status',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.brown,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                  else if(imgBill.path.isEmpty){
                    Fluttertoast.showToast(
                        msg: 'Please Add Atleast 1 Image',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.brown,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                  else{
                    imgPaths.add(imgBill);
                    imgPaths.add(imgOne);
                    imgPaths.add(imgTwo);
                    imgPaths.add(imgThree);
                    uploadMultipleImages();
                    setState(() {
                      isUploading = true;
                    });
                  }

                });
              },
                color: Colors.brown,
                child: Text(
                  'ADD', style: TextStyle(color: Colors.white, fontSize: 18),),
              )
            ],
          ),),
      )
      ,
    );
  }

  _getFromGallery(f,t) async {
    Navigator.pop(context);
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: t == 'c' ? ImageSource.camera : ImageSource.gallery,
      imageQuality: t == 'c' ? 100 : 100
    );
    CroppedFile? croppedFile;
    if (pickedFile != null) {
      if(f == 'bill'){
        croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false,


            ),
            IOSUiSettings(
              title: 'Cropper',
            ),
          ],
        );
      }

      setState(() {
        if (f == '1') {
          imgOne = File(pickedFile.path);
        } else if (f == '2') {
          imgTwo = File(pickedFile.path);
        }
        else if (f == '3') {
          imgThree = File(pickedFile.path);
        }
        else if(f == 'bill'){
          imgBill = File(croppedFile?.path ?? pickedFile.path);
        }
      });
    }
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 400,
      maxHeight: 400,
      imageQuality: 20
    );
    if (pickedFile != null) {
      setState(() {
        imgBill = File(pickedFile.path);
      });
    }
  }

  void _pickDateDialog(type) {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        //which date will display when user open the picker
        firstDate: DateTime(2022),
        //what will be the previous supported year in picker
        lastDate: DateTime(2025)) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        var inputFormat = DateFormat('dd-MM-yyyy');

        //for rebuilding the ui
        if (type == 'm') {
          measurementDateController.text = inputFormat.format(pickedDate);
//          _selectedMeasurement = pickedDate;
        }
        else if (type == 'f') {
          fittingDateController.text = inputFormat.format(pickedDate);
//          _selectedFitting = pickedDate;

        }
      });
    });
  }




  fillProducts(c) async {
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection(
        'products');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    for (var a in querySnapshot.docs) {
      print(a['name']);
      if (a['category'] == c) {
        if (a['name'] != null || a['name'] != '') {
          setState(() {
            _products.add(a['name']);
            _productModel.add(
                new ProductModel(id: a['id'],name: a['name'], quantity: a['quantity']));
          });
        }
      }
    }
  }

  getQuantity(p){
    for(var a in _productModel){
      if(a.name == p){
        setState(() {
          prodID = a.id;
          productQuantity = a.quantity;
        });
        print('quantity is $productQuantity');
      }
    }
  }


  showAlertDialog(BuildContext context,type) {
    // Create button
    Widget cameraBtn = FlatButton(
      child: Text("Camera"),
      onPressed: () {
       _getFromGallery(type, 'c');

      },
    );
    Widget galleryBtn = FlatButton(
      child: Text("Gallery"),
      onPressed: () {
        _getFromGallery(type, 'g');
        },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Select Image Using."),
      actions: [
        cameraBtn,
        galleryBtn
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  DateTime getUKDateTime() {
    tz.initializeTimeZones();
    var istanbulTimeZone = tz.getLocation('Europe/London');
    var now = tz.TZDateTime.now(istanbulTimeZone);
    return now;
  }

}