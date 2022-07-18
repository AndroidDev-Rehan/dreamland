// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class PasswordResetScreen extends StatefulWidget {
//   const PasswordResetScreen({Key? key}) : super(key: key);
//
//   @override
//   State<PasswordResetScreen> createState() => _PasswordResetScreenState();
// }
//
// class _PasswordResetScreenState extends State<PasswordResetScreen> {
//   TextEditingController emailController = new TextEditingController();
//   TextEditingController passwordController = new TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Password Reset',style: TextStyle(color: Colors.brown,fontSize: 25,fontWeight: FontWeight.bold),),
//             SizedBox(height: 30,),
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(
//                   labelText: 'Enter Email',
//                   labelStyle: TextStyle(color: Colors.black),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(width: 1.5, color: Colors.brown),
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(width: 1.5, color: Colors.brown),
//                     borderRadius: BorderRadius.circular(15),
//                   )),
//             ),
//             SizedBox(height: 15,),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                   labelText: 'Enter New Password',
//                   labelStyle: TextStyle(color: Colors.black),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(width: 1.5, color: Colors.brown),
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(width: 1.5, color: Colors.brown),
//                     borderRadius: BorderRadius.circular(15),
//                   )),
//             ),
//             SizedBox(height: 15,),
//
//             RaisedButton(onPressed: () async {
//               // loginAuth(emailController.text,passwordController.text);
//
//             },
//               color: Colors.brown,
//               child: Text('Reset',style: TextStyle(color: Colors.white,fontSize: 18),),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   updatePass(pass){
//     final FirebaseAuth firebaseAuth = FirebaseAuth.instance.confirmPasswordReset(code: code, newPassword: newPassword);
//     User? currentUser = firebaseAuth.currentUser;
//     currentUser?.updatePassword(pass).then((r){
//       Fluttertoast.showToast(
//           msg: 'Password Updated',
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.brown,
//           textColor: Colors.white,
//           fontSize: 16.0
//       );
//       Navigator.pop(context);
//     }).catchError((err){
//       Fluttertoast.showToast(
//           msg: err.toString(),
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.brown,
//           textColor: Colors.white,
//           fontSize: 16.0
//       );
//       // An error has occured.
//     });
//   }
//
//
//
// }
