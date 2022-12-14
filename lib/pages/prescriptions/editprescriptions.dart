import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:synapserx_prescriber/common/dio_client.dart';
import 'package:synapserx_prescriber/common/pdf_api.dart';
import 'package:synapserx_prescriber/common/service.dart';
import 'package:synapserx_prescriber/common/stringutils.dart';
import 'package:synapserx_prescriber/main.dart';
import 'package:synapserx_prescriber/models/prescription.dart';
import 'package:synapserx_prescriber/pages/prescriptions/addeditdrugs.dart';
import 'package:synapserx_prescriber/pages/prescriptions/selectmedicine.dart';
import 'package:synapserx_prescriber/common/pdf_prescription_api.dart'
    as pdfgen;

class EditPrescriptionPage extends StatefulWidget {
  const EditPrescriptionPage(
      {Key? key,
      required this.title,
      required this.patientID,
      required this.patientName,
      required this.pxGender,
      required this.pxAge,
      required this.prescriptionID,
      required this.isEditting,
      required this.pxDOB,
      required this.pxFirstname,
      required this.pxSurname,
      this.pxEmail,
      this.pxTelephone,
      required this.isRegistered,
      required this.isRenewal})
      : super(key: key);
  final String prescriptionID;
  final String patientID;
  final bool isEditting;
  final bool isRenewal;
  final bool isRegistered;
  final String title;
  final String patientName;
  final String pxGender;
  final String pxAge;
  final String pxDOB;
  final String pxFirstname;
  final String pxSurname;
  final String? pxEmail;
  final String? pxTelephone;

  @override
  State<EditPrescriptionPage> createState() => _EditPrescriptionPageState();
}

