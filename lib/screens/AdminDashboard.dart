import 'package:dreamland/Constants/AppConstants.dart';
import 'package:dreamland/screens/AddJob.dart';
import 'package:dreamland/screens/AddUser.dart';
import 'package:dreamland/screens/HomeSearch.dart';
import 'package:dreamland/screens/JobCalendar.dart';
import 'package:dreamland/screens/JobList.dart';
import 'package:dreamland/screens/ViewUsers.dart';
import 'package:dreamland/storage/SharedPref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Products.dart';
import 'ShowJob.dart';
import 'UpdatePassword.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {


  var user;

  getUser() async {
    SharedPref sp = new SharedPref();
    var r = await sp.getSession(AppConstants.ROLE);
    if(r != null){
      setState(() {
        user = r;
        print('dashboard role =$user');
      });
    }
  }

  AdminDrawer(){
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
                    Text('Welcome Admin',style: TextStyle(color: Colors.white),),

                  ],
                )
                )
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {

              Get.to(AdminDashboard());
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
            title: Text('Add User'),
            onTap: () {
              Navigator.pop(context);
              Get.to(AddUser());
              },
          ),
          ListTile(
            title: Text('View User'),
            onTap: () {
              Navigator.pop(context);

              Get.to(ViewUsers());
            },
          ),
          ListTile(
            title: Text('Calendar'),
            onTap: () {

              Get.to(JobCalendar(type: 'new',));

            },
          ),
          ListTile(
            title: Text('Add Job'),
            onTap: () {
              Navigator.pop(context);

              Get.to(AddJob());

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
              Get.to(AdminDashboard());
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
              Navigator.pop(context);

              Get.to(JobCalendar(type: 'new',));

            },
          ),
          ListTile(
            title: Text('Add Job'),
            onTap: () {
              Navigator.pop(context);

              Get.to(AddJob());

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
  void initState() {
    // TODO: implement initState
    getUser();

    super.initState();
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
          SharedPref pref = new SharedPref();
          pref.deleteAll();
        }, icon: Icon(Icons.logout,color: Colors.white,),

      ),
      ]
      ),
      drawer: user == "1" ? AdminDrawer() : UserDrawer(),
      body: SafeArea(
        child: HomeSearch()

      ),
    );

  }



}
