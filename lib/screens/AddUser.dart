import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();



   handleSignUp(name,email,phone, password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final User user = result.user!;
    if(user != null){
      FirebaseFirestore.instance
          .collection('users')
      .doc(user.uid)
          .set({
        'email':email,
        'name':name,
        'phone':phone,
        'role':'2',
        'status':'offline',
        'uid':user.uid
      })
          .then((value){
            Navigator.pop(context);
        Fluttertoast.showToast(
            msg: 'User Registered',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0
        );
        print('success');
      }).catchError((err){
        Fluttertoast.showToast(
            msg: err.message!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0
        );
        print(err);
      });
    }
    else{
      print('reg failed');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        centerTitle: true,
        title: Text('Add User'),
      ),
      body: Padding(padding: EdgeInsets.all(15),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('DREAMLAND',style: TextStyle(fontSize: 28,color: Colors.brown,fontWeight: FontWeight.bold),),
      SizedBox(height: 20,),

          TextField(
            controller: nameController,
            decoration: InputDecoration(
                labelText: 'Enter Name',
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
          SizedBox(height: 10,),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
                labelText: 'Enter Phone',
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
            handleSignUp(nameController.text,emailController.text,phoneController.text,passwordController.text);

          },
            color: Colors.brown,
            child: Text('REGISTER',style: TextStyle(color: Colors.white,fontSize: 18),),
          )
        ],
      ),)
    );
  }
}
