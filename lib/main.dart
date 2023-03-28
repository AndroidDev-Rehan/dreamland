import 'package:dreamland/screens/AdminDashboard.dart';
import 'package:dreamland/screens/contact_developer.dart';
import 'package:dreamland/screens/login.dart';
import 'package:dreamland/storage/SharedPref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  String? token = await FirebaseMessaging.instance.getToken();

  // if(token==null){
  //   print("token is null");
  // }
  // else {
  //
  //   String serverKey = "AAAAtu34FVc:APA91bEQDmN_-q_K5MRgDGlCz-env5SDgkkVqzZ1icvb-feW3oCy9gS6H5k5bof-CjSt1iBUfF7Y_mH7ODIpXFpwWZzWKcp0BhF2RTCINZdu_fIRNpT9iwMxCgx2asFXEg2tVoQSRLYY";
  //
  //   var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  //   var response = await http.post(
  //       url,
  //       body: json.encode(
  //           {
  //             "to": token,
  //             "notification": {
  //               "title": "Check this Mobile (title)",
  //               "body": "Rich Notification testing (body)",
  //               // "mutable_content": true,
  //               // "sound": "Tri-tone"
  //             },
  //           }
  //
  //       ),
  //       headers: {"Content-Type": "application/json", 'Authorization': 'Key $serverKey',}
  //   );
  //
  //   print('Response status: ${response.statusCode}');
  //   print('Response body: ${response.body}');
  //
  // }


  tz.initializeTimeZones();
  print("in the main");
  runApp( ScreenUtilInit(
      designSize: const Size(392.727272, 825.4545),
      minTextAdapt: true,
      splitScreenMode: true,
    builder: (context,c) {
      return GetMaterialApp(
        theme: ThemeData(primarySwatch: Colors.brown),
          debugShowCheckedModeBanner:false,
          home:
          DateTime.now().isAfter(DateFormat("dd-MM-yyyy").parse("14-04-2023")) ?  const ContactDeveloper() :
          const SplashScreen()
      );
    }
  )
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Constants pref = Constants();

  fetchUserSetRoles() async{
    if(FirebaseAuth.instance.currentUser==null){
      Get.off(Login());
    }
    else {

      if(FirebaseAuth.instance.currentUser!.email! == Constants.adminEmail)
        {
          Constants.role = "1";
        }
      else {
        Constants.role = "2";
      }

      Get.off(const AdminDashboard());


    }
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2),(){
      fetchUserSetRoles();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Container(
      color: Colors.white,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('Play Games',style: TextStyle(color: Colors.brown,fontSize: 25,fontWeight: FontWeight.bold),),
          SizedBox(height: 15,),
          CircularProgressIndicator(color: Colors.brown,)
        ],
      )),
    )
    );
  }
}

