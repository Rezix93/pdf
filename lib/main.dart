import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // For uploading PDFs
import 'dart:typed_data';
import 'dart:convert'; // To decode bytes to string

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('PDF Uploader & Reader'),
          centerTitle: true,
        ),
        body: PdfReaderScreen(),
      ),
    );
  }
}

class PdfReaderScreen extends StatefulWidget {
  @override
  _PdfReaderScreenState createState() => _PdfReaderScreenState();
}

class _PdfReaderScreenState extends State<PdfReaderScreen> {
  Uint8List? uploadedPdf;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _uploadPdf,
            child: Text('Upload PDF'),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadPdf() async {
    // Use FilePicker to select a PDF file
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        uploadedPdf = result.files.first.bytes;
      });

      // Simulate PDF extraction
      _extractPdfContent(uploadedPdf!);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF Uploaded Successfully')));
    }
  }

  // Simulate extraction by manually searching for WO no. and Date/time
  void _extractPdfContent(Uint8List pdfBytes) {
    // Convert the bytes to a string (this is a simplification, you would need a real PDF parser for complex files)
    String pdfContent = utf8.decode(pdfBytes, allowMalformed: true);

    // Look for WO no.
    RegExp woNoExp = RegExp(r'WO no\. (\w+-\w+)');
    RegExp dateTimeExp = RegExp(r'Date/time (\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})');

    String? woNo = woNoExp.firstMatch(pdfContent)?.group(1);
    String? dateTime = dateTimeExp.firstMatch(pdfContent)?.group(1);

    print(pdfContent);
    print('WO no.: $woNo');
    print('Date/time: $dateTime');
  }
}
