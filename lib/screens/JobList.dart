import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamland/screens/AdminDashboard.dart';
import 'package:dreamland/screens/Logs.dart';
import 'package:dreamland/screens/UpdateJob.dart';
import 'package:dreamland/screens/ViewJob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../Constants/AppConstants.dart';
import '../Model/JobModel.dart';
import '../storage/SharedPref.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;


class JobList extends StatefulWidget {
  var jobtype;
  JobList({this.jobtype});

  @override
  State<JobList> createState() => _JobListState();
}


class _JobListState extends State<JobList> {
  // var user;
  List<JobModel> jobModel = [];
  List<JobModel> dummyJobModel = [];
  TextEditingController searchController = TextEditingController();

  List<String> jobTypes = [
    'Booked',
    'Hold',
    'In Progress',
    'Unpaid',
    'Complain',
    'Completed',
    'Delivery Booked',
    'Delivery Complete'
  ];

  fillJobList() async {
    print("hi");
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection(
        'addjob');
    QuerySnapshot querySnapshot = await _collectionRef.orderBy("updatedAt", descending: true).get();
    for (var a in querySnapshot.docs) {
      print(a['title']);
      if (a['status'] == widget.jobtype) {
        setState(() {
          jobModel.add(
              JobModel(
              id: a['id'],
              name: a['author'] ?? ' ',
              number: a['bar'] ?? ' ',
              customNote: a['customn'] ?? ' ',
              jobTitle: a['jobtitle'] ?? ' ',
              employee: a['emplo'] ?? ' ',
              address: a['des'] ?? ' ',
              postCode: a['title'] ?? ' ',
              status: a['status'] ?? ' ',
              user: a['user'] ?? ' ',
              product: a['product'] ?? ' ',
              quatity: a['quantity'] ?? ' ',
              dateBooking: a['descri'] ?? ' ',
              dateFitting: a['datef'] ?? ' ',
              imgOne: a['imageURL'] ?? ' ',
              imgTwo: a['imageURL2'] ?? ' ',
              imgThree: a['imageURL3'] ?? ' ',
              billUrl: a['billURL'] ?? ' ',
            number2: a['phone2'] ?? '',
          ));
        });
      }

    }
    setState(() {
      setState(() {
        dummyJobModel.addAll(jobModel);
      });
    });
  }

  updateJobStatus(id, jobstatus) async{

    String dateTime = getUKDateTime().toString();

    var collection = FirebaseFirestore.instance.collection('addjob');
    await collection
        .doc(id)
        .update({'status': jobstatus, 'updatedAt' : dateTime })
        .then((value) {
      print('success');
      setState(() async{
        Navigator.of(context).pop();
        await addLog(id, jobstatus);
        jobModel.clear();
        jobTypes.remove(widget.jobtype);

        fillJobList();
      });
    }).catchError((e) {
      print(e);
    });
  }

