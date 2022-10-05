import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/common/dio_client.dart';
import 'package:synapserx_prescriber/main.dart';
import 'package:synapserx_prescriber/pages/prescriptions/addeditdrugs.dart';
import 'package:synapserx_prescriber/pages/prescriptions/selectmedicine.dart';

class EditPrescriptionPage extends StatefulWidget {
  const EditPrescriptionPage(
      {Key? key,
      required this.title,
      required this.patientID,
      required this.prescriptionID,
      required this.isEditting})
      : super(key: key);
  final String prescriptionID;
  final String patientID;
  final bool isEditting;
  final String title;

  @override
  State<EditPrescriptionPage> createState() => _EditPrescriptionPageState();
}

class _EditPrescriptionPageState extends State<EditPrescriptionPage> {
  List<RxMedicines> prescribedMedicines = [];
  bool isSaveButtonDisabled = true;
  @override
  void initState() {
    super.initState();
    if (widget.isEditting) {
      getPrescription();
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
              primary: Colors.green,
            ),
            onPressed: isSaveButtonDisabled
                ? null
                : () {
                    widget.isEditting
                        ? submitChangesToPrescription()
                        : submitNewPrescription();
                  },
            child: const Text('Save'),
          ),
        ),
        const SizedBox(
          width: 20,
        )
      ]),
      body: prescribedMedicines.isNotEmpty
          ? Column(
              children: [
                Container(),
                Expanded(
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
                                            builder: (context) =>
                                                AddEditDrugPage(
                                                  title: 'Editting Drug',
                                                  addingNewDrug: false,
                                                  drugCode:
                                                      prescribedMedicines[index]
                                                          .drugCode,
                                                  drugName:
                                                      prescribedMedicines[index]
                                                          .drugName,
                                                  drugDose:
                                                      prescribedMedicines[index]
                                                          .drugDose,
                                                  doseUnits:
                                                      prescribedMedicines[index]
                                                          .dosageUnits,
                                                  dosageRegimen:
                                                      prescribedMedicines[index]
                                                          .dosageRegimen,
                                                  duration:
                                                      prescribedMedicines[index]
                                                          .duration,
                                                  durationUnits:
                                                      prescribedMedicines[index]
                                                          .durationUnits,
                                                  directionOfUse:
                                                      prescribedMedicines[index]
                                                          .directionOfUse,
                                                ))).then((value) {
                                      if (value != null) {
                                        editMedicines(value, index);
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    prescribedMedicines.removeWhere((element) {
                                      return element.id ==
                                          prescribedMedicines[index].id;
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
              ],
            )
          : const Center(
              child: Text(
                'There are no medicines in the Prescription \n \n Click "+" to add',
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  void addMedicines(Map value) {
    setState(() {
      prescribedMedicines.add(RxMedicines(
        drugCode: value['DrugCode'],
        drugName: value['DrugName'],
        drugDose: value['DrugDose'],
        dosageRegimen: value['DosageRegimen'],
        dosageUnits: value['DoseUnits'],
        duration: value['Duration'],
        durationUnits: value['DurationUnits'],
        directionOfUse: value['DirectionOfUse'],
        id: (prescribedMedicines.length + 1).toString(),
      ));
      //enable save button
      isSaveButtonDisabled = false;
    });
  }

  void editMedicines(Map value, int index) {
    setState(() {
      prescribedMedicines[index].drugCode = value['DrugCode'];
      prescribedMedicines[index].drugName = value['DrugName'];
      prescribedMedicines[index].drugDose = value['DrugDose'];
      prescribedMedicines[index].dosageRegimen = value['DosageRegimen'];
      prescribedMedicines[index].dosageUnits = value['DoseUnits'];
      prescribedMedicines[index].duration = value['Duration'];
      prescribedMedicines[index].durationUnits = value['DurationUnits'];
      prescribedMedicines[index].directionOfUse = value['DirectionOfUse'];
      //enable the save button
      isSaveButtonDisabled = false;
    });
  }

  Future<void> submitChangesToPrescription() async {
    var prescribedMedicinesMap = prescribedMedicines.map(((e) {
      return {
        "drugCode": e.drugCode,
        "drugName": e.drugName,
        "dose": e.drugDose,
        "duration": e.duration,
        "durationUnits": e.durationUnits,
        "directionOfUse": e.directionOfUse,
        "dosageUnits": e.dosageUnits,
        "dosageRegimen": e.dosageRegimen,
      };
    })).toList();
    List medicines = prescribedMedicinesMap.toList();
    dynamic prescription = await _dioClient.updatePrescription(
        prescriptionID: widget.prescriptionID, medicines: medicines);
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
        "dose": e.drugDose,
        "duration": e.duration,
        "durationUnits": e.durationUnits,
        "directionOfUse": e.directionOfUse,
        "dosageUnits": e.dosageUnits,
        "dosageRegimen": e.dosageRegimen,
      };
    })).toList();
    List medicines = prescribedMedicinesMap.toList();
    dynamic prescription = await _dioClient.createPrescription(
        patientID: widget.patientID, medicines: medicines);
    if (prescription != null) {
      scaffoldMessengerKey.currentState!
          .showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
            content: Text(
              "New Prescription Successfully Created",
            ),
          ))
          .closed
          .then((_) => {Navigator.pop(navigatorKey.currentContext!)});
    } else {}
  }

  getPrescription() async {
    List retrievedMedicines = [];
    var prescription = await _dioClient.getPrescription(widget.prescriptionID);
    if (prescription != null) {
      retrievedMedicines = prescription.medications!.toList(growable: true);
      for (var element in retrievedMedicines) {
        debugPrint(element.sId.toString());
        prescribedMedicines.add(RxMedicines(
            id: element.sId,
            dosageRegimen: element.dosageRegimen,
            drugCode: element.drugCode,
            drugName: element.drugName,
            drugDose: element.dose,
            duration: element.duration,
            durationUnits: element.durationUnits,
            dosageUnits: element.dosageUnits));
      }
    }
    setState(() {});
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
  String? directionOfUse;
  RxMedicines({
    required this.id,
    required this.dosageRegimen,
    required this.drugCode,
    required this.drugName,
    required this.drugDose,
    required this.duration,
    required this.durationUnits,
    this.directionOfUse,
    required this.dosageUnits,
  });
}
