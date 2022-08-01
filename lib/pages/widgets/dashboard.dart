import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:synapserx_prescriber/pages/getprescription.dart';

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
  final storage = const FlutterSecureStorage();
  Future<String?> getData(String key) async {
    final String? value = await storage.read(key: key);
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
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
                      if (snapshot.hasError) return Text('${snapshot.error}');
                      if (snapshot.hasData) return Text('${snapshot.data}');
                      return const CircularProgressIndicator();
                    }),
                const SizedBox(
                  height: 3,
                ),
                FutureBuilder(
                    future: getData('mdcregno'),
                    builder: (context, AsyncSnapshot<String?> snapshot) {
                      if (snapshot.hasError) return Text('${snapshot.error}');
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
}
