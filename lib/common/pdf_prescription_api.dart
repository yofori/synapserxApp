import 'dart:io';
import 'package:synapserx_prescriber/models/prescription.dart';
import 'package:synapserx_prescriber/common/pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfPrescriptionApi {
  static Future<File> generate(Prescription prescription) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(prescription),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(prescription),
        buildInvoice(prescription),
      ],
      footer: (context) => buildFooter(prescription),
    ));

    return PdfApi.saveDocument(name: prescription.sId.toString(), pdf: pdf);
  }

  static Widget buildHeader(Prescription prescription) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildPrescriberAddress(prescription),
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: prescription.sId.toString(),
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildPatientAddress(prescription),
            ],
          ),
        ],
      );

  static Widget buildPatientAddress(Prescription prescription) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nme: ${prescription.pxFirstname} ${prescription.pxSurname}',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Age: ${prescription.pxAge} Gender: ${prescription.pxgender}'),
        ],
      );

  static Widget buildPrescriberAddress(Prescription prescription) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(prescription.prescriberName.toString(),
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(prescription.prescriberMDCRegNo.toString()),
        ],
      );

  static Widget buildTitle(Prescription prescription) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRESCRIPTION',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Prescription prescription) {
    final headers = [
      'Name of Medication',
      'Dose',
      'Dosage Regimen',
      'Duration',
    ];
    final data = prescription.medications!.map((item) {
      return [
        item.drugName,
        '${item.dose} ${item.dosageUnits}',
        '${item.dosageRegimen}',
        '${item.duration} ${item.durationUnits}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
      },
    );
  }

  static Widget buildFooter(Prescription prescription) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'Name', value: prescription.prescriberName.toString()),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'MDC Reg No',
              value: prescription.prescriberMDCRegNo.toString()),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
