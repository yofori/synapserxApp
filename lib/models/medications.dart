import 'package:json_annotation/json_annotation.dart';
part 'medications.g.dart';

@JsonSerializable()
class Medications {
  String drugId;
  String? drugName;
  String? routeOfAdministration;
  String? dose;
  String? dosageRegimen;
  int? noOfDays;
  String? status;
  String? sId;

  Medications(
      {required this.drugId,
      this.drugName,
      this.routeOfAdministration,
      this.dose,
      this.dosageRegimen,
      this.noOfDays,
      this.status,
      this.sId});

  factory Medications.fromJson(Map<String, dynamic> json) =>
      _$MedicationsFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationsToJson(this);
}
