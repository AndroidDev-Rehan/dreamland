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
  List<JobModel> jobModel = [];
  List<JobModel> eventjobModel = [];
  late QuerySnapshot querySnapshot;
  var user;
  var role;
  var current = DateTime.now();
  List<Color> clr = [];

  DateTime todayDate = DateTime.now();

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime(2022, 6, 20): [
        new Event(
          date: new DateTime(2022, 6, 21),
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

  fillHomeJobs(u) async {
  _markedDateMap.clear();
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
      }
      else if(u == a['user']){

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

    for(var a in jobModel){


      setState(() {

        DateTime? newTime = DateFormat("dd-MM-yyyy").parse(a.dateFitting);
      if(a.status == 'Hold'){
        _markedDateMap.add(newTime,
            new Event(date: newTime,
              dot: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                height: 5.0,
                width: 5.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.orange
                ),
              ),)
        );
      }
      else if(a.status == 'Completed'){
        _markedDateMap.add(newTime,
            new Event(date: newTime,
              dot: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                height: 5.0,
                width: 5.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green
                ),
              ),)
        );
      }
      else if(new DateTime(todayDate.year,todayDate.month,todayDate.day).isAfter(newTime) && a.status != 'Completed'){
        _markedDateMap.add(newTime,
            new Event(date: newTime,
              dot: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                height: 5.0,
                width: 5.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red
                ),
              ),)
        );

      }
      else if(newTime.isAfter(new DateTime(todayDate.year,todayDate.month,todayDate.day)) && a.status != 'Completed'){
        _markedDateMap.add(newTime,
            new Event(date: newTime,
              dot: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                height: 5.0,
                width: 5.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue
                ),
              ),)
        );

      }
      });

    }

    fillEvents(new DateTime(current.year,current.month,current.day));
  }


  fillEvents(d){

    var dateFormat = DateFormat('dd-MM-yyyy').format(d);
    var todayFormat = DateFormat('dd-MM-yyyy').format(todayDate);
    print('currrrr $dateFormat');
    eventjobModel.clear();
    clr.clear();
    for(var a in jobModel){
        if(a.dateFitting == dateFormat){
          print('fitting date ' + a.dateFitting + '/ selected date '+dateFormat + ' and status is '+a.status );
          setState(() {
            DateTime? newTime = DateFormat("dd-MM-yyyy").parse(a.dateFitting);

            eventjobModel.add(new JobModel(
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
            else if(a.status == 'Completed'){
              clr.add(Colors.green);
            }
            else if(new DateTime(todayDate.year,todayDate.month,todayDate.day).isAfter(newTime) && a.status != 'Completed'){
        clr.add(Colors.red);
            }
            else if(newTime.isAfter(new DateTime(todayDate.year,todayDate.month,todayDate.day)) && a.status != 'Completed'){
            clr.add(Colors.blue);
            }
            else if(a.dateFitting == todayFormat){
              clr.add(Colors.blue);
            }


          });
        }
    }
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
            eventjobModel[i].imgOne != "" ? Image.network(eventjobModel[i].imgOne,height: 150,width: 150,)
                : Image.network(AppConstants.NO_IMAGE,height: 150,width: 150)
          ],),
          SizedBox(width: 15,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(width: MediaQuery.of(context).size.width * 0.4,child:Text('Title : '+eventjobModel[i].jobTitle,style: TextStyle(color: Colors.black,fontSize: 14), overflow: TextOverflow.ellipsis, softWrap: false,)),
              SizedBox(width: MediaQuery.of(context).size.width * 0.4,child:Text('Employee : '+eventjobModel[i].employee,style: TextStyle(color: Colors.black,fontSize: 14),overflow: TextOverflow.ellipsis, softWrap: false,)),
              SizedBox(width: MediaQuery.of(context).size.width * 0.4,child:Text('Address : '+eventjobModel[i].address,style: TextStyle(color: Colors.black,fontSize: 14),overflow: TextOverflow.ellipsis, softWrap: false,)),
              SizedBox(width: MediaQuery.of(context).size.width * 0.4,child:Text('Post Code : '+eventjobModel[i].postCode,style: TextStyle(color: Colors.black,fontSize: 14),overflow: TextOverflow.ellipsis, softWrap: false,)),
              SizedBox(width: MediaQuery.of(context).size.width * 0.4,child:Text('Status Code : '+eventjobModel[i].status,style: TextStyle(color: Colors.black,fontSize: 14),overflow: TextOverflow.ellipsis, softWrap: false,)),
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

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Job Calendar'),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
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
                 fillEvents(new DateTime(date.year,date.month,date.day));
                },
                markedDatesMap: _markedDateMap,
                weekendTextStyle: TextStyle(
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
                  SizedBox(width: 10,),
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
                      Text('Job After Que Date')],
                  ),
                SizedBox(width: 10,),
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
                SizedBox(width: 10,),
                Row(
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
                    Text('Hold Jobs')],
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
      ),
    );
  }
}