class _EditPrescriptionPageState extends State<EditPrescriptionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<RxMedicines> prescribedMedicines = [];
  List<UserAccounts> useraccounts = [];
  String prescriberAccount = '';
  String defaultAccount = '';
  bool prescriberInstitutionEditted = false;
  List prescriberInstitutions = GlobalData.useraccounts;
  bool isSaveButtonDisabled = true;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    if (widget.isEditting) {
      getPrescription();
    } else {
      if (widget.isRenewal) {
        getPrescription();
        isSaveButtonDisabled = false;
      }
    }
    getUserAccounts();
  }

  getUserAccounts() async {
    for (int i = 0; i < prescriberInstitutions.length; i++) {
      UserAccounts useraccount = UserAccounts(
          value: prescriberInstitutions[i]['institutionName'],
          key: prescriberInstitutions[i]['_id']);
      if (prescriberInstitutions[i]['defaultAccount']) {
        defaultAccount = prescriberInstitutions[i]['_id'];
      }
      useraccounts.add(useraccount);
    }
  }

  final DioClient _dioClient = DioClient();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add New Medication',
          onPressed: () {
            setState(() {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectMedicinesPage()))
                  .then((value) {
                if (value != null) {
                  addMedicines(value);
                }
              });
            });
          },
          child: const Icon(
            Icons.add,
            size: 36,
          ),
        ),
        appBar: AppBar(title: Text(widget.title), actions: <Widget>[
          // icon to create prescription on server
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                //fixedSize: const Size(30, 20),
                //padding: const EdgeInsets.all(8.0),
                backgroundColor: Colors.green,
              ),
              onPressed: isSaveButtonDisabled
                  ? null
                  : () {
                      var form = _formKey.currentState;
                      if (_formKey.currentState!.validate()) {
                        form!.save();
                        widget.isEditting
                            ? submitChangesToPrescription()
                            : submitNewPrescription();
                      }
                    },
              child: const Text('Save'),
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ]),
        body: !isLoading
            ? Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: DropdownButtonFormField2(
                              value: defaultAccount,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              hint: const Text(
                                'Select an account to prescribe from',
                                style: TextStyle(fontSize: 14),
                              ),
                              icon: const Icon(
                                MdiIcons.badgeAccount,
                              ),
                              buttonHeight: 40,
                              buttonPadding:
                                  const EdgeInsets.only(left: 20, right: 10),
                              items: useraccounts
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item.key,
                                        child: Text(
                                          item.value,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select an Account to Prescribe from';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                isSaveButtonDisabled = false;
                                prescriberInstitutionEditted = true;
                                setState(() {});
                              },
                              onSaved: (value) {
                                prescriberAccount = value.toString();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
                            child: Text(
                                'Name: ${widget.patientName.toUpperCase()} ',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 10, 10),
                            child: Text(
                                'Sex: ${widget.pxGender.toCapitalized()}   Age: ${widget.pxAge} ',
                                style: const TextStyle(
                                  fontSize: 16,
                                )),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                      prescribedMedicines.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                  itemCount: prescribedMedicines.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                        child: ListTile(
                                      horizontalTitleGap: 2,
                                      leading: Text(
                                        '${index + 1}.',
                                        textAlign: TextAlign.center,
                                      ),
                                      title: Text(
                                        prescribedMedicines[index].drugName,
                                      ),
                                      subtitle: Text(
                                        '${prescribedMedicines[index].drugDose} ${prescribedMedicines[index].dosageUnits}  ${prescribedMedicines[index].dosageRegimen} x ${prescribedMedicines[index].duration} ${prescribedMedicines[index].durationUnits}', //
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                AddEditDrugPage(
                                                                  title:
                                                                      'Editting Drug',
                                                                  addingNewDrug:
                                                                      false,
                                                                  drugCode: prescribedMedicines[
                                                                          index]
                                                                      .drugCode,
                                                                  drugName: prescribedMedicines[
                                                                          index]
                                                                      .drugName,
                                                                  drugGenericName:
                                                                      prescribedMedicines[
                                                                              index]
                                                                          .drugGenericName,
                                                                  drugDose: prescribedMedicines[
                                                                          index]
                                                                      .drugDose,
                                                                  doseUnits: prescribedMedicines[
                                                                          index]
                                                                      .dosageUnits,
                                                                  dosageRegimen:
                                                                      prescribedMedicines[
                                                                              index]
                                                                          .dosageRegimen,
                                                                  duration: prescribedMedicines[
                                                                          index]
                                                                      .duration,
                                                                  durationUnits:
                                                                      prescribedMedicines[
                                                                              index]
                                                                          .durationUnits,
                                                                  directionOfUse:
                                                                      prescribedMedicines[
                                                                              index]
                                                                          .directionOfUse,
                                                                  dispenseAsWritten:
                                                                      prescribedMedicines[
                                                                              index]
                                                                          .dispenseAsWritten,
                                                                  allowRefill:
                                                                      prescribedMedicines[
                                                                              index]
                                                                          .allowRefills,
                                                                  maxRefillAllowed:
                                                                      prescribedMedicines[
                                                                              index]
                                                                          .maxRefillsAllowed,
                                                                ))).then(
                                                    (value) {
                                                  if (value != null) {
                                                    editMedicines(value, index);
                                                  }
                                                });
                                              },
                                              icon: const Icon(Icons.edit)),
                                          IconButton(
                                              onPressed: () {
                                                prescribedMedicines
                                                    .removeWhere((element) {
                                                  return element.id ==
                                                      prescribedMedicines[index]
                                                          .id;
                                                });
                                                isSaveButtonDisabled =
                                                    prescribedMedicines.isEmpty;
                                                setState(() {});
                                              },
                                              icon: const Icon(Icons.delete)),
                                        ],
                                      ),
                                    ));
                                  }),
                            )
                          : Column(
                              children: const [
                                SizedBox(
                                  height: 150,
                                ),
                                Center(
                                  child: Text(
                                    'There are no medicines in this Prescription \n \n Click "+" to add',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )
                    ]),
              )
            : const Center(child: CircularProgressIndicator()));
  }

  void addMedicines(Map value) {
    setState(() {
      prescribedMedicines.add(RxMedicines(
        drugCode: value['DrugCode'],
        drugName: value['DrugName'],
        drugGenericName: value['DrugGenericName'],
        drugDose: value['DrugDose'],
        dosageRegimen: value['DosageRegimen'],
        dosageUnits: value['DoseUnits'],
        duration: value['Duration'],
        durationUnits: value['DurationUnits'],
        directionOfUse: value['DirectionOfUse'],
        id: (prescribedMedicines.length + 1).toString(),
        allowRefills: value['allowRefills'],
        dispenseAsWritten: value['dispenseAsWritten'],
        maxRefillsAllowed: value['maxRefillsAllowed'],
      ));
      //enable save button
      isSaveButtonDisabled = false;
    });
  }

  void editMedicines(Map value, int index) {
    setState(() {
      prescribedMedicines[index].drugCode = value['DrugCode'];
      prescribedMedicines[index].drugName = value['DrugName'];
      prescribedMedicines[index].drugGenericName = value['DrugGenericName'];
      prescribedMedicines[index].drugDose = value['DrugDose'];
      prescribedMedicines[index].dosageRegimen = value['DosageRegimen'];
      prescribedMedicines[index].dosageUnits = value['DoseUnits'];
      prescribedMedicines[index].duration = value['Duration'];
      prescribedMedicines[index].durationUnits = value['DurationUnits'];
      prescribedMedicines[index].directionOfUse = value['DirectionOfUse'];
      prescribedMedicines[index].allowRefills = value['allowRefills'];
      prescribedMedicines[index].dispenseAsWritten = value['dispenseAsWritten'];
      prescribedMedicines[index].maxRefillsAllowed = value['maxRefillsAllowed'];
      //enable the save button
      isSaveButtonDisabled = false;
    });
  }

  Future<void> submitChangesToPrescription() async {
    String id = prescriberAccount;
    var params = {};

    var prescribedMedicinesMap = prescribedMedicines.map(((e) {
      return {
        "drugCode": e.drugCode,
        "drugName": e.drugName,
        "drugGenericName": e.drugGenericName,
        "dose": e.drugDose,
        "duration": e.duration,
        "durationUnits": e.durationUnits,
        "directionOfUse": e.directionOfUse,
        "dosageUnits": e.dosageUnits,
        "dosageRegimen": e.dosageRegimen,
        "allowRefills": e.allowRefills,
        "dispenseAsWritten": e.dispenseAsWritten,
        "maxRefillsAllowed": e.maxRefillsAllowed
      };
    })).toList();
    List medicines = prescribedMedicinesMap.toList();
    if (prescriberInstitutionEditted) {
      findAccount(id) =>
          prescriberInstitutions.firstWhere((account) => account['_id'] == id);

      log(findAccount(id)['institutionName'].toString());
      params = {
        "prescriberInstitution": findAccount(id)['_id'],
        "prescriberInstitutionName": findAccount(id)['institutionName'],
        "prescriberInstitutionAddress": findAccount(id)['institutionAddress'],
        "prescriberInstitutionEmail": findAccount(id)['institutionEmail'],
        "prescriberInstitutionTelephone":
            findAccount(id)['institutionTelephone'],
        "medications": medicines
      };
    } else {
      params = {"medications": medicines};
    }
    dynamic prescription = await _dioClient.updatePrescription(
      prescriptionID: widget.prescriptionID,
      data: params,
    );
    if (prescription != null) {
      scaffoldMessengerKey.currentState!
          .showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
            content: Text(
              "Prescription updated",
            ),
          ))
          .closed
          .then((_) => {Navigator.pop(navigatorKey.currentContext!)});
    } else {
      log('could not save edits');
    }
  }

  Future<void> submitNewPrescription() async {
    var prescribedMedicinesMap = prescribedMedicines.map(((e) {
      return {
        "drugCode": e.drugCode,
        "drugName": e.drugName,
        "drugGenericName": e.drugGenericName,
        "dose": e.drugDose,
        "duration": e.duration,
        "durationUnits": e.durationUnits,
        "directionOfUse": e.directionOfUse,
        "dosageUnits": e.dosageUnits,
        "dosageRegimen": e.dosageRegimen,
        "allowRefills": e.allowRefills,
        "dispenseAsWritten": e.dispenseAsWritten,
        "maxRefillsAllowed": e.maxRefillsAllowed
      };
    })).toList();
    List medicines = prescribedMedicinesMap.toList();
    //log(prescriberAccount);
    dynamic prescription = await _dioClient.createPrescription(
        patientID: widget.patientID,
        medicines: medicines,
        pxSurname: widget.pxSurname,
        pxAge: int.parse(widget.pxAge),
        pxDOB: widget.pxDOB,
        pxFirstname: widget.pxFirstname,
        pxGender: widget.pxGender.toLowerCase(),
        isRegistered: widget.isRegistered,
        pxEmail: widget.pxEmail,
        pxTelephone: widget.pxTelephone,
        prescriberAccount: prescriberAccount,
        //add changes to prescription if it is a renewal
        isRenewal: widget.isRenewal,
        prescriptionBeingRenewed: widget.prescriptionID);

    if (prescription != null) {
      Prescription createdPrescription = Prescription.fromJson(prescription);
      afterSaveOption(createdPrescription).then((_) => {
            if (widget.isRegistered)
              {Navigator.pop(navigatorKey.currentContext!)}
            else
              {Navigator.pushNamed(context, '/home')}
          });
    } else {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: Text(
          "Error creating subscription",
        ),
      ));
    }
  }

  afterSaveOption(Prescription prescription) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        border: Border.all(color: Colors.green),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0))),
                    child: const Text(
                      'Prescription Created Sucessfully',
                      textScaleFactor: 1,
                      style: TextStyle(color: Colors.white),
                    )),
                Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: const Text(
                    'What would you like to do?',
                    textScaleFactor: 1.2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 8,
                    child: ListTile(
                      leading: const Icon(Icons.edit),
                      trailing: const Icon(CupertinoIcons.chevron_forward),
                      title: const Text('Edit Prescription'),
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditPrescriptionPage(
                                      title: 'Edit Prescription',
                                      prescriptionID:
                                          prescription.sId.toString(),
                                      isEditting: true,
                                      patientID: prescription.pxId.toString(),
                                      patientName:
                                          '${prescription.pxFirstname} ${prescription.pxSurname}',
                                      pxAge: prescription.pxAge.toString(),
                                      pxGender: prescription.pxgender,
                                      isRegistered: true,
                                      pxDOB: '',
                                      pxFirstname: '',
                                      pxSurname: '',
                                      isRenewal: false,
                                    ))).whenComplete(
                            () => Navigator.pop(context));
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Card(
                    elevation: 8,
                    child: ListTile(
                        leading: const SizedBox(
                            height: double.infinity, child: Icon(Icons.share)),
                        trailing: const Icon(CupertinoIcons.chevron_forward),
                        title: const Text('Share Prescription'),
                        subtitle:
                            const Text('via WhatsApp, Telegram, Email, etc'),
                        onTap: () async {
                          final pdfFile =
                              await pdfgen.PdfPrescriptionApi.generate(
                                  prescription);
                          PdfApi.sharePDF(
                                  scaffoldMessengerKey.currentContext!, pdfFile)
                              .whenComplete(() => Navigator.pop(context));
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                  child: Card(
                    elevation: 8,
                    child: ListTile(
                        leading: const Icon(Icons.picture_as_pdf),
                        trailing: const Icon(CupertinoIcons.chevron_forward),
                        title: const Text('View Prescription (PDF)'),
                        onTap: () async {
                          final pdfFile =
                              await pdfgen.PdfPrescriptionApi.generate(
                                  prescription);
                          PdfApi.openFile(pdfFile)
                              .whenComplete(() => Navigator.pop(context));
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                  child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Dismiss', textScaleFactor: 1.2)),
                )
              ]));
        });
  }

  getPrescription() async {
    setState(() {
      isLoading = true;
    });

    List retrievedMedicines = [];
    var prescription = await _dioClient.getPrescription(widget.prescriptionID);
    if (prescription != null) {
      if (prescription.prescriberInstitution != null) {
        defaultAccount = prescription.prescriberInstitution!;
      }
      retrievedMedicines = prescription.medications!.toList(growable: true);
      for (var element in retrievedMedicines) {
        prescribedMedicines.add(RxMedicines(
          id: element.sId,
          dosageRegimen: element.dosageRegimen,
          drugCode: element.drugCode,
          drugName: element.drugName,
          drugGenericName: element.drugGenericName,
          drugDose: element.dose,
          duration: element.duration,
          durationUnits: element.durationUnits,
          dosageUnits: element.dosageUnits,
          allowRefills:
              (element.allowRefills == null) ? false : element.allowRefills,
          dispenseAsWritten: (element.dispenseAsWritten == null)
              ? false
              : element.dispenseAsWritten,
          maxRefillsAllowed: (element.maxRefillsAllowed == null)
              ? 1
              : element.maxRefillsAllowed,
        ));
      }
    }
    setState(() {
      isLoading = false;
    });
  }
}

class RxMedicines {
  String id,
      drugCode,
      drugName,
      drugDose,
      dosageRegimen,
      duration,
      durationUnits,
      dosageUnits;
  bool dispenseAsWritten, allowRefills;
  int maxRefillsAllowed;
  String? directionOfUse, drugGenericName;
  RxMedicines(
      {required this.id,
      required this.dosageRegimen,
      required this.drugCode,
      required this.drugName,
      required this.drugDose,
      required this.duration,
      required this.durationUnits,
      this.directionOfUse,
      this.drugGenericName,
      required this.dosageUnits,
      required this.allowRefills,
      required this.dispenseAsWritten,
      required this.maxRefillsAllowed});
}

class UserAccounts {
  String key;
  String value;
  UserAccounts({required this.key, required this.value});
}
