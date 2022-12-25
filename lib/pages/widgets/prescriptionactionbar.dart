import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/common/dio_client.dart';
import 'package:synapserx_prescriber/common/pdf_api.dart';
import 'package:synapserx_prescriber/common/pdf_prescription_api.dart'
    as pdfgen;
import 'package:synapserx_prescriber/models/prescription.dart';
import 'package:synapserx_prescriber/pages/prescriptions/editprescriptions.dart';

class PrescriptionActionBar extends StatefulWidget {
  final Prescription prescription;
  final Function(int action) notifyParent;

  const PrescriptionActionBar(
      {super.key, required this.prescription, required this.notifyParent});
  @override
  PrescriptionActionBarState createState() => PrescriptionActionBarState();
}

class PrescriptionActionBarState extends State<PrescriptionActionBar> {
  final DioClient _dioClient = DioClient();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
            Widget>[
          Column(children: [
            IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Share Prescription',
                onPressed: () async {
                  final pdfFile = await pdfgen.PdfPrescriptionApi.generate(
                      widget.prescription);
                  // ignore: use_build_context_synchronously
                  PdfApi.sharePDF(context, pdfFile);
                  //PdfApi.openFile(pdfFile);
                }),
            const Text(
              'Share ',
              textAlign: TextAlign.center,
            ),
          ]),
          Column(children: [
            IconButton(
                icon: const Icon(Icons.preview),
                tooltip: 'Preview Prescription',
                onPressed: () async {
                  final pdfFile = await pdfgen.PdfPrescriptionApi.generate(
                      widget.prescription);
                  // ignore: use_build_context_synchronously
                  //PdfApi.sharePDF(context, pdfFile);
                  PdfApi.openFile(pdfFile);
                }),
            const Text(
              'Preview',
              textAlign: TextAlign.center,
            ),
          ]),
          Column(children: [
            IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit Prescription',
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditPrescriptionPage(
                                title: 'Edit Prescription',
                                prescriptionID:
                                    widget.prescription.sId.toString(),
                                isEditting: true,
                                patientID: widget.prescription.pxId.toString(),
                                patientName:
                                    '${widget.prescription.pxFirstname} ${widget.prescription.pxSurname}',
                                pxAge: widget.prescription.pxAge.toString(),
                                pxGender: widget.prescription.pxgender,
                                isRegistered: true,
                                pxDOB: '',
                                pxFirstname: '',
                                pxSurname: '',
                                isRenewal: false,
                              )));
                  widget.notifyParent(2);
                }),
            const Text(
              'Edit ',
              textAlign: TextAlign.center,
            ),
          ]),
          Column(children: [
            IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Delete Prescription',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        'Confirm Action',
                        textAlign: TextAlign.center,
                      ),
                      content: const Text(
                        'Are you sure you want to delete this prescription? This cannot be undone',
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel')),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: () async {
                              String prescriptionID =
                                  widget.prescription.sId.toString();
                              await _dioClient
                                  .deletePrescription(
                                      prescriptionID: prescriptionID)
                                  .whenComplete(() => {
                                        Navigator.pop(context),
                                        setState(() {
                                          widget.notifyParent(3);
                                          if (!mounted) {
                                            return;
                                          }
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: const Text(
                                                'Prescription deleted'),
                                            backgroundColor:
                                                Colors.green.shade300,
                                          ));
                                        })
                                      });
                            },
                            child: const Text(
                              'Delete',
                            ))
                      ],
                    ),
                  );
                }),
            const Text(
              'Delete ',
              textAlign: TextAlign.center,
            ),
          ]),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.copy),
                tooltip: 'Renew Prescription',
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditPrescriptionPage(
                                title: 'Renew Prescription',
                                prescriptionID:
                                    widget.prescription.sId.toString(),
                                isEditting: false,
                                patientID: widget.prescription.pxId.toString(),
                                patientName:
                                    '${widget.prescription.pxFirstname} ${widget.prescription.pxSurname}',
                                pxAge: widget.prescription.pxAge.toString(),
                                pxGender: widget.prescription.pxgender,
                                isRegistered:
                                    widget.prescription.isPxRegistered!,
                                pxDOB: widget.prescription.pxDOB!,
                                pxFirstname: widget.prescription.pxFirstname,
                                pxSurname: widget.prescription.pxSurname,
                                isRenewal: true,
                              )));
                  setState(() {
                    widget.notifyParent(4);
                    if (!mounted) {
                      return;
                    }
                  });
                },
                /*onPressed: () async {
                        var renewedRx = await _dioClient.renewPrescription(
                            prescriptionID: widget.prescription.sId.toString());
                        if (renewedRx != null) {
                          setState(() {
                            widget.notifyParent(4);
                            if (!mounted) {
                              return;
                            }
                          });
                          scaffoldMessengerKey.currentState!
                              .showSnackBar(const SnackBar(
                            content: Text('Prescription Sucessfully Renewed'),
                            backgroundColor: Colors.green,
                          ));
                        }
                      }*/
              ),
              const Text(
                'Renew',
                textAlign: TextAlign.center,
              ),
            ],
          )
        ]),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
