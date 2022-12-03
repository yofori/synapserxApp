// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'useraccounts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAccount _$UserAccountFromJson(Map<String, dynamic> json) => UserAccount(
      institutionName: json['institutionName'] as String,
      institutionAddress: json['institutionAddress'] as String?,
      institutionTelephone: json['institutionTelephone'] as String?,
      institutionEmail: json['institutionEmail'] as String?,
      defaultAccount: json['defaultAccount'] as bool,
      id: json['_id'] as String?,
    );

Map<String, dynamic> _$UserAccountToJson(UserAccount instance) =>
    <String, dynamic>{
      'institutionName': instance.institutionName,
      'institutionAddress': instance.institutionAddress,
      'institutionTelephone': instance.institutionTelephone,
      'institutionEmail': instance.institutionEmail,
      'defaultAccount': instance.defaultAccount,
      '_id': instance.id,
    };
