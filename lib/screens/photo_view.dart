import 'dart:io';

import 'package:dreamland/controllers/viewphoto_controller.dart';
import 'package:dreamland/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotoViewScreen extends StatelessWidget {

  final String? imageLink;
  final String? filePath;
  PhotoViewScreen({Key? key, this.imageLink, this.filePath}) : super(key: key);

  final ViewPhotoController controller = ViewPhotoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(title: const Text('Image'),
      //   centerTitle: true,
      //   backgroundColor: Colors.brown,
      // ),
      body: InteractiveViewer(
        scaleEnabled: true,
          panEnabled: true,
          child:  (filePath!=null && filePath!.isNotEmpty ) ?
          Image.file(File(filePath!)) :
          CustomCacheImage(
            imgUrl: imageLink!,
            fullScreen: true,
          )),
      floatingActionButton: imageLink!=null ? Obx(() => FloatingActionButton(
        onPressed: (){
          if(controller.isSharing.isFalse){
                    controller.saveAndShare(imageLink!);
                  }
                },
        child: controller.isSharing.isTrue ? const Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(color: Colors.white,),
        ) : const Icon(Icons.share,color: Colors.white,),
      )) : null,
    );
  }

}

