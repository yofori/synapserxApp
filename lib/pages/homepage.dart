import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synapserx_prescriber/pages/widgets/dashboard.dart';
import 'package:synapserx_prescriber/pages/widgets/myorders.dart';
import 'package:synapserx_prescriber/pages/widgets/mypatients.dart';
import 'package:synapserx_prescriber/pages/widgets/medicinespage.dart';
import 'package:icofont_flutter/icofont_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.showIndex}) : super(key: key);
  final int showIndex;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.showIndex;
  }

  final List _screens = [
    {"screen": const HomeDashboardPage()},
    {"screen": const PatientsPage(title: 'My Patients')},
    {"screen": const PrescriptionsPage(title: 'My Prescriptions')},
    {"screen": const MyPrescriptionsPage(title: 'Medicines')},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        body: IndexedStack(children: [_screens[_selectedIndex]['screen']]),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'My Patients',
            ),
            BottomNavigationBarItem(
              icon: Icon(IcoFontIcons.prescription, size: 20),
              label: 'My Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medical_services),
              label: 'Medicines',
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color.fromARGB(255, 65, 116, 209),
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Please confirm'),
      content: const Text('Do you want to exit the app?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Yes'),
        ),
      ],
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    if (exitResult!) {
      Platform.isIOS //iOS will not allow for programatically exit the app so go to login page
          ? {true}
          : SystemNavigator.pop();
      return true;
    } else {
      return false;
    }
  }
}
