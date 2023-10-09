import 'package:dreamland/enums/materials.dart';

class MaterialItem {
  final Material? material;
  final int? quantity;
  final double? totalPrice;
  final double? materialUnitPrice;

MaterialItem({
    required this.material,
    required this.quantity,
    required this.totalPrice,
    required this.materialUnitPrice,
  });


  Map<String, dynamic> toMap() {
    return {
      'material': material?.name,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'unitPrice': materialUnitPrice,
    };
  }

  factory MaterialItem.fromMap(Map<String, dynamic> map) {
    return MaterialItem(
      material: getMaterial(map['material']),
      quantity: map['quantity'] as int?,
      totalPrice: map['totalPrice'] as double?,
      materialUnitPrice: map['unitPrice'] as double?,
    );
  }
}