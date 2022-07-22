import 'package:dreamland/screens/AdminDashboard.dart';
import 'package:dreamland/screens/login.dart';
import 'package:dreamland/storage/SharedPref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  runApp( GetMaterialApp(
    theme: ThemeData(primarySwatch: Colors.brown),
      debugShowCheckedModeBanner:false,
      home: const SplashScreen())

  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Constants pref = new Constants();
  // checkUser() async{
  // var role = await pref.getSession(AppConstants.ROLE);
  //   print(role);
  //
  //
  // if(role != null){
  //   if(role == '1'){
  //     Get.offAll(()=>AdminDashboard());
  //  }
  //  else{
  //     Get.offAll(()=>AdminDashboard());
  //  }
  // }
  // else{
  //   Get.to(()=>Login());
  // }
  //
  // }

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


     // DocumentSnapshot<Map<String,dynamic>> snapshot = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
     // final Map? map = snapshot.data();
     //
     // if(map==null){
     //   Get.off(Login());
     // }
     // else{
     //   Constants.user = FirebaseAuth.instance.currentUser!.displayName!;
     //   if(map["role"] == "1" || map["role"] == 1){
     //     Constants.role == "1";
     //   }
     //   else if(map["role"] == "2" || map["role"] == 2){
     //     Constants.role == "2";
     //   }
     //
     //   Get.off(AdminDashboard());
     //
     // }
     //
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

