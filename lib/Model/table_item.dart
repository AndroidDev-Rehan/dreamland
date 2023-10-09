class TableItem {
  final String? location;
  final double? height;
  final double? width;
  final String? description;
  final String? flooringColor;
  final String? stockLocation;
  final double? unitPrice;
  final int? quantity;
  final double? totalAmount;

  const TableItem({
    required this.location,
    required this.height,
    required this.width,
    required this.description,
    required this.flooringColor,
    required this.stockLocation,
    required this.unitPrice,
    required this.quantity,
    required this.totalAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'height': height,
      'width': width,
      'description': description,
      'flooringColor': flooringColor,
      'stockLocation': stockLocation,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'totalAmount': totalAmount,
    };
  }

  factory TableItem.fromMap(Map<String, dynamic> map) {
    return TableItem(
      location: map['location'] as String?,
      height: map['height'] as double?,
      width: map['width'] as double?,
      description: map['description'] as String?,
      flooringColor: map['flooringColor'] as String?,
      stockLocation: map['stockLocation'] as String?,
      unitPrice: map['unitPrice'] as double?,
      quantity: map['quantity'] as int?,
      totalAmount: map['totalAmount'] as double?,
    );
  }
}