import 'dart:typed_data';

import 'package:dreamland/controllers/job_form_controller.dart';
import 'package:dreamland/screens/drawing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:dreamland/enums/materials.dart' as m;

class RegisterJobForm extends StatefulWidget {
  const RegisterJobForm({Key? key}) : super(key: key);

  @override
  State<RegisterJobForm> createState() => _RegisterJobFormState();
}

class _RegisterJobFormState extends State<RegisterJobForm> {
  final JobFormController _jobFormController = Get.put(JobFormController());

  @override
  void initState() {
    // _jobFormController.measurementDateController.text =
    //     _jobFormController.dateFormat.format(DateTime.now());
    // _jobFormController.fittingDateController.text =
    //     _jobFormController.dateFormat.format(DateTime.now());

    for (var element in _jobFormController.tableRowsData) {
      _jobFormController.locationControllersMap[element.toString()] =
          TextEditingController();
      _jobFormController.descControllersMap[element.toString()] =
          TextEditingController();
      _jobFormController.quantityControllersMap[element.toString()] =
          TextEditingController();
      _jobFormController.wControllersMap[element.toString()] =
          TextEditingController();
      _jobFormController.hControllersMap[element.toString()] =
          TextEditingController();
      _jobFormController.unitPrizeControllersMap[element.toString()] =
          TextEditingController();
      _jobFormController.stockLocationControllersMap[element.toString()] =
          TextEditingController();
      _jobFormController.floringColorControllersMap[element.toString()] =
          TextEditingController();
    }

    _jobFormController.fillMaterialControllersMap();
    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Order Form"),
        actions: [
          if(!_jobFormController.saving)
          GestureDetector(
              onTap: () async{
                setState(() {
                  _jobFormController.saving = true;
                });
                bool result = await _jobFormController.saveJobForm();
                    if(!result){
                  setState(() {
                    _jobFormController.saving = false;
                  });
                }
              },
              child: const Icon(Icons.save)),
          20.horizontalSpace,
        ],
      ),
      body:
      _jobFormController.saving ?  const Center(
        child: CircularProgressIndicator(
        ),
      ):
      SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            15.verticalSpace,
            _buildFormHeader(context),
            15.verticalSpace,
            _buildItemsTable(),
            10.verticalSpace,
            _buildMaterialsSection(),
            10.verticalSpace,
            _buildSection3(),
            10.verticalSpace,
            _buildSignaturesSection(),
            100.verticalSpace,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            String id = const Uuid().v4();
            //print("adding row with id: $id");
            _jobFormController.tableRowsData.add(id);
            _jobFormController.locationControllersMap[id] =
                TextEditingController();
            _jobFormController.descControllersMap[id] = TextEditingController();
            _jobFormController.hControllersMap[id] = TextEditingController();
            _jobFormController.wControllersMap[id] = TextEditingController();
            _jobFormController.quantityControllersMap[id] =
                TextEditingController();

            _jobFormController.unitPrizeControllersMap[id] =
                TextEditingController();
            _jobFormController.floringColorControllersMap[id] =
                TextEditingController();
            _jobFormController.stockLocationControllersMap[id] =
                TextEditingController();

