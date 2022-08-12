import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/common/service.dart';
import 'package:synapserx_prescriber/models/associations.dart';
import 'package:synapserx_prescriber/common/dio_client.dart';

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

  String getInitials(String patientFullname) => patientFullname.isNotEmpty
      ? patientFullname
          .trim()
          .split(RegExp(' +'))
          .map((s) => s[0])
          .take(2)
          .join()
      : '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
              decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: 'Enter patient name',
            suffixIcon: const Icon(Icons.search),
          )),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
              child: FutureBuilder<List<Associations>>(
                  future: _dioClient.getAssociations(accessToken),
                  builder: (context, snapshot) {
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
                    }
                    if (snapshot.hasData) {
                      List<Associations>? associations = snapshot.data;
                      if (associations != null) {
                        return Container(
                          child: ListView?.separated(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              // ignore: avoid_unnecessary_containers
                              return Container(
                                  child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  child: Text(getInitials(associations[index]
                                      .patientFullname
                                      .toString())),
                                ),
                                title: Text(
                                  '${associations[index].patientFullname.toString()} ',
                                  maxLines: 2,
                                ),
                              ));
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 4);
                            },
                          ),
                        );
                      }
                    }
                    return Container(child: const Text('No patients found'));
                  }))
        ],
      ),
    ));
  }
}
