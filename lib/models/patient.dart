import 'package:json_annotation/json_annotation.dart';
import 'package:synapserx_prescriber/models/patientinsurancepolicy.dart';

part 'patient.g.dart';

@JsonSerializable(explicitToJson: true)
class Patient {
  @JsonKey(name: '_id')
  String? id;
  String? surname;
  String? firstname;
  String? title;
  DateTime? dateOfBirth;
  bool? isAgeEstimated;
  String? gender;
  bool? active;
  List<InsurancePolicy?>? insurancePolicies;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Patient(
      {this.id,
      this.surname,
      this.firstname,
      this.title,
      this.dateOfBirth,
      this.isAgeEstimated,
      this.gender,
      this.active,
      this.insurancePolicies,
      this.createdAt,
      this.updatedAt,
      this.v});

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);

  Map<String, dynamic> toJson() => _$PatientToJson(this);
}
