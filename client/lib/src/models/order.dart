class Order {
  Order({
    required this.id,
    required this.userId,
    required this.discountPrice,
    required this.totalPrice,
    required this.paidStatus,
    required this.shippingStatus,
    required this.details,
    required this.createdAt,
    required this.customerName,
    required this.customerPhoneNumber,
    required this.customerAddress,
  });

  final String id;
  final String userId;
  final int discountPrice;
  final int totalPrice;
  final int paidStatus;
  final int shippingStatus;
  final List<dynamic> details;
  final DateTime createdAt;
  final String customerName;
  final String customerPhoneNumber;
  final String customerAddress;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["_id"],
        userId: json["userId"],
        discountPrice: json["discountPrice"],
        totalPrice: json["totalPrice"],
        paidStatus: json["paidStatus"],
        shippingStatus: json["shippingStatus"],
        details: List<dynamic>.from(json["details"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        customerName: json["customerName"],
        customerPhoneNumber: json["customerPhoneNumber"],
        customerAddress: json["customerAddress"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "discountPrice": discountPrice,
        "totalPrice": totalPrice,
        "paidStatus": paidStatus,
        "shippingStatus": shippingStatus,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
        "createdAt": createdAt.toIso8601String(),
        "customerName": customerName,
        "customerPhoneNumber": customerPhoneNumber,
        "customerAddress": customerAddress,
      };
}
