import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/pages/prescriptions/addeditdrugs.dart';
import 'package:synapserx_prescriber/pages/widgets/medicineslist.dart';

class SelectMedicinesPage extends StatefulWidget {
  const SelectMedicinesPage({Key? key}) : super(key: key);

  @override
  State<SelectMedicinesPage> createState() => _SelectMedicinesPageState();
}

class _SelectMedicinesPageState extends State<SelectMedicinesPage> {
  String drugName = '';
  String drugCode = '';
  String drugGenericName = '';
  @override
  Widget build(BuildContext context) {
    return MedicinesList(onTap: (value) {
      Map<String, dynamic> map = jsonDecode(value);
      drugCode = map["drugCode"].toString();
      drugName = map["drugName"].toString();
      drugGenericName = map["drugGenericName"].toString();
      _navigateAndDisplayAddEditDrug(context);
    });
  }

  Future<void> _navigateAndDisplayAddEditDrug(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditDrugPage(
                title: 'Adding Drug',
                drugCode: drugCode,
                drugName: drugName,
                drugGenericName: drugGenericName,
                addingNewDrug: true,
                allowRefill: false,
                dispenseAsWritten: false,
                maxRefillAllowed: 1,
              )),
    );
    if (!mounted) return;
    if (result != null) {
      Navigator.pop(context, result);
      log('$result');
    } else {
      Navigator.pop(context);
    }
  }
}
