import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart' as c;
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/src/pdf/colors.dart';
import 'package:pdf/src/pdf/page_format.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'package:printing/printing.dart';

class JobFormPdf {
  final Document pdf = Document();
  Widget dreamLandLogo = FlutterLogo();
  final Border tableBorder = Border.all(width: 1, color: PdfColors.black);
  final BorderSide tableBorderSide =
      const BorderSide(width: 1, color: PdfColors.black);
  EdgeInsets singleRowPadding =
      const EdgeInsets.only(left: 4, right: 2, top: 3, bottom: 2);
  final double rowHeight = 18;
  final double headingFontSize = 7;
  final double signatureContentSize = 5;
  final int dataTableRows = 15;

  Future<bool> hasStoragePermission() async {
    bool success = false;
    if (await DeviceInfoPlugin()
            .androidInfo
            .then((value) => value.version.sdkInt) <
        33) {
      if ((await Permission.storage.request().isGranted)) {
        success = true;
      }
    } else {
      ///For sdk 33 or greater
      if (await Permission.manageExternalStorage.request().isGranted) {
        success = true;
      }
    }
    return success;
  }

  Future saveJobFormPdf() async {
    if (await hasStoragePermission()) {
      Uint8List uInt8list = await getJobFormPdf();
      c.debugPrint("saving file");
      await FileSaveHelper.saveFile(uInt8list, 'job_form.pdf');
    } else {
      print("permission not granted");
    }
  }

