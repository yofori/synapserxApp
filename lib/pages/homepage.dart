import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/pages/widgets/dashboard.dart';
import 'package:synapserx_prescriber/pages/widgets/mypatients.dart';
import 'package:synapserx_prescriber/pages/widgets/medicinespage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List _screens = [
    {"screen": const HomeDashboardPage()},
    {"screen": const PatientsPage(title: 'My Patients')},
    {"screen": const MyPrescriptionsPage(title: 'Medicines')},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: (const Text('SynapseRx')),
      ),*/
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
            icon: Icon(Icons.medical_services),
            label: 'Medicines',
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 65, 116, 209),
        onTap: _onItemTapped,
      ),
    );
  }
}
