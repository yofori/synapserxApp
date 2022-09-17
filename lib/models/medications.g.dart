// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Medications _$MedicationsFromJson(Map<String, dynamic> json) => Medications(
      drugCode: json['drugCode'] as String,
      drugName: json['drugName'] as String?,
      duration: json['duration'] as String?,
      dose: json['dose'] as String?,
      dosageRegimen: json['dosageRegimen'] as String?,
      durationUnits: json['durationUnits'] as String?,
      status: json['status'] as String?,
      sId: json['sId'] as String?,
      directionOfUse: json['directionOfUse'] as String?,
    );

Map<String, dynamic> _$MedicationsToJson(Medications instance) =>
    <String, dynamic>{
      'drugCode': instance.drugCode,
      'drugName': instance.drugName,
      'dose': instance.dose,
      'dosageRegimen': instance.dosageRegimen,
      'duration': instance.duration,
      'durationUnits': instance.durationUnits,
      'status': instance.status,
      'sId': instance.sId,
      'directionOfUse': instance.directionOfUse,
    };