  deleteJob(id) {
    showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (BuildContext ctx) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: AlertDialog(
              elevation: 10,
              content: Text('Are You Sure You Want To Delete Job ?'),
              actions: [
                TextButton(
                    onPressed: () {
                      final collection = FirebaseFirestore.instance.collection(
                          'addjob');
                      collection
                          .doc(id)
                          .delete()
                          .then((_) {
                        Navigator.pop(context);
                        jobModel.clear();
                        jobTypes.remove(widget.jobtype);

                        fillJobList();
                      })
                          .catchError((error) =>
                          print('Delete failed: $error'));
                    },
                    child: const Text(
                      'Yes', style: TextStyle(color: Colors.brown),)),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                        'No', style: TextStyle(color: Colors.brown)))
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      jobTypes.remove(widget.jobtype);
      print(jobTypes);
    });
    fillJobList();
  }

  jobButtons() {
    for (var a in jobTypes) {
      print(jobTypes);
      return ElevatedButton(onPressed: () {},
        child: Text(a),);
    }
  }

  DateTime getUKDateTime() {
    tz.initializeTimeZones();
    var istanbulTimeZone = tz.getLocation('Europe/London');
    var now = tz.TZDateTime.now(istanbulTimeZone);
    print("returning $now");
    return now;
  }

  Future<String> getUsername(String id) async{
   DocumentSnapshot<Map<String,dynamic>> snapshot = await FirebaseFirestore.instance.collection("users").doc(id).get();
   Map m = snapshot.data()!;
   return m['name'];
  }

  addLog(jid, s) async{
    String name  = await getUsername(FirebaseAuth.instance.currentUser!.uid);


    String dateTime = getUKDateTime().toString();
    print("in add log it is: ${getUKDateTime()}");
    String id = FirebaseFirestore.instance
        .collection('logs')
        .doc()
        .id;
    FirebaseFirestore.instance
        .collection('logs')
        .add({
      'date': dateTime,
      'employee': name,
      'id': id,
      'jobid': jid,
      'status': s
    })
        .then((value) {
      print('success');
    }).catchError((err) {
      print(err);
    });
  }

  jobCard(int i) {
    return Card(
        elevation: 5,
        child: Column(children: [
          Row(
            children: [
              Column(children: [
                jobModel[i].imgOne != "" ? Image.network(
                  jobModel[i].imgOne, height: 150, width: 150,)
                    : Image.network(
                  AppConstants.NO_IMAGE, height: 150, width: 150,)
              ],),
              SizedBox(width: 15,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text('Title : ' + jobModel[i].jobTitle,
                    style: const TextStyle(color: Colors.black, fontSize: 14),),
                  Text('Employee : ' + jobModel[i].employee,
                    style: const TextStyle(color: Colors.black, fontSize: 14),),
                  Text('Address : ' + jobModel[i].address,
                    style: const TextStyle(color: Colors.black, fontSize: 14),),
                  Text('Post Code : ' + jobModel[i].postCode,
                    style: const TextStyle(color: Colors.black, fontSize: 14),),
                  Text('Status Code : ' + jobModel[i].status,
                    style: const TextStyle(color: Colors.black, fontSize: 14),),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      false ? ClipOval(
                        child: Material(
                          color: Colors.brown, // Button color
                          child: InkWell(
                            splashColor: Colors.brown[200], // Splash color
                            onTap: () {
                              deleteJob(jobModel[i].id);
                            },
                            child: SizedBox(width: 40,
                                height: 40,
                                child: Icon(
                                  Icons.delete, color: Colors.white,)),
                          ),
                        ),
                      ) : SizedBox(height: 0,),
                      SizedBox(width: 10,),
                      ClipOval(
                        child: Material(
                          color: Colors.brown, // Button color
                          child: InkWell(
                            splashColor: Colors.brown[200], // Splash color
                            onTap: () {
                              Get.to(() =>
                                  UpdateJob(jobModel: jobModel[i], t: 'new',));
                            },
                            child: SizedBox(width: 40,
                                height: 40,
                                child: Icon(Icons.edit, color: Colors.white,)),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      ClipOval(
                        child: Material(
                          color: Colors.brown, // Button color
                          child: InkWell(
                            splashColor: Colors.brown[200], // Splash color
                            onTap: () {
                              Get.to(() => ViewJob(jobModel: jobModel[i]));
                            },
                            child: SizedBox(width: 40,
                                height: 40,
                                child: Icon(Icons.sticky_note_2_outlined,
                                  color: Colors.white,)),
                          ),
                        ),
                      )

                    ],)
                ],)
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () {
                showBox(jobModel[i].id, jobTypes[0]);
              },
                child: Text(jobTypes[0]),
              ),
              ElevatedButton(onPressed: () {
                showBox(jobModel[i].id, jobTypes[1]);
              },
                child: Text(jobTypes[1]),
              ),
              ElevatedButton(onPressed: () {
                showBox(jobModel[i].id, jobTypes[2]);
              },
                child: Text(jobTypes[2]),
              ),
              ElevatedButton(onPressed: () {
                showBox(jobModel[i].id, jobTypes[3]);
              },
                child: Text(jobTypes[3]),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () {

                if(Constants.role == "2"){

                }

                showBox(jobModel[i].id, jobTypes[4]);
              },
                child: Text(jobTypes[4]),
              ),
              ElevatedButton(onPressed: () {
                // if(Constants.role=="2"){
                //   Fluttertoast.showToast(msg: "Only Admin Can move Jobs to Completed");
                // }
                // else{
                  print("showing box");
                  showBox(jobModel[i].id, jobTypes[5]);
                // }
              },
                child: Text(jobTypes[5]),
              ),
              ElevatedButton(onPressed: () {
                showBox(jobModel[i].id, jobTypes[6]);
              },
                child: Text(jobTypes[6]),
              ),
            ],
          ),
          Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child:
              ElevatedButton(onPressed: () {
                Get.to(Logs(jobid: jobModel[i].id));
              },
                child: Text('Show Log'),)
          )
        ],)

    );
  }

  showBox(id, ty) async {

    print(ty);
    if (ty=="Completed" && Constants.role=="2"){
      Fluttertoast.showToast(msg: "Ask Admin to move to completed");
      return;
    }

    showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (BuildContext ctx) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: AlertDialog(
              elevation: 10,
              content: Text(
                  'Are You Sure You Want To Change Job Status To ' + ty + ' ?'),
              actions: [
                TextButton(
                    onPressed: () {
                      updateJobStatus(id, ty);
                    },
                    child: const Text(
                      'Yes', style: TextStyle(color: Colors.brown),)),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                        'No', style: TextStyle(color: Colors.brown)))
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true,
            backgroundColor: Colors.brown,
            title: TextField(
              controller: searchController,
              onChanged: (t) => onSearchTextChanged(t),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: const InputDecoration(hintText: 'Search Here',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                  border: InputBorder.none),
            ),
          leading: InkWell(
              onTap: (){
                Get.off(const AdminDashboard());
              },
              child: const Icon(Icons.arrow_back)),

        ),
        body: Container(
            color: Colors.white,
            child: ListView.builder(
                itemCount: jobModel.length,
                itemBuilder: (BuildContext ctx, int i) {
                  return jobCard(i);
                })
        ));
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  ///For numbers search
  onSearchTextChangedV2(String text) async {
    setState(() {
      jobModel.clear();
    });
    if (text.isEmpty || text == '') {
      setState(() {

        jobModel.addAll(dummyJobModel);
      });
    }else {
      print(jobModel.length);
      print(dummyJobModel.length);
      dummyJobModel.forEach((data) {
        if (data.number.toString().toLowerCase().contains(text.toLowerCase()) || data.address.toString().toLowerCase().contains(text.toLowerCase())  ) {
          setState(() {
            jobModel.add(data);
          });
        }
      });
    }

  }


  onSearchTextChanged(String text) async {

    if(isNumeric(text)){
      onSearchTextChangedV2(text);
      return ;
    }


    setState(() {
      jobModel.clear();
    });
    if (text.isEmpty || text == '') {
      setState(() {
        jobModel.addAll(dummyJobModel);
      });
    }
    else {
      print(text);
      dummyJobModel.forEach((data) {
        if (data.postCode.toString().toLowerCase().contains(text.toLowerCase())
            ||
            data.jobTitle.toString().toLowerCase().contains(text.toLowerCase())
            ||
            data.employee.toString().toLowerCase().contains(text.toLowerCase())
            ||
            data.address.toString().toLowerCase().contains(text.toLowerCase())
        ) {
          setState(() {
            jobModel.add(data);
          });
        }
      });
    }
  }
}
