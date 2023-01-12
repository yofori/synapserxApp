import 'package:json_annotation/json_annotation.dart';
part 'medications.g.dart';

@JsonSerializable()
class Medications {
  String drugCode;
  String? drugName;
  String? drugGenericName;
  String? dose;
  String? dosageUnits;
  String? dosageRegimen;
  String? duration;
  String? durationUnits;
  String? status;
  bool? dispenseAsWritten;
  bool? allowRefills;
  int? maxRefillsAllowed;
  @JsonKey(name: '_id')
  String? sId;
  String? directionOfUse;

  Medications(
      {required this.drugCode,
      this.drugName,
      this.drugGenericName,
      this.duration,
      this.dose,
      this.dosageRegimen,
      this.durationUnits,
      this.status,
      this.sId,
      this.directionOfUse,
      this.dosageUnits,
      this.allowRefills,
      this.dispenseAsWritten,
      this.maxRefillsAllowed});

  factory Medications.fromJson(Map<String, dynamic> json) =>
      _$MedicationsFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationsToJson(this);
}
