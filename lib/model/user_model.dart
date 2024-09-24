class UserModel {
  String? userId;
  String? name;
  String? email;
  String? password;
  String? imageUrl;
  String? bio;

  UserModel(
      {this.userId,
      this.name,
      this.email,
      this.password,
      this.imageUrl,
      this.bio});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['uid'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      imageUrl: json['imageUrl'],
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': userId,
      'name': name,
      'email': email,
      'password': password,
      'imageUrl': imageUrl,
      'bio': bio,
    };
  }
}
