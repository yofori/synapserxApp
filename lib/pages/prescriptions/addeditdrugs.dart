import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:synapserx_prescriber/pages/widgets/customdropdown.dart';

class AddEditDrugPage extends StatefulWidget {
  const AddEditDrugPage({
    Key? key,
    required this.addingNewDrug,
    required this.title,
    required this.drugName,
    required this.drugCode,
    this.drugDose,
    this.doseUnits,
    this.dosageRegimen,
    this.duration,
    this.durationUnits,
    this.directionOfUse,
    required this.maxRefillAllowed,
    required this.dispenseAsWritten,
    required this.allowRefill,
  }) : super(key: key);
  final String drugName, drugCode, title;
  final String? drugDose,
      doseUnits,
      dosageRegimen,
      duration,
      durationUnits,
      directionOfUse;
  final bool addingNewDrug;
  final int maxRefillAllowed;
  final bool dispenseAsWritten, allowRefill;
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

  List<RefillTimes> refillTimes = [
    RefillTimes(key: 1, value: 'Once'),
    RefillTimes(key: 2, value: 'Twice'),
    RefillTimes(key: 3, value: 'Three times'),
  ];

  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _doseDuration = TextEditingController();
  final TextEditingController _directionOfUseController =
      TextEditingController();

  String _selectDoseUnits = '';
  String _selectDoseFrequency = '';
  String _selectedDurationUnit = '';
  bool dispenseAsWritten = false;
  bool allowRefill = false;
  int maxRefillsAllowed = 1;

  @override
  void initState() {
    if (!widget.addingNewDrug) {
      _doseController.text = widget.drugDose!;
      _doseDuration.text = widget.duration!;
      dispenseAsWritten = widget.dispenseAsWritten;
      allowRefill = widget.allowRefill;
      maxRefillsAllowed = widget.maxRefillAllowed;
      if (widget.directionOfUse != '') {
        _directionOfUseController.text = widget.directionOfUse ?? '';
      }
      _selectDoseUnits = widget.doseUnits!;
      _selectDoseFrequency = widget.dosageRegimen!;
      _selectedDurationUnit = widget.durationUnits!;
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
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r"[0-9./]")),
                          ],
                          controller: _doseController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter dose of the drug';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(12),
                            border: OutlineInputBorder(),
                            labelText: 'Dose',
                            hintText: 'Enter dose of drug',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: widget.addingNewDrug
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomSynapseDropDown(
                                  dropdownItems: units,
                                  onChanged: (value) {},
                                  onSaved: (value) {
                                    _selectDoseUnits = value.toString();
                                  },
                                  hint: 'Select Units',
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select dose unit';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomSynapseDropDown(
                                  value: widget.doseUnits,
                                  dropdownItems: units,
                                  onChanged: (value) {},
                                  onSaved: (value) {
                                    _selectDoseUnits = value.toString();
                                  },
                                  hint: 'Select Units',
                                ),
                              ))
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
                            return null;
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
                            return null;
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
                Row(mainAxisSize: MainAxisSize.max, children: [
                  Expanded(
                    flex: 40,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        controller: _doseDuration,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter duration';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(12),
                          border: OutlineInputBorder(),
                          //labelText: 'Enter duration',
                          hintText: 'Enter duration of treatment',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: widget.addingNewDrug
                          ? CustomSynapseDropDown(
                              hint: 'Select duration type',
                              dropdownItems: durationUnits,
                              validator: (value) {
                                if (value == null) {
                                  return 'Select duration type';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                //Do something when changing the item if you want.
                              },
                              onSaved: (value) {
                                _selectedDurationUnit = value.toString();
                              },
                            )
                          : CustomSynapseDropDown(
                              value: _selectedDurationUnit,
                              hint: 'Select duration type',
                              dropdownItems: durationUnits,
                              validator: (value) {
                                if (value == null) {
                                  return 'Select duration type';
                                }
                                return null;
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
                ]),
                // const SizedBox(
                //   height: 5,
                // ),
                Row(children: [
                  Checkbox(
                      value: dispenseAsWritten,
                      onChanged: (value) {
                        //value returned when checkbox is clicked
                        setState(() {
                          dispenseAsWritten = value!;
                        });
                      }),
                  const Text('Dispense as Written'),
                ]),
                Row(children: [
                  Checkbox(
                      value: allowRefill,
                      onChanged: (value) {
                        //value returned when checkbox is clicked
                        setState(() {
                          allowRefill = value!;
                        });
                      }),
                  const Text('Allow Refill: '),
                  Container(
                    width: 120,
                    child: DropdownButtonFormField2(
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      value: widget.maxRefillAllowed,
                      isDense: true,
                      items: refillTimes
                          .map((item) => DropdownMenuItem<int>(
                                value: item.key,
                                child: Text(
                                  item.value,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: allowRefill
                          ? (value) {
                              //Do something when changing the item if you want.
                            }
                          : null,
                      onSaved: allowRefill
                          ? (value) {
                              maxRefillsAllowed = int.parse(value.toString());
                            }
                          : (value) {
                              maxRefillsAllowed = 1;
                            },
                    ),
                  )
                ]),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child:
                          const Text('Direction of use / other instructions')),
                ),
                Container(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              //fixedSize: const Size(double.maxFinite, 40),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              //primary: Colors.pink,
                              //fixedSize: const Size(double.maxFinite, 40),
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
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
                                'DirectionOfUse':
                                    _directionOfUseController.text,
                                'dispenseAsWritten': dispenseAsWritten,
                                'allowRefills': allowRefill,
                                'maxRefillsAllowed': maxRefillsAllowed,
                              });
                            }
                          },
                          child: const Text("Submit")),
                    ),
                  ],
                ),
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

class RefillTimes {
  int key;
  String value;
  RefillTimes({required this.key, required this.value});
}
