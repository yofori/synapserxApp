import 'package:json_annotation/json_annotation.dart';
part 'medications.g.dart';

@JsonSerializable()
class Medications {
  String drugCode;
  String? drugName;
  String? dose;
  String? dosageRegimen;
  String? duration;
  String? durationUnits;
  String? status;
  String? sId;
  String? directionOfUse;

  Medications(
      {required this.drugCode,
      this.drugName,
      this.duration,
      this.dose,
      this.dosageRegimen,
      this.durationUnits,
      this.status,
      this.sId,
      this.directionOfUse});

  factory Medications.fromJson(Map<String, dynamic> json) =>
      _$MedicationsFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationsToJson(this);
}
