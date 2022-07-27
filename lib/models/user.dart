import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.surname,
    required this.firstname,
    required this.prescriberMDCRegNo,
    required this.telephoneNo,
    required this.title,
    required this.role,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String username;
  String email;
  String surname;
  String firstname;
  String prescriberMDCRegNo;
  String telephoneNo;
  String id;
  String title;
  String role;
  String password;
}
