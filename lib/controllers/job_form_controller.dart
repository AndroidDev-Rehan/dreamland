import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class JobFormController extends GetxController{

  FocusNode measurementDateFocusNode = FocusNode();
  FocusNode fittingDateFocusNode = FocusNode();
  TextEditingController measurementDateController = TextEditingController();
  TextEditingController orderNoController = TextEditingController();
  TextEditingController fittingDateController = TextEditingController();

  List<String> tableRowsData = ['0','1','2'];


  Rx<bool> section1Hidden = false.obs;
  Rx<bool> section2Hidden = false.obs;
  Rx<bool> materialSectHidden = false.obs;

  Map<String,TextEditingController> locationControllersMap = {};
  Map<String,TextEditingController> wControllersMap = {};
  Map<String,TextEditingController> hControllersMap = {};
  Map<String,TextEditingController> descControllersMap = {};
  Map<String,TextEditingController> amountControllersMap = {};



  Rx<bool> carpetFittingSelected = false.obs;
  Rx<bool> laminateFittingSelected = false.obs;
  Rx<bool> deliveryOnlySelected = false.obs;


  @override
  void onInit() {
    print('on init called');


    // TODO: implement onInit
    super.onInit();
  }


}