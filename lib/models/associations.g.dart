// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'associations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Associations _$AssociationsFromJson(Map<String, dynamic> json) => Associations(
      id: json['_id'] as String,
      prescriberuid: json['prescriberuid'] as String,
      patientuid: json['patientuid'] as String,
      status: json['status'] as String?,
      patientFullname: json['patientFullname'] as String,
      prescriberFullname: json['prescriberFullname'] as String,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      iV: json['iV'] as int?,
    );

Map<String, dynamic> _$AssociationsToJson(Associations instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'prescriberuid': instance.prescriberuid,
      'patientuid': instance.patientuid,
      'status': instance.status,
      'patientFullname': instance.patientFullname,
      'prescriberFullname': instance.prescriberFullname,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'iV': instance.iV,
    };
