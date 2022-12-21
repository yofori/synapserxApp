import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synapserx_prescriber/common/dio_client.dart';
import 'package:synapserx_prescriber/main.dart';
import 'package:synapserx_prescriber/models/prescription.dart';
import 'package:synapserx_prescriber/pages/widgets/prescriptionactionbar.dart';

class DisplayPrescriptionPage extends StatefulWidget {
  const DisplayPrescriptionPage(
      {Key? key, required this.prescriptionid, required this.prescription})
      : super(key: key);
  final String prescriptionid;
  final Prescription prescription;

  @override
  State<DisplayPrescriptionPage> createState() =>
      _DisplayPrescriptionPageState();
}

class _DisplayPrescriptionPageState extends State<DisplayPrescriptionPage> {
  final DioClient _dioClient = DioClient();
  late Prescription retrievedPrescription;

  @override
  void initState() {
    retrievedPrescription = widget.prescription;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
              height: 85, //set your height here
              width: double.maxFinite, //set your width here
              child: PrescriptionActionBar(
                  prescription: widget.prescription,
                  notifyParent: () async {
                    await refreshPrescription(widget.prescriptionid);
                    setState(() {});
                  })),
        ),
        appBar: AppBar(
          title: const Text('SynapseRx - Patient Prescription'),
        ),
        body: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.all(15),
                alignment: Alignment.topLeft,
                padding: EdgeInsets.zero,
                width: MediaQuery.of(context).size.width,
                child: Column(children: [
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Patient Details',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: Text(
                          textAlign: TextAlign.left,
                          'Name: ${retrievedPrescription.pxFirstname} ${retrievedPrescription.pxSurname}')),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                        textAlign: TextAlign.left,
                        'Age / Gender: ${retrievedPrescription.pxAge}yrs / ${toBeginningOfSentenceCase(retrievedPrescription.pxgender)} '),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                        textAlign: TextAlign.left,
                        'Prescription Date: ${DateFormat('dd-MM-yyyy @ hh:mm a').format(DateTime.parse(retrievedPrescription.createdAt.toString()))}'),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                        textAlign: TextAlign.left,
                        'Prescription Status: ${(retrievedPrescription.status)}'),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(child: buildPrescription(retrievedPrescription)),
                  Center(child: buildFooter(retrievedPrescription)),
                  const SizedBox(
                    height: 20,
                  ),
                ]))));
  }

  static Widget buildFooter(Prescription prescription) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const Divider(
          //   thickness: 1,
          // ),
          const SizedBox(
            height: 20,
          ),
          buildSimpleText(
              title: 'Name of Prescriber: ',
              value: prescription.prescriberName.toString()),
          const SizedBox(height: 5),
          buildSimpleText(
              title: 'MDC Reg No: ',
              value: prescription.prescriberMDCRegNo.toString()),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    const style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        const SizedBox(width: 20),
        Text(value),
      ],
    );
  }

  static Widget buildPrescription(Prescription prescription) {
    double width = MediaQuery.of(navigatorKey.currentContext!).size.width;
    int i = 1;
    List<DataColumn> createColumns() {
      return [
        DataColumn(
            label: Container(
                padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                alignment: Alignment.bottomLeft,
                width: width * .05,
                height: 15,
                child: const Text('#'))),
        DataColumn(
            label: Container(
                padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                alignment: Alignment.bottomLeft,
                width: width * .40,
                height: 15,
                child: const Text('Name of Medication'))),
        DataColumn(
            label: Container(
                padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                alignment: Alignment.bottomLeft,
                width: width * .15,
                height: 15,
                child: const Text('Dose'))),
        DataColumn(
            label: Container(
                padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                alignment: Alignment.bottomCenter,
                width: width * .15,
                height: 15,
                child: const Text('Dosage'))),
        DataColumn(
            label: Container(
                padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                alignment: Alignment.bottomLeft,
                width: width * .15,
                height: 15,
                child: const Text('Duration'))),
      ];
    }

    List<DataRow> createrows() {
      return prescription.medications!
          .map((item) => DataRow(cells: [
                DataCell(Container(
                    margin: const EdgeInsets.all(3),
                    alignment: Alignment.topLeft,
                    child: Text('${(i++)}'))),
                DataCell(Container(
                  margin: const EdgeInsets.all(3),
                  alignment: Alignment.topLeft,
                  child: Text(
                      '${item.drugName} ${item.directionOfUse == null || item.directionOfUse.toString().trim() == '' ? '' : '\n \n Sig: ${item.directionOfUse.toString()}'}'),
                )),
                DataCell(Container(
                    margin: const EdgeInsets.all(3),
                    alignment: Alignment.topLeft,
                    child: Text('${item.dose}${item.dosageUnits}'))),
                DataCell(Container(
                    margin: const EdgeInsets.all(3),
                    alignment: Alignment.topCenter,
                    child: Text('${item.dosageRegimen}'))),
                DataCell(Container(
                    margin: const EdgeInsets.all(3),
                    alignment: Alignment.topLeft,
                    child: Text('${item.duration} ${item.durationUnits}'))),
              ]))
          .toList();
    }

    return SizedBox(
      width: width,
      child: DataTable(
          showBottomBorder: true,
          headingRowHeight: 30,
          headingRowColor:
              MaterialStateColor.resolveWith((states) => Colors.grey),
          dataRowHeight: 75,
          border: TableBorder.all(width: 0.5),
          columnSpacing: 0,
          horizontalMargin: 0,
          columns: createColumns(),
          rows: createrows()),
    );
  }

  refreshPrescription(String prescriptionId) async {
    retrievedPrescription =
        await _dioClient.getPrescription(prescriptionId) as Prescription;
  }
}
