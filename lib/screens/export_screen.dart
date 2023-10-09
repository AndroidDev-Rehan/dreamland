import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dreamland/Model/JobModel.dart';
// import 'package:native_pdf_view/native_pdf_view.dart' as nv;
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class ExportDataScreen extends StatefulWidget {
  const ExportDataScreen({Key? key}) : super(key: key);

  @override
  State<ExportDataScreen> createState() => _ExportDataScreenState();
}

class _ExportDataScreenState extends State<ExportDataScreen> {
  TextEditingController startDateController = new TextEditingController();
  TextEditingController endDateController = new TextEditingController();

  final pw.Document pdf = pw.Document();

  bool loading = false;

  String? pdfPath;

  // nv.PdfController? pdfController;

  List<JobModel>? jobsList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.brown,
        title: const Text('Export Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: startDateController,
              readOnly: true,
              onTap: () {
                _pickDateDialog('m');
              },
              decoration: InputDecoration(
                  labelText: 'Star Date',
                  labelStyle: const TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1.5, color: Colors.brown),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1.5, color: Colors.brown),
                    borderRadius: BorderRadius.circular(15),
                  )),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: endDateController,
              readOnly: true,
              onTap: () {
                _pickDateDialog('f');
              },
              decoration: InputDecoration(
                  labelText: 'End Date',
                  labelStyle: const TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1.5, color: Colors.brown),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1.5, color: Colors.brown),
                    borderRadius: BorderRadius.circular(15),
                  )),
            ),
            SizedBox(
              height: pdfPath == null ? 50 : 0,
            ),
            (!loading)
                ? (pdfPath == null
                    ? ElevatedButton(
                        onPressed: () async {
                          await _exportPdf();
                        },
                        child: const Text("Export Data"))
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text("PDF is saved in Directory : $pdfPath"),
                      ))
                : const SizedBox(
                    height: 50,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
            if (pdfPath != null)
              Expanded(
                  child:
                      Container(color: Colors.blue, child: pdfView(pdfPath!))),
            if (pdfPath != null)
              ElevatedButton(
                  onPressed: () async {
                    Share.shareXFiles([
                      XFile(pdfPath!),
                    ], text: 'Dreamland PDF');
                  },
                  child: const Text("Share PDF")),
          ],
        ),
      ),
    );
  }

  void _pickDateDialog(type) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(2022),
            //what will be the previous supported year in picker
            lastDate: DateTime(
                2025)) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        var inputFormat = DateFormat('dd-MM-yyyy');

        //for rebuilding the ui
        if (type == 'm') {
          startDateController.text = inputFormat.format(pickedDate);
//          _selectedMeasurement = pickedDate;
        } else if (type == 'f') {
          endDateController.text = inputFormat.format(pickedDate);
//          _selectedFitting = pickedDate;
        }
      });
    });
  }

  Future<void> fillJobsList() async {

    if (jobsList != null) {
      return;
    } else {
      jobsList = [];
    }

    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('addjob');
    QuerySnapshot querySnapshot =
        await collectionRef.orderBy("createdAt", descending: true).get();

    for (var a in querySnapshot.docs) {
      jobsList!.add(JobModel(
        id: a['id'],
        name: a['author'] ?? ' ',
        number: a['bar'] ?? ' ',
        customNote: a['customn'] ?? ' ',
        jobTitle: a['jobtitle'] ?? ' ',
        employee: a['emplo'] ?? ' ',
        address: a['des'] ?? ' ',
        postCode: a['title'] ?? ' ',
        status: a['status'] ?? ' ',
        user: a['user'] ?? ' ',
        product: a['product'] ?? ' ',
        quatity: a['quantity'] ?? ' ',
        dateBooking: a['descri'] ?? ' ',
        dateFitting: a['datef'] ?? ' ',
        imgOne: a['imageURL'] ?? ' ',
        imgTwo: a['imageURL2'] ?? ' ',
        imgThree: a['imageURL3'] ?? ' ',
        billUrl: a['billURL'] ?? ' ',
        number2: a['phone2'] ?? ' ',
      ));
    }

  }

  Future<pw.Widget> _buildTopImages(JobModel jobModel) async {
    // print("building images");
    final billImage = (jobModel.billUrl != null && jobModel.billUrl != "")
        ? await networkImage(jobModel.billUrl)
        : null;
    return pw.Image(
      billImage!,
    );
  }

  Future<void> _addJobPageToPdf(int i) async {
    pw.Widget imagesRow = await _buildTopImages(jobsList![i]);

    // print("building images completed");
    // print("adding pages in pdf");

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(children: [
            pw.Expanded(
                child:
                    pw.Align(alignment: pw.Alignment.center, child: imagesRow)),
            pw.SizedBox(height: 20),
            _buildPdfPageDetails(jobsList![i])
          ]); // Center
        }));
  }

  pw.Widget _buildPdfPageDetails(JobModel jobModel) {
    return pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
      _buildSinglePdfDetailRow("Job Title", jobModel.jobTitle),
      _buildSinglePdfDetailRow("Employer Title", jobModel.employee),
      _buildSinglePdfDetailRow("Name", jobModel.name),
      _buildSinglePdfDetailRow("Address", jobModel.address),
      _buildSinglePdfDetailRow("Post Code", jobModel.postCode),
      _buildSinglePdfDetailRow("Phone No", jobModel.number),
      _buildSinglePdfDetailRow("Phone No 2", jobModel.number2),
      _buildSinglePdfDetailRow("Date Measurement", jobModel.dateBooking),
      _buildSinglePdfDetailRow("Date Fitting", jobModel.dateFitting),
      _buildSinglePdfDetailRow("Custom Note", jobModel.customNote),
      _buildSinglePdfDetailRow("Current Job Status", jobModel.status),
    ]);
  }

  pw.Widget _buildSinglePdfDetailRow(String title, String detail) {
    return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 5),
        child: pw.Row(
            // mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Expanded(
                  // flex: 1,
                  child: pw.Center(
                      child: pw.Text("$title: ",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 12)))),
              // pw.SizedBox(width: 20),
              pw.Expanded(
                // flex: 4,
                child: pw.Center(
                    child: pw.Text(detail,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal, fontSize: 12))),
              ),
              // pw.Divider(height: 5)
            ]));
  }

  _exportPdf() async {
    if (startDateController.text == "") {
      Fluttertoast.showToast(msg: "Select Starting Date");
      return;
    } else if (endDateController.text == "") {
      Fluttertoast.showToast(msg: "Select Ending Date");
      return;
    }

    bool success = false;

    if (await DeviceInfoPlugin().androidInfo.then((value) => value.version.sdkInt) < 33){
      if ((await Permission.storage.request().isGranted)) {
        success = true;
      }
    }
    else {
      ///For sdk 33 or greater
      if(await Permission.manageExternalStorage.request().isGranted){
        success = true;
      }
    }


    if (!success) {
      Fluttertoast.showToast(msg: "Permission not granted");
      return;
    }

    setState(() {
      loading = true;
    });

    await fillJobsList();

    for (int i = 0; i < jobsList!.length; i++) {
      if ((DateFormat("dd-MM-yyyy").parse(jobsList![i].dateBooking).isAfter(
              DateFormat("dd-MM-yyyy").parse(startDateController.text))) &&
          DateFormat("dd-MM-yyyy").parse(jobsList![i].dateBooking).isBefore(
              DateFormat("dd-MM-yyyy").parse(endDateController.text))) {
        await _addJobPageToPdf(i);
      } else {
      }
    }

    // pdf.document.

    final Directory? output = await getExternalStorageDirectory();
    final File file = File("${output!.path}/dreamland_jobs_data.pdf");
    await file.writeAsBytes(await pdf.save());

    Fluttertoast.showToast(
        msg: "PDF saved successfully in directory: ${file.path}",
        toastLength: Toast.LENGTH_LONG);

    // pdfController = nv.PdfController(
    //   document: nv.PdfDocument.openFile(file.path),
    // );

    setState(() {
      pdfPath = file.path;
      loading = false;
    });
  }

  Widget pdfView(String pdfPath) {
    return PDF(
      enableSwipe: true,
      swipeHorizontal: true,
      autoSpacing: false,
      pageFling: false,
      onError: (error) {
      },
      onPageError: (page, error) {
      },
      onPageChanged: (int? page, int? total) {
      },
    ).fromPath(pdfPath);
  }

// Widget pdfView() => nv.PdfView(
  //   controller: pdfController!,
  //   scrollDirection: Axis.vertical,
  //   pageLoader: const SizedBox(
  //       height: 20,
  //       child: Center(child: CircularProgressIndicator())),
  // );
}
