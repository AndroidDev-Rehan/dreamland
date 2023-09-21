import 'dart:io';

import 'package:flutter/material.dart';

class PhotoViewScreen extends StatelessWidget {

  final String? imageLink;
  final String? filePath;
  PhotoViewScreen({Key? key, this.imageLink, this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InteractiveViewer(
        scaleEnabled: true,
          panEnabled: true,
          child: Image(
          image:
          (filePath!=null && filePath!.isNotEmpty ) ?
          FileImage(File(filePath!)) as ImageProvider
              :
          NetworkImage(imageLink!)
      )),
    );
  }
}
