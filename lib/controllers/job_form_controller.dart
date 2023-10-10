import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamland/Model/job_form_model.dart';
import 'package:dreamland/Model/material_item.dart';
import 'package:dreamland/Model/table_item.dart';
import 'package:dreamland/enums/floor_condition.dart';
import 'package:dreamland/enums/materials.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as m;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../Constants/AppConstants.dart';
import '../utils/global_functions.dart';

class JobFormController extends GetxController {
  FocusNode measurementDateFocusNode = FocusNode();
  FocusNode fittingDateFocusNode = FocusNode();
  TextEditingController measurementDateController = TextEditingController();
  TextEditingController orderNoController = TextEditingController();
  TextEditingController fittingDateController = TextEditingController();
  bool saving = false;

  ///Section 1 Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  TextEditingController telNoController = TextEditingController();

 DateFormat dateFormat =  DateFormat("dd-MM-yyyy");

  List<String> tableRowsData = ['0', '1', '2'];

  Rx<bool> section1Hidden = false.obs;
  Rx<bool> section2Hidden = false.obs;
  Rx<bool> section3Hidden = false.obs;
  Rx<bool> jobFormHidden = false.obs;
  Rx<bool> materialSectHidden = false.obs;
  Rx<bool> signaturesSectHidden = false.obs;

  Rx<Uint8List> estimateAcceptanceImageBytes = Uint8List(0).obs;
  Rx<Uint8List> workSatisfactoryImageBytes = Uint8List(0).obs;

  TextEditingController estimateAcceptanceNameController =
      TextEditingController();
  TextEditingController workSatisfactoryNameController =
      TextEditingController();

  Map<String, TextEditingController> locationControllersMap = {};
  Map<String, TextEditingController> wControllersMap = {};
  Map<String, TextEditingController> hControllersMap = {};
  Map<String, TextEditingController> descControllersMap = {};
  Map<String, TextEditingController> quantityControllersMap = {};
  Map<String, TextEditingController> unitPrizeControllersMap = {};
  Map<String, TextEditingController> stockLocationControllersMap = {};
  Map<String, TextEditingController> floringColorControllersMap = {};

  Map<String, TextEditingController> materialQtyControllersMap = {};
  Map<String, TextEditingController> materialPriceControllersMap = {};

  final TextEditingController completedByController = TextEditingController();
  final TextEditingController otherDetailsController = TextEditingController();
  final TextEditingController invoiceNoController = TextEditingController();
  final TextEditingController jobRefNoController = TextEditingController();



  Rx<bool?> carpetFittingSelected = false.obs;
  Rx<bool?> laminateFittingSelected = false.obs;
  Rx<bool?> deliveryOnlySelected = false.obs;

  ///Section 3

  Rx<bool> workNeeded = false.obs;

  ///conditionOFFloor3
  Rx<bool> doorTrimmingRequired = false.obs;

  TextEditingController balanceDueController = TextEditingController();
  TextEditingController subTotalController = TextEditingController();
  TextEditingController depositController = TextEditingController();



  void fillMaterialControllersMap(){
    materialQtyControllersMap.clear();
    materialPriceControllersMap.clear();
    for (var element in Material.values) {
      materialQtyControllersMap[element.name] = TextEditingController();
      materialPriceControllersMap[element.name] = TextEditingController();
    }
  }

  Future<bool> saveJobForm() async{
    try
    {
      JobFormModel jobFormModel = await _getJobFormModel();
      await FirebaseFirestore.instance
          .collection(CollectionKeys.jobForms)
          .doc(jobFormModel.id)
          .set(jobFormModel.toMap());
      Get.back();
      Get.snackbar('Success', 'Job Form created', backgroundColor: m.Colors.green, colorText: m.Colors.white);
      return true;
    }
    catch (e){
      if(kDebugMode) rethrow;
      Get.snackbar('Error', 'Something went wrong', backgroundColor: m.Colors.red, colorText: m.Colors.white);
      return false;
    }
  }

