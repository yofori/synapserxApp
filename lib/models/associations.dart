import 'package:json_annotation/json_annotation.dart';
part 'associations.g.dart';

@JsonSerializable()
class Associations {
  @JsonKey(name: '_id')
  String id;
  String prescriberuid;
  String patientuid;
  String? status;
  String patientFullname;
  String prescriberFullname;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Associations(
      {required this.id,
      required this.prescriberuid,
      required this.patientuid,
      this.status,
      required this.patientFullname,
      required this.prescriberFullname,
      this.createdAt,
      this.updatedAt,
      this.iV});

  factory Associations.fromJson(Map<String, dynamic> json) =>
      _$AssociationsFromJson(json);

  Map<String, dynamic> toJson() => _$AssociationsToJson(this);
}
