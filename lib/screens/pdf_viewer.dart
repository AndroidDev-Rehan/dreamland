import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class ViewPdfScreen extends StatefulWidget {
  const ViewPdfScreen(
      {super.key, required this.pdfUrlOrPath, required this.localFile});
  final String pdfUrlOrPath;
  final bool localFile;

  @override
  State<ViewPdfScreen> createState() => _ViewPdfScreenState();
}

class _ViewPdfScreenState extends State<ViewPdfScreen> {
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    PDF pdf = PDF(
      enableSwipe: true,
      swipeHorizontal: true,
      autoSpacing: false,
      pageFling: false,
      onError: (error) {
        debugPrint("something went wrong");
      },
      onPageError: (page, error) {},
      onPageChanged: (int? page, int? total) {},
    );

    return Scaffold(
      body: errorMessage == null
          ? (widget.localFile
              ? pdf.fromPath(widget.pdfUrlOrPath)
              : pdf.fromUrl(widget.pdfUrlOrPath))
          : Center(
              child: Text(
              'Something went wrong\n${errorMessage!}',
              textAlign: TextAlign.center,
            )),
    );
  }
}
