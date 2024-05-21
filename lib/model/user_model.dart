class UserModel {
  String? userId;
  String? name;
  String? email;
  String? password;
  String? imageUrl;

  UserModel({
    this.userId,
    this.name,
    this.email,
    this.password,
    this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'password': password,
      'imageUrl': imageUrl,
    };
  }
}
