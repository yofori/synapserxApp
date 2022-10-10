// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patientinsurancepolicy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsurancePolicy _$InsurancePolicyFromJson(Map<String, dynamic> json) =>
    InsurancePolicy(
      code: json['code'] as String?,
      insurnaceCompanyName: json['insurnaceCompanyName'] as String?,
      policyNo: json['policyNo'] as String?,
      benefitPackageCode: json['benefitPackageCode'] as String?,
      benefitPackageName: json['benefitPackageName'] as String?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      status: json['status'] as String?,
      id: json['_id'] as String?,
    );

Map<String, dynamic> _$InsurancePolicyToJson(InsurancePolicy instance) =>
    <String, dynamic>{
      'code': instance.code,
      'insurnaceCompanyName': instance.insurnaceCompanyName,
      'policyNo': instance.policyNo,
      'benefitPackageCode': instance.benefitPackageCode,
      'benefitPackageName': instance.benefitPackageName,
      'startDate': instance.startDate?.toIso8601String(),
      'status': instance.status,
      '_id': instance.id,
    };
