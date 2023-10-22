import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamland/Constants/AppConstants.dart';
import 'package:dreamland/Model/job_form_model.dart';
import 'package:dreamland/screens/pdf_viewer.dart';
import 'package:dreamland/utils/global_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/job_form_pdf.dart';

class ViewJobFormsController extends GetxController {
  // List<Rx<bool>> loadingList = [];

  Map<String,Rx<bool>> loadingStatesMap = {};

  final TextEditingController searchController = TextEditingController();


  List<JobFormModel> allJobForms = [];
  RxList<JobFormModel> filteredJobForms = RxList<JobFormModel>([]);


  void fillLoadingMap(int length){
    for(int i = 0; i < length; i++){
      loadingStatesMap[allJobForms[i].id] = false.obs;
    }
  }

  Future<void> handleMainButtonTap(JobFormModel jobForm,int index) async {
    try {

      loadingStatesMap[jobForm.id]!.value = true;

      String? pdfUrl = jobForm.pdfLink;

      if (pdfUrl != null) {
        Get.to(() => ViewPdfScreen(
              pdfUrlOrPath: pdfUrl,
              localFile: false,
            ));
        return;
      }

      await createNewPdf(jobForm);

    } catch (e) {
      Get.snackbar('Error', 'Something went wrong\n${e.toString()}',
          backgroundColor: Colors.red, colorText: Colors.white
      );
      if (kDebugMode) rethrow;
    } finally {
      loadingStatesMap[jobForm.id]!.value = false;
    }
  }

  Future<void> createNewPdf(JobFormModel jobForm) async {
    String? pdfPath =
        (await JobFormPdf(jobFormModel: jobForm).saveJobFormPdf());

    if (pdfPath != null) {
      updatePdfLink(jobForm, pdfPath);
      Get.to(() => ViewPdfScreen(
            pdfUrlOrPath: pdfPath,
            localFile: true,
          ));
    }
  }

  Future<void> overwritePdf(JobFormModel jobFormModel,int index) async{
    try {
      loadingStatesMap[jobFormModel.id]!.value = true;
      await createNewPdf(jobFormModel);
    }
    catch (e){
      Get.snackbar('Error', 'Something went wrong', backgroundColor: Colors.red, colorText: Colors.white);
      if(kDebugMode) rethrow;
    }
    finally{
      loadingStatesMap[jobFormModel.id]!.value = false;
    }
  }

  Future<String?> updatePdfLink(JobFormModel jobFormModel, String path) async {
    try {
      String pdfUrl =
          (await uploadAndGetFileDownloadUrl(File(path).readAsBytesSync()))!;
      await FirebaseFirestore.instance
          .collection(CollectionKeys.jobForms)
          .doc(jobFormModel.id)
          .update({
        'pdfLink': pdfUrl,
      });
      return pdfUrl;
    } catch (e) {
      if (kDebugMode) rethrow;
      return null;
    }
  }

  void setFilteredList(List<JobFormModel> updatedList){
    filteredJobForms.value = List.from(updatedList);
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  void onSearchTextChanged(String text) async {
    if (text.trim().isEmpty) {
      setFilteredList(allJobForms);
      return;
    }

    if (isNumeric(text)) {
      onSearchTextChangedV2(text);
      return;
    }

    setFilteredList(allJobForms
        .where((data) => (data.postCode
        .toString()
        .toLowerCase()
        .contains(text.toLowerCase()) ||
        data
        .otherDetails
            .toString()
            .toLowerCase()
            .contains(text.toLowerCase()) ||
        data.customerName
            .toString()
            .toLowerCase()
            .contains(text.toLowerCase()) ||
        data.jobRefNo
            .toString()
            .toLowerCase()
            .contains(text.toLowerCase()) ||
        // data.status.toString().toLowerCase().contains(text.toLowerCase()) ||
        data.customerAddress.toString().toLowerCase().contains(text.toLowerCase())))
        .toList());
  }

  ///For numbers search
  void onSearchTextChangedV2(String text) async {
    if (text.isEmpty) {
      // setState(() {
      //   homeController.allJobsList.addAll(dummyJobModel);
      // });
    } else {
      setFilteredList(allJobForms
          .where((data) =>
      data.telNo
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase()) ||
          data.customerAddress
              .toString()
              .toLowerCase()
              .contains(text.toLowerCase()))
          .toList());
    }
  }

}
