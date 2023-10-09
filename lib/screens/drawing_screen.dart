import 'dart:typed_data';

import 'package:dreamland/controllers/job_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({Key? key, this.secondSignature = false}) : super(key: key);

  final bool secondSignature;

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final JobFormController jobFormController = Get.find();

  DrawingController drawingController = DrawingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text("Signature"),
        actions: [
          ElevatedButton(onPressed: () async{
            setState(() {
              loading=true;
            });
            if(widget.secondSignature){
              jobFormController.workSatisfactoryImageBytes.value = (await drawingController.getImageData())?.buffer.asUint8List() ?? Uint8List(0);
            }
            else{
              jobFormController.estimateAcceptanceImageBytes.value = (await drawingController.getImageData())?.buffer.asUint8List() ?? Uint8List(0);
            }
            Get.back();
          }, child: const Text("Save")),
          20.horizontalSpace,
        ],
      ),
      body:
      loading ?  const Center(
        child: CircularProgressIndicator(
            color: Colors.white
        ),
      ):
      DrawingBoard(
      controller: drawingController,
      background: Container(
        width: 1.sw,
        height: 200,
        color: Colors.white,
      ),
      // onPanStart: (f){},
      // onPanEnd: (f){},
      clipBehavior: Clip.none,
      showDefaultActions: true, /// 开启默认操作选项
      showDefaultTools: true,
        panAxis: PanAxis.aligned,
        // alignment: Alignment.bottomCenter,
        boardPanEnabled: false,
        // boardBoundaryMargin: EdgeInsets.only(top: 0.3.sh),

      ),
    );
  }
}
