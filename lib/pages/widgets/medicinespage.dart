import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/common/sqlite_service.dart';
import 'package:synapserx_prescriber/pages/widgets/drawerbutton.dart';
import 'package:synapserx_prescriber/pages/widgets/rxdrawer.dart';

class MyPrescriptionsPage extends StatefulWidget {
  const MyPrescriptionsPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyPrescriptionsPage> createState() => _MyPrescriptionsPageState();
}

class _MyPrescriptionsPageState extends State<MyPrescriptionsPage> {
  final GlobalKey<ScaffoldState> _skey = GlobalKey();
  List allMedicines = [];
  List filteredMedicines = [];
  bool _isLoading = true;
  bool _searchBoolean = false;
  final TextEditingController _controller = TextEditingController();

  Widget _searchTextField() {
    //add
    return TextField(
        autofocus: true, //Display the keyboard when TextField is displayed
        cursorColor: Colors.black,
        style: const TextStyle(
          //color: Colors.white,
          fontSize: 16,
        ),
        textInputAction: TextInputAction.search,
        controller: _controller,
        onChanged: (value) {
          filterSearch(value);
        },
        decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.all(12.0),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(
                  width: 1.0,
                  color: Colors.white,
                  style: BorderStyle.none), // BorderSide
            ),
            hintText: 'Enter drug name to search',
            hintStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            )));
  }

  @override
  void initState() {
    SqliteService.getMedicines().then((data) {
      setState(() {
        allMedicines = data;
        filteredMedicines = allMedicines = data;
        _isLoading = false;
      });
    });
    super.initState();
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
            drawer: const RxDrawer(),
            appBar: AppBar(
                leading: DrawerButton(key: _skey),
                title: !_searchBoolean
                    ? const Text('SynapseRx')
                    : _searchTextField(),
                actions: !_searchBoolean
                    ? [
                        IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              setState(() {
                                _searchBoolean = true;
                              });
                            })
                      ]
                    : [
                        IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchBoolean = false;
                                _controller.clear();
                                filteredMedicines = allMedicines;
                              });
                            })
                      ]),
            body: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      const SizedBox(
                        height: 10,
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
