import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:synapserx_prescriber/common/service.dart';
import 'package:synapserx_prescriber/common/dio_client.dart';
import 'package:synapserx_prescriber/models/models.dart';
import 'package:synapserx_prescriber/pages/widgets/drawerbutton.dart';
import 'package:synapserx_prescriber/pages/widgets/prescriptionactionbar.dart';
import 'package:synapserx_prescriber/pages/widgets/rxdrawer.dart';

// ignore: must_be_immutable
class PrescriptionsPage extends StatefulWidget {
  const PrescriptionsPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<PrescriptionsPage> createState() => _PrescriptionsPageState();
}

class _PrescriptionsPageState extends State<PrescriptionsPage> {
  GlobalKey _key = GlobalKey();
  final GlobalKey<ScaffoldState> _skey = GlobalKey();
  final DioClient _dioClient = DioClient();
  final TextEditingController _textController = TextEditingController();
  bool _searchBoolean = false;
  late Future<List<Prescription>> prescriptions;
  String searchString = "";
  int selected = -1; //attention

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
          leading: DrawerButton(key: _skey),
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
                            'You haven\'t written any orders yet.\nClick the add button to add orders',
                            textAlign: TextAlign.center),
                      );
                    }
                    return ListView.builder(
                      key: Key('builder ${selected.toString()}'),
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ('${snapshot.data![index].pxSurname} ${snapshot.data![index].pxSurname}')
                                .toLowerCase()
                                .contains(searchString)
                            ? ExpansionTile(
                                textColor:
                                    const Color.fromARGB(255, 2, 64, 116),
                                iconColor:
                                    const Color.fromARGB(255, 2, 64, 116),
                                backgroundColor:
                                    const Color.fromARGB(255, 243, 236, 224),
                                initiallyExpanded: index == selected,
                                onExpansionChanged: (newState) {
                                  if (newState) {
                                    setState(() {
                                      selected = index;
                                    });
                                  } else {
                                    setState(() {
                                      selected = -1;
                                    });
                                  }
                                },
                                leading: const Icon(
                                    FontAwesomeIcons.prescriptionBottle),
                                //onTap: () {},
                                title: Container(
                                  decoration: const BoxDecoration(
                                      //border: Border(
                                      //bottom: BorderSide(color: Colors.grey)),
                                      ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${snapshot.data?[index].pxFirstname} ${snapshot.data?[index].pxSurname}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                    'Prescription written on \n${DateFormat('dd-MM-yyyy @ hh:mm a').format(DateTime.parse(snapshot.data![index].createdAt.toString()))}'),
                                trailing: Text(
                                    textAlign: TextAlign.right,
                                    'Status:\n${snapshot.data?[index].status}'),
                                children: [
                                    //_Product_ExpandAble_List_Builder(index),
                                    medicationsList(
                                        snapshot.data![index].medications!),
                                    //prescriptionactionbar(snapshot.data![index])
                                    PrescriptionActionBar(
                                      prescription: snapshot.data![index],
                                      notifyParent: _refresh,
                                    )
                                  ])
                            : Container();
                      },
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

  Future<void> _refresh() async {
    if (mounted) {
      _key = GlobalKey();
      setState(() {
        prescriptions = fetchprescriptions();
      });
    }
    Future.value(null);
  }

  medicationsList(List<Medications> medication) {
    return ListView.builder(
        itemCount: medication.length,
        shrinkWrap: true,
        itemBuilder: (context, i) => ListTile(
            leading: CircleAvatar(
              child: Text((i + 1).toString()),
            ),
            title: Text(medication[i].drugName!.toUpperCase()),
            subtitle: Text('${medication[i].dose} '
                '${medication[i].dosageUnits} '
                '${medication[i].dosageRegimen} x '
                '${medication[i].duration} ${medication[i].durationUnits}')));
  }
}
