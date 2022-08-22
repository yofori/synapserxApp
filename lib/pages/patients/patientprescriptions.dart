import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synapserx_prescriber/common/dio_client.dart';
import 'package:synapserx_prescriber/common/service.dart';
import 'package:synapserx_prescriber/models/prescription.dart';

class PatientPrescriptionsPage extends StatefulWidget {
  const PatientPrescriptionsPage({Key? key, required this.patientuid})
      : super(key: key);
  final String patientuid;

  @override
  // ignore: library_private_types_in_public_api
  _PatientPrescriptionsPageState createState() =>
      _PatientPrescriptionsPageState();
}

class _PatientPrescriptionsPageState extends State<PatientPrescriptionsPage> {
  final DioClient _dioClient = DioClient();
  late Future<List<Prescription>> prescriptions;

  @override
  void initState() {
    super.initState();
    prescriptions = fetchPatientPrescriptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prescriptions')),
      body: Column(children: <Widget>[
        Expanded(
            child: FutureBuilder(
                builder: (context, AsyncSnapshot<List<Prescription>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: const Center(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator(),
                          ),
                        ));
                  } else {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return ExpansionTile(
                              childrenPadding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.end,
                              maintainState: true,
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border:
                                      Border.all(color: Colors.blue, width: 2),
                                ),
                                child: Center(
                                    child: Text(
                                  (index + 1).toString(),
                                  style: const TextStyle(fontSize: 16),
                                )),
                              ),
                              title: Text(DateFormat('dd-MM-yyyy @ hh:mm a')
                                  .format(DateTime.parse(snapshot
                                      .data![index].createdAt
                                      .toString()))),
                              subtitle: Text(
                                  'Prescriber: ${snapshot.data![index].prescriberName.toString()}'),
                              children: [
                                ListView.builder(
                                    itemCount: snapshot
                                        .data![index].medications!.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, i) => ListTile(
                                        leading: CircleAvatar(
                                          child: Text((i + 1).toString()),
                                        ),
                                        title: Text(snapshot.data![index]
                                            .medications![i].drugName!
                                            .toUpperCase()),
                                        subtitle: Text(
                                            '${snapshot.data![index].medications![i].routeOfAdministration} '
                                            '${snapshot.data![index].medications![i].dose} '
                                            '${snapshot.data![index].medications![i].dosageRegimen} x '
                                            '${snapshot.data![index].medications![i].noOfDays} days')))
                              ]);
                        },
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            height: 2,
                            color: Colors.grey,
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text(
                              'There are no prescriptions for the selected Patient'));
                    }
                    return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: const Center(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator(),
                          ),
                        ));
                  }
                },
                future: prescriptions))
      ]),
    );
  }

  Future<List<Prescription>> fetchPatientPrescriptions() async {
    final response = await _dioClient.getPxRx(
        token: GlobalData.accessToken, patientuid: widget.patientuid);
    return response;
  }
}
