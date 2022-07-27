import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/pages/widgets/dashboard.dart';
import 'package:synapserx_prescriber/pages/widgets/my_prescriptions.dart';
import 'package:synapserx_prescriber/pages/widgets/my_patients.dart';
import 'package:synapserx_prescriber/pages/widgets/pharmacies.dart';
import 'package:synapserx_prescriber/pages/widgets/formularies.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List _screens = [
    {"screen": const HomeDashboardPage()},
    {
      "screen": const PatientsPage(
        title: 'My Patients',
      )
    },
    {"screen": const MyPrescriptionsPage(title: 'My Prescriptions')},
    {"screen": const FormularyPage(title: 'Formularies')},
    {"screen": const PharmaciesPage(title: 'Pharmacies')},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (const Text('SynapseRx')),
      ),
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
            icon: Icon(Icons.receipt),
            label: 'My Prescriptions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_rounded),
            label: 'Formularies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Pharmacies',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 65, 116, 209),
        onTap: _onItemTapped,
      ),
    );
  }
}
