import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewUsers extends StatefulWidget {

  @override
  State<ViewUsers> createState() => _ViewUsersState();
}

class UsersList{
  var id;
  var name;
  var email;
  UsersList({this.id,this.name,this.email});
}
class _ViewUsersState extends State<ViewUsers> {
  List<UsersList> userList = [];
  getUsers() async{
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection('users');

    QuerySnapshot querySnapshot = await _collectionRef.get();
    for(var a in querySnapshot.docs) {
      if(a['role'] == '2' || a['role'] ==2){
        setState(() {
          userList.add(UsersList(id:a['uid'],name: a['name'],email: a['email']));
        });
      }
      
    }
    
  }

  deleteUser(uid) async{


    showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (BuildContext ctx) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: AlertDialog(
              elevation: 10,
              content:  Text('Are You Sure You Want To Delete This User ?'),
              actions: [
                TextButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .delete().then((value) {
                        userList.clear();
                        getUsers();
                        print('success');
                      }).catchError((e){
                        print(e.toString());
                      });
                    },
                    child: const Text('Yes',style: TextStyle(color: Colors.brown),)),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('No',style: TextStyle(color: Colors.brown)))
              ],
            ),
          );
        });

  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.brown,
        centerTitle: true,
        title: Text('View User'),
    ),
    body:SingleChildScrollView(
      child: Padding(padding: EdgeInsets.all(10),
      child: Table(
          columnWidths: {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(3),
            2: FlexColumnWidth(0.5),
          },
          border: TableBorder.all(
              color: Colors.brown,
              style: BorderStyle.solid,
              width: 1),
          children: [
            TableRow(
                children: [

                  Container(color: Colors.brown,child:Column(children:[Text('Name',style: TextStyle(fontSize: 20,color: Colors.white),)])),
                  Container(color: Colors.brown,child:Column(children:[Text('Email',style: TextStyle(fontSize: 20,color: Colors.white),)])),
                  Container(color: Colors.brown,child:Column(children:[Icon(Icons.call_to_action_outlined,color: Colors.white,size: 20,)])),
                ]),
            for(var x in userList)
              TableRow(children: [
                Container(color: Colors.white,child:Column(children:[Text(x.name,style: TextStyle(fontSize: 20),)])),
                Container(color: Colors.white,child:Column(children:[Text(x.email,style: TextStyle(fontSize: 20),)])),
                Container(color: Colors.white,child:Column(children:[IconButton(icon: Icon(Icons.delete,color: Colors.brown,size: 20,),onPressed: (){
                  deleteUser(x.id);

                },)])),
              ])

          ]),)
    ),

    );
  }
}
