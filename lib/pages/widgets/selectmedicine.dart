import 'package:flutter/material.dart';
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
      print(value);
    });
  }
}
