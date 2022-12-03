import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/common/dio_client.dart';
import 'package:synapserx_prescriber/common/service.dart';
import 'package:synapserx_prescriber/main.dart';
import 'package:synapserx_prescriber/models/useraccounts.dart';

class UserAccountsPage extends StatefulWidget {
  const UserAccountsPage({Key? key}) : super(key: key);

  @override
  UserAccountsPageState createState() => UserAccountsPageState();
}

class UserAccountsPageState extends State<UserAccountsPage> {
  final DioClient _dioClient = DioClient();
  TextEditingController institutionName = TextEditingController();
  TextEditingController institutionAddress = TextEditingController();
  TextEditingController institutionTelephone = TextEditingController();
  TextEditingController institutionEmail = TextEditingController();
  late Future<List<UserAccount>> useraccounts;

  @override
  void initState() {
    super.initState();
    useraccounts = fetchUserAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Accounts'),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add Account',
          child: const Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10.0))),
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                              padding: const EdgeInsets.all(10),
                              child:
                                  const Text('Enter Health Facility Details')),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              controller: institutionName,
                              decoration: const InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  labelText: 'Health Facility Name',
                                  hintText:
                                      'Enter your Health Facility\'s Name here')),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              controller: institutionAddress,
                              decoration: const InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  labelText: 'Health Facility Address',
                                  hintText:
                                      'Enter your Health Facility\'s Address here')),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              controller: institutionEmail,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  labelText: 'Health Facility Email',
                                  hintText:
                                      'Enter your Health Facility\'s Email')),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              controller: institutionTelephone,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  labelText: 'Health Facility Telephone No',
                                  hintText:
                                      'Enter your Health Facility\'s Telephone No here')),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent),
                                  onPressed: (() {
                                    Navigator.pop(context);
                                  }),
                                  child: const Text('Cancel')),
                              const SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                  onPressed: (() {
                                    addUserAcount();
                                  }),
                                  child: const Text('Save')),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
        body: FutureBuilder(
          builder: (context, AsyncSnapshot<List<UserAccount>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Align(
                  alignment: Alignment.center,
                  child: Text(
                      'You have not setup any accounts.\nClick the add button to create an account',
                      textAlign: TextAlign.center),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: Card(
                        child: ListTile(
                          title: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Text(
                                      snapshot.data![index].institutionName)),
                              PopupMenuButton(
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry>[
                                        const PopupMenuItem(
                                          child: Text('Edit'),
                                        ),
                                        const PopupMenuItem(
                                          child: Text('Delete'),
                                        ),
                                        const PopupMenuItem(
                                          child: Text('Set as Default'),
                                        ),
                                      ])
                            ],
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(snapshot.data![index].institutionAddress
                                  .toString()),
                              Text(
                                  'Email: ${snapshot.data![index].institutionEmail}'),
                              Text(
                                  'Tel: ${snapshot.data![index].institutionTelephone}'),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }));
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
          future: useraccounts,
        ));
  }

  Future<List<UserAccount>> fetchUserAccounts() async {
    final response = await _dioClient.getUserAccounts(GlobalData.prescriberid);
    return response;
  }

  Future<void> addUserAcount() async {
    bool outcome;
    UserAccount useraccount = UserAccount(
        defaultAccount: false,
        institutionName: institutionName.text,
        institutionAddress: institutionAddress.text,
        institutionEmail: institutionEmail.text,
        institutionTelephone: institutionTelephone.text);

    outcome = await _dioClient.addUserAccount(useraccount: useraccount);
    if (outcome) {
      Navigator.pop(navigatorKey.currentContext!);
      setState(() {
        useraccounts = fetchUserAccounts();
      });
    }
  }
}
