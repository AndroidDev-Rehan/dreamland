import 'package:dreamland/screens/login.dart';
import 'package:get/get.dart';

class Constants{

  static var user;
  static var role;

  static reset(){
    user = null;
    role = null;
  }


  // saveSession(key,value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString(key, value);
  // }
  //
  // getSession(key) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   String? stringValue = prefs.getString(key);
  //   return stringValue;
  // }
  //
  // deleteAll() async{
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   await preferences.clear();
  //   Get.offAll(()=>Login());
  // }
}