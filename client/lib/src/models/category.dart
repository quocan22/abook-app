import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String categoryName;
  final String imageUrl;
  final String cloudinaryId;

  Category({
    required this.id,
    required this.categoryName,
    required this.imageUrl,
    required this.cloudinaryId,
  });

  Category.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        categoryName = json['categoryName'],
        imageUrl = json['imageUrl'],
        cloudinaryId = json['cloudinaryId'];

  Map<String, dynamic> toJson() => {
        'categoryName': categoryName,
        'imageUrl': imageUrl,
        'cloudinaryId': cloudinaryId,
      };

  @override
  List<Object?> get props => [id];
}
