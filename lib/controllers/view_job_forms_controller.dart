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
  List<Rx<bool>> loadingList = [];

  void fillLoadingList(int length){
    loadingList = List.generate(length, (index) => false.obs);
  }

  Future<void> handleMainButtonTap(JobFormModel jobForm,int index) async {
    try {
      loadingList[index].value = true;
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
      loadingList[index].value = false;
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
      loadingList[index].value = true;
      await createNewPdf(jobFormModel);
    }
    catch (e){
      Get.snackbar('Error', 'Something went wrong', backgroundColor: Colors.red, colorText: Colors.white);
      if(kDebugMode) rethrow;
    }
    finally{
      loadingList[index].value = false;
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
}
