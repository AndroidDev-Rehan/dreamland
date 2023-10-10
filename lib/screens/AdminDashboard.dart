import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamland/screens/AddJob.dart';
import 'package:dreamland/screens/AddUser.dart';
import 'package:dreamland/screens/HomeSearch.dart';
import 'package:dreamland/screens/JobCalendar.dart';
import 'package:dreamland/screens/JobList.dart';
import 'package:dreamland/screens/ViewUsers.dart';
import 'package:dreamland/screens/login.dart';
import 'package:dreamland/screens/product_sale_logs.dart';
import 'package:dreamland/screens/register_job_form.dart';
import 'package:dreamland/screens/remove_products.dart';
import 'package:dreamland/screens/view_job_forms.dart';
import 'package:dreamland/storage/SharedPref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Products.dart';
import 'ShowJob.dart';
import 'UpdatePassword.dart';
import 'export_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);
///hi
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {


  var user;
  String username = "";

  getUser() async {
    // Constants sp = new Constants();
    var r = Constants.role;
    if(r != null){
      setState(() {
        user = r;
        print('dashboard role =$user');
      });
    }
  }

  Future<String> getUserName() async{
    if (FirebaseAuth.instance.currentUser!.email==Constants.adminEmail){
      return "Welcome Admin";
    }
    else if(username!=""){
      return username;
    }
    else {
      DocumentSnapshot<Map<String,dynamic>> snapshot = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
      Map map = snapshot.data()!;
      username = map["name"];
      return username;
    }

  }

  adminDrawer(){
    return Drawer(

      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.brown,
              ),
            child: Center(child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Play Games',style: TextStyle(color: Colors.white,fontSize: 40),),
                    const SizedBox(height: 10,),
                    FutureBuilder(
                      future: getUserName(),
                      builder: (context,AsyncSnapshot<String> snapshot) {
                        if(snapshot.connectionState==ConnectionState.waiting){
                          return const Text('Welcome',style: TextStyle(color: Colors.white),);
                        }
                        return Text(snapshot.data!,style: const TextStyle(color: Colors.white),);
                      }
                    ),
                  ],
                )
                )
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {

              Get.to(const AdminDashboard());
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
            title: const Text("Sale Logs"),
            onTap: (){
              Get.to(()=>const ProductSaleLogs());
            },

          ),
          ListTile(
            title: const Text("Registration Form"),
            onTap: (){
              Get.to(()=>RegisterJobForm());
            },

          ),
          ListTile(
            title: const Text("View Job Forms"),
            onTap: (){
              Get.to(()=>ViewJobForms());
            },

          ),

          ListTile(
            title: const Text('Add Job'),
            onTap: () {
              Navigator.pop(context);

              Get.to(AddJob());

            },
          ),
          ListTile(
            title: Text('Show Job'),
            onTap: () {
              Navigator.pop(context);

              Get.off(ShowJob());
            },
          ),
          ListTile(
            title: Text('Booked Job'),
            onTap: () {
              Navigator.pop(context);

              Get.off(JobList(jobtype: 'Booked'));
            },
          ),
          ListTile(
            title: Text('Hold Job'),
            onTap: () {
              Navigator.pop(context);

              Get.off(JobList(jobtype: 'Hold'));
            },
          ),
          ListTile(
            title: Text('In Progress Job'),
            onTap: () {
              Navigator.pop(context);

              Get.off(JobList(jobtype: 'In Progress'));
            },
          ),
          ListTile(
            title: Text('Un Paid Job'),
            onTap: () {
              Navigator.pop(context);

                Get.off(JobList(jobtype: 'Unpaid'));
            },
          ),
          ListTile(
            title: Text('Complain'),
            onTap: () {
              Navigator.pop(context);

              Get.off(JobList(jobtype: 'Complain'));
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

              Get.off(JobList(jobtype: 'Delivery Booked'));
            },
          ),
          ListTile(
            title: Text('Delivery Complete'),
            onTap: () {

              Navigator.pop(context);

                Get.off(JobList(jobtype: 'Delivery Complete'));
              },
          ),
          ListTile(
            title: Text('Export Data'),
            onTap: () {

              Navigator.pop(context);

              Get.to(ExportDataScreen());
            },
          )

        ],
      ),
    );
  }

  userDrawer(){
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
                  Text('Play Games',style: TextStyle(color: Colors.white,fontSize: 40),),
                  SizedBox(height: 10,),
                  FutureBuilder(
                      future: getUserName(),
                      builder: (context,AsyncSnapshot<String> snapshot) {
                        if(snapshot.connectionState==ConnectionState.waiting){
                          return const Text('Welcome',style: TextStyle(color: Colors.white),);
                        }
                        return Text("Welcome ${snapshot.data!}",style: const TextStyle(color: Colors.white),);
                      }
                  ),

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
              Get.off(ShowJob());

            },
          ),

          ListTile(
            title: Text('Booked Job'),
            onTap: () {
              Navigator.pop(context);
              Get.off(JobList(jobtype: 'Booked'));
            },
          ),
          ListTile(
            title: Text('Hold Job'),
            onTap: () {
              Navigator.pop(context);
              Get.off(JobList(jobtype: 'Hold'));
            },
          ),
          ListTile(
            title: Text('In Progress Job'),
            onTap: () {
              Navigator.pop(context);

              Get.off(JobList(jobtype: 'In Progress'));
            },
          ),
          ListTile(
            title: Text('Un Paid Job'),
            onTap: () {
              Navigator.pop(context);

              Get.off(JobList(jobtype: 'Unpaid'));
            },
          ),
          ListTile(
            title: Text('Complain'),
            onTap: () {
              Navigator.pop(context);

              Get.off(JobList(jobtype: 'Complain'));
            },
          ),
          ListTile(
            title: Text('Complete Job'),
            onTap: () {
              Navigator.pop(context);
              Get.off(JobList(jobtype: 'Completed'));

            },
          ),
          ListTile(
            title: Text('Delivery Booked'),
            onTap: () {
              Navigator.pop(context);

              Get.off(JobList(jobtype: 'Delivery Booked'));
            },
          ),
          ListTile(
            title: Text('Delivery Complete'),
            onTap: () {
              Navigator.pop(context);

              Get.off(JobList(jobtype: 'Delivery Complete'));
            },
          ),

        ],
      ),
    );
  }

  @override
  void initState() {
    getUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.brown,
        //leading: ElevatedButton(onPressed: (){}, child: Text("Sale")),
        title: Text('Play Games'),
        centerTitle: false,
      actions:[

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(onPressed: (){
            Get.to(()=>const ProductsRemovalScreen(),
            );
          },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent
              ),
              child: const Text("Sale")),
        ),
      SizedBox(width: 5,),

      IconButton(
        onPressed: () async{
          Constants.reset();
          await FirebaseAuth.instance.signOut();
          Get.offAll(Login());
          // Constants pref = new Constants();
          // pref.deleteAll();


        }, icon: Icon(Icons.logout,color: Colors.white,),

      ),


      ]
      ),
      drawer: user == "1" ? adminDrawer() : userDrawer(),
      body: SafeArea(
        child: HomeSearch()

      ),
    );

  }



}
