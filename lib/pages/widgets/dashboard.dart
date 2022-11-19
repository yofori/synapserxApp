import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:synapserx_prescriber/common/service.dart';
import 'package:synapserx_prescriber/pages/changepassword.dart';
import 'package:synapserx_prescriber/pages/login.dart';
import 'package:synapserx_prescriber/pages/prescriptions/createadhocpatient.dart';
import 'package:synapserx_prescriber/pages/prescriptions/getprescription.dart';
import 'package:synapserx_prescriber/pages/widgets/rxdrawer.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({Key? key}) : super(key: key);

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
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
          title: const Text('SynapseRx'),
        ),
        drawer: const RxDrawer(),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 15,
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
                          return const CircularProgressIndicator();
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
                          return const CircularProgressIndicator();
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
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              splashColor: const Color(0xFF3B4257),
                              //onTap: widget.onSelect,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CreateAdhocPxPage()));
                              },
                              child: Card(
                                  child: Container(
                                height: 80,
                                width: 80,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(5.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.create_new_folder_sharp),
                                      Text(
                                        'Create\nPrescription',
                                        textAlign: TextAlign.center,
                                      )
                                    ]),
                              )),
                            ),
                            InkWell(
                              splashColor: const Color(0xFF3B4257),
                              //onTap: widget.onSelect,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const GetPrescriptionPage()));
                              },
                              child: Card(
                                  child: Container(
                                height: 80,
                                width: 80,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(5.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.qr_code),
                                      Text(
                                        'Retrieve\nPrescription',
                                        textAlign: TextAlign.center,
                                      )
                                    ]),
                              )),
                            ),
                            InkWell(
                              splashColor: const Color(0xFF3B4257),
                              //onTap: widget.onSelect,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CreateAdhocPxPage()));
                              },
                              child: Card(
                                  child: Container(
                                height: 80,
                                width: 80,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(5.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.ac_unit),
                                      Text(
                                        'Request\nlabs',
                                        textAlign: TextAlign.center,
                                      )
                                    ]),
                              )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ]),
          ]),
        ));
  }

  void logout() async {
    //_dioClient.logoutUser();
    // implement signout here. Clear the secure storage and call logout api
    // const storage = FlutterSecureStorage();
    // await storage.deleteAll().whenComplete(() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
    // });
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Text('Logged out Successfully'),
        backgroundColor: Colors.green,
      ));
  }
}
