import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/common/dio_client.dart';
import 'package:synapserx_prescriber/pages/prescriptions/addeditdrugs.dart';
import 'package:synapserx_prescriber/pages/prescriptions/selectmedicine.dart';

class CreatePrescriptionPage extends StatefulWidget {
  const CreatePrescriptionPage({Key? key, required this.patientID})
      : super(key: key);
  final String patientID;

  @override
  State<CreatePrescriptionPage> createState() => _CreatePrescriptionPageState();
}

class _CreatePrescriptionPageState extends State<CreatePrescriptionPage> {
  final DioClient _dioClient = DioClient();
  List<RxMedicines> prescribedMedicines = [
    RxMedicines(
        drugCode: 'R034466',
        drugName: 'Methicillin',
        drugDose: '250',
        dosageRegimen: 'BD',
        dosageUnits: 'mg',
        duration: '7',
        durationUnits: 'Days',
        id: '1'),
    RxMedicines(
      drugCode: 'R035677',
      drugName: 'Flucloxacillin',
      drugDose: '500',
      dosageRegimen: 'QID',
      dosageUnits: 'mg',
      duration: '30',
      durationUnits: 'Days',
      id: '2',
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Medication',
        onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SelectMedicinesPage()))
              .then((value) {
            if (value != null) {
              addMedicines(value);
            }
          });
        },
        child: const Icon(
          Icons.add,
          size: 36,
        ),
      ),
      appBar:
          AppBar(title: const Text('Create Prescription'), actions: <Widget>[
        // icon to create prescription on server
        IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              submitNewPrescription();
            }),
        const SizedBox(
          width: 20,
        )
      ]),
      body: Column(
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
                      '${prescribedMedicines[index].drugDose}${prescribedMedicines[index].dosageUnits}  ${prescribedMedicines[index].dosageRegimen} x ${prescribedMedicines[index].duration} ${prescribedMedicines[index].durationUnits}', //
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddEditDrugPage(
                                            title: 'Editting Drug',
                                            addingNewDrug: false,
                                            drugCode: prescribedMedicines[index]
                                                .drugCode,
                                            drugName: prescribedMedicines[index]
                                                .drugName,
                                            drugDose: prescribedMedicines[index]
                                                .drugDose,
                                            doseUnits:
                                                prescribedMedicines[index]
                                                    .dosageUnits,
                                            dosageRegimen:
                                                prescribedMedicines[index]
                                                    .dosageRegimen,
                                            duration: prescribedMedicines[index]
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
                              setState(() {});
                            },
                            icon: const Icon(Icons.delete)),
                      ],
                    ),
                  ));
                }),
          )
        ],
      ),
    );
  }

  void addMedicines(Map value) {
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
    setState(() {});
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
    });
  }

  Future<void> submitNewPrescription() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Creating new prescription'),
      backgroundColor: Colors.blue.shade300,
    ));
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
    dynamic prescription = await _dioClient.creatPrescription(
        patientID: widget.patientID, medicines: medicines);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (prescription != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('New prescription added'),
        backgroundColor: Colors.green.shade300,
      ));
      Navigator.pop(context);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Error: Unable to add patient'),
        backgroundColor: Colors.red.shade300,
      ));
    }
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
