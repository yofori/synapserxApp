import 'package:json_annotation/json_annotation.dart';

part 'useraccounts.g.dart';

@JsonSerializable(explicitToJson: true)
class UserAccount {
  String institutionName;
  String? institutionAddress;
  String? institutionTelephone;
  String? institutionEmail;
  bool defaultAccount;
  @JsonKey(name: '_id')
  String? id;

  UserAccount(
      {required this.institutionName,
      this.institutionAddress,
      this.institutionTelephone,
      this.institutionEmail,
      required this.defaultAccount,
      this.id});

  factory UserAccount.fromJson(Map<String, dynamic> json) =>
      _$UserAccountFromJson(json);

  Map<String, dynamic> toJson() => _$UserAccountToJson(this);
}
