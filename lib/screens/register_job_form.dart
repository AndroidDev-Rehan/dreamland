import 'dart:typed_data';

import 'package:dreamland/controllers/job_form_controller.dart';
import 'package:dreamland/screens/drawing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class RegisterJobForm extends StatefulWidget {
  const RegisterJobForm({Key? key}) : super(key: key);

  @override
  State<RegisterJobForm> createState() => _RegisterJobFormState();
}

class _RegisterJobFormState extends State<RegisterJobForm> {
  final JobFormController jobFormController = Get.put(JobFormController());

  @override
  void initState() {
    jobFormController.measurementDateController.text =
        DateFormat("dd-MM-yyyy").format(DateTime.now());
    jobFormController.fittingDateController.text =
        DateFormat("dd-MM-yyyy").format(DateTime.now());

    for (var element in jobFormController.tableRowsData) {
      jobFormController.locationControllersMap[element.toString()] =
          TextEditingController();
      jobFormController.descControllersMap[element.toString()] =
          TextEditingController();
      jobFormController.amountControllersMap[element.toString()] =
          TextEditingController();
      jobFormController.wControllersMap[element.toString()] =
          TextEditingController();
      jobFormController.hControllersMap[element.toString()] =
          TextEditingController();
      jobFormController.unitPrizeControllersMap[element.toString()] =
          TextEditingController();
      jobFormController.stockLocationControllersMap[element.toString()] =
          TextEditingController();
      jobFormController.floringColorControllersMap[element.toString()] =
          TextEditingController();
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Order Form"),
        actions: [
          Icon(Icons.save),
          20.horizontalSpace,
        ],
      ),
      body: SingleChildScrollView(
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
            print("adding row with id: $id");
            jobFormController.tableRowsData.add(id);
            jobFormController.locationControllersMap[id] =
                TextEditingController();
            jobFormController.descControllersMap[id] = TextEditingController();
            jobFormController.hControllersMap[id] = TextEditingController();
            jobFormController.wControllersMap[id] = TextEditingController();
            jobFormController.amountControllersMap[id] =
                TextEditingController();

            jobFormController.unitPrizeControllersMap[id] =
                TextEditingController();
            jobFormController.floringColorControllersMap[id] =
                TextEditingController();
            jobFormController.stockLocationControllersMap[id] =
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
                        jobFormController.section1Hidden.value
                            ? "Expand"
                            : "Hide",
                        style: TextStyle(color: Colors.brown, fontSize: 20.sp),
                      ),
                      5.horizontalSpace,
                      Icon(
                        !jobFormController.section1Hidden.value
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        size: 30,
                        color: Colors.brown,
                      )
                    ],
                  ),
                  onTap: () {
                    jobFormController.section1Hidden.value =
                        !jobFormController.section1Hidden.value;
                  },
                )
              ],
            ),
            8.verticalSpace,
            jobFormController.section1Hidden.value
                ? const SizedBox()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              focusNode:
                                  jobFormController.measurementDateFocusNode,
                              readOnly: true,
                              controller:
                                  jobFormController.measurementDateController,
                              onTap: () async {
                                DateTime? dateTime = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate:
                                        DateTime(DateTime.now().year + 1));
                                if (dateTime != null) {
                                  print("dateTime not null");
                                  jobFormController
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
                              controller: jobFormController.orderNoController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  label: Text("Order NO")),
                            ),
                          ),
                          5.horizontalSpace,
                          Expanded(
                            child: TextFormField(
                              focusNode: jobFormController.fittingDateFocusNode,
                              readOnly: true,
                              controller:
                                  jobFormController.fittingDateController,
                              onTap: () async {
                                DateTime? dateTime = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate:
                                        DateTime(DateTime.now().year + 1));
                                if (dateTime != null) {
                                  jobFormController.fittingDateController.text =
                                      DateFormat("dd-MM-yyyy").format(dateTime);
                                } else {}
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
                              controller: jobFormController.nameController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  label: Text("Name")),
                            ),
                          ),
                          5.horizontalSpace,
                          Expanded(
                            child: TextFormField(
                              controller: jobFormController.addressController,
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
                              controller: jobFormController.postCodeController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  label: Text("PostCode")),
                            ),
                          ),
                          5.horizontalSpace,
                          Expanded(
                            child: TextFormField(
                              controller: jobFormController.telNoController,
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
                        jobFormController.section2Hidden.value
                            ? "Expand"
                            : "Hide",
                        style: TextStyle(color: Colors.brown, fontSize: 20.sp),
                      ),
                      5.horizontalSpace,
                      Icon(
                        !jobFormController.section2Hidden.value
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        size: 30,
                        color: Colors.brown,
                      )
                    ],
                  ),
                  onTap: () {
                    jobFormController.section2Hidden.value =
                        !jobFormController.section2Hidden.value;
                  },
                )
              ],
            ),
            8.verticalSpace,
            jobFormController.section2Hidden.value
                ? const SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  label: Text("Job Ref. NO")),
                            ),
                          ),
                          5.horizontalSpace,
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  label: Text("Invoice NO")),
                            ),
                          ),
                          5.horizontalSpace,
                          Expanded(
                            child: TextFormField(
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
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(),
                            label: Text("Other Details")),
                      ),
                      10.verticalSpace,
                      Obx(() => _checkBoxWithTitle("Carpet Fitting",
                              jobFormController.carpetFittingSelected.value,
                              () {
                            jobFormController.carpetFittingSelected.value =
                                !jobFormController.carpetFittingSelected.value;
                          })),
                      5.verticalSpace,
                      Obx(() => _checkBoxWithTitle("Laminate Fitting",
                              jobFormController.laminateFittingSelected.value,
                              () {
                            jobFormController.laminateFittingSelected.value =
                                !jobFormController
                                    .laminateFittingSelected.value;
                          })),
                      5.verticalSpace,
                      Obx(() => _checkBoxWithTitle("Delivery Only",
                              jobFormController.deliveryOnlySelected.value, () {
                            jobFormController.deliveryOnlySelected.value =
                                !jobFormController.deliveryOnlySelected.value;
                          }))
                    ],
                  ),
          ],
        ));
  }

  Widget _buildSection3() {
    String text1 = "COLOURS AND PATTERNS OF ALL FLOOR COVERINGS MAY VARY SLIGHTLY. YOU MAY NOTICE COLOUR SHADING IN YOUR NEW CARPETS. THIS IS A NORMAL AND INHERENT CHARACTERISTIC OF CUT-PILE CARPETS. BEADING THAT IS SUPPLIED WITH THE LAMINATE FLOORING MAY VARY SLIGHTLY IN COLOUR AND IT IS HIGHLY UNLIKELY THAT THE BEADING AND LAMINATE FLOORING WILL BE AN EXACT MATCH (IN TERMS OF COLOUR AND TEXTURE). BY SIGNING THIS FORM, YOU ALSO AGREE THAT WHERE PAYMENT IS MADE BY CREDIT CARD, YOU WAIVE YOUR RIGHT TO MAKE A CLAIM FOR A REFUND (OR A CHARGEBACK).";
    String text2 = "FULL PAYMENT REQUIRED BEFORE FITTING";
    String text3 = "COLOURS AND PATTERNS OF ALL FLOOR COVERINGS MAY VARY SLIGHTLY. YOU MAY NOTICE COLOUR SHADING IN YOUR NEW CARPETS. THIS IS A NORMAL AND INHERENT CHARACTERISTIC OF CUT-PILE CARPETS.";

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
                    jobFormController.section3Hidden.value
                        ? "Expand"
                        : "Hide",
                    style: TextStyle(color: Colors.brown, fontSize: 20.sp),
                  ),
                  5.horizontalSpace,
                  Icon(
                    !jobFormController.section3Hidden.value
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    size: 30,
                    color: Colors.brown,
                  )
                ],
              ),
              onTap: () {
                jobFormController.section3Hidden.value =
                !jobFormController.section3Hidden.value;
              },
            )
          ],
        ),
        8.verticalSpace,
        jobFormController.section3Hidden.value
            ? const SizedBox()
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 10.verticalSpace,
            Obx(() => _checkBoxWithTitle("Door Trimming Required",
                jobFormController.doorTrimmingRequired.value,
                    () {
                  jobFormController.doorTrimmingRequired.value =
                  !jobFormController.doorTrimmingRequired.value;
                },
            // textColor: Colors.black
            ),
            ),
            5.verticalSpace,
            Obx(() => _checkBoxWithTitle("Condition of Floor: Work Needed?",
                jobFormController.workNeeded.value,
                    () {
                  jobFormController.workNeeded.value =
                  !jobFormController
                      .workNeeded.value;
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
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(),
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
            color: Colors.red,
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
                    jobFormController.signaturesSectHidden.value
                        ? "Expand"
                        : "Hide",
                    style: TextStyle(color: Colors.brown, fontSize: 20.sp),
                  ),
                  5.horizontalSpace,
                  Icon(
                    !jobFormController.signaturesSectHidden.value
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    size: 30,
                    color: Colors.brown,
                  )
                ],
              ),
              onTap: () {
                jobFormController.signaturesSectHidden.value =
                !jobFormController.signaturesSectHidden.value;
              },
            )
          ],
        ),
        8.verticalSpace,
        jobFormController.signaturesSectHidden.value
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
              Obx(() => textPortion("ACCEPTANCE OF ESTIMATE",estimatedAcceptanceText,jobFormController.estimateAcceptanceImageBytes.value,textEditingController: jobFormController.estimateAcceptanceNameController,label: "Name")),
              20.verticalSpace,
              Obx(() => textPortion("WORK SATISFACTORY COMPLETED",satisfactoryWorkAcceptanceText,jobFormController.workSatisfactoryImageBytes.value,secondSign: true, textEditingController: jobFormController.workSatisfactoryNameController,label: "Name")),

          ],
        ),
            ),
      ],
    ));
  }



  Widget _checkBoxWithTitle(
      String title, bool selected, void Function() onTap, {Color? textColor}) {
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
                      selected
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
    Widget _oneTableRow(String id, int index) {
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
                      jobFormController.tableRowsData
                          .removeWhere((element) => element == id);
                      jobFormController.locationControllersMap
                          .removeWhere((key, value) => key == id);
                      jobFormController.descControllersMap
                          .removeWhere((key, value) => key == id);
                      jobFormController.wControllersMap
                          .removeWhere((key, value) => key == id);
                      jobFormController.hControllersMap
                          .removeWhere((key, value) => key == id);
                      jobFormController.amountControllersMap
                          .removeWhere((key, value) => key == id);
                      jobFormController.unitPrizeControllersMap
                          .removeWhere((key, value) => key == id);
                      jobFormController.stockLocationControllersMap
                          .removeWhere((key, value) => key == id);
                      jobFormController.floringColorControllersMap
                          .removeWhere((key, value) => key == id);

                      print('removing id $id\n\n');
                      print(jobFormController.tableRowsData);
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
                    controller: jobFormController.locationControllersMap[id]!,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(),
                        label: Text("Location"),
                        labelStyle: TextStyle(fontSize: 16.sp)),
                  ),
                ),
                5.horizontalSpace,
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: jobFormController.wControllersMap[id]!,
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
                          controller: jobFormController.hControllersMap[id]!,
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
                    controller: jobFormController.unitPrizeControllersMap[id]!,
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
                        jobFormController.floringColorControllersMap[id]!,
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
                        jobFormController.stockLocationControllersMap[id]!,
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
                    controller: jobFormController.amountControllersMap[id]!,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(),
                      label: const Text("Amount"),
                      labelStyle: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ),
              ],
            ),
            5.verticalSpace,
            TextFormField(
              controller: jobFormController.descControllersMap[id]!,
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

    Widget _totalAmountRow() {
      return Row(
        children: [
          Expanded(
            child: TextFormField(
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
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(),
                label: const Text("BALANCE DUE"),
                labelStyle: TextStyle(fontSize: 16.sp),
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
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
              Spacer(),
              InkWell(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      jobFormController.jobFormHidden.value ? "Expand" : "Hide",
                      style: TextStyle(color: Colors.brown, fontSize: 20.sp),
                    ),
                    5.horizontalSpace,
                    Icon(
                      !jobFormController.jobFormHidden.value
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      size: 30,
                      color: Colors.brown,
                    )
                  ],
                ),
                onTap: () {
                  jobFormController.jobFormHidden.value =
                      !jobFormController.jobFormHidden.value;
                },
              )
            ],
          ),
          if (!jobFormController.jobFormHidden.value)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                5.verticalSpace,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: jobFormController.tableRowsData.map((e) {
                    return _oneTableRow(e, ++index);
                  }).toList(),
                ),
                5.verticalSpace,
                _totalAmountRow(),
              ],
            ),
        ],
      );
    });
  }

  Widget _buildMaterialsSection() {
    Widget _buildSingleMaterialRow(String materialName) {
      return Row(
        children: [
          Expanded(
            child: TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(),
                label: Text(materialName),
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
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(),
                        label: Text("QTY")),
                  ),
                ),
                5.horizontalSpace,
                Expanded(
                  child: TextFormField(
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
                        jobFormController.materialSectHidden.value
                            ? "Expand"
                            : "Hide",
                        style: TextStyle(color: Colors.brown, fontSize: 20.sp),
                      ),
                      5.horizontalSpace,
                      Icon(
                        !jobFormController.materialSectHidden.value
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        size: 30,
                        color: Colors.brown,
                      )
                    ],
                  ),
                  onTap: () {
                    jobFormController.materialSectHidden.value =
                        !jobFormController.materialSectHidden.value;
                  },
                )
              ],
            ),
            if (!jobFormController.materialSectHidden.value)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSingleMaterialRow("CC"),
                  _buildSingleMaterialRow("CL"),
                  _buildSingleMaterialRow("CV"),
                  _buildSingleMaterialRow("LV"),
                  _buildSingleMaterialRow("EP"),
                  _buildSingleMaterialRow("DP"),
                ],
              ),
          ],
        ));
  }
}
