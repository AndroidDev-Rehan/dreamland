import 'package:dreamland/screens/login.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{

  saveSession(key,value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
  getSession(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? stringValue = prefs.getString(key);
    return stringValue;
  }

  deleteAll() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Get.offAll(()=>Login());
  }
}