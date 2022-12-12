import 'package:json_annotation/json_annotation.dart';
import 'medications.dart';

part 'prescription.g.dart';

@JsonSerializable(explicitToJson: true)
class Prescription {
  @JsonKey(name: '_id')
  String? sId;
  String pxId;
  String pxSurname;
  String pxFirstname;
  String pxgender;
  int? pxAge;
  String? pxDOB;
  String? prescriberID;
  String? prescriberMDCRegNo;
  String? prescriberName;
  String? prescriberInstitution;
  String? prescriberInstitutionName;
  String? prescriberInstitutionAddress;
  String? prescriberInstitutionTelephone;
  String? prescriberInstitutionEmail;
  bool? refillRx;
  bool? isPxRegistered;
  String? status;
  List<Medications>? medications;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Prescription(
      {this.sId,
      required this.pxId,
      required this.pxSurname,
      required this.pxFirstname,
      required this.pxgender,
      this.pxAge,
      this.pxDOB,
      this.prescriberID,
      this.prescriberMDCRegNo,
      this.prescriberName,
      this.prescriberInstitution,
      this.prescriberInstitutionName,
      this.prescriberInstitutionAddress,
      this.prescriberInstitutionTelephone,
      this.prescriberInstitutionEmail,
      this.refillRx,
      this.isPxRegistered,
      this.status,
      this.medications,
      this.createdAt,
      this.updatedAt,
      this.iV});

  factory Prescription.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionFromJson(json);

  Map<String, dynamic> toJson() => _$PrescriptionToJson(this);
}
