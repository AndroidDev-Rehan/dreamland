import 'package:dreamland/Model/table_item.dart';

import 'package:dreamland/Model/material_item.dart';

import '../enums/floor_condition.dart';

class JobFormModel{

  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? pdfLink;

  ///Top Left Portion
  final DateTime? measurementDate;
  final String? orderNo;
  final DateTime? fittingDate;
  final String? customerAddress;
  final String? postCode;
  final String? telNo;
  final String? customerName;

  ///Top Right Portion
  final String? jobRefNo;
  final String? invoiceNo;
  final String? completedByName;
  final bool? carpetFitting;
  final bool? laminateFitting;
  final bool? deliverOnly;
  final String? otherDetails;

  ///Table
  final List<TableItem> tableItems;

  ///Material
  final List<MaterialItem> materialItems;
  final double? materialsTotalPrice;

  final bool? doorTrimmingReq;
  final FloorCondition? floorCondition;

  ///Payment related 
  final double? subTotal;
  final double? deposit;
  final double? balanceDue;
  
  ///Images URLs
  final String? customerSignAcceptanceOfEst;
  final String? customerSignWorkCompleted;

  ///Names
  final String? customerNameAcceptanceOfEst;
  final String? customerNameWorkSatisfaction;

  const JobFormModel( {
    this.pdfLink,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    this.measurementDate,
    this.orderNo,
    this.fittingDate,
    this.customerAddress,
    this.postCode,
    this.telNo,
    this.customerName,
    this.jobRefNo,
    this.invoiceNo,
    this.completedByName,
    required this.carpetFitting,
    required this.laminateFitting,
    required this.deliverOnly,
    this.otherDetails,
    required this.tableItems,
    required this.materialItems,
    this.materialsTotalPrice,
    required this.doorTrimmingReq,
    this.floorCondition,
    this.subTotal,
    this.deposit,
    this.balanceDue,
    this.customerSignAcceptanceOfEst,
    this.customerSignWorkCompleted,
    this.customerNameAcceptanceOfEst,
    this.customerNameWorkSatisfaction,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'measurementDate': measurementDate?.toIso8601String(),
      'orderNo': orderNo,
      'fittingDate': fittingDate?.toIso8601String(),
      'customerAddress': customerAddress,
      'postCode': postCode,
      'telNo': telNo,
      'customerName': customerName,
      'jobRefNo': jobRefNo,
      'invoiceNo': invoiceNo,
      'completedByName': completedByName,
      'carpetFitting': carpetFitting,
      'laminateFitting': laminateFitting,
      'deliverOnly': deliverOnly,
      'otherDetails': otherDetails,
      'tableItems': tableItems.map((e) => e.toMap()).toList(),
      'materialItems': materialItems.map((e) => e.toMap()).toList(),
      'materialsTotalPrice': materialsTotalPrice,
      'doorTrimmingReq': doorTrimmingReq,
      'floorCondition': floorCondition?.name,
      'subTotal': subTotal,
      'deposit': deposit,
      'balanceDue': balanceDue,
      'customerSignAcceptanceOfEst': customerSignAcceptanceOfEst,
      'customerSignWorkCompleted': customerSignWorkCompleted,
      'customerNameAcceptanceOfEst': customerNameAcceptanceOfEst,
      'customerNameWorkSatisfaction': customerNameWorkSatisfaction,
      'pdfLink': pdfLink,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory JobFormModel.fromMap(Map<String, dynamic> map) {
    return JobFormModel(
      id: map['id'] as String,
      measurementDate: DateTime.tryParse(map['measurementDate'] ?? ''),
      orderNo: map['orderNo'] as String?,
      fittingDate: DateTime.tryParse(map['fittingDate'] ?? ''),
      customerAddress: map['customerAddress'] as String?,
      postCode: map['postCode'] as String?,
      telNo: map['telNo'] as String?,
      customerName: map['customerName'] as String?,
      jobRefNo: map['jobRefNo'] as String?,
      invoiceNo: map['invoiceNo'] as String?,
      completedByName: map['completedByName'] as String?,
      carpetFitting: (map['carpetFitting'] as bool?) ?? false,
      laminateFitting: (map['laminateFitting'] as bool?) ?? false,
      deliverOnly: (map['deliverOnly'] as bool?) ?? false,
      otherDetails: map['otherDetails'] as String?,
      tableItems: (map['tableItems'] as List).map((e) => TableItem.fromMap(e)).toList(),
      materialItems:  (map['materialItems'] as List).map((e) => MaterialItem.fromMap(e)).toList(),
      materialsTotalPrice: map['materialsTotalPrice'] as double?,
      doorTrimmingReq: (map['doorTrimmingReq'] as bool?),
      floorCondition:  getFloorCondition(map['floorCondition']),
      subTotal: map['subTotal'] as double?,
      deposit: map['deposit'] as double?,
      balanceDue: map['balanceDue'] as double?,
      customerSignAcceptanceOfEst: map['customerSignAcceptanceOfEst'] as String?,
      customerSignWorkCompleted: map['customerSignWorkCompleted'] as String?,
      customerNameAcceptanceOfEst: map['customerNameAcceptanceOfEst'] as String?,
      customerNameWorkSatisfaction:
          map['customerNameWorkSatisfaction'] as String?,
      createdAt: DateTime.tryParse(map['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(map['updatedAt'] ?? ''),
      pdfLink: map['pdfLink'] as String?,
    );
  }
}