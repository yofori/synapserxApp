import 'package:flutter/material.dart';

class FormularyPage extends StatefulWidget {
  const FormularyPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<FormularyPage> createState() => _FormularyPageState();
}

class _FormularyPageState extends State<FormularyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container());
  }
}
