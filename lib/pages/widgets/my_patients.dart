import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/common/service.dart';
import 'package:synapserx_prescriber/models/associations.dart';
import 'package:synapserx_prescriber/common/dio_client.dart';
import 'package:synapserx_prescriber/pages/addassociations.dart';

import '../patients/patientprescriptions.dart';

// ignore: must_be_immutable
class PatientsPage extends StatefulWidget {
  const PatientsPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  static String accessToken = GlobalData.accessToken;
  final DioClient _dioClient = DioClient();
  final TextEditingController _textController = TextEditingController();

  late Future<List<Associations>> associations;
  String searchString = "";

  @override
  void initState() {
    super.initState();
    associations = fetchAssociations();
  }

  String getInitials(String patientFullname) => patientFullname.isNotEmpty
      ? patientFullname
          .trim()
          .split(RegExp(' +'))
          .map((s) => s[0])
          .take(2)
          .join()
      : '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Patient',
        child: const Icon(Icons.person_add),
        onPressed: () {
          navigateToAddAssociation();
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
                controller: _textController,
                onChanged: (value) {
                  setState(() {
                    searchString = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Enter patient name',
                  prefixIcon: const Icon(Icons.search),
                )),
          ),
          Expanded(
            child: FutureBuilder(
              builder: (context, AsyncSnapshot<List<Associations>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return snapshot.data![index].patientFullname
                              .toLowerCase()
                              .contains(searchString)
                          ? ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PatientPrescriptionsPage(
                                            patientuid: snapshot
                                                .data![index].patientuid,
                                          )),
                                );
                              },
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors
                                    .primaries[index % Colors.primaries.length],
                                child: Text(
                                  getInitials(
                                    snapshot.data![index].patientFullname
                                        .toString(),
                                  ),
                                ),
                              ),
                              title: Container(
                                //height: 43,
                                decoration: const BoxDecoration(
                                    //border: Border(
                                    //bottom: BorderSide(color: Colors.grey)),
                                    ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      '${snapshot.data?[index].patientFullname}'),
                                ),
                              ),
                              subtitle: Text(
                                  'Status: ${snapshot.data?[index].status}'),
                            )
                          : Container();
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        height: 2,
                        color: Colors.grey,
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong :('));
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
              },
              future: associations,
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Associations>> fetchAssociations() async {
    final response = await _dioClient.getAssociations(accessToken);
    return response;
  }

  void navigateToAddAssociation() async {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => const AddAssociationsPage()))
        .whenComplete(() {
      setState(() {
        associations = fetchAssociations();
      });
    });
  }
}
