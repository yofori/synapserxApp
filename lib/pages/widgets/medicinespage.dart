import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/common/sqlite_service.dart';

class MyPrescriptionsPage extends StatefulWidget {
  const MyPrescriptionsPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyPrescriptionsPage> createState() => _MyPrescriptionsPageState();
}

class _MyPrescriptionsPageState extends State<MyPrescriptionsPage> {
  List allMedicines = [];
  List filteredMedicines = [];
  bool _isLoading = true;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    SqliteService.getMedicines().then((data) {
      setState(() {
        allMedicines = data;
        filteredMedicines = allMedicines = data;
        _isLoading = false;
      });
      super.initState();
    });
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
            appBar: AppBar(
                title: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: TextField(
                    controller: _controller,
                    onChanged: (value) {
                      filterSearch(value);
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter drug name',
                      prefixIcon: const Icon(
                        Icons.search,
                      ),
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
            )),
            body: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredMedicines.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.orange[200],
                                margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: ListTile(
                                  title: Text(
                                      filteredMedicines[index].genericName),
                                  subtitle:
                                      Text(filteredMedicines[index].brandName),
                                ),
                              );
                            }),
                      ),
                    ],
                  )));
  }
}
