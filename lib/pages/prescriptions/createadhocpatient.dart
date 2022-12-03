import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:synapserx_prescriber/models/genders.dart';
import 'package:synapserx_prescriber/pages/prescriptions/editprescriptions.dart';
import 'package:synapserx_prescriber/pages/widgets/genderselector.dart';

class CreateAdhocPxPage extends StatefulWidget {
  const CreateAdhocPxPage({super.key});

  @override
  State<CreateAdhocPxPage> createState() => CreateAdhocPxPageState();
}

class CreateAdhocPxPageState extends State<CreateAdhocPxPage> {
  bool ageIsEstimated = false;
  String selectedGender = '';
  DateTime pickedDate = DateTime.now();
  TextEditingController pxSurnameController = TextEditingController();
  TextEditingController pxFirstnameController = TextEditingController();
  TextEditingController pxTelephoneController = TextEditingController();
  TextEditingController pxEmailController = TextEditingController();
  TextEditingController pxDOBController = TextEditingController();
  TextEditingController pxAgeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Gender> genders = <Gender>[];

  @override
  void initState() {
    super.initState();
    genders.add(Gender("Male", MdiIcons.genderMale, false));
    genders.add(Gender("Female", MdiIcons.genderFemale, false));
    genders.add(Gender("Others", MdiIcons.genderTransgender, false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Patient'),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  TextFormField(
                    controller: pxSurnameController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Patient's surname is required";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        isDense: true,
                        border: OutlineInputBorder(),
                        labelText: 'Surname',
                        hintText: 'Enter Patient\'s Surname'),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: pxFirstnameController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Patient's firstname is required";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        isDense: true,
                        border: OutlineInputBorder(),
                        labelText: 'First Names',
                        hintText: 'Enter Patient\'s First Names'),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Gender Of Patient:',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GenderSelector(
                    onSelect: (String gender) {
                      selectedGender = gender;
                    },
                    genders: genders,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Age Of Patient:',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Checkbox(
                            value: ageIsEstimated,
                            onChanged: (bool? value) {
                              //value returned when checkbox is clicked
                              setState(() {
                                ageIsEstimated = value!;
                              });
                            }),
                        const Text('Age is estimated'),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 30,
                          child: TextFormField(
                              controller: pxAgeController,
                              onChanged: ((value) {
                                var today = DateTime.now();
                                pxDOBController.text = DateFormat("yyyy-MM-dd")
                                    .format(DateTime(
                                        today.year -
                                            int.parse(pxAgeController.text),
                                        today.month,
                                        today.day));
                              }),
                              keyboardType: TextInputType.number,
                              enabled: ageIsEstimated,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(5.0),
                                border: OutlineInputBorder(),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      const Text('Date of birth:'),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: 160,
                        //height: 36,
                        child: TextFormField(
                            onChanged: ((value) {}),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Patient's DOB is required";
                              }
                              return null;
                            },
                            controller: pxDOBController,
                            keyboardType: TextInputType.datetime,
                            enabled: !ageIsEstimated,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8),
                              suffixIcon: GestureDetector(
                                onTap: ageIsEstimated
                                    ? null
                                    : () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime
                                                    .now(), //get today's date
                                                firstDate: DateTime(
                                                    1910), //DateTime.now() - not to allow to choose before today.
                                                lastDate: DateTime.now());
                                        pxDOBController.text =
                                            DateFormat("yyyy-MM-dd")
                                                .format(pickedDate!);
                                        pxAgeController.text =
                                            (DateTime.now().year -
                                                    pickedDate.year)
                                                .toString();
                                      },
                                child: const Icon(Icons.calendar_month),
                              ),
                              isDense: true,
                              border: const OutlineInputBorder(),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      controller: pxTelephoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Telephone',
                        hintText: 'Enter Patient\' Telephone Number',
                        isDense: true,
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      controller: pxEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter Patient\' Email',
                        isDense: true,
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditPrescriptionPage(
                                            title: 'Create Prescription',
                                            isEditting: false,
                                            patientName:
                                                '${pxFirstnameController.text} ${pxSurnameController.text}',
                                            pxGender: selectedGender,
                                            pxAge: pxAgeController.text,
                                            patientID: '',
                                            prescriptionID: '',
                                            isRegistered: false,
                                            pxDOB: pxDOBController.text,
                                            pxFirstname:
                                                pxFirstnameController.text,
                                            pxSurname: pxSurnameController.text,
                                            pxEmail: pxEmailController.text,
                                            pxTelephone:
                                                pxTelephoneController.text,
                                          )));
                            }
                          },
                          child: const Text('Add Medicines')),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
