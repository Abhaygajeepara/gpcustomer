import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfPreviewScreen extends StatelessWidget {
  final String? path;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  PdfPreviewScreen({this.path});

  @override
  Widget build(BuildContext context) {
  File file = File(path!);
    return SfPdfViewer.file(
      file,
      key: _pdfViewerKey,
    );
  }
}