class UserModel {
  final String uid;
  final String name;
  final String email;
  final String password;
  final String phone;
  final String profileImage;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.profileImage,
  });

  factory UserModel.fromMap(Map<String, dynamic> obj, String id) {
    return UserModel(
      uid: id,
      name: obj['user']?.toString() ?? '',
      email: obj['email']?.toString() ?? '',
      password: obj['email']?.toString() ?? '',
      phone: obj['phone']?.toString() ?? '',
      profileImage: obj['profileImage']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': name,
      'email': email,
      'password': password,
      'phone': phone,
      'profileImage': profileImage,
    };
  }
}