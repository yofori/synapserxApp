import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:synapserx_prescriber/common/service.dart';
import 'package:synapserx_prescriber/pages/changepassword.dart';
import 'package:synapserx_prescriber/pages/login.dart';

class RxDrawer extends StatelessWidget {
  const RxDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
              leading: const Icon(Icons.key),
              title: const Text('Change Password ....'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChangePasswordPage()));
              }),
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
    );
  }

  void logout() async {
    //_dioClient.logoutUser();
    // implement signout here. Clear the secure storage and call logout api
    // const storage = FlutterSecureStorage();
    // await storage.deleteAll().whenComplete(() {
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => const LoginPage()));
    // });
    // // ignore: use_build_context_synchronously
    // ScaffoldMessenger.of(context)
    //   ..removeCurrentSnackBar()
    //   ..showSnackBar(const SnackBar(
    //     content: Text('Logged out Successfully'),
    //     backgroundColor: Colors.green,
    //   ));
  }
}
