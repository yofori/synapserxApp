import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AddEditDrugPage extends StatefulWidget {
  const AddEditDrugPage(
      {Key? key,
      required this.addingNewDrug,
      required this.title,
      required this.drugName,
      required this.drugCode,
      this.drugDose,
      this.doseUnits,
      this.dosageRegimen,
      this.duration,
      this.durationUnits,
      this.directionOfUse})
      : super(key: key);
  final String drugName, drugCode, title;
  final String? drugDose,
      doseUnits,
      dosageRegimen,
      duration,
      durationUnits,
      directionOfUse;
  final bool addingNewDrug;
  @override
  State<AddEditDrugPage> createState() => _AddEditDrugPageState();
}

class _AddEditDrugPageState extends State<AddEditDrugPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> units = [
    'mg',
    'g',
    'ml',
    'Units',
    'micrograms',
  ];

  final List<String> durationUnits = [
    'Hours',
    'Days',
    'Weeks',
    'Months',
  ];

  List<DosingFrequency> dosingFrequency = [
    DosingFrequency(key: 'OD', value: 'OD - once daily'),
    DosingFrequency(key: 'BD', value: 'BD - twice daily'),
    DosingFrequency(key: 'TID', value: 'TID - three times a day'),
    DosingFrequency(key: 'QID', value: 'QID - four times a day'),
    DosingFrequency(key: 'Nocte', value: 'Nocte - at night'),
    DosingFrequency(key: 'Mane', value: 'Mane - in the morning'),
    DosingFrequency(key: 'Stat', value: 'Stat - immediately'),
    DosingFrequency(key: 'QoD', value: 'QoD - every other day'),
    DosingFrequency(key: 'PRN', value: 'PRN - as needed'),
    DosingFrequency(key: 'q4h', value: 'q4h - every 4 hours'),
    DosingFrequency(key: 'q6h', value: 'q6h - every 6 hours'),
    DosingFrequency(key: 'q8h', value: 'q8h - every 8 hours'),
    DosingFrequency(key: 'q12h', value: 'q12h - every 12 hours'),
  ];

  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _doseDuration = TextEditingController();
  final TextEditingController _directionOfUseController =
      TextEditingController();

  String _selectDoseUnits = '';
  String _selectDoseFrequency = '';
  String _selectedDurationUnit = 'Days';

  @override
  void initState() {
    if (!widget.addingNewDrug) {
      _doseController.text = widget.drugDose ?? '';
      _doseDuration.text = widget.duration ?? '';
      _directionOfUseController.text = widget.directionOfUse ?? '';
      _selectDoseUnits = widget.doseUnits ?? '';
      _selectDoseFrequency = widget.dosageRegimen ?? '';
      _selectedDurationUnit = widget.durationUnits ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        // decoration: BoxDecoration(
                        //   border: Border.all(
                        //     //color: Colors.blue,
                        //     width: 1,
                        //   ),
                        //   borderRadius:
                        //       const BorderRadius.all(Radius.circular(5)),
                        // ),
                        child: Text(
                          widget.drugName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _doseController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter dose of the drug';
                            }
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Dose',
                            hintText: 'Enter dose of drug',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: widget.addingNewDrug
                              ? DropdownButtonFormField2(
                                  //value: _selectDoseUnits,
                                  decoration: InputDecoration(
                                    //Add isDense true and zero Padding.
                                    //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    //Add more decoration as you want here
                                    //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                  ),
                                  isExpanded: true,
                                  hint: const Text(
                                    'Select units',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black45,
                                  ),
                                  iconSize: 30,
                                  buttonHeight: 60,
                                  buttonPadding: const EdgeInsets.only(
                                      left: 20, right: 10),
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  items: units
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select dose units';
                                    }
                                  },
                                  onChanged: (value) {
                                    //Do something when changing the item if you want.
                                  },
                                  onSaved: (value) {
                                    _selectDoseUnits = value.toString();
                                  },
                                )
                              : DropdownButtonFormField2(
                                  value: _selectDoseUnits,
                                  decoration: InputDecoration(
                                    //Add isDense true and zero Padding.
                                    //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    //Add more decoration as you want here
                                    //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                  ),
                                  isExpanded: true,
                                  hint: const Text(
                                    'Select units',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black45,
                                  ),
                                  iconSize: 30,
                                  buttonHeight: 60,
                                  buttonPadding: const EdgeInsets.only(
                                      left: 20, right: 10),
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  items: units
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  validator: (value) {
                                    if (value == '') {
                                      return 'Please select dose units';
                                    }
                                  },
                                  onChanged: (value) {
                                    //Do something when changing the item if you want.
                                  },
                                  onSaved: (value) {
                                    _selectDoseUnits = value.toString();
                                  },
                                )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text('Frequency')),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: widget.addingNewDrug
                      ? DropdownButtonFormField2(
                          //value: _selectDoseFrequency,
                          dropdownMaxHeight: 200,
                          decoration: InputDecoration(
                            //Add isDense true and zero Padding.
                            //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            //Add more decoration as you want here
                            //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                          ),
                          isExpanded: true,
                          hint: const Text(
                            'Select dosing frequecy',
                            style: TextStyle(fontSize: 14),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 30,
                          buttonHeight: 60,
                          buttonPadding:
                              const EdgeInsets.only(left: 20, right: 10),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          items: dosingFrequency
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
                              return 'Please select dosing frequency';
                            }
                          },
                          onChanged: (value) {
                            //Do something when changing the item if you want.
                          },
                          onSaved: (value) {
                            _selectDoseFrequency = value.toString();
                          },
                        )
                      : DropdownButtonFormField2(
                          value: _selectDoseFrequency,
                          dropdownMaxHeight: 200,
                          decoration: InputDecoration(
                            //Add isDense true and zero Padding.
                            //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            //Add more decoration as you want here
                            //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                          ),
                          isExpanded: true,
                          hint: const Text(
                            'Select dosing frequecy',
                            style: TextStyle(fontSize: 14),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 30,
                          buttonHeight: 60,
                          buttonPadding:
                              const EdgeInsets.only(left: 20, right: 10),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          items: dosingFrequency
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
                              return 'Please select dosing frequency';
                            }
                          },
                          onChanged: (value) {
                            //Do something when changing the item if you want.
                          },
                          onSaved: (value) {
                            _selectDoseFrequency = value.toString();
                          },
                        ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: const Text('Duration of treatment')),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      flex: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _doseDuration,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter duration';
                            }
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            //labelText: 'Enter duration',
                            hintText: 'Enter duration of treatment',
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 60,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField2(
                          value: _selectedDurationUnit,
                          decoration: InputDecoration(
                            //Add isDense true and zero Padding.
                            //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            //Add more decoration as you want here
                            //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                          ),
                          isExpanded: true,
                          hint: const Text(
                            'Select duration type',
                            style: TextStyle(fontSize: 14),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 30,
                          buttonHeight: 60,
                          buttonPadding:
                              const EdgeInsets.only(left: 20, right: 10),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          items: durationUnits
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          validator: (value) {
                            if (value == '') {
                              return 'Select duration type';
                            }
                          },
                          onChanged: (value) {
                            //Do something when changing the item if you want.
                          },
                          onSaved: (value) {
                            _selectedDurationUnit = value.toString();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child:
                          const Text('Direction of use / other instructions')),
                ),
                Container(
                    //height: 30,
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                        controller: _directionOfUseController,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            //labelText: 'Directions of use',
                            hintText:
                                'Enter the directions of use of the medication'),
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ))),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          //primary: Colors.pink,
                          fixedSize: const Size(double.maxFinite, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        var form = _formKey.currentState;
                        if (_formKey.currentState!.validate()) {
                          form!.save();
                          Navigator.pop(context, {
                            'DrugCode': widget.drugCode,
                            'DrugName': widget.drugName,
                            'DrugDose': _doseController.text,
                            'DoseUnits': _selectDoseUnits,
                            'DosageRegimen': _selectDoseFrequency,
                            'Duration': _doseDuration.text,
                            'DurationUnits': _selectedDurationUnit,
                            'DirectionOfUse': _directionOfUseController.text,
                          });
                        }
                      },
                      child: const Text("Submit")),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          fixedSize: const Size(double.maxFinite, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                )
              ],
            ),
          ),
        ));
  }
}

class DosingFrequency {
  String key;
  String value;
  DosingFrequency({required this.key, required this.value});
}
