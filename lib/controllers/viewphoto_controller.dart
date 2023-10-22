import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:share_plus/share_plus.dart';

class ViewPhotoController extends GetxController {
  Rx<bool> isSharing = false.obs;

  Future<void> saveAndShare(String imgUrl) async {
    try {
      isSharing.value = true;
      var response = await http.get(Uri.parse(imgUrl));
      final documentDirectory = (await getExternalStorageDirectory())?.path;
      File imgFile = File('$documentDirectory/Dreamland.png');
      debugPrint('File Path: ${imgFile.path}');
      imgFile.writeAsBytesSync(response.bodyBytes);

      await Share.shareXFiles(
        [XFile(imgFile.path)],
      );
      isSharing.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isSharing.value = false;
    }
  }
}
