import 'package:json_annotation/json_annotation.dart';

part 'patientinsurancepolicy.g.dart';

@JsonSerializable(explicitToJson: true)
class InsurancePolicy {
  String? code;
  String? insurnaceCompanyName;
  String? policyNo;
  String? benefitPackageCode;
  String? benefitPackageName;
  DateTime? startDate;
  String? status;
  @JsonKey(name: '_id')
  String? id;

  InsurancePolicy(
      {this.code,
      this.insurnaceCompanyName,
      this.policyNo,
      this.benefitPackageCode,
      this.benefitPackageName,
      this.startDate,
      this.status,
      this.id});

  factory InsurancePolicy.fromJson(Map<String, dynamic> json) =>
      _$InsurancePolicyFromJson(json);

  Map<String, dynamic> toJson() => _$InsurancePolicyToJson(this);
}
