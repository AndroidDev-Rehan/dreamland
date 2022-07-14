import 'package:dreamland/Constants/AppConstants.dart';
import 'package:dreamland/screens/AddUser.dart';
import 'package:dreamland/screens/AdminDashboard.dart';
import 'package:dreamland/screens/UserDashboard.dart';
import 'package:dreamland/screens/login.dart';
import 'package:dreamland/storage/SharedPref.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const GetMaterialApp(debugShowCheckedModeBanner:false,home: SplashScreen()));
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPref pref = new SharedPref();
  checkUser() async{
  var role = await pref.getSession(AppConstants.ROLE);
    print(role);
  if(role != null){
    if(role == '1'){
      Get.offAll(()=>AdminDashboard());
   }
   else{
      Get.offAll(()=>AdminDashboard());
   }
  }
  else{
    Get.to(()=>Login());
  }

  }



@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2),(){
      checkUser();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Container(
      color: Colors.white,
      child: Center(child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('DREAMLAND',style: TextStyle(color: Colors.brown,fontSize: 25,fontWeight: FontWeight.bold),),
          SizedBox(height: 15,),
          CircularProgressIndicator(color: Colors.brown,)
        ],
      )),
    )
    );
  }
}

