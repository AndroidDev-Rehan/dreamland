class ProductSaleLog{
final String userId;
final String userName;
final int quantitySold;
final DateTime dateTime;
final String category;
final String saleId;
final String? productName;

ProductSaleLog( {required this.userId,required this.userName,required this.quantitySold,required this.dateTime, required this.category,required this.saleId, required this.productName});

Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "userName": userName,
      "quantitySold": quantitySold,
      "dateTime": dateTime.toIso8601String(),
      'category' : category,
      'saleId' : saleId,
      'productName' : productName,
    };
  }

factory ProductSaleLog.fromJson(Map<String, dynamic> json) {
    return ProductSaleLog(
      productName: json['productName'],
      saleId : json['saleId'],
      category: json['category'],
      userId: json["userId"],
      userName: json["userName"],
      quantitySold: json["quantitySold"],
      dateTime: DateTime.parse(json["dateTime"]),
    );
  }
}