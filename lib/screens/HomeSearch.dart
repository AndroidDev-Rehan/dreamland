import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamland/Constants/AppConstants.dart';
import 'package:dreamland/Model/JobModel.dart';
import 'package:dreamland/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'UpdateJob.dart';
import 'ViewJob.dart';

class HomeSearch extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
  final HomeController homeController = HomeController();

  HomeSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
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
                  stream: FirebaseFirestore.instance
                      .collection('addjob')
                      .orderBy("createdAt", descending: true)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !(snapshot.hasData)) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    fillHomeJobs(snapshot.data!);

                    debugPrint(
                        'allJobsList length: ${homeController.allJobsList.length}');

                    homeController.filteredJobsList.value = List.from(homeController.allJobsList);

                    return Obx(() => ListView.builder(
                        itemCount: homeController.filteredJobsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return jobCard(homeController.filteredJobsList[index]);
                        }));
                  }),
            )
          ],
        ));
  }

  Widget jobCard(JobModel jobModel) {
    return Card(
      elevation: 5,
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          CachedNetworkImage(
            imageUrl: jobModel.imgOne != ""
                ? jobModel.imgOne
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
                  'Title : ${jobModel.jobTitle}',
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
                Text(
                  'Employee : ${jobModel.employee}',
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
                Text(
                  'Address : ${jobModel.address}',
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
                Text(
                  'Post Code : ${jobModel.postCode}',
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
                Text(
                  'Status Code : ${jobModel.status}',
                  style: const TextStyle(color: Colors.black, fontSize: 14),
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
                                  jobModel: jobModel,
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
                            Get.to(() => ViewJob(
                                jobModel: jobModel));
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

  void fillHomeJobs(QuerySnapshot<Map<String, dynamic>> querySnapshot) {
    homeController.allJobsList =
        querySnapshot.docs.map((QueryDocumentSnapshot<Map> documentSnapshot) {
      Map a = documentSnapshot.data();
      return JobModel(
        id: a['id'],
        name: a['author'] ?? '',
        number: a['bar'] ?? '',
        customNote: a['customn'] ?? '',
        jobTitle: a['jobtitle'] ?? '',
        employee: a['emplo'] ?? '',
        address: a['des'] ?? '',
        postCode: a['title'] ?? '',
        status: a['status'] ?? '',
        user: a['user'] ?? '',
        product: a['product'] ?? '',
        quatity: a['quantity'] ?? '',
        dateBooking: a['descri'] ?? '',
        dateFitting: a['datef'] ?? '',
        imgOne: a['imageURL'] ?? '',
        imgTwo: a['imageURL2'] ?? '',
        imgThree: a['imageURL3'] ?? '',
        billUrl: a['billURL'] ?? '',
        number2: a['phone2'] ?? '',
      );
    }).toList();
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  void onSearchTextChanged(String text) async {
    if (text.trim().isEmpty)
      {
        homeController.setFilteredList(homeController.allJobsList);
        return;
      }

    if (isNumeric(text)) {
      onSearchTextChangedV2(text);
      return;
    }

    homeController.setFilteredList(homeController.allJobsList
        .where((data) => (data.postCode
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
            data.address.toString().toLowerCase().contains(text.toLowerCase())))
        .toList());
  }

  ///For numbers search
  void onSearchTextChangedV2(String text) async {
    if (text.isEmpty) {
      // setState(() {
      //   homeController.allJobsList.addAll(dummyJobModel);
      // });
    } else {
      homeController.setFilteredList(homeController.allJobsList
          .where((data) =>
              data.number
                  .toString()
                  .toLowerCase()
                  .contains(text.toLowerCase()) ||
              data.address
                  .toString()
                  .toLowerCase()
                  .contains(text.toLowerCase()))
          .toList());
    }
  }
}
