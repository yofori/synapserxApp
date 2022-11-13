import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/common/service.dart';
import 'package:synapserx_prescriber/models/associations.dart';
import 'package:synapserx_prescriber/common/dio_client.dart';
import 'package:synapserx_prescriber/pages/patients/addassociations.dart';
import 'package:synapserx_prescriber/pages/widgets/rxdrawer.dart';

import '../patients/patientprescriptions.dart';

// ignore: must_be_immutable
class PatientsPage extends StatefulWidget {
  const PatientsPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  GlobalKey _key = GlobalKey();
  static String accessToken = GlobalData.accessToken;
  final DioClient _dioClient = DioClient();
  final TextEditingController _textController = TextEditingController();
  bool _searchBoolean = false;
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
      drawer: const RxDrawer(),
      appBar: AppBar(
          title: !_searchBoolean
              ? const Text('SynapseRx')
              : TextField(
                  autofocus:
                      true, //Display the keyboard when TextField is displayed
                  cursorColor: Colors.black,
                  style: const TextStyle(
                    //color: Colors.white,
                    fontSize: 16,
                  ),
                  textInputAction: TextInputAction.search,
                  controller: _textController,
                  onChanged: (value) {
                    setState(() {
                      searchString = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.all(12.0),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(
                          width: 1.0,
                          color: Colors.white,
                          style: BorderStyle.none), // BorderSide
                    ),
                    hintText: "Enter patient's name to search",
                    hintStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  )),
          actions: !_searchBoolean
              ? [
                  IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _searchBoolean = true;
                        });
                      })
                ]
              : [
                  IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchBoolean = false;
                          _textController.clear();
                          searchString = '';
                        });
                      })
                ]),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Patient',
        child: const Icon(Icons.person_add),
        onPressed: () {
          navigateToAddAssociation();
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refresh();
        },
        child: Column(
          key: _key,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                builder: (context, AsyncSnapshot<List<Associations>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const Align(
                        alignment: Alignment.center,
                        child: Text(
                            'You dont have any patients in your list.\nClick the add button to add patients',
                            textAlign: TextAlign.center),
                      );
                    }
                    return ListView.builder(
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
                                              patientName: snapshot
                                                  .data![index].patientFullname,
                                            )),
                                  );
                                },
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.primaries[
                                      index % Colors.primaries.length],
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
                      // separatorBuilder: (BuildContext context, int index) {
                      //   return const Divider(
                      //     height: 1,
                      //     color: Colors.grey,
                      //   );
                      // },
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

  Future<void> _refresh() async {
    if (mounted) {
      _key = GlobalKey();
      setState(() {});
    }
    Future.value(null);
  }
}
