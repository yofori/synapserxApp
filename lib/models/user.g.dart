// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      surname: json['surname'] as String,
      firstname: json['firstname'] as String,
      prescriberMDCRegNo: json['prescriberMDCRegNo'] as String,
      telephoneNo: json['telephoneNo'] as String,
      title: json['title'] as String,
      role: json['role'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'surname': instance.surname,
      'firstname': instance.firstname,
      'prescriberMDCRegNo': instance.prescriberMDCRegNo,
      'telephoneNo': instance.telephoneNo,
      'id': instance.id,
      'title': instance.title,
      'role': instance.role,
      'password': instance.password,
    };
