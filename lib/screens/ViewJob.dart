import 'package:dreamland/Model/JobModel.dart';
import 'package:dreamland/screens/ViewImageSlider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewJob extends StatefulWidget {
JobModel jobModel;
ViewJob({required this.jobModel});
  @override
  State<ViewJob> createState() => _ViewJobState();
}

class _ViewJobState extends State<ViewJob> {

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      jobTitleController.text = widget.jobModel.jobTitle;
      employerNameController.text = widget.jobModel.employee;
      nameController.text = widget.jobModel.name;
      addressController.text = widget.jobModel.address;
      postCodeController.text = widget.jobModel.postCode;
      phoneController.text = widget.jobModel.number;
      measurementDateController.text = widget.jobModel.dateBooking;
      fittingDateController.text = widget.jobModel.dateFitting;
      customNoteController.text = widget.jobModel.customNote;
      phoneController2.text = widget.jobModel.number2;
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

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Job Detail'),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: Container(
                        color: Colors.white,
                        height: 140,
                        width: 120,
                        child: widget.jobModel.billUrl != ''
                            ? Image.network(
                          widget.jobModel.billUrl, height: 140, width: 120, fit: BoxFit.cover,)
                            : Center(child: Text(
                          'Dreamland',style: TextStyle(fontSize: 18,color: Colors.brown),),
                        )
                    ),
                    onTap: (){
                      if(widget.jobModel.billUrl != ''){
                        Get.to(()=>ViewImageSlider(img: widget.jobModel.billUrl));
                      }                    },
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: (){
                        if(widget.jobModel.imgOne != ''){
                          Get.to(()=>ViewImageSlider(img: widget.jobModel.imgOne));
                      }
                        },
                      child:
                    Container(
                        color: Colors.white,
                        height: 140,
                        width: 120,
                        child: widget.jobModel.imgOne != ''
                            ? Image.network(
                          widget.jobModel.imgOne, height: 140, width: 120, fit: BoxFit.cover,)
                            : Center(child: Text(
                          'Dreamland',style: TextStyle(fontSize: 18,color: Colors.brown),),
                        )
                    )),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: (){
                        if(widget.jobModel.imgTwo != ''){
                          Get.to(()=>ViewImageSlider(img: widget.jobModel.imgTwo));
                        }
                      },
                    child:
                    Container(
                        color: Colors.white,
                        height: 140,
                        width: 120,
                        child: widget.jobModel.imgTwo != ''
                            ? Image.network(
                          widget.jobModel.imgTwo, height: 140, width: 120, fit: BoxFit.cover,)
                            : Center(child: Text(
                          'Dreamland',style: TextStyle(fontSize: 18,color: Colors.brown),),
                        )
                    )),

                    SizedBox(width: 10,),
                    InkWell(
                      onTap: (){
                        if(widget.jobModel.imgThree != ''){
                          Get.to(()=>ViewImageSlider(img: widget.jobModel.imgThree));
                        }
                      },
                    child:Container(
                        color: Colors.white,
                        height: 140,
                        width: 120,
                        child: widget.jobModel.imgThree != ''
                            ? Image.network(
                          widget.jobModel.imgThree, height: 140, width: 120, fit: BoxFit.cover,)
                            : Center(child: Text(
                          'Dreamland',style: TextStyle(fontSize: 18,color: Colors.brown),),
                        )
                    )),
                  ],
                ),

              ),
              SizedBox(height: 15,),
              TextField(
                controller: jobTitleController,
                enabled: false,
                readOnly: true,
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
                enabled: false,
                readOnly: true,
                decoration: InputDecoration(
                    labelText: 'Employer Title',
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
                enabled: false,
                readOnly: true,
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
                enabled: false,
                readOnly: true,
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
                enabled: false,
                readOnly: true,
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
                enabled: false,
                readOnly: true,
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

              ///phone2
              widget.jobModel.number2!="" ?
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 15,),
                  TextField(
                    controller: phoneController2,
                    enabled: false,
                    readOnly: true,
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
                ],
              ) : SizedBox(),



              SizedBox(height: 15,),
              TextField(
                controller: measurementDateController,
                readOnly: true,
                enabled: false,
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
                enabled: false,
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
                readOnly: true,
                enabled: false,
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
            Center(child: Text('Current Job Status : '+widget.jobModel.status,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),)
            ],
          ),),
      )
    );
  }
}
