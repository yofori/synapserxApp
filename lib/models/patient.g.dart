// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient(
      id: json['_id'] as String?,
      surname: json['surname'] as String?,
      firstname: json['firstname'] as String?,
      title: json['title'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      isAgeEstimated: json['isAgeEstimated'] as bool?,
      gender: json['gender'] as String?,
      active: json['active'] as bool?,
      insurancePolicies: (json['insurancePolicies'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : InsurancePolicy.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      v: json['v'] as int?,
    );

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
      '_id': instance.id,
      'surname': instance.surname,
      'firstname': instance.firstname,
      'title': instance.title,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'isAgeEstimated': instance.isAgeEstimated,
      'gender': instance.gender,
      'active': instance.active,
      'insurancePolicies':
          instance.insurancePolicies?.map((e) => e?.toJson()).toList(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'v': instance.v,
    };