            setState(() {});
          }),
    );
  }

  Widget _buildFormHeader(BuildContext context) {
    return Column(
      children: [
        _buildSection1(),
        10.verticalSpace,
        _buildSection2(),
      ],
    );
  }

  Widget _buildSection1() {
    return Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text("Section 1",
                    style: TextStyle(
                        color: Colors.brown,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                InkWell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _jobFormController.section1Hidden.value
                            ? "Expand"
                            : "Hide",
                        style: TextStyle(color: Colors.brown, fontSize: 20.sp),
                      ),
                      5.horizontalSpace,
                      Icon(
                        !_jobFormController.section1Hidden.value
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        size: 30,
                        color: Colors.brown,
                      )
                    ],
                  ),
                  onTap: () {
                    _jobFormController.section1Hidden.value =
                        !_jobFormController.section1Hidden.value;
                  },
                )
              ],
            ),
            8.verticalSpace,
            _jobFormController.section1Hidden.value
                ? const SizedBox()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              // focusNode:
                              //     _jobFormController.measurementDateFocusNode,
                              readOnly: true,
                              controller:
                                  _jobFormController.measurementDateController,
                              onTap: () async {
                                DateTime? dateTime = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate:
                                        DateTime(DateTime.now().year + 1));
                                if (dateTime != null) {
                                  //print("dateTime not null");
                                  _jobFormController
                                          .measurementDateController.text =
                                      DateFormat("dd-MM-yyyy").format(dateTime);
                                } else {}
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                enabledBorder: const OutlineInputBorder(),
                                label: Text("Measurement Date",
                                    style: TextStyle(fontSize: 13.sp)),
                                hintText: "Measurement Date",
                              ),
                            ),
                          ),
                          5.horizontalSpace,
                          Expanded(
                            child: TextFormField(
                              controller: _jobFormController.orderNoController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  label: Text("Order NO")),
                            ),
                          ),
                          5.horizontalSpace,
                          Expanded(
                            child: TextFormField(
                              // focusNode: _jobFormController.fittingDateFocusNode,
                              readOnly: true,
                              controller:
                                  _jobFormController.fittingDateController,
                              onTap: () async {
                                DateTime? dateTime = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate:
                                        DateTime(DateTime.now().year + 1));
                                if (dateTime != null) {
                                  _jobFormController.fittingDateController.text =
                                      DateFormat("dd-MM-yyyy").format(dateTime);
                                }
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  label: Text("Fitting Date")),
                            ),
                          ),
                        ],
                      ),
                      5.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _jobFormController.nameController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  label: Text("Name")),
                            ),
                          ),
                          5.horizontalSpace,
                          Expanded(
                            child: TextFormField(
                              controller: _jobFormController.addressController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  label: Text("Address")),
                            ),
                          )
                        ],
                      ),
                      5.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _jobFormController.postCodeController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  label: Text("PostCode")),
                            ),
                          ),
                          5.horizontalSpace,
                          Expanded(
                            child: TextFormField(
                              controller: _jobFormController.telNoController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  label: Text("Tel. No")),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
          ],
        ));
  }

  Widget _buildSection2() {
    return Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text("Section 2",
                    style: TextStyle(
                        color: Colors.brown,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                InkWell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _jobFormController.section2Hidden.value
                            ? "Expand"
                            : "Hide",
                        style: TextStyle(color: Colors.brown, fontSize: 20.sp),
                      ),
                      5.horizontalSpace,
                      Icon(
                        !_jobFormController.section2Hidden.value
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        size: 30,
                        color: Colors.brown,
                      )
                    ],
                  ),
                  onTap: () {
                    _jobFormController.section2Hidden.value =
                        !_jobFormController.section2Hidden.value;
                  },
                )
              ],
            ),
            8.verticalSpace,
            _jobFormController.section2Hidden.value
                ? const SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _jobFormController.jobRefNoController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  label: Text("Job Ref. NO")),
                            ),
                          ),
                          5.horizontalSpace,
                          Expanded(
                            child: TextFormField(
                              controller: _jobFormController.invoiceNoController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  label: Text("Invoice NO")),
                            ),
                          ),
                          5.horizontalSpace,
                          Expanded(
                            child: TextFormField(
                              controller: _jobFormController.completedByController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  label: Text("Completed By")),
                            ),
                          ),
                        ],
                      ),
                      5.verticalSpace,
                      TextFormField(
                        controller: _jobFormController.otherDetailsController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(),
                            label: Text("Other Details")),
                      ),
                      10.verticalSpace,
                      Obx(() => _checkBoxWithTitle("Carpet Fitting",
                              _jobFormController.carpetFittingSelected.value ?? false,
                              () {
                            _jobFormController.carpetFittingSelected.value =
                                !(_jobFormController.carpetFittingSelected.value ?? false) ;
                          })),
                      5.verticalSpace,
                      Obx(() => _checkBoxWithTitle("Laminate Fitting",
                              _jobFormController.laminateFittingSelected.value ?? false,
                              () {
                            _jobFormController.laminateFittingSelected.value =
                                !(_jobFormController
                                    .laminateFittingSelected.value ?? false);
                          })),
                      5.verticalSpace,
                      Obx(() => _checkBoxWithTitle("Delivery Only",
                              _jobFormController.deliveryOnlySelected.value ?? false, () {
                            _jobFormController.deliveryOnlySelected.value =
                                !(_jobFormController.deliveryOnlySelected.value ?? false);
                          }))
                    ],
                  ),
          ],
        ));
  }

  Widget _buildSection3() {
    String text1 = "COLOURS AND PATTERNS OF ALL FLOOR COVERINGS MAY VARY SLIGHTLY. YOU MAY NOTICE COLOUR SHADING IN YOUR NEW CARPETS. THIS IS A NORMAL AND INHERENT CHARACTERISTIC OF CUT-PILE CARPETS. BEADING THAT IS SUPPLIED WITH THE LAMINATE FLOORING MAY VARY SLIGHTLY IN COLOUR AND IT IS HIGHLY UNLIKELY THAT THE BEADING AND LAMINATE FLOORING WILL BE AN EXACT MATCH (IN TERMS OF COLOUR AND TEXTURE). BY SIGNING THIS FORM, YOU ALSO AGREE THAT WHERE PAYMENT IS MADE BY CREDIT CARD, YOU WAIVE YOUR RIGHT TO MAKE A CLAIM FOR A REFUND (OR A CHARGEBACK).";
    String text2 = "FULL PAYMENT REQUIRED BEFORE FITTING";
    // String text3 = "COLOURS AND PATTERNS OF ALL FLOOR COVERINGS MAY VARY SLIGHTLY. YOU MAY NOTICE COLOUR SHADING IN YOUR NEW CARPETS. THIS IS A NORMAL AND INHERENT CHARACTERISTIC OF CUT-PILE CARPETS.";

    Widget textPortion(){
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black)
        ),
        child: Column(
          children: [
            Text(text1,
            // textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),),
            8.verticalSpace,
            Text(text2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),),
            // 8.verticalSpace,
            // Text(text3,
            //   // textAlign: TextAlign.center,
            //   style: TextStyle(
            //     fontSize: 12.sp,
            //     fontWeight: FontWeight.bold,
            //   ),)



          ],
        ),
      );
    }

    return Obx(() => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text("Section 3",
                style: TextStyle(
                    color: Colors.brown,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold)),
            const Spacer(),
            InkWell(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _jobFormController.section3Hidden.value
                        ? "Expand"
                        : "Hide",
                    style: TextStyle(color: Colors.brown, fontSize: 20.sp),
                  ),
                  5.horizontalSpace,
                  Icon(
                    !_jobFormController.section3Hidden.value
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    size: 30,
                    color: Colors.brown,
                  )
                ],
              ),
              onTap: () {
                _jobFormController.section3Hidden.value =
                !_jobFormController.section3Hidden.value;
              },
            )
          ],
        ),
        8.verticalSpace,
        _jobFormController.section3Hidden.value
            ? const SizedBox()
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 10.verticalSpace,
            Obx(() => _checkBoxWithTitle("Door Trimming Required",
                _jobFormController.doorTrimmingRequired.value,
                    () {
                  _jobFormController.doorTrimmingRequired.value =
                  !(_jobFormController.doorTrimmingRequired.value ?? false);
                },
            // textColor: Colors.black
            ),
            ),
            5.verticalSpace,
            Obx(() => _checkBoxWithTitle("Condition of Floor: Work Needed?",
                _jobFormController.workNeeded.value,
                    () {
                  _jobFormController.workNeeded.value =
                  !(_jobFormController
                      .workNeeded.value ?? false);
                },
                // textColor: Colors.black

            )),
            10.verticalSpace,
            textPortion(),
          ],
        ),
      ],
    ));
  }

  Widget _buildSignaturesSection() {
    String estimatedAcceptanceText = "I hereby accept the estimate outlined above and authorised work to be carried accordingly on the date stated above and I Agree To the Terms & Conditions Printed Overleaf.";
    String satisfactoryWorkAcceptanceText = "I hereby accept the above described work has been completed to my satisfaction.Dreamland Carpet & Floors Ltd will not accept responsibility for complaints after 7 days.";


    Widget textPortion(String heading, String detailText, Uint8List imageBytes, {bool secondSign=false, required String label, required TextEditingController textEditingController}){
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading,
            // textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),),
          5.verticalSpace,
          Text(detailText,
            // textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),),
          5.verticalSpace,
          Row(
            children: [
              ElevatedButton(onPressed: (){
                Get.to(()=> DrawingScreen(
                  secondSignature: secondSign,
                ));
              }, child: const Text("Signature")),
              const Spacer(),
      SizedBox(

        height: 45.h,
        width: 160.w,
        child:  TextFormField(
          controller: textEditingController,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(),
              label: Text(label),
              labelStyle: TextStyle(fontSize: 16.sp)),
        ),
      ),
            ],
          ),
          5.verticalSpace,
          imageBytes.isEmpty ?
          const Text("    Nothing to show", style: TextStyle(fontStyle: FontStyle.italic),) :
          Container(
            color: Colors.grey[200],
            child: Image.memory(imageBytes,
            height: 200,
              width: Get.width,
              fit: BoxFit.cover,
            ),
          )





        ],
      );
    }

    return Obx(() => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text("Signatures Section",
                style: TextStyle(
                    color: Colors.brown,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold)),
            const Spacer(),
            InkWell(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _jobFormController.signaturesSectHidden.value
                        ? "Expand"
                        : "Hide",
                    style: TextStyle(color: Colors.brown, fontSize: 20.sp),
                  ),
                  5.horizontalSpace,
                  Icon(
                    !_jobFormController.signaturesSectHidden.value
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    size: 30,
                    color: Colors.brown,
                  )
                ],
              ),
              onTap: () {
                _jobFormController.signaturesSectHidden.value =
                !_jobFormController.signaturesSectHidden.value;
              },
            )
          ],
        ),
        8.verticalSpace,
        _jobFormController.signaturesSectHidden.value
            ? const SizedBox()
            : Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black)
          ),
          child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
              Obx(() => textPortion("ACCEPTANCE OF ESTIMATE",estimatedAcceptanceText,_jobFormController.estimateAcceptanceImageBytes.value,textEditingController: _jobFormController.estimateAcceptanceNameController,label: "Name")),
              20.verticalSpace,
              Obx(() => textPortion("WORK SATISFACTORY COMPLETED",satisfactoryWorkAcceptanceText,_jobFormController.workSatisfactoryImageBytes.value,secondSign: true, textEditingController: _jobFormController.workSatisfactoryNameController,label: "Name")),

          ],
        ),
            ),
      ],
    ));
  }



  Widget _checkBoxWithTitle(
      String title, bool? selected, void Function() onTap, {Color? textColor}) {
    return Material(
      borderRadius: BorderRadius.circular(4),
      elevation: 5,
      color: Colors.white,
      child: Padding(
        padding:
            EdgeInsets.only(left: 10.w, right: 20.w, top: 10.h, bottom: 10.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: Text(
              title,
              style: TextStyle(color:textColor ?? Colors.brown, fontSize: 18.sp),
            )),
            30.horizontalSpace,
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                    onTap: onTap,
                    child: Icon(
                      (selected ?? false)
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: Colors.brown,
                      size: 30,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItemsTable() {
    Widget oneTableRow(String id, int index) {
      return Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.brown, borderRadius: BorderRadius.circular(2)),
              child: Row(
                children: [
                  5.horizontalSpace,
                  Text(
                    "Item ${index.toString()}",
                    style: TextStyle(
                        color: Colors.white,
                        // fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      _jobFormController.tableRowsData
                          .removeWhere((element) => element == id);
                      _jobFormController.locationControllersMap
                          .removeWhere((key, value) => key == id);
                      _jobFormController.descControllersMap
                          .removeWhere((key, value) => key == id);
                      _jobFormController.wControllersMap
                          .removeWhere((key, value) => key == id);
                      _jobFormController.hControllersMap
                          .removeWhere((key, value) => key == id);
                      _jobFormController.quantityControllersMap
                          .removeWhere((key, value) => key == id);
                      _jobFormController.unitPrizeControllersMap
                          .removeWhere((key, value) => key == id);
                      _jobFormController.stockLocationControllersMap
                          .removeWhere((key, value) => key == id);
                      _jobFormController.floringColorControllersMap
                          .removeWhere((key, value) => key == id);

                      // print('removing id $id\n\n');
                      // print(jobFormController.tableRowsData);
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            5.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _jobFormController.locationControllersMap[id]!,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(),
                        label: const Text("Location"),
                        labelStyle: TextStyle(fontSize: 16.sp)),
                  ),
                ),
                5.horizontalSpace,
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _jobFormController.wControllersMap[id]!,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 20),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(),
                              label: Text(" W")),
                        ),
                      ),
                      Icon(
                        Icons.close,
                        size: 15.w,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _jobFormController.hControllersMap[id]!,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 3, vertical: 20),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(),
                            label: Text(" H"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                5.horizontalSpace,
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _jobFormController.unitPrizeControllersMap[id]!,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(),
                        label: const Text("Unit Price",
                            textAlign: TextAlign.center),
                        labelStyle: TextStyle(
                          fontSize: 15.sp,
                        )),
                  ),
                ),
              ],
            ),
            5.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller:
                        _jobFormController.floringColorControllersMap[id]!,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(),
                        label: Text("Floring Color"),
                        labelStyle: TextStyle(fontSize: 16.sp)),
                  ),
                ),
                5.horizontalSpace,
                Expanded(
                  child: TextFormField(
                    controller:
                        _jobFormController.stockLocationControllersMap[id]!,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(),
                        label: const Text("Stock Location",
                            textAlign: TextAlign.center),
                        labelStyle: TextStyle(
                          fontSize: 15.sp,
                        )),
                  ),
                ),
                5.horizontalSpace,
                Expanded(
                  child: TextFormField(
                    controller: _jobFormController.quantityControllersMap[id]!,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(),
                      label: const Text("Quantity"),
                      labelStyle: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ),
              ],
            ),
            5.verticalSpace,
            TextFormField(
              controller: _jobFormController.descControllersMap[id]!,
              maxLines: 2,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(),
                  label: const Text("Description"),
                  labelStyle: TextStyle(fontSize: 16.sp)),
            )
          ],
        ),
      );
    }

    Widget totalAmountRow() {
      return Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _jobFormController.depositController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(),
                label: const Text("DEPOSIT"),
                labelStyle: TextStyle(fontSize: 16.sp),
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _jobFormController.balanceDueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(),
                label: const Text("BALANCE DUE"),
                labelStyle: TextStyle(fontSize: 16.sp),
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _jobFormController.subTotalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(),
                label: const Text("SUB TOTAL"),
                labelStyle: TextStyle(fontSize: 16.sp),
              ),
            ),
          )
        ],
      );
    }

    return Obx(() {
      int index = 0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text("Job Form".toUpperCase(),
                  style: TextStyle(
                      color: Colors.brown,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              InkWell(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _jobFormController.jobFormHidden.value ? "Expand" : "Hide",
                      style: TextStyle(color: Colors.brown, fontSize: 20.sp),
                    ),
                    5.horizontalSpace,
                    Icon(
                      !_jobFormController.jobFormHidden.value
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      size: 30,
                      color: Colors.brown,
                    )
                  ],
                ),
                onTap: () {
                  _jobFormController.jobFormHidden.value =
                      !_jobFormController.jobFormHidden.value;
                },
              )
            ],
          ),
          if (!_jobFormController.jobFormHidden.value)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                5.verticalSpace,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _jobFormController.tableRowsData.map((e) {
                    return oneTableRow(e, ++index);
                  }).toList(),
                ),
                5.verticalSpace,
                totalAmountRow(),
              ],
            ),
        ],
      );
    });
  }

  Widget _buildMaterialsSection() {
    Widget buildSingleMaterialRow(String materialName) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(),
                  label: Text(materialName.toUpperCase()),
                  hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  hintText: materialName,
                ),
              ),
            ),
            5.horizontalSpace,
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _jobFormController.materialQtyControllersMap[materialName.toLowerCase()],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(),
                          label: Text("QTY")),
                    ),
                  ),
                  5.horizontalSpace,
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _jobFormController.materialPriceControllersMap[materialName.toLowerCase()],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(),
                          label: Text("€")),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }

    return Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text("Material Section",
                    style: TextStyle(
                        color: Colors.brown,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                InkWell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _jobFormController.materialSectHidden.value
                            ? "Expand"
                            : "Hide",
                        style: TextStyle(color: Colors.brown, fontSize: 20.sp),
                      ),
                      5.horizontalSpace,
                      Icon(
                        !_jobFormController.materialSectHidden.value
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        size: 30,
                        color: Colors.brown,
                      )
                    ],
                  ),
                  onTap: () {
                    _jobFormController.materialSectHidden.value =
                        !_jobFormController.materialSectHidden.value;
                  },
                )
              ],
            ),
            if (!_jobFormController.materialSectHidden.value)
              Column(
                mainAxisSize: MainAxisSize.min,
                children:
                m.Material.values.map((e) => buildSingleMaterialRow(e.name)).toList(),
                // [
                //   buildSingleMaterialRow("CC"),
                //   buildSingleMaterialRow("CL"),
                //   buildSingleMaterialRow("CV"),
                //   buildSingleMaterialRow("LV"),
                //   buildSingleMaterialRow("EP"),
                //   buildSingleMaterialRow("DP"),
                // ],
              ),
          ],
        ));
  }
}

///EP, DP , Bottom Checks