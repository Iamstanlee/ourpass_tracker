class UserModel {
  final String uid;
  UserModel({
    required this.uid,
  });

  bool get isValid => uid.isNotEmpty;
}
