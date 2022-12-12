import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synapserx_prescriber/common/service.dart';
import 'package:synapserx_prescriber/main.dart';
import 'package:synapserx_prescriber/pages/user/changepassword.dart';
import 'package:synapserx_prescriber/pages/user/useraccounts.dart';

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
            dense: true,
            leading: const Icon(Icons.person_add_alt),
            title: const Text('Invite Colleagues'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.manage_accounts),
            title: const Text('Accounts'),
            trailing: GlobalData.defaultAccount.isEmpty
                ? const Icon(
                    Icons.notifications_active,
                    color: Colors.red,
                  )
                : null,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserAccountsPage()));
            },
          ),
          ListTile(
              dense: true,
              leading: const Icon(Icons.key),
              title: const Text('Change Password'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChangePasswordPage()));
              }),
          const Divider(),
          ListTile(
            dense: true,
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () {
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

  void logout() {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (ctx) => AlertDialog(
              title: const Text('Please confirm'),
              content: const Text('Do you want to exit the app?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Platform
                            .isIOS //iOS will not allow for programatically exit the app so go to login page
                        ? {
                            Navigator.pushReplacementNamed(
                                navigatorKey.currentContext!, '/')
                          }
                        : SystemNavigator.pop();
                  },
                  child: const Text('Yes'),
                ),
              ],
            ));
  }
}
