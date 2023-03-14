class ProductSaleLog{
final String userId;
final String userName;
final int quantitySold;
final DateTime dateTime;
final String category;

ProductSaleLog({required this.userId,required this.userName,required this.quantitySold,required this.dateTime, required this.category});

Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "userName": userName,
      "quantitySold": quantitySold,
      "dateTime": dateTime.toIso8601String(),
      'category' : category,
    };
  }

factory ProductSaleLog.fromJson(Map<String, dynamic> json) {
    return ProductSaleLog(
      category: json['category'],
      userId: json["userId"],
      userName: json["userName"],
      quantitySold: json["quantitySold"],
      dateTime: DateTime.parse(json["dateTime"]),
    );
  }
}