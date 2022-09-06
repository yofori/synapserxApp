import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/common/sqlite_service.dart';
import 'package:synapserx_prescriber/models/formulary.dart';

class FormularyPage extends StatefulWidget {
  const FormularyPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<FormularyPage> createState() => _FormularyPageState();
}

class _FormularyPageState extends State<FormularyPage> {
  // All items
  List<Medicines> _medicines = [];
  bool _isLoading = true;

  void _refreshMedicinesList() async {
    final data = await SqliteService.getMedicines();
    setState(() {
      _medicines = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    SqliteService.initiateDb().whenComplete(() async {
      _refreshMedicinesList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _medicines.length,
                itemBuilder: (BuildContext context, int index) => Card(
                  color: Colors.orange[200],
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: ListTile(
                    title: Text(_medicines[index].genericName),
                    //subtitle: Text(_medicines[index].brandName),
                  ),
                ),
              ));
  }
}