  Future<JobFormModel> _getJobFormModel() async{
    List<MaterialItem> materialItems = _getMaterialItems();
    List<TableItem> tableItems= _getTableItems();

    tableItems.removeWhere((element) => isTableItemEmpty(element));

    final double? deposit = double.tryParse(depositController.text);
    final double subTotal = double.tryParse(subTotalController.text) ??
        (tableItems.fold<double>(0, (previousValue, element) => previousValue + (element.totalAmount ?? 0)));

    return JobFormModel(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      carpetFitting: carpetFittingSelected.value,
      laminateFitting: laminateFittingSelected.value,
      deliverOnly: deliveryOnlySelected.value,
      tableItems: tableItems,
      materialItems: materialItems,
      doorTrimmingReq: doorTrimmingRequired.value,
      completedByName: completedByController.text,
      balanceDue: double.tryParse(balanceDueController.text) ??
         ((subTotal) - (deposit ?? 0 )),
      subTotal: subTotal,
      deposit: deposit ?? 0,
      customerAddress: addressController.text,
      customerName: nameController.text,
      postCode: postCodeController.text,
      telNo: telNoController.text,
      measurementDate: dateFormat.parse(measurementDateController.text),
      fittingDate: dateFormat.parse(fittingDateController.text),
      orderNo: orderNoController.text,
      floorCondition: workNeeded.value ? FloorCondition.workNeeded : FloorCondition.good,
      otherDetails: otherDetailsController.text,
      customerNameAcceptanceOfEst: estimateAcceptanceNameController.text,
      customerNameWorkSatisfaction: workSatisfactoryNameController.text,
      invoiceNo: invoiceNoController.text,
      jobRefNo: jobRefNoController.text,
      materialsTotalPrice: materialItems.fold<double>(0, (previousValue, element) => previousValue + (element.totalPrice ?? 0)),
      customerSignAcceptanceOfEst: await _getSignaturesImgUrl(estimateAcceptanceImageBytes.value),
      customerSignWorkCompleted: await _getSignaturesImgUrl(workSatisfactoryImageBytes.value),
    );
  }

  Future<String?> _getSignaturesImgUrl(Uint8List list) async{
    if(list.isEmpty) return null;

    return await uploadAndGetFileDownloadUrl(list);
  }

  bool isTableItemEmpty(TableItem tableItem){
    return (
    isEmptyOrNull(tableItem.location) &&
        isEmptyOrNull(tableItem.totalAmount) &&
        isEmptyOrNull(tableItem.width) &&
        isEmptyOrNull(tableItem.quantity) &&
        isEmptyOrNull(tableItem.flooringColor) &&
        isEmptyOrNull(tableItem.height) &&
        isEmptyOrNull(tableItem.description) &&
        isEmptyOrNull(tableItem.stockLocation) &&
        isEmptyOrNull(tableItem.unitPrice)
    );
  }

  bool isEmptyOrNull(dynamic e){
    return (e == null || e == '' || e==0);
  }


  List<TableItem> _getTableItems() {
    return locationControllersMap.entries.map((e) {
      double? unitPrize = double.tryParse(unitPrizeControllersMap[e.key]?.text ?? '0');
      int? quantity = double.tryParse(quantityControllersMap[e.key]?.text ?? '0')?.toInt();
      return TableItem(
          location: e.value.text,
          height: double.tryParse(hControllersMap[e.key]?.text ?? ''),
          width: double.tryParse(wControllersMap[e.key]?.text ?? ''),
          description: descControllersMap[e.key]?.text,
          flooringColor: floringColorControllersMap[e.key]?.text,
          stockLocation: stockLocationControllersMap[e.key]?.text,
          unitPrice: unitPrize ,
          quantity: quantity,
          totalAmount: _getTotalAmount(unitPrize: unitPrize, quantity: quantity),
      );
    } ).toList();
  }

  List<MaterialItem> _getMaterialItems() {
    return Material.values.map((e) {
      double? unitPrize = double.tryParse(materialPriceControllersMap[e.name]?.text ?? '0');
      int? quantity = double.tryParse(materialQtyControllersMap[e.name]?.text ?? '0')?.toInt();
      return MaterialItem(
        material: e,
        quantity: quantity,
        materialUnitPrice: unitPrize,
        totalPrice: _getTotalAmount(unitPrize: unitPrize, quantity: quantity),
      );
    } ).toList();
  }

  double _getTotalAmount({required double? unitPrize, required int? quantity}) {
    return (unitPrize ?? 0) * (quantity ?? 0);
  }

}
