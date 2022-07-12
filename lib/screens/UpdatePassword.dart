import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  TextEditingController passwordController = new TextEditingController();


  updatePass(pass){
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? currentUser = firebaseAuth.currentUser;
    currentUser?.updatePassword(pass).then((r){
      Fluttertoast.showToast(
          msg: 'Password Updated',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.brown,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.pop(context);
    }).catchError((err){
      Fluttertoast.showToast(
          msg: err.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.brown,
          textColor: Colors.white,
          fontSize: 16.0
      );
      // An error has occured.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true,
          backgroundColor: Colors.brown,
          title: Text('Update Password'),),
        body:Padding(padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                  labelText: 'Enter New Password',
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
            SizedBox(height: 10,),
            RaisedButton(onPressed: () async {
        updatePass(passwordController.text);

            },
              color: Colors.brown,
              child: Text('UPDATE',style: TextStyle(color: Colors.white,fontSize: 18),),
            )
          ],
        ),)
    );
  }
}
