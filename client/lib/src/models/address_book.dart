class AddressBook {
  final String fullName;
  final String phoneNumber;
  final String address;

  AddressBook({
    required this.fullName,
    required this.phoneNumber,
    required this.address,
  });

  factory AddressBook.fromJson(Map<String, dynamic> json) => AddressBook(
        fullName: json["fullName"],
        phoneNumber: json["phoneNumber"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "phoneNumber": phoneNumber,
        "address": address,
      };
}
