class UserModel {
  int id;
  int isDeleted;
  String email;
  String token;

  UserModel({
    required this.id,
    required this.email,
    required this.token,
    this.isDeleted = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['Id'],
      email: json['Email'],
      token: json['Token'] ?? "",
      isDeleted: json['isDeleted'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Id'] = id;
    data['Email'] = email;
    data['Token'] = token;
    return data;
  }
}
