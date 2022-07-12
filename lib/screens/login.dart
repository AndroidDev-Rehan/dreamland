import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamland/Constants/AppConstants.dart';
import 'package:dreamland/screens/AdminDashboard.dart';
import 'package:dreamland/screens/UserDashboard.dart';
import 'package:dreamland/storage/SharedPref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';


class Login extends StatefulWidget {

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  SharedPref pref = new SharedPref();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('DREAMLAND',style: TextStyle(color: Colors.brown,fontSize: 25,fontWeight: FontWeight.bold),),
          SizedBox(height: 30,),
            TextField(
              controller: emailController,
          decoration: InputDecoration(
              labelText: 'Enter Email',
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1.5, color: Colors.brown),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1.5, color: Colors.brown),
                borderRadius: BorderRadius.circular(15),
              )),
        ),
          SizedBox(height: 15,),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Enter Password',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1.5, color: Colors.brown),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1.5, color: Colors.brown),
                    borderRadius: BorderRadius.circular(15),
                  )),
            ),
            SizedBox(height: 15,),

          RaisedButton(onPressed: () async {
            loginAuth(emailController.text,passwordController.text);

          },
                color: Colors.brown,
            child: Text('LOGIN',style: TextStyle(color: Colors.white,fontSize: 18),),
          )
          ],
        ),
      ),
    );
  }

loginAuth(em,pw) async {
    var isUser = false;
    try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: em,
        password: pw
    );
    if(userCredential != null) {
      User? user = FirebaseAuth.instance.currentUser;

      CollectionReference _collectionRef = FirebaseFirestore.instance.collection('users');
      QuerySnapshot querySnapshot = await _collectionRef.get();
      for(var a in querySnapshot.docs) {
        if(a['email'] ==em){
          setState(() {
            isUser = true;
          });
        }
      }

  if(isUser) {
    if (user!.email!.contains('admin')) {
      pref.saveSession(AppConstants.USER, user.displayName);
      pref.saveSession(AppConstants.ROLE, '1');
      Get.offAll(() => AdminDashboard());
    }
    else {
      pref.saveSession(AppConstants.USER, user.displayName);
      pref.saveSession(AppConstants.ROLE, '2');
      Get.offAll(() => AdminDashboard());
    }
  }
  else{
    Fluttertoast.showToast(
        msg: 'Account Not Found',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.brown,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
    }
    else{

      print('not found');
    }
  } on FirebaseAuthException catch (e) {
    print(e.message);
    Fluttertoast.showToast(
        msg: e.message!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.brown,
        textColor: Colors.white,
        fontSize: 16.0
    );
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}

}
