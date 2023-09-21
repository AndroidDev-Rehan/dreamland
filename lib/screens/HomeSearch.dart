import 'package:cached_network_image/cached_network_image.dart';
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
  // late QuerySnapshot querySnapshot;
  List<JobModel> allJobsList = [];
  List<JobModel> dummyJobModel = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          children: [
            TextField(
              onChanged: (txt) => onSearchTextChanged(txt),
              controller: searchController,
              decoration: InputDecoration(
                  labelText: 'Search Here',
                  labelStyle: const TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1.5, color: Colors.brown),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1.5, color: Colors.brown),
                    borderRadius: BorderRadius.circular(15),
                  )),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('addjob').orderBy("createdAt", descending: true).snapshots(),
                builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot) {

                  if(snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  }

                  if(snapshot.connectionState == ConnectionState.waiting || !(snapshot.hasData)) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  fillHomeJobs(snapshot.data!);

                  return ListView.builder(
                      itemCount: allJobsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return jobCard(index);
                      });
                }
              ),
            )
          ],
        ));
  }

  Widget jobCard(int i) {
    return Card(
      elevation: 5,
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          CachedNetworkImage(
            imageUrl: allJobsList[i].imgOne != ""
                ? allJobsList[i].imgOne
                : AppConstants.NO_IMAGE,
            height: 150,
            width: 150,
            placeholder: (context, url) => const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image),
                SizedBox(
                  height: 10,
                ),
                Text('Loading...'),
              ],
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const SizedBox(
            width: 15,
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title : ' + allJobsList[i].jobTitle,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                Text(
                  'Employee : ' + allJobsList[i].employee,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                Text(
                  'Address : ' + allJobsList[i].address,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                Text(
                  'Post Code : ' + allJobsList[i].postCode,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                Text(
                  'Status Code : ' + allJobsList[i].status,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    ClipOval(
                      child: Material(
                        color: Colors.brown, // Button color
                        child: InkWell(
                          splashColor: Colors.brown[200], // Splash color
                          onTap: () {
                            Get.to(() => UpdateJob(
                              jobModel: allJobsList[i],
                              t: 'new',
                            ));
                          },
                          child: const SizedBox(
                              width: 40,
                              height: 40,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.brown, // Button color
                        child: InkWell(
                          splashColor: Colors.brown[200], // Splash color
                          onTap: () {
                            Get.to(() => ViewJob(jobModel: allJobsList[i]));
                          },
                          child: const SizedBox(
                              width: 40,
                              height: 40,
                              child: Icon(
                                Icons.sticky_note_2_outlined,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void fillHomeJobs(QuerySnapshot<Map<String,dynamic>> querySnapshot) async {

    allJobsList =  querySnapshot.docs.map((QueryDocumentSnapshot<Map> documentSnapshot){
      Map a = documentSnapshot.data();
      return JobModel(
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
        billUrl: a['billURL'] == null ? ' ' : a['billURL'],
        number2: a['phone2'] == null ? ' ' : a['phone2'],
      );
    }).toList();
    print("All Jobs List : ${allJobsList.length}");
  }


  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  onSearchTextChanged(String text) async {
    if (isNumeric(text)) {
      onSearchTextChangedV2(text);
      return;
    }

    setState(() {
      allJobsList.clear();
    });
    if (text.isEmpty || text == '') {
      setState(() {
        allJobsList.addAll(dummyJobModel);
      });
    } else {
      print(allJobsList.length);
      print(dummyJobModel.length);
      dummyJobModel.forEach((data) {
        if (data.postCode
                .toString()
                .toLowerCase()
                .contains(text.toLowerCase()) ||
            data.jobTitle
                .toString()
                .toLowerCase()
                .contains(text.toLowerCase()) ||
            data.employee
                .toString()
                .toLowerCase()
                .contains(text.toLowerCase()) ||
            data.status.toString().toLowerCase().contains(text.toLowerCase()) ||
            data.address
                .toString()
                .toLowerCase()
                .contains(text.toLowerCase())) {
          setState(() {
            allJobsList.add(data);
          });
        }
      });
    }
  }

  ///For numbers search
  onSearchTextChangedV2(String text) async {
    setState(() {
      allJobsList.clear();
    });
    if (text.isEmpty || text == '') {
      setState(() {
        allJobsList.addAll(dummyJobModel);
      });
    } else {
      print(allJobsList.length);
      print(dummyJobModel.length);
      dummyJobModel.forEach((data) {
        if (data.number.toString().toLowerCase().contains(text.toLowerCase()) ||
            data.address
                .toString()
                .toLowerCase()
                .contains(text.toLowerCase())) {
          setState(() {
            allJobsList.add(data);
          });
        }
      });
    }
  }
}
