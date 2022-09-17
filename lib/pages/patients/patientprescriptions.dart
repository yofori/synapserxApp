import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synapserx_prescriber/common/dio_client.dart';
import 'package:synapserx_prescriber/models/prescription.dart';
import 'package:synapserx_prescriber/pages/prescriptions/createprescription.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Prescription',
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreatePrescriptionPage(
                        patientID: widget.patientuid,
                      )));
        },
        child: const Icon(Icons.edit_note),
      ),
      appBar: AppBar(title: const Text('Prescriptions')),
      body: Column(children: <Widget>[
        const SizedBox(height: 10),
        Text('Patient: ${widget.patientName}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  child: Text('No data'),
                );
              }
              return ListView.separated(
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
                                    '${snapshot.data![index].medications![i].dosageRegimen} x '
                                    '${snapshot.data![index].medications![i].duration} ${snapshot.data![index].medications![i].durationUnits}')))
                      ]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    height: 2,
                    color: Colors.grey,
                  );
                },
              );
            }
            return Container();
          },
        )),
      ]),
    );
  }
}
