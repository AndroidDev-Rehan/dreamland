import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ViewImageSlider extends StatefulWidget {
  var img;
  ViewImageSlider({required this.img});
  @override
  State<ViewImageSlider> createState() => _ViewImageSliderState();
}

class _ViewImageSliderState extends State<ViewImageSlider> {

  var size = 0;
  bool isSharing = false;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      size = widget.img.length;
    });
  }
  File? _displayImage;


  Future<Null> saveAndShare() async {

    if (Platform.isAndroid) {
      var url = widget.img;
      var response = await http.get(Uri.parse(url));
      final documentDirectory = (await getExternalStorageDirectory())?.path;
      File imgFile = new File('$documentDirectory/Dreamland.png');
      imgFile.writeAsBytesSync(response.bodyBytes);

      setState(() {
        isSharing = false;

      });
      FlutterShare.shareFile(
         filePath: '$documentDirectory/Dreamland.png',
          title: 'Share');
    } else {
      // Share.share('Hey! Checkout the Share Files repo',
      //     subject: 'URL conversion + Share',
      //     sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image'),
          centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: isSharing ? Center(child:Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
        CircularProgressIndicator(color: Colors.brown,),
        SizedBox(height: 10,),
          Text('Downloading Image',style: TextStyle(fontSize: 20),)
      ],) ):
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: InteractiveViewer(
            boundaryMargin: EdgeInsets.all(100),
            minScale: 1.0,
            maxScale: 10,
            child:Image.network(widget.img)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          setState(() {
            isSharing = true;
          });
          saveAndShare();
        },
        backgroundColor: Colors.brown,
        child: Icon(Icons.share,color: Colors.white,),
      ),

    );
}
}
