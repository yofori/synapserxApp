// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Medications _$MedicationsFromJson(Map<String, dynamic> json) => Medications(
      drugId: json['drugId'] as String,
      drugName: json['drugName'] as String?,
      routeOfAdministration: json['routeOfAdministration'] as String?,
      dose: json['dose'] as String?,
      dosageRegimen: json['dosageRegimen'] as String?,
      noOfDays: json['noOfDays'] as int?,
      status: json['status'] as String?,
      sId: json['sId'] as String?,
    );

Map<String, dynamic> _$MedicationsToJson(Medications instance) =>
    <String, dynamic>{
      'drugId': instance.drugId,
      'drugName': instance.drugName,
      'routeOfAdministration': instance.routeOfAdministration,
      'dose': instance.dose,
      'dosageRegimen': instance.dosageRegimen,
      'noOfDays': instance.noOfDays,
      'status': instance.status,
      'sId': instance.sId,
    };
