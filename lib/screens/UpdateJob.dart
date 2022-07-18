import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamland/screens/AdminDashboard.dart';
import 'package:dreamland/screens/JobCalendar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../Model/JobModel.dart';

class UpdateJob extends StatefulWidget {
  JobModel jobModel;
  var t;
  UpdateJob({required this.jobModel,this.t});

  @override
  State<UpdateJob> createState() => _UpdateJobState();
}

class _UpdateJobState extends State<UpdateJob> {
  bool isUploading = false;
  File? imgOne ;
  File? imgTwo ;
  File? imgThree ;
  File? imgBill ;
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
  List<String> _images = [];
  List<String> jobTypes = [];
  // List<File> imgPaths = [];

  var selectedJobStatus = 'Select Job Status';
var loggedinUser;
  Future<void> uploadMultipleImages() async {


    List<String?> urls = [null,null,null,null];

    try {

      if(imgBill!=null){
        final Reference storageReference = FirebaseStorage.instance.ref().child(Uuid().v4());
        final UploadTask uploadTask = storageReference.putFile(imgBill!);

        await uploadTask.whenComplete(() async {
          String imageUrl = await storageReference.getDownloadURL();
          urls[0] = imageUrl;
        });


      }
      if(imgOne!=null){
        final Reference storageReference = FirebaseStorage.instance.ref().child(Uuid().v4());
        final UploadTask uploadTask = storageReference.putFile(imgOne!);

        await uploadTask.whenComplete(() async {
          String imageUrl = await storageReference.getDownloadURL();
          urls[1] = imageUrl;
        });


      }
      if(imgTwo!=null){
        final Reference storageReference = FirebaseStorage.instance.ref().child(Uuid().v4());
        final UploadTask uploadTask = storageReference.putFile(imgTwo!);

        await uploadTask.whenComplete(() async {
          String imageUrl = await storageReference.getDownloadURL();
          urls[2] = imageUrl;
        });


      }
      if(imgThree!=null){
        final Reference storageReference = FirebaseStorage.instance.ref().child(Uuid().v4());
        final UploadTask uploadTask = storageReference.putFile(imgThree!);

        await uploadTask.whenComplete(() async {
          String imageUrl = await storageReference.getDownloadURL();
          urls[3] = imageUrl;
        });


      }


      //upload the list of imageUrls to firebase as an array
      var d = {
        'author':nameController.text, // author
        'jobtitle': jobTitleController.text, // job title
        'title': postCodeController.text, // post code
        'bar': phoneController.text, // phone number
        'phone2' : phoneController2.text,
        'emplo': employerNameController.text, // employer name
        'customn': customNoteController.text, // custom note
        'datef': fittingDateController.text, // date fitting
        'descri': measurementDateController.text, // date measure
        'des': addressController.text, // address
        'status': selectedJobStatus == 'Select Job Status' ? widget.jobModel.status : selectedJobStatus, // address
        'billURL': urls[0] ?? widget.jobModel.billUrl,
        'imageURL': urls[1] ?? widget.jobModel.imgOne,
        'imageURL2': urls[2] ?? widget.jobModel.imgTwo,
        'imageURL3': urls[3] ?? widget.jobModel.imgThree,
      };
    print(widget.jobModel.id);
      var collection = FirebaseFirestore.instance.collection('addjob');
      collection
          .doc(widget.jobModel.id) // <-- Doc ID where data should be updated.
          .update(d)
          .then((value){
            addLog(widget.jobModel.id, selectedJobStatus);
        Fluttertoast.showToast(
            msg: 'Job Updated Updated',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0
        );
        if(widget.t =='reload'){
          Get.to(()=>JobCalendar(type: 'new'));
        }
        else {
          Get.to(AdminDashboard());
        }
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

  addLog(jid,m){

    String dateTime = getUKDateTime().toString();

    String id = FirebaseFirestore.instance.collection('logs').doc().id;
    FirebaseFirestore.instance
        .collection('logs')
        .add({
      'date':dateTime,
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

  DateTime getUKDateTime() {
    tz.initializeTimeZones();
    var istanbulTimeZone = tz.getLocation('Europe/London');
    var now = tz.TZDateTime.now(istanbulTimeZone);
    return now;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    jobTypes.add('Select Job Status');
    jobTypes.add('Booked');
    jobTypes.add('Hold');
    jobTypes.add('In Progress');
    jobTypes.add('Unpaid');
    jobTypes.add('Completed');
    jobTypes.add('Delivery Booked');
    jobTypes.add('Delivery Complete');
    jobTitleController.text = widget.jobModel.jobTitle;
    employerNameController.text = widget.jobModel.employee;
    nameController.text = widget.jobModel.name;
    addressController.text = widget.jobModel.address;
    postCodeController.text = widget.jobModel.postCode;
    phoneController.text = widget.jobModel.number;
    measurementDateController.text = widget.jobModel.dateBooking;
    fittingDateController.text = widget.jobModel.dateFitting;
    phoneController2.text = widget.jobModel.number2;
    customNoteController.text = widget.jobModel.customNote;
    if(widget.jobModel.billUrl != ''){
      _images.add(widget.jobModel.billUrl);
    }
    if(widget.jobModel.imgOne != ''){
      _images.add(widget.jobModel.imgOne);
    }
    if(widget.jobModel.imgTwo != ''){
      _images.add(widget.jobModel.imgTwo);
    }
    if(widget.jobModel.imgThree != ''){
      _images.add(widget.jobModel.imgThree);
    }
  }

  @override
  Widget build(BuildContext context) {

    print(widget.jobModel.id);

    return Scaffold(
        appBar: AppBar(
        centerTitle: true,
        title: const Text('Update Job'),
    backgroundColor: Colors.brown,
    ),
        body: (!isUploading) ? SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          showAlertDialog(context,'bill');


                        },
                        child: Container(
                            color: Colors.white,
                            height: 140,
                            width: 120,
                            child: (imgBill != null)
                                ? Image.file(
                              imgBill!, height: 140, width: 120, fit: BoxFit.cover,) : widget.jobModel.billUrl != ''
                                ? Image.network(
                              widget.jobModel.billUrl, height: 140, width: 120, fit: BoxFit.cover,)
                                : Center(child: Icon(
                              Icons.sticky_note_2_outlined, color: Colors.black,),),
                        ),

                      ),
                      SizedBox(width: 10,),

                      InkWell(
                          onTap: (){
                            showAlertDialog(context,'1');


                          },
                          child:
                          Container(
                              color: Colors.white,
                              height: 140,
                              width: 120,
                              child: (imgOne!=null)
                                  ? Image.file(
                                imgOne!, height: 140, width: 120, fit: BoxFit.cover,) : widget.jobModel.imgOne != ''
                                  ? Image.network(
                                widget.jobModel.imgOne, height: 140, width: 120, fit: BoxFit.cover,)
                                  : Center(child: Icon(
                                Icons.add_a_photo, color: Colors.black,),),
                          )),
                      SizedBox(width: 10,),

                      InkWell(
                          onTap: (){
                            showAlertDialog(context,'2');

                          },
                          child:
                          Container(
                              color: Colors.white,
                              height: 140,
                              width: 120,
                              child: (imgTwo!=null)
                                  ? Image.file(
                                imgTwo!, height: 140, width: 120, fit: BoxFit.cover,) : widget.jobModel.imgTwo != ''
                                  ? Image.network(
                                widget.jobModel.imgTwo, height: 140, width: 120, fit: BoxFit.cover,)
                                  : Center(child: Icon(
                                Icons.add_a_photo, color: Colors.black,),),
                          )),
                      SizedBox(width: 10,),

                      InkWell(
                          onTap: (){
                            showAlertDialog(context,'3');

                          },
                          child:Container(
                              color: Colors.white,
                              height: 140,
                              width: 120,
                              child: (imgThree!=null)
                                  ? Image.file(
                                imgThree!, height: 140, width: 120, fit: BoxFit.cover,) : widget.jobModel.imgThree != ''
                                  ? Image.network(
                                widget.jobModel.imgThree, height: 140, width: 120, fit: BoxFit.cover,)
                                  : Center(child: Icon(
                                Icons.add_a_photo, color: Colors.black,),),
                          )),
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

                const SizedBox(height: 15,),
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
                const SizedBox(height: 15,),
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

                const SizedBox(height: 15,),
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

                const SizedBox(height: 15,),
                TextField(
                  controller: phoneController2,

                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Phone Number 2',
                      labelStyle: const TextStyle(color: Colors.black),
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
                  onTap: (){
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
                Center(child: Text('Current Job Status : '+widget.jobModel.status,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),),
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
                  setState((){
                    isUploading = true;
                  });
                  await uploadMultipleImages();
                  setState((){
                    isUploading = false;
                  });

                },
                  color: Colors.brown,
                  child: const Text('UPDATE',style: TextStyle(color: Colors.white,fontSize: 18),),
                )

              ],
            ),),
        ) :
        Center(child: CircularProgressIndicator(),)
    );
  }

  _getFromGallery(String type,String t) async {
    Navigator.pop(context);
    PickedFile? pickedFile = await ImagePicker().getImage(
        source: t == 'c' ? ImageSource.camera : ImageSource.gallery,
        imageQuality: t == 'c' ? 100 : 100
    );
    if (pickedFile != null) {

      if (type == '1') {
        imgOne = File(pickedFile.path);
      }
      else if (type == '2') {
        imgTwo = File(pickedFile.path);
      }
      else if (type == '3') {
        imgThree = File(pickedFile.path);
      }
      else if(type == 'bill'){
        imgBill = File(pickedFile.path);
        CroppedFile? croppedFile = await ImageCropper().cropImage(
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
            ]
        );

        imgBill = File(croppedFile?.path ?? pickedFile.path);

      }


      setState(() {});
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
}
