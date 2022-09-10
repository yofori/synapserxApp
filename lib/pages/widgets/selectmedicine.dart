import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/pages/widgets/addeditdrugs.dart';
import 'package:synapserx_prescriber/pages/widgets/medicineslist.dart';

class SelectMedicinesPage extends StatefulWidget {
  const SelectMedicinesPage({Key? key}) : super(key: key);

  @override
  State<SelectMedicinesPage> createState() => _SelectMedicinesPageState();
}

class _SelectMedicinesPageState extends State<SelectMedicinesPage> {
  String drugName = '';
  String drugCode = '';
  @override
  Widget build(BuildContext context) {
    return MedicinesList(onTap: (value) {
      Map<String, dynamic> map = jsonDecode(value);
      drugCode = map["drugCode"].toString();
      drugName = map["drugName"].toString();
      _navigateAndDisplayAddEditDrug(context);
    });
  }

  Future<void> _navigateAndDisplayAddEditDrug(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditDrugPage(
                drugCode: drugCode,
                drugName: drugName,
              )),
    );
    if (!mounted) return;
    if (result != null) {
      Navigator.pop(context, result);
      print(result);
    } else {
      Navigator.pop(context);
    }
  }
}
