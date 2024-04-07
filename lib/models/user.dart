class BaseUser {
  final String uid;
  final String name;
  final String phoneNumber;

  BaseUser({
    required this.uid,
    required this.name,
    required this.phoneNumber,
  });

  factory BaseUser.fromJson(Map<String, dynamic> json) => BaseUser(
        uid: json["id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "id": uid,
        "name": name,
        "phoneNumber": phoneNumber,
      };
}