  Future<Uint8List> getJobFormPdf() async {
    dreamLandLogo = Image(
      MemoryImage(
        (await rootBundle.load('assets/images/dreamland_logo.jpeg')).buffer.asUint8List(),
      ),
    );

    pdf.addPage(Page(
      build: (Context context) => _buildJobFormPdfPage(),
      pageFormat: PdfPageFormat.a4,
      theme: ThemeData.withFont(
        base: await PdfGoogleFonts.openSansRegular(),
        bold: await PdfGoogleFonts.openSansBold(),
        icons: await PdfGoogleFonts.materialIcons(), // this line
      ),
      margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10
      ),
      // pageTheme: const PageTheme(
      //   margin: EdgeInsets.zero,
      // ),
    ));
    Uint8List uInt8list = await pdf.save();
    return uInt8list;
  }

  Widget _buildJobFormPdfPage() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _topArea(),
      SizedBox(height: 10),
      _getFormHeading(),
      _buildUpperFields(),
      SizedBox(height: 5),
      _buildItemsTable(),
      SizedBox(height: 5),
      _buildMaterialSection(),
      SizedBox(height: 5),
      _buildInstructionsWidget(),
      SizedBox(height: 10),
      _buildSignaturesSection(),
      SizedBox(height: 5),
      _buildThankYouText(),
    ]);
  }

  Widget _buildThankYouText() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        "Thank you for purchasing high quality floor coverings from us. We hope you will enjoy them for many years to come. ",
        style:
            TextStyle(fontSize: headingFontSize, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      )
    ]);
  }

  Widget _buildMiniHeading(String text,
      {int maxLines = 1, double? fontSize, bool capitalize = true}) {
    return Text(
      capitalize ? text.toUpperCase() : text,
      style: TextStyle(
          fontSize: fontSize ?? headingFontSize, fontWeight: FontWeight.bold),
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.clip : TextOverflow.visible,
    );
  }

  Widget _buildHorizontalHeadingValueRow(KeyValue keyValue,
      {bool bottomBorder = true,
      bool rightBorder = false,
      Widget? valueWidget}) {
    return Container(
        height: rowHeight,
        padding: singleRowPadding,
        decoration: BoxDecoration(
            border: Border(
          bottom: bottomBorder ? tableBorderSide : BorderSide.none,
          right: rightBorder ? tableBorderSide : BorderSide.none,
        )),
        child: Row(children: [
          _buildMiniHeading(keyValue.key),
          valueWidget ??
              Container(
                  margin:
                      EdgeInsets.only(left: keyValue.selected == null ? 5 : 15),
                  child: keyValue.selected == null
                      ? _buildTextValue(keyValue.value)
                      : _buildSelectionBox(selected: keyValue.selected!)),
        ]));
  }

  ///Fields on top of the form
  Widget _buildUpperFields() {
    Widget buildMiniHeadingForTopSec(KeyValue keyValue,
        {bool rightBorder = false}) {
      return Container(
          height: rowHeight + 5,
          padding: singleRowPadding,
          decoration: BoxDecoration(
              border: Border(
            right: rightBorder ? tableBorderSide : BorderSide.none,
          )),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMiniHeading(keyValue.key),
                _buildTextValue(
                  keyValue.value,
                ),
              ]));
    }

    Widget buildTopRow(
        KeyValue keyValue1, KeyValue keyValue2, KeyValue keyValue3) {
      return Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: tableBorderSide,
          )),
          child: Row(children: [
            Expanded(
                child: buildMiniHeadingForTopSec(keyValue1, rightBorder: true)),
            Expanded(
                child: buildMiniHeadingForTopSec(keyValue2, rightBorder: true)),
            Expanded(child: buildMiniHeadingForTopSec(keyValue3)),
          ]));
    }

    Widget buildLeftPortion() {
      return Container(
          decoration: BoxDecoration(
              border: Border(
            right: tableBorderSide.copyWith(width: tableBorderSide.width / 2),
          )),
          child: Column(children: [
            buildTopRow(KeyValue('Date Of Measure', ''),
                KeyValue('Order No', ''), KeyValue('Date Of Fitting', '')),
            _buildHorizontalHeadingValueRow(KeyValue('Name', '')),
            _buildHorizontalHeadingValueRow(KeyValue('Address', '')),
            _buildHorizontalHeadingValueRow(KeyValue('Address', '')),
            _buildHorizontalHeadingValueRow(KeyValue('POST CODE', '')),
            _buildHorizontalHeadingValueRow(
                KeyValue(
                  'TEL NO:',
                  '',
                ),
                bottomBorder: false),
          ]));
    }

    Widget buildRightPortion() {
      return Container(
          decoration: BoxDecoration(
              border: Border(
            left: tableBorderSide.copyWith(width: tableBorderSide.width / 2),
          )),
          child: Column(children: [
            buildTopRow(KeyValue('Job Ref. No', ''), KeyValue('Invoice No', ''),
                KeyValue('Completed By', '')),
            _buildHorizontalHeadingValueRow(
                KeyValue('Carpet Fitting', '', selected: false)),
            _buildHorizontalHeadingValueRow(
                KeyValue('Laminate Fitting', '', selected: false)),
            _buildHorizontalHeadingValueRow(
                KeyValue('Deliver Only', '', selected: false)),
            _buildHorizontalHeadingValueRow(KeyValue('', '')),
            _buildHorizontalHeadingValueRow(KeyValue('Other', ''),
                bottomBorder: false),
          ]));
    }

    return Container(
        decoration: BoxDecoration(
          border: tableBorder,
        ),
        child: Row(children: [
          Expanded(child: buildLeftPortion()),
          Expanded(child: buildRightPortion()),
        ]));
  }

  Widget _buildSelectionBox({bool selected = false}) {
    return selected ? Icon(const IconData(
        // mt.Icons.check_box.codePoint,
        0xe834), size: 10) : Icon(const IconData(
        // mt.Icons.check_box_outline_blank.codePoint,
        0xe835), size: 10);
  }

  Widget _getFormHeading() {
    return Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: PdfColors.black,
        ),
        child: Text('Order Form'.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: PdfColors.white)));
  }

  Widget _topArea() {
    Widget topInfoSection() {
      Widget buildSingleTopAreaRow(String text, {bool bold = false}) {
        return Text(text,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: 10,
            ));
      }

      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildSingleTopAreaRow('Name:..................'),
            buildSingleTopAreaRow('388 A Dickenson Road,'),
            buildSingleTopAreaRow('Longsight,'),
            buildSingleTopAreaRow('Manchester'),
            buildSingleTopAreaRow('M13 0WQ'),
            buildSingleTopAreaRow('Tel: 0161 256 4033'),
            buildSingleTopAreaRow('www.dreamlandflooringandfurniture.com',
                bold: true),
          ]);
    }

    return Row(children: [
      Expanded(child: dreamLandLogo),
      SizedBox(width: 30),
      Expanded(child: topInfoSection()),
    ]);
  }

  Widget _buildTextValue(String value) {
    return Text(value, style: const TextStyle(fontSize: 6));
  }

  Widget _buildValueDataContainer(
    String value, {
    bool rightBorder = true,
  }) {
    return Container(
        height: rowHeight,
        padding: singleRowPadding,
        decoration: BoxDecoration(
            border: Border(
          right: rightBorder ? tableBorderSide : BorderSide.none,
          // bottom: tableBorderSide,
        )),
        child: _buildTextValue(value));
  }

  Widget _buildTableHeadingContainer(String heading,
      {bool rightBorder = true,
      int maxLines = 1,
      double? fontSize,
      EdgeInsets? padding,
      bool capitalize = true}) {
    return Container(
        height: rowHeight,
        padding: padding ?? singleRowPadding,
        decoration: BoxDecoration(
            border: Border(
          right: rightBorder ? tableBorderSide : BorderSide.none,
          // bottom: tableBorderSide,
        )),
        child: _buildMiniHeading(heading,
            maxLines: maxLines, fontSize: fontSize, capitalize: capitalize));
  }

  Widget _buildItemsTable() {
    List<int> dataTableColumnFlexes = [4, 2, 5, 2, 2, 2, 2];

    Widget getTableHeadingRow() {
      return Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: tableBorderSide,
          )),
          child: Row(children: [
            Expanded(
                child:
                    _buildTableHeadingContainer('Location', rightBorder: false),
                flex: dataTableColumnFlexes[0]),
            Expanded(
                child: _buildTableHeadingContainer(
                  'Size',
                ),
                flex: dataTableColumnFlexes[1]),
            Expanded(
                child: _buildTableHeadingContainer(
                  'Description',
                ),
                flex: dataTableColumnFlexes[2]),
            Expanded(
                child: _buildTableHeadingContainer('Flooring Colour',
                    maxLines: 2, padding: singleRowPadding.copyWith(top: 1)),
                flex: dataTableColumnFlexes[3]),
            Expanded(
                child:
                    _buildTableHeadingContainer('Stock Location', maxLines: 2),
                flex: dataTableColumnFlexes[4]),
            Expanded(
                child: _buildTableHeadingContainer(
                  'Unit Price',
                ),
                flex: dataTableColumnFlexes[5]),
            Expanded(
                child:
                    _buildTableHeadingContainer('Amount', rightBorder: false),
                flex: dataTableColumnFlexes[6]),
          ]));
    }

    Widget getTableDataRow() {
      return Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: tableBorderSide,
          )),
          child: Row(children: [
            Expanded(
                child: _buildValueDataContainer(
                  'location',
                ),
                flex: dataTableColumnFlexes[0]),
            Expanded(
                child: _buildValueDataContainer(
                  '8 x 8',
                ),
                flex: dataTableColumnFlexes[1]),
            Expanded(
                child: _buildValueDataContainer(
                  'description',
                ),
                flex: dataTableColumnFlexes[2]),
            Expanded(
                child: _buildValueDataContainer(
                  'color',
                ),
                flex: dataTableColumnFlexes[3]),
            Expanded(
                child: _buildValueDataContainer(
                  'stock l',
                ),
                flex: dataTableColumnFlexes[4]),
            Expanded(
                child: _buildValueDataContainer(
                  '50',
                ),
                flex: dataTableColumnFlexes[5]),
            Expanded(
                child: _buildValueDataContainer(
                  '100',
                ),
                flex: 1),
            Expanded(
              child: _buildValueDataContainer('5000', rightBorder: false),
              flex: 1,
            ),
          ]));
    }

    List<Widget> children = [];

    children.add(getTableHeadingRow());
    children.addAll(List.generate(dataTableRows, (index) => getTableDataRow()));

    return Container(
        decoration: BoxDecoration(
          border: tableBorder,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: children));
  }

  Widget _buildMaterialSection() {
    List<int> materialTableColumnFlexes = [3, 2, 2, 1, 6, 2, 1, 3, 2, 1];

    Widget buildCCTypeRow(
        {required String materialType,
        required String headingUnderTotal,
        required String subtotalTypeHeading}) {
      return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: tableBorderSide,
            ),
          ),
          child: Row(children: [
            Expanded(
                child: _buildHorizontalHeadingValueRow(
                    KeyValue(materialType, ''),
                    bottomBorder: false,
                    rightBorder: true),
                flex: materialTableColumnFlexes[0]),
            Expanded(
                child: _buildValueDataContainer(''),
                flex: materialTableColumnFlexes[1]),
            Expanded(
                child: _buildValueDataContainer(''),
                flex: materialTableColumnFlexes[2]),
            Expanded(
                child: _buildValueDataContainer(''),
                flex: materialTableColumnFlexes[3]),
            Expanded(
                child: _buildHorizontalHeadingValueRow(
                    KeyValue(headingUnderTotal, ''),
                    bottomBorder: false,
                    rightBorder: true),
                flex: materialTableColumnFlexes[4]),
            Expanded(
                child: _buildValueDataContainer(''),
                flex: materialTableColumnFlexes[5]),
            Expanded(
                child: _buildValueDataContainer(''),
                flex: materialTableColumnFlexes[6]),
            Expanded(
                child: _buildHorizontalHeadingValueRow(
                    KeyValue(subtotalTypeHeading, ''),
                    bottomBorder: false,
                    rightBorder: true),
                flex: materialTableColumnFlexes[7]),
            Expanded(
                child: _buildValueDataContainer(''),
                flex: materialTableColumnFlexes[8]),
            Expanded(
                child: _buildValueDataContainer('', rightBorder: false),
                flex: materialTableColumnFlexes[9]),
          ]));
    }

    Widget buildTextCheckBoxRow(String text, bool value) {
      return Row(mainAxisSize: MainAxisSize.min, children: [
        _buildMiniHeading(
          text,
        ),
        SizedBox(width: 2),
        _buildSelectionBox(selected: value),
      ]);
    }

    Widget buildTrimmingWidget() {
      Widget yesNoBoxes = Row(mainAxisSize: MainAxisSize.min, children: [
        buildTextCheckBoxRow('YES', false),
        SizedBox(width: 4),
        buildTextCheckBoxRow('NO', false),
      ]);
      return _buildHorizontalHeadingValueRow(
          KeyValue('Door Trimming Required', ''),
          valueWidget: Container(
              margin: const EdgeInsets.only(left: 4), child: yesNoBoxes),
          bottomBorder: false,
          rightBorder: true);
    }

    Widget buildEPRow() {
      return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: tableBorderSide,
            ),
          ),
          child: Row(children: [
            Expanded(
                child: _buildHorizontalHeadingValueRow(KeyValue('EP', ''),
                    bottomBorder: false, rightBorder: true),
                flex: materialTableColumnFlexes[0]),
            Expanded(
                child: _buildValueDataContainer(''),
                flex: materialTableColumnFlexes[1]),
            Expanded(
                child: _buildValueDataContainer(''),
                flex: materialTableColumnFlexes[2]),
            Expanded(
                child: _buildValueDataContainer(''),
                flex: materialTableColumnFlexes[3]),
            Expanded(
                child: buildTrimmingWidget(),
                flex: materialTableColumnFlexes[4] +
                    materialTableColumnFlexes[5] +
                    materialTableColumnFlexes[6]),
            Expanded(
                child: _buildHorizontalHeadingValueRow(KeyValue('', ''),
                    bottomBorder: false, rightBorder: true),
                flex: materialTableColumnFlexes[7]),
            Expanded(
                child: _buildValueDataContainer(''),
                flex: materialTableColumnFlexes[8]),
            Expanded(
                child: _buildValueDataContainer('', rightBorder: false),
                flex: materialTableColumnFlexes[9]),
          ]));
    }

    Widget buildFloorConditionWidget() {
      Widget resultBoxes = Row(mainAxisSize: MainAxisSize.min, children: [
        buildTextCheckBoxRow('GOOD', false),
        SizedBox(width: 10),
        buildTextCheckBoxRow('WORK NEEDED', false),
      ]);
      return _buildHorizontalHeadingValueRow(KeyValue('Condition of floor', ''),
          valueWidget: Container(
            margin: const EdgeInsets.only(left: 8),
            child: resultBoxes,
          ),
          bottomBorder: false,
          rightBorder: true);
    }

    Widget buildDPRow() {
      return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: tableBorderSide,
            ),
          ),
          child: Row(children: [
            Expanded(
                child: _buildHorizontalHeadingValueRow(KeyValue('EP', ''),
                    bottomBorder: false, rightBorder: true),
                flex: materialTableColumnFlexes[0]),
            Expanded(
                child: _buildValueDataContainer(''),
                flex: materialTableColumnFlexes[1]),
            Expanded(
                child: _buildValueDataContainer(''),
                flex: materialTableColumnFlexes[2]),
            Expanded(
                child: _buildValueDataContainer(''),
                flex: materialTableColumnFlexes[3]),
            Expanded(
                child: buildFloorConditionWidget(),
                flex: materialTableColumnFlexes[4] +
                    materialTableColumnFlexes[5] +
                    materialTableColumnFlexes[6] +
                    materialTableColumnFlexes[7]),
            Expanded(
                child: _buildValueDataContainer(''),
                flex: materialTableColumnFlexes[8]),
            Expanded(
                child: _buildValueDataContainer('', rightBorder: false),
                flex: materialTableColumnFlexes[9]),
          ]));
    }

    Widget getMaterialTableHeadingRow() {
      return Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: tableBorderSide,
          )),
          child: Row(children: [
            Expanded(
                child: _buildTableHeadingContainer(
                  'Materials',
                ),
                flex: materialTableColumnFlexes[0]),
            Expanded(
                child: _buildTableHeadingContainer(
                  'QTY',
                ),
                flex: materialTableColumnFlexes[1]),
            Expanded(
                child: _buildTableHeadingContainer(
                  '€',
                ),
                flex: materialTableColumnFlexes[2]),
            Expanded(
                child: _buildTableHeadingContainer(
                  'p',
                  capitalize: false,
                ),
                flex: materialTableColumnFlexes[3]),
            Expanded(
                child: _buildTableHeadingContainer('Total'),
                flex: materialTableColumnFlexes[4]),
            Expanded(
                child: _buildTableHeadingContainer(
                  '€',
                ),
                flex: materialTableColumnFlexes[5]),
            Expanded(
                child: _buildTableHeadingContainer(
                  'p',
                ),
                flex: materialTableColumnFlexes[6]),
            Expanded(
                child: _buildTableHeadingContainer(
                  '',
                ),
                flex: materialTableColumnFlexes[7]),
            Expanded(
                child: _buildTableHeadingContainer(
                  '€',
                ),
                flex: materialTableColumnFlexes[8]),
            Expanded(
                child: _buildTableHeadingContainer('p', rightBorder: false),
                flex: materialTableColumnFlexes[9]),
          ]));
    }

    return Container(
      decoration: BoxDecoration(
        border: tableBorder,
      ),
      child: Column(children: [
        getMaterialTableHeadingRow(),
        buildCCTypeRow(
            materialType: 'CC',
            headingUnderTotal: 'Materials',
            subtotalTypeHeading: 'Sub Total'),
        buildCCTypeRow(
            materialType: 'CL',
            headingUnderTotal: 'Underlay',
            subtotalTypeHeading: 'DEPOSIT'),
        buildCCTypeRow(
            materialType: 'CV',
            headingUnderTotal: '',
            subtotalTypeHeading: 'Balance Due'),
        buildCCTypeRow(
            materialType: 'LV', headingUnderTotal: '', subtotalTypeHeading: ''),
        buildEPRow(),
        buildDPRow(),
      ]),
    );
  }

  Widget _buildInstructionsWidget() {
    return Container(
        decoration: BoxDecoration(
          border: tableBorder,
        ),
        padding: singleRowPadding,
        child: Column(children: [
          Text(
              "COLOURS AND PATTERNS OF ALL FLOOR COVERINGS MAY VARY SLIGHTLY. YOU MAY NOTICE COLOUR SHADING IN YOUR NEW CARPETS. THIS IS A NORMAL AND INHERENT CHARACTERISTIC OF CUT-PILE CARPETS. BEADING THAT IS SUPPLIED WITH THE LAMINATE FLOORING MAY VARY SLIGHTLY IN COLOUR AND IT IS HIGHLY UNLIKELY THAT THE BEADING AND LAMINATE FLOORING WILL BE AN EXACT MATCH (IN TERMS OF COLOUR AND TEXTURE). BY SIGNING THIS FORM, YOU ALSO AGREE THAT WHERE PAYMENT IS MADE BY CREDIT CARD, YOU WAIVE YOUR RIGHT TO MAKE A CLAIM FOR A REFUND (OR A CHARGEBACK).",
              style: TextStyle(
                  fontSize: headingFontSize, fontWeight: FontWeight.bold)),
          Text('FULL PAYMENT REQUIRED BEFORE FITTING',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              )),
        ]));
  }

  Widget _buildUpdatedInstructionsWidget() {
    return Container(
        decoration: BoxDecoration(
          border: tableBorder,
        ),
        padding: singleRowPadding,
        child: Column(children: [
          Text(
              "COLOURS AND PATTERNS OF ALL FLOOR COVERINGS MAY VARY SLIGHTLY. YOU MAY NOTICE COLOUR SHADING IN YOUR NEW CARPETS. THIS IS A NORMAL AND INHERENT CHARACTERISTIC OF CUT-PILE CARPETS. BEADING THAT IS SUPPLIED WITH THE LAMINATE FLOORING MAY VARY SLIGHTLY IN COLOUR AND IT IS HIGHLY UNLIKELY THAT THE BEADING AND LAMINATE FLOORING WILL BE AN EXACT MATCH (IN TERMS OF COLOUR AND TEXTURE). BY SIGNING THIS FORM, YOU ALSO AGREE THAT WHERE PAYMENT IS MADE BY CREDIT CARD, YOU WAIVE YOUR RIGHT TO MAKE A CLAIM FOR A REFUND (OR A CHARGEBACK).",
              style: TextStyle(
                  fontSize: headingFontSize, fontWeight: FontWeight.bold)),
          Text('FULL PAYMENT REQUIRED BEFORE FITTING',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              )),
        ]));
  }


  Widget _buildSignaturesSection() {
    String estimatedAcceptanceText =
        "I hereby accept the estimate outlined above and authorised work to be carried accordingly on the date stated above and I Agree To the Terms & Conditions Printed Overleaf.";
    String satisfactoryWorkAcceptanceText =
        "I hereby accept the above described work has been completed to my satisfaction. Woodenvalley Ltd will not accept responsibility for complaints after 7 days.";

    buildSignaturePortion(
        {required String heading,
        required String content,
        bool rightSection = false}) {
      final double innerHeadingSize = signatureContentSize + 1;
      final TextStyle innerHeadingStyle =
          TextStyle(fontSize: innerHeadingSize, fontWeight: FontWeight.bold);
      return Column(children: [
        _buildMiniHeading(heading, fontSize: 7),
        SizedBox(height: 3),
        Container(
          padding: singleRowPadding.copyWith(top: singleRowPadding.top + 2),
          decoration: BoxDecoration(
            border: Border(
              top: tableBorderSide,
              bottom: tableBorderSide,
              right: tableBorderSide,
              left: rightSection ? BorderSide.none : tableBorderSide,
            ),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              content,
              style: TextStyle(
                  fontSize: signatureContentSize, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(children: [
              Expanded(
                  flex: 4,
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      'Customer Signature',
                      style: innerHeadingStyle,
                    ),
                    SizedBox(width: 5),

                    ///TODO: Signatures Here
                  ])),
              Expanded(
                flex: 1,
                child: Row(children: [
                  Text(
                    'Date',
                    style: innerHeadingStyle,
                  ),
                ]),
              ),
            ])
          ]),
        ),
      ]);
    }

    return Row(children: [
      Expanded(
          child: buildSignaturePortion(
              heading: 'Acceptance of Estimate',
              content: estimatedAcceptanceText),
          flex: 1),
      Expanded(
          child: buildSignaturePortion(
              heading: 'Work Satisfactory Completed',
              content: satisfactoryWorkAcceptanceText,
              rightSection: true),
          flex: 1),
    ]);
  }
}

class FileSaveHelper {
  static Future<void> saveFile(Uint8List uint8list, String fileName) async {
    c.debugPrint("int save file");
    final String downloadPath = '/storage/emulated/0/Download/$fileName';
    c.debugPrint("download path: $downloadPath");
    final file = File(downloadPath);
    await file.writeAsBytes(uint8list);
    c.debugPrint("File saved");
  }
}

class KeyValue {
  final String key;
  final String value;
  final bool? selected;

  KeyValue(this.key, this.value, {this.selected});
}
