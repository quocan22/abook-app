import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final UserClaim userClaim;
  final String email;

  User({required this.userClaim, required this.id, required this.email});

  User.fromJson(Map<String, dynamic> json)
      : userClaim = new UserClaim.fromJson(json['userClaim']),
        id = json['_id'],
        email = json['email'];

  Map<String, dynamic> toJson() =>
      {'userClaim': userClaim.toJson(), 'email': email};

  @override
  List<Object?> get props => [id];
}

class UserClaim {
  final String displayName;
  final String? phoneNumber;
  final String? address;
  final List<dynamic> favorite;
  final String avatarUrl;

  UserClaim(
      {required this.displayName,
      this.phoneNumber,
      this.address,
      required this.favorite,
      required this.avatarUrl});

  UserClaim.fromJson(Map<String, dynamic> json)
      : displayName = json['displayName'],
        phoneNumber = json['phoneNumber'],
        address = json['address'],
        favorite = json['favorite'],
        avatarUrl = json['avatarUrl'];

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'phoneNumber': phoneNumber,
        'address': address,
        'favorite': favorite,
        'avatarUrl': avatarUrl
      };
}
