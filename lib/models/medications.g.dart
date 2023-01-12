// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Medications _$MedicationsFromJson(Map<String, dynamic> json) => Medications(
      drugCode: json['drugCode'] as String,
      drugName: json['drugName'] as String?,
      drugGenericName: json['drugGenericName'] as String?,
      duration: json['duration'] as String?,
      dose: json['dose'] as String?,
      dosageRegimen: json['dosageRegimen'] as String?,
      durationUnits: json['durationUnits'] as String?,
      status: json['status'] as String?,
      sId: json['_id'] as String?,
      directionOfUse: json['directionOfUse'] as String?,
      dosageUnits: json['dosageUnits'] as String?,
      allowRefills: json['allowRefills'] as bool?,
      dispenseAsWritten: json['dispenseAsWritten'] as bool?,
      maxRefillsAllowed: json['maxRefillsAllowed'] as int?,
    );

Map<String, dynamic> _$MedicationsToJson(Medications instance) =>
    <String, dynamic>{
      'drugCode': instance.drugCode,
      'drugName': instance.drugName,
      'drugGenericName': instance.drugGenericName,
      'dose': instance.dose,
      'dosageUnits': instance.dosageUnits,
      'dosageRegimen': instance.dosageRegimen,
      'duration': instance.duration,
      'durationUnits': instance.durationUnits,
      'status': instance.status,
      'dispenseAsWritten': instance.dispenseAsWritten,
      'allowRefills': instance.allowRefills,
      'maxRefillsAllowed': instance.maxRefillsAllowed,
      '_id': instance.sId,
      'directionOfUse': instance.directionOfUse,
    };
