import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:synapserx_prescriber/common/auth.dart';
import 'package:synapserx_prescriber/common/service.dart';
import 'package:synapserx_prescriber/pages/login.dart';
import 'package:synapserx_prescriber/pages/prescriptions/getprescription.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({Key? key}) : super(key: key);

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
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
          title: const Text('SynapseRx'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 27,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                          maxRadius: 25,
                          child: Text(
                            GlobalData.firstname[0] + GlobalData.surname[0],
                            style: const TextStyle(fontSize: 20),
                          )),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      GlobalData.fullname,
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      GlobalData.mdcregno,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person_add_alt),
                title: const Text('Invite Colleagues'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings ....'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: () async {
                  logout();
                },
              ),
              const Divider(),
              const SizedBox(height: 30),
              BarcodeWidget(
                barcode: Barcode.qrCode(), // Barcode type and settings
                data: GlobalData.prescriberid, // Content
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 10),
              const Center(
                child: SizedBox(
                  height: 40,
                  width: 120,
                  child: Text(
                    'Show this QR Code to Patients to add you as their prescriber',
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
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
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(0.0),
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'What would you like to do?',
                      textAlign: TextAlign.left,
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 10, 20, 2.5),
                      padding: const EdgeInsets.all(8),
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.newspaper,
                          size: 48,
                        ),
                        label: const Text('Create A New Prescription'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 2.5, 20, 2.5),
                      padding: const EdgeInsets.all(8),
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const GetPrescriptionPage()));
                        },
                        icon: const Icon(
                          Icons.download,
                          size: 48,
                        ),
                        label: const Text('Get an Existing Prescription'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 2.5, 20, 2.5),
                      padding: const EdgeInsets.all(8),
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit_notifications,
                          size: 48,
                        ),
                        label: const Text('Modify a Prescription'),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ]),
            ),
          ]),
        ));
  }

  void logout() async {
    _dioClient.logoutUser();
    // implement signout here. Clear the secure storage and call logout api
    const storage = FlutterSecureStorage();
    await storage.deleteAll().whenComplete(() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    });
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Text('Logged out Successfully'),
        backgroundColor: Colors.green,
      ));
  }
}
