import 'package:dreamland/screens/Products.dart';
import 'package:dreamland/screens/ShowJob.dart';
import 'package:dreamland/screens/UpdatePassword.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../storage/SharedPref.dart';
import 'HomeSearch.dart';
import 'JobList.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  UserDrawer(){
    return Drawer(

      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown,
              ),
              child: Center(child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Dreamland',style: TextStyle(color: Colors.white,fontSize: 40),),
                  SizedBox(height: 10,),
                  Text('Welcome User',style: TextStyle(color: Colors.white),),

                ],
              )
              )
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {

            },
          ),
          ListTile(
            title: Text('Update Password'),
            onTap: () {
              Navigator.pop(context);
              Get.to(UpdatePassword());
            },
          ),
          ListTile(
            title: Text('Product'),
            onTap: () {
              Navigator.pop(context);
              Get.to(Products());
            },
          ),


          ListTile(
            title: Text('Calendar'),
            onTap: () {
            },
          ),
          ListTile(
            title: Text('Add Job'),
            onTap: () {
            },
          ),
          ListTile(
            title: Text('Show Job'),
            onTap: () {
              Navigator.pop(context);
              Get.to(ShowJob());
            },
          ),
          ListTile(
            title: Text('Booked Job'),
            onTap: () {
              Navigator.pop(context);
              Get.to(JobList(jobtype: 'Booked'));
            },
          ),
          ListTile(
            title: Text('Hold Job'),
            onTap: () {
              Navigator.pop(context);
              Get.to(JobList(jobtype: 'Hold'));
            },
          ),
          ListTile(
            title: Text('In Progress Job'),
            onTap: () {
              Navigator.pop(context);

              Get.to(JobList(jobtype: 'In Progress'));
            },
          ),
          ListTile(
            title: Text('Un Paid Job'),
            onTap: () {
              Navigator.pop(context);

              Get.to(JobList(jobtype: 'Unpaid'));
            },
          ),
          ListTile(
            title: Text('Complain'),
            onTap: () {
              Navigator.pop(context);

              Get.to(JobList(jobtype: 'Complain'));
            },
          ),
          ListTile(
            title: Text('Complete Job'),
            onTap: () {
              Navigator.pop(context);
              Get.to(JobList(jobtype: 'Completed'));

            },
          ),
          ListTile(
            title: Text('Delivery Booked'),
            onTap: () {
              Navigator.pop(context);

              Get.to(JobList(jobtype: 'Delivery Booked'));
            },
          ),
          ListTile(
            title: Text('Delivery Complete'),
            onTap: () {
              Navigator.pop(context);

              Get.to(JobList(jobtype: 'Delivery Complete'));
            },
          ),

        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text('Dreamland'),
          centerTitle: true,
          actions:[
            IconButton(
              onPressed: (){
                // Constants pref = new Constants();
                // pref.deleteAll();
              }, icon: Icon(Icons.logout,color: Colors.white,),

            ),
          ]
      ),
      drawer:  UserDrawer(),
      body: SafeArea(
          child: HomeSearch()

      ),
    );
  }
}
