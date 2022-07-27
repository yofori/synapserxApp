import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/pages/login.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'SynapseRX Prescriber';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: LoginPage(),
    );
  }
}
