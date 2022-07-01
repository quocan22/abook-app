class Discount {
  Discount({
    required this.id,
    required this.code,
    required this.value,
    required this.expiredDate,
  });

  String id;
  String code;
  int value;
  DateTime expiredDate;

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
        id: json["_id"],
        code: json["code"],
        value: json["value"],
        expiredDate: DateTime.parse(json["expiredDate"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "code": code,
        "value": value,
        "expiredDate": expiredDate.toIso8601String(),
      };
}
