import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamland/Constants/AppConstants.dart';
import 'package:dreamland/Model/JobModel.dart';
import 'package:dreamland/storage/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'UpdateJob.dart';
import 'ViewJob.dart';

class HomeSearch extends StatefulWidget {
  @override
  State<HomeSearch> createState() => _HomeSearchState();
}

class _HomeSearchState extends State<HomeSearch> {
  TextEditingController searchController = new TextEditingController();
  late QuerySnapshot querySnapshot;
  var user;
  var role;
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
  

  jobCard(int i){
    return Card(
    elevation: 5,
      child: Row(

        children: [
          SizedBox(width: 5,),

          Column(children: [
            jobModel[i].imgOne != "" ? Image.network(jobModel[i].imgOne,height: 150,width: 150,)
                : Image.network(AppConstants.NO_IMAGE,height: 150,width: 150)
          ],),
          SizedBox(width: 15,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            Text('Title : '+jobModel[i].jobTitle,style: TextStyle(color: Colors.black,fontSize: 14),),
            Text('Employee : '+jobModel[i].employee,style: TextStyle(color: Colors.black,fontSize: 14),),
              Text('Address : '+jobModel[i].address,style: TextStyle(color: Colors.black,fontSize: 14),),
            Text('Post Code : '+jobModel[i].postCode,style: TextStyle(color: Colors.black,fontSize: 14),),
            Text('Status Code : '+jobModel[i].status,style: TextStyle(color: Colors.black,fontSize: 14),),
              SizedBox(height: 10,),
              Row(
                children: [
                  ClipOval(
                    child: Material(
                      color: Colors.brown, // Button color
                      child: InkWell(
                        splashColor: Colors.brown[200], // Splash color
                        onTap: () {
                          Get.to(()=>UpdateJob(jobModel: jobModel[i],t: 'new',));
                        },
                        child: SizedBox(width: 40, height: 40, child: Icon(Icons.edit,color: Colors.white,)),
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
                          Get.to(()=>ViewJob(jobModel: jobModel[i]));
                        },
                        child: SizedBox(width: 40, height: 40, child: Icon(Icons.sticky_note_2_outlined,color: Colors.white,)),
                      ),
                    ),
                  )

                ],)


            ],),

        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
getUser();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Padding(padding:EdgeInsets.only(top: 10,left: 10,right: 10) ,
        child:Column(
        children: [
          TextField(
            onChanged: (txt)=>onSearchTextChanged(txt),
            controller: searchController,
            decoration: InputDecoration(
                labelText: 'Search Here',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1.5, color: Colors.brown),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1.5, color: Colors.brown),
                  borderRadius: BorderRadius.circular(15),
                )),
          ),        Container(height: MediaQuery.of(context).size.height * 0.8, child:
        ListView.builder(
          scrollDirection:Axis.vertical,
            itemCount: jobModel.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context,int index){
              return jobCard(index);
            })
        )
      ],
    )
    ));
  }

  onSearchTextChanged(String text) async {
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
