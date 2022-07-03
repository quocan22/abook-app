import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String categoryId;
  final String name;
  final String imageUrl;
  final String cloudinaryId;
  final bool isAvailable;
  final int price;
  final int quantity;
  final String description;
  final double avgRate;
  final List<dynamic> comments;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int iV;
  final String author;
  final int discountRatio;

  const Book(
      {required this.id,
      required this.categoryId,
      required this.name,
      required this.imageUrl,
      required this.cloudinaryId,
      required this.isAvailable,
      required this.price,
      required this.quantity,
      required this.description,
      required this.avgRate,
      required this.comments,
      required this.createdAt,
      required this.updatedAt,
      required this.iV,
      required this.author,
      required this.discountRatio});

  Book.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        categoryId = json['categoryId'],
        name = json['name'],
        imageUrl = json['imageUrl'],
        cloudinaryId = json['cloudinaryId'],
        isAvailable = json['isAvailable'],
        price = json['price'],
        quantity = json['quantity'],
        description = json['description'],
        avgRate = double.parse(json['avgRate'].toString()),
        comments = json['comments'],
        createdAt = DateTime.parse(json['createdAt']),
        updatedAt = DateTime.parse(json['updatedAt']),
        iV = json['__v'],
        author = json['author'],
        discountRatio = json['discountRatio'];

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'name': name,
        'imageUrl': imageUrl,
        'cloudinaryId': cloudinaryId,
        'isAvailable': isAvailable,
        'price': price,
        'quantity': quantity,
        'description': description,
        'avgRate': avgRate,
        'comments': comments,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': iV,
        'author': author,
        'discountRatio': discountRatio
      };

  @override
  List<Object?> get props => [id];
}
