import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/common/sqlite_service.dart';

typedef DrugCodeCallback(code);

class MedicinesList extends StatefulWidget {
  const MedicinesList({Key? key, required this.onTap}) : super(key: key);
  final DrugCodeCallback onTap;

  @override
  State<MedicinesList> createState() => _MedicineListState();
}

class _MedicineListState extends State<MedicinesList> {
  List allMedicines = [];
  List filteredMedicines = [];
  bool _isLoading = true;
  final TextEditingController _controller = TextEditingController();

  @override
  // ignore: must_call_super
  void initState() {
    SqliteService.getMedicines().then((data) {
      setState(() {
        allMedicines = data;
        filteredMedicines = allMedicines = data;
        _isLoading = false;
      });
      //super.initState();
    });
  }

  void _handleTap(String drugCode, drugName, drugGenericName) {
    widget.onTap(
        '{"drugCode":"$drugCode","drugName":"$drugName","drugGenericName":"$drugGenericName"}');
  }

  void filterSearch(String query) async {
    _isLoading = true;
    SqliteService.searchMedicines(query.toLowerCase()).then((data) {
      setState(() {
        filteredMedicines = data;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(title: const Text('Select Medicine')),
          body: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          controller: _controller,
                          onChanged: (value) {
                            filterSearch(value);
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Enter drug name',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _controller.clear();
                                    filteredMedicines = allMedicines;
                                  });
                                }),
                          )),
                    ),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredMedicines.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.orange[200],
                              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: ListTile(
                                onTap: (() {
                                  setState(() {
                                    _handleTap(
                                        filteredMedicines[index].code,
                                        filteredMedicines[index].brandName,
                                        filteredMedicines[index].genericName);
                                  });
                                }),
                                title: Text(filteredMedicines[index].brandName),
                                subtitle:
                                    Text(filteredMedicines[index].genericName),
                              ),
                            );
                          }),
                    ),
                  ],
                )),
    );
  }
}
