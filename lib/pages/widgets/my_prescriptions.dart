import 'package:flutter/material.dart';

class MyPrescriptionsPage extends StatefulWidget {
  const MyPrescriptionsPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyPrescriptionsPage> createState() => _MyPrescriptionsPageState();
}

class _MyPrescriptionsPageState extends State<MyPrescriptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container());
  }
}
