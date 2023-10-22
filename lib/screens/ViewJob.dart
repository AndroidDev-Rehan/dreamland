import 'package:dreamland/Model/JobModel.dart';
import 'package:dreamland/screens/photo_view.dart';
import 'package:dreamland/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewJob extends StatefulWidget {
  final JobModel jobModel;
  const ViewJob({Key? key, required this.jobModel}) : super(key: key);
  @override
  State<ViewJob> createState() => _ViewJobState();
}

class _ViewJobState extends State<ViewJob> {
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController employerNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController phoneController2 = TextEditingController();
  TextEditingController measurementDateController = TextEditingController();
  TextEditingController fittingDateController = TextEditingController();
  TextEditingController customNoteController = TextEditingController();
  final List<String> _images = [];

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
      phoneController2.text = widget.jobModel.number2 ?? "";
      if (widget.jobModel.billUrl != '') {
        _images.add(widget.jobModel.billUrl);
      }
      if (widget.jobModel.imgOne != '') {
        _images.add(widget.jobModel.imgOne);
      }
      if (widget.jobModel.imgTwo != '') {
        _images.add(widget.jobModel.imgTwo);
      }
      if (widget.jobModel.imgThree != '') {
        _images.add(widget.jobModel.imgThree);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Job Detail'),
          backgroundColor: Colors.brown,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child:
                            CustomCacheImage(imgUrl: widget.jobModel.billUrl),
                        onTap: () {
                          if (widget.jobModel.billUrl != '') {
                            Get.to(() =>
                                PhotoViewScreen(imageLink: widget.jobModel.billUrl));
                          }
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          onTap: () {
                            if (widget.jobModel.imgOne != '') {
                              Get.to(() =>
                                  PhotoViewScreen(imageLink: widget.jobModel.imgOne));
                            }
                          },
                          child:
                              CustomCacheImage(imgUrl: widget.jobModel.imgOne)),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          onTap: () {
                            if (widget.jobModel.imgTwo != '') {
                              Get.to(() =>
                                  PhotoViewScreen(imageLink: widget.jobModel.imgTwo));
                            }
                          },
                          child:
                              CustomCacheImage(imgUrl: widget.jobModel.imgTwo)),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          onTap: () {
                            if (widget.jobModel.imgThree != '') {
                              Get.to(() => PhotoViewScreen(
                                  imageLink: widget.jobModel.imgThree));
                            }
                          },
                          child: CustomCacheImage(
                              imgUrl: widget.jobModel.imgThree)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: jobTitleController,
                  enabled: false,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: 'Job Title',
                      labelStyle: const TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.brown),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.brown),
                        borderRadius: BorderRadius.circular(15),
                      )),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: employerNameController,
                  enabled: false,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: 'Employer Title',
                      labelStyle: const TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.brown),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.brown),
                        borderRadius: BorderRadius.circular(15),
                      )),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: nameController,
                  enabled: false,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: const TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.brown),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.brown),
                        borderRadius: BorderRadius.circular(15),
                      )),
                ),

                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: addressController,
                  enabled: false,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: 'Address',
                      labelStyle: const TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.brown),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.brown),
                        borderRadius: BorderRadius.circular(15),
                      )),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: postCodeController,
                  enabled: false,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: 'Post Code',
                      labelStyle: const TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.brown),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.brown),
                        borderRadius: BorderRadius.circular(15),
                      )),
                ),

                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: phoneController,
                  enabled: false,
                  readOnly: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: const TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.brown),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.brown),
                        borderRadius: BorderRadius.circular(15),
                      )),
                ),

                ///phone2
                (widget.jobModel.number2 != "" &&
                        widget.jobModel.number2 != null)
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          TextField(
                            controller: phoneController2,
                            enabled: false,
                            readOnly: true,
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
                        ],
                      )
                    : const SizedBox(),

                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: measurementDateController,
                  readOnly: true,
                  enabled: false,
                  decoration: InputDecoration(
                      labelText: 'Date Measurement',
                      labelStyle: const TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.brown),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.brown),
                        borderRadius: BorderRadius.circular(15),
                      )),
                ),

                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: fittingDateController,
                  readOnly: true,
                  enabled: false,
                  decoration: InputDecoration(
                      labelText: 'Date Fitting',
                      labelStyle: const TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.brown),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.brown),
                        borderRadius: BorderRadius.circular(15),
                      )),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: customNoteController,
                  readOnly: true,
                  enabled: false,
                  decoration: InputDecoration(
                      labelText: 'Custom Note',
                      labelStyle: const TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.brown),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.brown),
                        borderRadius: BorderRadius.circular(15),
                      )),
                ),

                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Text(
                    'Current Job Status : ${widget.jobModel.status}',
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
