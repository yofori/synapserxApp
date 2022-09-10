import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AddEditDrugPage extends StatefulWidget {
  const AddEditDrugPage(
      {Key? key, required this.drugName, required this.drugCode})
      : super(key: key);
  final String drugName, drugCode;

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

  final List<String> dosingFrequency = [
    'OD',
    'BD',
    'TID',
    'QID',
    'Nocte',
    'Mane',
    'Stat',
    'QOD',
  ];

  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _doseDuration = TextEditingController();
  final TextEditingController _directionOfUseController =
      TextEditingController();

  String? _selectDoseUnits = '';
  String _selectDoseFrequency = '';
  String? _selectedDurationUnit = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.drugName),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(height: 10),
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
                        child: DropdownButtonFormField2(
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
                          buttonPadding:
                              const EdgeInsets.only(left: 20, right: 10),
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
                        ),
                      ),
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
                  child: DropdownButtonFormField2(
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
                    buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    items: dosingFrequency
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
                            labelText: 'Enter duration',
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
                            if (value == null) {
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
                            labelText: 'Directions of use',
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
                )
              ],
            ),
          ),
        ));
  }
}
