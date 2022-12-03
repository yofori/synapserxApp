import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synapserx_prescriber/common/dio_client.dart';
import 'package:synapserx_prescriber/models/models.dart';
import 'package:synapserx_prescriber/pages/prescriptions/editprescriptions.dart';
import 'package:synapserx_prescriber/pages/widgets/prescriptionactionbar.dart';

class PatientPrescriptionsPage extends StatefulWidget {
  const PatientPrescriptionsPage({
    Key? key,
    required this.patientuid,
    required this.patientName,
  }) : super(key: key);
  final String patientuid;
  final String patientName;

  @override
  // ignore: library_private_types_in_public_api
  _PatientPrescriptionsPageState createState() =>
      _PatientPrescriptionsPageState();
}

class _PatientPrescriptionsPageState extends State<PatientPrescriptionsPage> {
  final DioClient _dioClient = DioClient();
  GlobalKey _key = GlobalKey();
  Patient patient = Patient();
  int pxAge = 0;
  String pxGender = '';

  @override
  void initState() {
    super.initState();
    getPatientDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          tooltip: 'Add New Medication',
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditPrescriptionPage(
                          title: 'Create Prescription',
                          prescriptionID: '',
                          isEditting: false,
                          patientID: widget.patientuid,
                          patientName: widget.patientName.toString(),
                          pxAge: pxAge.toString(),
                          pxGender: pxGender,
                          pxDOB: '',
                          isRegistered: true,
                          pxFirstname: '',
                          pxSurname: '',
                        )));
            setState(() {});
          },
          child: const Icon(
            Icons.post_add,
            size: 30,
          )),
      appBar: AppBar(title: const Text('Prescriptions')),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
              child: Text('Name: ${widget.patientName.toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 10, 10),
              child: Text('Sex: $pxGender   Age: $pxAge',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 16,
                  )),
            ),
            const SizedBox(height: 10),
            Expanded(
                child: FutureBuilder<List<Prescription>>(
              future: _dioClient.getPxRx(widget.patientuid),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Prescription>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  final error = snapshot.error;
                  return Center(
                    child: Text(
                      "Error: $error",
                    ),
                  );
                } else if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Patient has no prescriptions'),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      _refresh();
                    },
                    child: ListView.separated(
                      key: _key,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ExpansionTile(
                          childrenPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          expandedCrossAxisAlignment: CrossAxisAlignment.end,
                          maintainState: true,
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(color: Colors.blue, width: 2),
                            ),
                            child: Center(
                                child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(fontSize: 16),
                            )),
                          ),
                          title: Text(
                              'Date: ${DateFormat('dd-MM-yyyy @ hh:mm a').format(DateTime.parse(snapshot.data![index].createdAt.toString()))}'),
                          subtitle: Text(
                              'Prescriber: ${snapshot.data![index].prescriberName.toString()}'),
                          children: [
                            ListView.builder(
                                itemCount:
                                    snapshot.data![index].medications!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, i) => ListTile(
                                    leading: CircleAvatar(
                                      child: Text((i + 1).toString()),
                                    ),
                                    title: Text(snapshot
                                        .data![index].medications![i].drugName!
                                        .toUpperCase()),
                                    subtitle: Text(
                                        '${snapshot.data![index].medications![i].dose} '
                                        '${snapshot.data![index].medications![i].dosageUnits} '
                                        '${snapshot.data![index].medications![i].dosageRegimen} x '
                                        '${snapshot.data![index].medications![i].duration} ${snapshot.data![index].medications![i].durationUnits}'))),
                            PrescriptionActionBar(
                              prescription: snapshot.data![index],
                              notifyParent: _refresh,
                            )
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          height: 2,
                          color: Colors.grey,
                        );
                      },
                    ),
                  );
                }
                return Container();
              },
            )),
          ]),
    );
  }

  Future<void> _refresh() async {
    if (mounted) {
      _key = GlobalKey();
      setState(() {});
    }
    Future.value(null);
  }

  Future<void> getPatientDetails() async {
    patient = (await _dioClient.getPatientDetails(widget.patientuid))!;
    setState(() {
      pxAge = calculateAge(patient.dateOfBirth!);
      pxGender = patient.gender!.toUpperCase();
    });
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
