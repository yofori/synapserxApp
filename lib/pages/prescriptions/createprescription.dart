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
        noOfDays: '7'),
    RxMedicines(
        drugCode: 'R035677',
        drugName: 'Flucloxacillin',
        drugDose: '500mg',
        dosageRegimen: 'QID',
        noOfDays: '7')
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
                  builder: (context) => const SelectMedicinesPage()));
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
                            onPressed: () {}, icon: const Icon(Icons.delete)),
                      ],
                    ),
                  ));
                }),
          )
        ],
      ),
    );
  }
}

class RxMedicines {
  String drugCode, drugName, drugDose, dosageRegimen, noOfDays;
  RxMedicines(
      {required this.dosageRegimen,
      required this.drugCode,
      required this.drugName,
      required this.drugDose,
      required this.noOfDays});
}
