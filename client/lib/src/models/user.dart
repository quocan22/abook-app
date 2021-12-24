class User {
  final String id;
  final String email;
  final String fullName;
  final String? profileImageUrl;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        email: json['email'],
        fullName: json['full_name'],
        profileImageUrl: json['profile_image_url']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'full_name': fullName,
        'profile_image_url': profileImageUrl,
      };
}
