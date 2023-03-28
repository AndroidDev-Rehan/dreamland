import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:get/get.dart';

class JobFormController extends GetxController{

  FocusNode measurementDateFocusNode = FocusNode();
  FocusNode fittingDateFocusNode = FocusNode();
  TextEditingController measurementDateController = TextEditingController();
  TextEditingController orderNoController = TextEditingController();
  TextEditingController fittingDateController = TextEditingController();

  ///Section 1 Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  TextEditingController telNoController = TextEditingController();


  List<String> tableRowsData = ['0','1','2'];


  Rx<bool> section1Hidden = false.obs;
  Rx<bool> section2Hidden = false.obs;
  Rx<bool> section3Hidden = false.obs;
  Rx<bool> jobFormHidden = false.obs;
  Rx<bool> materialSectHidden = false.obs;
  Rx<bool> signaturesSectHidden = false.obs;

  Rx<Uint8List> estimateAcceptanceImageBytes = Uint8List(0).obs;
  Rx<Uint8List> workSatisfactoryImageBytes = Uint8List(0).obs;

  TextEditingController estimateAcceptanceNameController = TextEditingController();
  TextEditingController workSatisfactoryNameController = TextEditingController();



  // Rx<DrawingController> drawingController = DrawingController().obs;




  Map<String,TextEditingController> locationControllersMap = {};
  Map<String,TextEditingController> wControllersMap = {};
  Map<String,TextEditingController> hControllersMap = {};
  Map<String,TextEditingController> descControllersMap = {};
  Map<String,TextEditingController> amountControllersMap = {};
  Map<String,TextEditingController> unitPrizeControllersMap = {};
  Map<String,TextEditingController> stockLocationControllersMap = {};
  Map<String,TextEditingController> floringColorControllersMap = {};





  Rx<bool> carpetFittingSelected = false.obs;
  Rx<bool> laminateFittingSelected = false.obs;
  Rx<bool> deliveryOnlySelected = false.obs;

  ///Section 3

  Rx<bool> workNeeded = false.obs;      ///conditionOFFloor3
  Rx<bool> doorTrimmingRequired = false.obs;

  @override
  void onInit() {
    print('on init called');


    // TODO: implement onInit
    super.onInit();
  }


}