import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synapserx_prescriber/common/dio_client.dart';
import 'package:synapserx_prescriber/main.dart';
import 'package:synapserx_prescriber/models/prescription.dart';

class DisplayPrescriptionPage extends StatefulWidget {
  const DisplayPrescriptionPage({Key? key, required this.prescriptionid})
      : super(key: key);
  final String prescriptionid;

  @override
  State<DisplayPrescriptionPage> createState() =>
      _DisplayPrescriptionPageState();
}

class _DisplayPrescriptionPageState extends State<DisplayPrescriptionPage> {
  final DioClient _dioClient = DioClient();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SynapseRx - Retrieved Prescription'),
        ),
        body: SingleChildScrollView(
            child: (FutureBuilder<Prescription?>(
                future: _dioClient.getPrescription(widget.prescriptionid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: const Center(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator(),
                          ),
                        ));
                  } else {
                    if (snapshot.hasError) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: const Center(
                          child: Text('No Prescription Found'),
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      Prescription? prescriptionInfo = snapshot.data;
                      if (prescriptionInfo != null) {
                        return Container(
                          margin: const EdgeInsets.all(15),
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.zero,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(children: [
                                const SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'Patient Details',
                                    textAlign: TextAlign.left,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                        textAlign: TextAlign.left,
                                        'Name: ${prescriptionInfo.pxFirstname} ${prescriptionInfo.pxSurname}')),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                      textAlign: TextAlign.left,
                                      'Age / Gender: ${prescriptionInfo.pxAge}yrs / ${toBeginningOfSentenceCase(prescriptionInfo.pxgender)} '),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                      textAlign: TextAlign.left,
                                      'Prescription Date: ${DateFormat('dd-MM-yyyy @ hh:mm a').format(DateTime.parse(prescriptionInfo.createdAt.toString()))}'),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                      textAlign: TextAlign.left,
                                      'Prescription Status: ${(prescriptionInfo.status)}'),
                                ),
                              ]),
                              Center(
                                  child: buildPrescription(prescriptionInfo)),
                              Center(child: buildFooter(prescriptionInfo)),
                            ],
                          ),
                        );
                      }
                    }
                    // ignore: avoid_unnecessary_containers
                    return Container(
                        child: const Text(
                            'No Prescription Found')); //const CircularProgressIndicator();
                  }
                }))));
  }

  static Widget buildFooter(Prescription prescription) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Divider(
            thickness: 1,
          ),
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
                alignment: Alignment.bottomLeft,
                width: width * .05,
                height: 15,
                child: const Text('#'))),
        DataColumn(
            label: Container(
                alignment: Alignment.bottomLeft,
                width: width * .40,
                height: 15,
                child: const Text('Name of Medication'))),
        DataColumn(
            label: Container(
                alignment: Alignment.bottomLeft,
                width: width * .15,
                height: 15,
                child: const Text('Dose'))),
        DataColumn(
            label: Container(
                alignment: Alignment.bottomCenter,
                width: width * .15,
                height: 15,
                child: const Text('Dosage'))),
        DataColumn(
            label: Container(
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
                    alignment: Alignment.topLeft, child: Text('${(i++)}'))),
                DataCell(Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                      '${item.drugName} ${item.directionOfUse == null || item.directionOfUse.toString().trim() == '' ? '' : '\n \n Sig: ${item.directionOfUse.toString()}'}'),
                )),
                DataCell(Container(
                    alignment: Alignment.topLeft,
                    child: Text('${item.dose}${item.dosageUnits}'))),
                DataCell(Container(
                    alignment: Alignment.topCenter,
                    child: Text('${item.dosageRegimen}'))),
                DataCell(Container(
                    alignment: Alignment.topLeft,
                    child: Text('${item.duration} ${item.durationUnits}'))),
              ]))
          .toList();
    }

    return SizedBox(
      width: width,
      child: DataTable(
          columnSpacing: 0,
          horizontalMargin: 0,
          columns: createColumns(),
          rows: createrows()),
    );
  }
}
