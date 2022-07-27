import 'package:flutter/material.dart';

class PharmaciesPage extends StatefulWidget {
  const PharmaciesPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<PharmaciesPage> createState() => _PharmaciesPageState();
}

class _PharmaciesPageState extends State<PharmaciesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container());
  }
}
