class BaseUser {
  BaseUser({required this.uid, required this.name, required this.phoneNumber});
  final String uid;
  final String name;
  final String phoneNumber;

  factory BaseUser.fromJson(Map<String, dynamic> json) => BaseUser(
        uid: json["id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
      );

  // toJson
  Map<String, dynamic> toJson() => {
        "id": uid,
        "name": name,
        "phoneNumber": phoneNumber,
      };
}
