// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Prescription _$PrescriptionFromJson(Map<String, dynamic> json) => Prescription(
      sId: json['sId'] as String?,
      pxId: json['pxId'] as String,
      pxSurname: json['pxSurname'] as String,
      pxFirstname: json['pxFirstname'] as String,
      pxgender: json['pxgender'] as String,
      pxAge: json['pxAge'] as int?,
      pxDOB: json['pxDOB'] as String?,
      prescriberID: json['prescriberID'] as String?,
      prescriberMDCRegNo: json['prescriberMDCRegNo'] as String?,
      prescriberName: json['prescriberName'] as String?,
      refillRx: json['refillRx'] as bool?,
      isPxRegistered: json['isPxRegistered'] as bool?,
      status: json['status'] as String?,
      medications: (json['medications'] as List<dynamic>?)
          ?.map((e) => Medications.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      iV: json['iV'] as int?,
    );

Map<String, dynamic> _$PrescriptionToJson(Prescription instance) =>
    <String, dynamic>{
      'sId': instance.sId,
      'pxId': instance.pxId,
      'pxSurname': instance.pxSurname,
      'pxFirstname': instance.pxFirstname,
      'pxgender': instance.pxgender,
      'pxAge': instance.pxAge,
      'pxDOB': instance.pxDOB,
      'prescriberID': instance.prescriberID,
      'prescriberMDCRegNo': instance.prescriberMDCRegNo,
      'prescriberName': instance.prescriberName,
      'refillRx': instance.refillRx,
      'isPxRegistered': instance.isPxRegistered,
      'status': instance.status,
      'medications': instance.medications?.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'iV': instance.iV,
    };
