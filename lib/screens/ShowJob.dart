import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constants/AppConstants.dart';
import '../Model/JobModel.dart';
import '../storage/SharedPref.dart';
import 'UpdateJob.dart';

class ShowJob extends StatefulWidget {


  @override
  State<ShowJob> createState() => _ShowJobState();
}

class _ShowJobState extends State<ShowJob> {
  TextEditingController searchController = new TextEditingController();
  late QuerySnapshot querySnapshot;
  var user;
  List<JobModel> jobModel = [];
  List<JobModel> dummyJobModel = [];

  fillHomeJobs(u) async {

    CollectionReference _collectionRef = FirebaseFirestore.instance.collection('addjob');
    QuerySnapshot querySnapshot = await _collectionRef.get();

    for(var a in querySnapshot.docs){
      if(u == 'Admin') {
        setState(() {
          jobModel.add(JobModel(
              id: a['id'],
              name: a['author'] == null ? ' ' : a['author'],
              number: a['bar'] == null ? ' ' : a['bar'],
              customNote: a['customn'] == null ? ' ' : a['customn'],
              jobTitle: a['jobtitle'] == null ? ' ' : a['jobtitle'],
              employee: a['emplo'] == null ? ' ' : a['emplo'],
              address: a['des'] == null ? ' ' : a['des'],
              postCode: a['title'] == null ? ' ' : a['title'],
              status: a['status'] == null ? ' ' : a['status'],
              user: a['user'] == null ? ' ' : a['user'],
              product: a['product'] == null ? ' ' : a['product'],
              quatity: a['quantity'] == null ? ' ' : a['quantity'],
              dateBooking: a['descri'] == null ? ' ' : a['descri'],
              dateFitting: a['datef'] == null ? ' ' : a['datef'],
              imgOne: a['imageURL'] == null ? ' ' : a['imageURL'],
              imgTwo: a['imageURL2'] == null ? ' ' : a['imageURL2'],
              imgThree: a['imageURL3'] == null ? ' ' : a['imageURL3'],
              billUrl: a['billURL'] == null ? ' ' : a['billURL']
          ));
        });
        print(a['user']);
      }
      else if(u == a['user']){
        print(a['user']);
        setState(() {
          jobModel.add(JobModel(
              id: a['id'],
              name: a['author'] == null ? ' ' : a['author'],
              number: a['bar'] == null ? ' ' : a['bar'],
              customNote: a['customn'] == null ? ' ' : a['customn'],
              jobTitle: a['jobtitle'] == null ? ' ' : a['jobtitle'],
              employee: a['emplo'] == null ? ' ' : a['emplo'],
              address: a['des'] == null ? ' ' : a['des'],
              postCode: a['title'] == null ? ' ' : a['title'],
              status: a['status'] == null ? ' ' : a['status'],
              user: a['user'] == null ? ' ' : a['user'],
              product: a['product'] == null ? ' ' : a['product'],
              quatity: a['quantity'] == null ? ' ' : a['quantity'],
              dateBooking: a['descri'] == null ? ' ' : a['descri'],
              dateFitting: a['datef'] == null ? ' ' : a['datef'],
              imgOne: a['imageURL'] == null ? ' ' : a['imageURL'],
              imgTwo: a['imageURL2'] == null ? ' ' : a['imageURL2'],
              imgThree: a['imageURL3'] == null ? ' ' : a['imageURL3'],
              billUrl: a['billURL'] == null ? ' ' : a['billURL']
          ));
        });
      }
    }
    setState(() {
      dummyJobModel.addAll(jobModel);
    });

  }
  getUser() async{
    SharedPref pref = new SharedPref();
    var u = await pref.getSession(AppConstants.USER);
    if(u != null){
      setState(() {
        user = u;
        print(user);
      });
      fillHomeJobs(user);
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true,
        backgroundColor: Colors.brown,
        title: TextField(
          controller: searchController,
          onChanged: (t)=>onSearchTextChanged(t),
          style: TextStyle(color: Colors.white,fontSize: 16),
          decoration: InputDecoration(hintText: 'Search Here',hintStyle: TextStyle(color: Colors.white,fontSize: 16),border: InputBorder.none),
        )),
      body:SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(10),
            child: Table(
                columnWidths: {
                  0: FlexColumnWidth(5),
                  1: FlexColumnWidth(2),
                },
                border: TableBorder.all(
                    color: Colors.brown,
                    style: BorderStyle.solid,
                    width: 1),
                children: [
                  TableRow(
                      children: [
                        Container(color: Colors.brown,child:Column(children:[Text('Jobs',style: TextStyle(fontSize: 20,color: Colors.white),)])),
                        Container(color: Colors.brown,child:Column(children:[Icon(Icons.call_to_action_outlined,color: Colors.white,size: 20,)])),
                      ]),
                  for(var x in jobModel)
                    TableRow(children: [
                      Container(color: Colors.white,child:Column(children:[
                        Text('Title : ' +x.jobTitle,style: TextStyle(fontSize: 18),),
                        Text('Address : '+x.address,style: TextStyle(fontSize: 18),),
                        Text('Postal Code : '+x.postCode,style: TextStyle(fontSize: 18),)


                      ])),
                      Container(color: Colors.white,child:Row(children:[
                        IconButton(icon: Icon(Icons.edit,color: Colors.brown,size: 20,),onPressed: (){
                          Get.to(()=>UpdateJob(jobModel: x,t: 'new',))  ;

                        },),
                        IconButton(icon: Icon(Icons.delete,color: Colors.brown,size: 20,),onPressed: (){
                        },)


                      ])),
                    ])

                ]),)
      ),
    );
  }


  onSearchTextChanged(String text) async {
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
            || data.status.toString().toLowerCase().contains(text.toLowerCase())
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

