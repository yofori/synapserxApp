import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:share_plus/share_plus.dart';

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    log(url);
    await OpenFile.open(url);
  }

  static Future sharePDF(BuildContext context, File file) async {
    final box = context.findRenderObject() as RenderBox;
    await Share.shareFiles([(file.path)],
        subject: 'Your Prescription',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
