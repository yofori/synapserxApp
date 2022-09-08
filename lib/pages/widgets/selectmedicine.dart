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
  @override
  Widget build(BuildContext context) {
    return MedicinesList(onTap: (value) {
      Map<String, dynamic> map = jsonDecode(value);
      String drugCode = map["drugCode"].toString();
      String drugName = map["drugName"].toString();
      Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (context) => AddEditDrugPage(
                    drugCode: drugCode,
                    drugName: drugName,
                  )))
          .whenComplete(() {
        setState(() {
          // add code to refresh list
        });
      });
    });
  }
}
