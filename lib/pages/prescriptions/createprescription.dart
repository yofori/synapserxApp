import 'package:flutter/material.dart';

import '../widgets/selectMedicine.dart';

class CreatePrescriptionPage extends StatefulWidget {
  const CreatePrescriptionPage({Key? key}) : super(key: key);

  @override
  State<CreatePrescriptionPage> createState() => _CreatePrescriptionPageState();
}

class _CreatePrescriptionPageState extends State<CreatePrescriptionPage> {
  List<RxMedicines> prescribedMedicines = [
    RxMedicines(
        drugCode: 'R034466',
        drugName: 'Methicillin',
        drugDose: '250mg',
        dosageRegimen: 'BD',
        dosageUnits: '',
        duration: '',
        durationUnits: '',
        id: '1'),
    RxMedicines(
      drugCode: 'R035677',
      drugName: 'Flucloxacillin',
      drugDose: '500mg',
      dosageRegimen: 'QID',
      dosageUnits: '',
      duration: '',
      durationUnits: '',
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
        child: const Icon(Icons.add_to_queue),
      ),
      appBar: AppBar(title: const Text('Create Prescription')),
      body: Column(
        children: [
          Container(),
          Expanded(
            child: ListView.builder(
                itemCount: prescribedMedicines.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    title: Text(
                        '${index + 1}. ${prescribedMedicines[index].drugName}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.edit)),
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
      dosageUnits: 'DoseUnits',
      duration: value['Duration'],
      durationUnits: 'DurationUnits',
      directionOfUse: value['DirectionOfUse'],
      id: (prescribedMedicines.length + 1).toString(),
    ));
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
