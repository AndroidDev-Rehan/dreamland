import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


import '../Constants/AppConstants.dart';
import '../Model/JobModel.dart';
import '../storage/SharedPref.dart';
import 'UpdateJob.dart';
import 'ViewJob.dart';



class JobCalendar extends StatefulWidget {
  var type;
  JobCalendar({this.type});
  @override
  State<JobCalendar> createState() => _JobCalendarState();
}

class _JobCalendarState extends State<JobCalendar> {
  List<JobModel> jobsList = [];
  List<JobModel> eventjobModel = [];
  late QuerySnapshot querySnapshot;
  var user;
  var role;
  var current = DateTime.now();
  List<Color> clr = [];
  bool done = false;
  DateTime todayDate = DateTime.now();



  final EventList<Event> _markedDateMap = EventList<Event>(
    events: {
      DateTime(2022, 6, 20): [
        Event(
          date: DateTime(2022, 6, 21),
          title: 'Event 1',
          dot: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            height: 7.0,
            width: 7.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red
            ),
          ),
        ),

      ],
    },
  );

  Map<String,List<bool>> dateStatus = {};

  Future<void> fillHomeJobs() async {

    if(done == true){
      return;
    }

    print("filling home jobs");
    _markedDateMap.clear();
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection('addjob');
    QuerySnapshot querySnapshot = await _collectionRef.get();

    for(var a in querySnapshot.docs){

      ///it was in setstate

      jobsList.add(JobModel(
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

      ));

      // setState(() {
      // });

    }



    for(var a in jobsList){

      // bool holdAdded = false;
      // bool completedAdded = false;
      // bool redAdded = false;
      // bool blueAdded = false;


      DateTime? time = DateFormat("dd-MM-yyyy").parse(a.dateFitting);
      if(a.status == 'Hold'){

        // dateStatus[time.toString()] = dateS
        if((dateStatus[time.toString()]==null) || (!((dateStatus[time.toString()])![0]) ) )
        {
          _markedDateMap.add(
              time,
              Event(
                date: time,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  height: 5.0,
                  width: 5.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orange),
                ),
              ));

        }

        if(dateStatus[time.toString()] == null){
          dateStatus[time.toString()] = <bool>[true,false,false,false];
        }
        else{
          dateStatus[time.toString()]![0] = true;
        }


      }
      else if((a.status == 'Completed' || a.status == 'Delivery Complete')){
        // completedAdded = true;
        print("completed spotted: $time, status: ${a.status}");

        if((dateStatus[time.toString()]==null) || (!((dateStatus[time.toString()])![1]) ) )
        {
          _markedDateMap.add(
              time,
              Event(
                date: time,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  height: 5.0,
                  width: 5.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green),
                ),
              ));
        }

        if(dateStatus[time.toString()] == null){
          dateStatus[time.toString()] = <bool>[false,true,false,false];
        }
        else{
          dateStatus[time.toString()]![1] = true;
        }

      }
      else if((DateTime(todayDate.year,todayDate.month,todayDate.day).isAfter(time) && a.status != 'Completed')){
        // redAdded = true;
        if((dateStatus[time.toString()]==null) || (!((dateStatus[time.toString()])![2]) ) )
        {
          _markedDateMap.add(
              time,
              Event(
                date: time,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  height: 5.0,
                  width: 5.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red),
                ),
              ));
        }

        if(dateStatus[time.toString()] == null){
          dateStatus[time.toString()] = <bool>[false,false,true,false];
        }
        else{
          dateStatus[time.toString()]![2] = true;
        }

      }
      else
      //   if(
      // time.isAfter( DateTime(todayDate.year,todayDate.month,todayDate.day)) && a.status != 'Completed')
      {
        if((dateStatus[time.toString()]==null) || (!((dateStatus[time.toString()])![3]) ) )
        {
          _markedDateMap.add(
              time,
              Event(
                date: time,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  height: 5.0,
                  width: 5.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue),
                ),
              ));
        }

        if(dateStatus[time.toString()] == null){
          dateStatus[time.toString()] = <bool>[false,false,false,true];
        }
        else{
          dateStatus[time.toString()]![3] = true;
        }

      }
      // setState(() {});

    }

    fillEvents( DateTime(current.year,current.month,current.day));
    done = true;
    return ;
  }


  fillEvents(d){

    var dateFormat = DateFormat('dd-MM-yyyy').format(d);
    var todayFormat = DateFormat('dd-MM-yyyy').format(todayDate);
    print('currrrr $dateFormat');
    eventjobModel.clear();
    clr.clear();
    for(var a in jobsList){
      if(a.dateFitting == dateFormat){
        print('fitting date ' + a.dateFitting + '/ selected date '+dateFormat + ' and status is '+a.status );
        DateTime? time = DateFormat("dd-MM-yyyy").parse(a.dateFitting);

        eventjobModel.add( JobModel(
            id: a.id,
            name: a.name,
            status: a.status,
            billUrl: a.billUrl,
            imgThree: a.imgThree,
            imgTwo: a.imgTwo,
            imgOne: a.imgOne,
            dateFitting: a.dateFitting,
            dateBooking: a.dateBooking,
            quatity: a.quatity,
            product: a.product,
            user: a.user,
            postCode: a.postCode,
            address: a.address,
            employee: a.employee,
            jobTitle: a.jobTitle,
            customNote: a.customNote,
            number: a.number
        ));

        if(a.status == 'Hold'){
          clr.add(Colors.orange);
        }
        else if(a.status == 'Completed'
            || a.status == 'Delivery Complete'
        ){
          clr.add(Colors.green);
        }
        else if( DateTime(todayDate.year,todayDate.month,todayDate.day).isAfter(time) && a.status != 'Completed'){
          clr.add(Colors.red);
          print("status is : ${a.status}");
        }
        else if(time.isAfter( DateTime(todayDate.year,todayDate.month,todayDate.day)) && a.status != 'Completed'){
          clr.add(Colors.blue);
        }
        else if(a.dateFitting == todayFormat){
          clr.add(Colors.blue);
        }

        // setState(() {});
      }
    }
    return ;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  jobCard(int i){
    return Card(
      elevation: 5,
      child: Row(

        children: [
          SizedBox(width: 5,),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            height: 30.0,
            width: 30.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: clr[i]
            ),
          ),

          SizedBox(width: 5,),

          Column(children: [
            eventjobModel[i].imgOne != "" ? Image.network(eventjobModel[i].imgOne,height: 100,width: 100,)
                : Image.network(AppConstants.NO_IMAGE,height: 100,width: 100)
          ],),
          SizedBox(width: 15,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(width: MediaQuery.of(context).size.width * 0.4,child:Text('Title : '+eventjobModel[i].jobTitle,style: TextStyle(color: Colors.black,fontSize: 14), overflow: TextOverflow.ellipsis, softWrap: false,)),
                SizedBox(width: MediaQuery.of(context).size.width * 0.4,child:Text('Employee : '+eventjobModel[i].employee,style: TextStyle(color: Colors.black,fontSize: 14),overflow: TextOverflow.ellipsis, softWrap: false,)),
                Text('Address : '+eventjobModel[i].address,style: TextStyle(color: Colors.black,fontSize: 14),overflow: TextOverflow.ellipsis, softWrap: false,),
                SizedBox(width: MediaQuery.of(context).size.width * 0.4,child:Text('Post Code : '+eventjobModel[i].postCode,style: TextStyle(color: Colors.black,fontSize: 14),overflow: TextOverflow.ellipsis, softWrap: false,)),
                Text('Status Code : '+eventjobModel[i].status,style: TextStyle(color: Colors.black,fontSize: 14),overflow: TextOverflow.ellipsis, softWrap: false,),
                SizedBox(width: MediaQuery.of(context).size.width * 0.4,child:Text('Fitting Date : '+eventjobModel[i].dateFitting,style: TextStyle(color: Colors.black,fontSize: 14),overflow: TextOverflow.ellipsis, softWrap: false,)),
                SizedBox(height: 10,),
                Row(
                  children: [
                    ClipOval(
                      child: Material(
                        color: Colors.brown, // Button color
                        child: InkWell(
                          splashColor: Colors.brown[200], // Splash color
                          onTap: () {
                            Get.to(()=>UpdateJob(jobModel: eventjobModel[i],t: 'reload',));
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
                            Get.to(()=>ViewJob(jobModel: eventjobModel[i]));
                          },
                          child: SizedBox(width: 40, height: 40, child: Icon(Icons.sticky_note_2_outlined,color: Colors.white,)),
                        ),
                      ),
                    )

                  ],)


              ],),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Job Calendar'),
        backgroundColor: Colors.brown,
      ),
      body: done ? SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height / 1.9,
                child: CalendarCarousel<Event>(
                  selectedDateTime: current,
                  todayTextStyle: TextStyle(color: Colors.black),
                  selectedDayButtonColor: Colors.brown,
                  todayButtonColor: Colors.blueGrey,
                  todayBorderColor: Colors.transparent,
                  onDayPressed: (DateTime date, List<Event> events) {
                    setState(() {

                      current = date;
                      print(current);
                    });
                    fillEvents( DateTime(date.year,date.month,date.day));
                  },
                  markedDatesMap: _markedDateMap,
                  // markedDateIconMaxShown: 2,
                  // markedDateMoreShowTotal: true,
                  weekendTextStyle: const TextStyle(
                    color: Colors.black12,
                  ),
                  thisMonthDayBorderColor: Colors.grey,
                  daysHaveCircularBorder: false,

                )
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.0),
                      height: 15.0,
                      width: 15.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green
                      ),
                    ),
                    Text('Completed')],
                ),
                SizedBox(width: 5,),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.0),
                      height: 15.0,
                      width: 15.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red
                      ),
                    ),
                    Text('Job Aft Due Date')],
                ),
                SizedBox(width: 5,),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.0),
                      height: 15.0,
                      width: 15.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue
                      ),
                    ),
                    Text('Queue Jobs')],
                ),
                SizedBox(width: 5,),
                Flexible(
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 1.0),
                        height: 15.0,
                        width: 15.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.orange
                        ),
                      ),
                      const Flexible(child: Text('Hold Jobs',maxLines: 1,softWrap: false,),)],
                  ),
                )
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Total Jobs On ${DateFormat('dd-MM-yyyy').format(current)} are : ${eventjobModel.length}',style: TextStyle(fontSize: 18),)
              ],),
            SizedBox(height: 10,),
            ListView.builder(
                physics:  BouncingScrollPhysics(),
                itemCount: eventjobModel.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext ctx,int i){
                  return jobCard(i);
                })
          ],
        ),
      )  : FutureBuilder(
        future: fillHomeJobs(),
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: Text("Loading Calendar and Jobs.."),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height / 1.9,
                    child: CalendarCarousel<Event>(
                      selectedDateTime: current,
                      todayTextStyle: const TextStyle(color: Colors.black),
                      selectedDayButtonColor: Colors.brown,
                      todayButtonColor: Colors.blueGrey,
                      todayBorderColor: Colors.transparent,
                      onDayPressed: (DateTime date, List<Event> events) {
                        setState(() {

                          current = date;
                          print(current);
                        });
                        fillEvents( DateTime(date.year,date.month,date.day));
                      },
                      markedDatesMap: _markedDateMap,
                      // markedDateIconMaxShown: 2,
                      markedDateMoreShowTotal: true,
                      weekendTextStyle: const TextStyle(
                        color: Colors.black12,
                      ),
                      thisMonthDayBorderColor: Colors.grey,
                      daysHaveCircularBorder: false,

                    )
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 1.0),
                          height: 15.0,
                          width: 15.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green
                          ),
                        ),
                        Text('Completed')],
                    ),
                    SizedBox(width: 5,),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 1.0),
                          height: 15.0,
                          width: 15.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red
                          ),
                        ),
                        Text('Job Aft Due Date')],
                    ),
                    SizedBox(width: 5,),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 1.0),
                          height: 15.0,
                          width: 15.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue
                          ),
                        ),
                        Text('Queue Jobs')],
                    ),
                    SizedBox(width: 5,),
                    Flexible(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 1.0),
                            height: 15.0,
                            width: 15.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.orange
                            ),
                          ),
                          const Flexible(child: Text('Hold Jobs',maxLines: 1,softWrap: false,),)],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Total Jobs On ${DateFormat('dd-MM-yyyy').format(current)} are : ${eventjobModel.length}',style: TextStyle(fontSize: 18),)
                  ],),
                SizedBox(height: 10,),
                ListView.builder(
                    physics:  BouncingScrollPhysics(),
                    itemCount: eventjobModel.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext ctx,int i){
                      return jobCard(i);
                    })
              ],
            ),
          );
        }
      ),
    );
  }
}
