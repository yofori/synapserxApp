import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:synapserx_prescriber/common/service.dart';
import 'package:synapserx_prescriber/common/dio_client.dart';
import 'package:synapserx_prescriber/models/models.dart';
import 'package:synapserx_prescriber/pages/patients/addassociations.dart';
import 'package:synapserx_prescriber/pages/widgets/rxdrawer.dart';

import '../patients/patientprescriptions.dart';

// ignore: must_be_immutable
class PrescriptionsPage extends StatefulWidget {
  const PrescriptionsPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<PrescriptionsPage> createState() => _PrescriptionsPageState();
}

class _PrescriptionsPageState extends State<PrescriptionsPage> {
  GlobalKey _key = GlobalKey();
  final DioClient _dioClient = DioClient();
  final TextEditingController _textController = TextEditingController();
  bool _searchBoolean = false;
  late Future<List<Prescription>> prescriptions;
  String searchString = "";

  @override
  void initState() {
    super.initState();
    prescriptions = fetchprescriptions();
  }

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
                builder: (context, AsyncSnapshot<List<Prescription>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const Align(
                        alignment: Alignment.center,
                        child: Text(
                            'You haven\'t wrriten any prescriptions yet.\nClick the add button to add prescriptions',
                            textAlign: TextAlign.center),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ('${snapshot.data![index].pxSurname} ${snapshot.data![index].pxSurname}')
                                .toLowerCase()
                                .contains(searchString)
                            ? ListTile(
                                leading: const Icon(
                                    FontAwesomeIcons.prescriptionBottle),
                                onTap: () {},
                                title: Container(
                                  decoration: const BoxDecoration(
                                      //border: Border(
                                      //bottom: BorderSide(color: Colors.grey)),
                                      ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        '${snapshot.data?[index].pxFirstname} ${snapshot.data?[index].pxSurname}'),
                                  ),
                                ),
                                subtitle: Text(
                                    'Prescription\nWritten on ${DateFormat('dd-MM-yyyy @ hh:mm a').format(DateTime.parse(snapshot.data![index].createdAt.toString()))}'),
                                trailing: Text(
                                    textAlign: TextAlign.right,
                                    'Status:\n${snapshot.data?[index].status}'),
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
                        child: CircularProgressIndicator(),
                      ));
                },
                future: prescriptions,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Prescription>> fetchprescriptions() async {
    final response = await _dioClient.getPrescriberRx(GlobalData.prescriberid);
    return response;
  }

  void navigateToAddAssociation() async {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => const AddAssociationsPage()))
        .whenComplete(() {
      setState(() {
        prescriptions = fetchprescriptions();
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
