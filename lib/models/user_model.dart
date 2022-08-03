class UserModel {
  String uid;
  String token;
  String? email;
  String? pwd;
  String? displayName;
  String? phoneNumber;
  String? photoUrl;

  UserModel(
      {required this.uid,
      required this.token,
      this.email,
      this.displayName,
      this.phoneNumber,
      this.photoUrl});
}
