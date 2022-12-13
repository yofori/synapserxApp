import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:synapserx_prescriber/common/dio_client.dart';
import 'package:synapserx_prescriber/common/service.dart';
import 'package:synapserx_prescriber/models/models.dart';
import 'package:synapserx_prescriber/pages/prescriptions/createadhocpatient.dart';
import 'package:synapserx_prescriber/pages/prescriptions/getprescription.dart';
import 'package:synapserx_prescriber/pages/user/useraccounts.dart';
import 'package:synapserx_prescriber/pages/widgets/drawerbutton.dart';
import 'package:synapserx_prescriber/pages/widgets/rxcustombutton.dart';
import 'package:synapserx_prescriber/pages/widgets/rxdrawer.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({Key? key}) : super(key: key);

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  final GlobalKey<ScaffoldState> _skey = GlobalKey();
  final DioClient _dioClient = DioClient();
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  // get stored full name of prescriber from secure storage
  Future<String?> getData(String key) async {
    const storage = FlutterSecureStorage();
    final String? value = await storage.read(key: key);
    return value;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: DrawerButton(
            key: _skey,
          ),
          title: const Text('SynapseRx'),
        ),
        drawer: const RxDrawer(),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 5,
            ),
            Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                decoration: (BoxDecoration(
                  color: Colors.blue[50],
                  border: Border.all(
                    color: Colors.blue,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                )),
                child: Column(
                  children: [
                    Text(
                      greeting(),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FutureBuilder(
                        future: getData('fullname'),
                        builder: (context, AsyncSnapshot<String?> snapshot) {
                          if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          if (snapshot.hasData) return Text('${snapshot.data}');
                          return const Text('');
                        }),
                    const SizedBox(
                      height: 3,
                    ),
                    FutureBuilder(
                        future: getData('mdcregno'),
                        builder: (context, AsyncSnapshot<String?> snapshot) {
                          if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          if (snapshot.hasData) return Text('${snapshot.data}');
                          return const Text('');
                        })
                  ],
                )),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'What would you like to do?',
                    //textAlign: TextAlign.left,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RxButton(
                                icon: FontAwesomeIcons.filePrescription,
                                title: 'New\nPrescription',
                                onTap: () {
                                  GlobalData.defaultAccount.isEmpty
                                      ? Future.delayed(
                                          const Duration(seconds: 0),
                                          () => showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                      actions: [
                                                        TextButton(
                                                            onPressed: (() {
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const UserAccountsPage()));
                                                            }),
                                                            child: const Text(
                                                                'Setup Account')),
                                                        TextButton(
                                                            onPressed: (() {
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                            child: const Text(
                                                                'Cancel'))
                                                      ],
                                                      title: const Text(
                                                        'Account Setup Required',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      content: const Text(
                                                        'You need to setup at least one Institution Account before you can start prescribing',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ))))
                                      : showModalBottomSheet(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(
                                                          10.0))),
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Container(
                                                      alignment: Alignment
                                                          .center,
                                                      width: double.infinity,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          border: Border.all(
                                                              color: Colors
                                                                  .green),
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10.0),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10.0))),
                                                      child: const Text(
                                                        'Choose Patient Type',
                                                        textScaleFactor: 1,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: InkWell(
                                                      splashColor: const Color(
                                                          0xFF3B4257),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const CreateAdhocPxPage()));
                                                      },
                                                      child: Card(
                                                        elevation: 8,
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          height: 60,
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              const Icon(
                                                                Entypo.user,
                                                                size: 40,
                                                              ),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: const [
                                                                  Text(
                                                                      'Adhoc Patient',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  Text(
                                                                    'Choose this option for patients \nwho are not registered on SynapseRx',
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: InkWell(
                                                      splashColor: const Color(
                                                          0xFF3B4257),
                                                      onTap: () {},
                                                      child: Card(
                                                        elevation: 8,
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          height: 70,
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              const Icon(
                                                                Entypo.users,
                                                                size: 40,
                                                              ),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: const [
                                                                  Text(
                                                                      'Registered Patients',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  Text(
                                                                    'Choose this option for patients who are \nregistered on SynapseRx.You can select\nfrom your list or add them via their QR Code',
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                }),
                            RxButton(
                                icon: MdiIcons.qrcodeScan,
                                title: 'Retrieve\nPrescription',
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const GetPrescriptionPage()));
                                }),
                            RxButton(
                                icon: CupertinoIcons.lab_flask,
                                title: 'Request\nlabs',
                                onTap: () {
                                  Future.delayed(
                                    const Duration(seconds: 0),
                                    () => showDialog(
                                      context: context,
                                      builder: (context) => const AlertDialog(
                                        title: Text('Future Feature'),
                                        content: Text(
                                            'This feature will be available in a future release'),
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Card(
                      child: ExpansionTile(
                          title: const Text('Recent Activity'),
                          children: [
                            FutureBuilder<List<Prescription>>(
                                future: _dioClient
                                    .getPrescriberRx(GlobalData.prescriberid),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Prescription>>
                                        snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    // If we got an error
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                          '${snapshot.error} occured',
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      );

                                      // if we got our data
                                    } else if (snapshot.hasData) {
                                      // Extracting data from snapshot object
                                      final data = snapshot.data;
                                      return SizedBox(
                                          height: 180,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: data!.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return ListTile(
                                                leading: const Icon(
                                                    FontAwesomeIcons
                                                        .filePrescription),
                                                title: Text(
                                                    '${data[index].pxFirstname} ${data[index].pxSurname}'),
                                                subtitle: Text(
                                                    'Prescription written on ${data[index].createdAt}'),
                                              );
                                            },
                                          ));
                                    }
                                  }
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                })
                          ]),
                    ),
                  ),
                ]),
          ]),
        ));
  }
}
