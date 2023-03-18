class ProductSaleLog{
final String userId;
final String userName;
final int quantitySold;
final DateTime dateTime;
final String category;
final String saleId;

ProductSaleLog( {required this.userId,required this.userName,required this.quantitySold,required this.dateTime, required this.category,required this.saleId,});

Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "userName": userName,
      "quantitySold": quantitySold,
      "dateTime": dateTime.toIso8601String(),
      'category' : category,
      'saleId' : saleId,
    };
  }

factory ProductSaleLog.fromJson(Map<String, dynamic> json) {
    return ProductSaleLog(
      saleId : json['saleId'],
      category: json['category'],
      userId: json["userId"],
      userName: json["userName"],
      quantitySold: json["quantitySold"],
      dateTime: DateTime.parse(json["dateTime"]),
    );
  }
}