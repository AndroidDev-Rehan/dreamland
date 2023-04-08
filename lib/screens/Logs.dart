import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Logs extends StatefulWidget {
  var jobid;
  Logs({this.jobid});
  @override
  State<Logs> createState() => _LogsState();
}

class LogModel{
  var date;
  var name;
  var status;
  LogModel({this.date,this.status,this.name});
}
class _LogsState extends State<Logs> {

  List<LogModel> logs = [];
  fillLogs() async{
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection('logs');
    QuerySnapshot querySnapshot = await _collectionRef.orderBy('date',descending: true).get();
    for(var a in querySnapshot.docs) {
      print(a);
      if(a['jobid'] == widget.jobid)
        {
          setState(() {
            print(a["date"]);
            logs.add(LogModel(date: a['date'],status: a['status'],name: a['employee']));
          });
        }
    }

  }

  Widget logList(i){
    print(logs[i].date.runtimeType);
    String datee = (logs[i].date).toString();
    print(datee);
    return Padding(padding: EdgeInsets.only(left: 10,right: 5,top:20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(DateFormat("dd-MM-yyyy kk:mm:ss").format(DateTime.parse(datee)).toString(),style: TextStyle(fontSize: 15), maxLines: 1, softWrap: false,),

        SizedBox(height: 5,),
        Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          // alignment: WrapAlignment.start,
          // runAlignment: WrapAlignment.start,
          children: [

            Text(logs[i].name ?? '',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 15),),
            const Text(' has marked job as ',style: TextStyle(fontSize: 15),),
            Text(logs[i].status,style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 15),),
            const Text('. '),
          ],
        ),
      ],
    ),);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fillLogs();
  }
  @override
  Widget build(BuildContext context) {
    // print(FirebaseAuth.instance.currentUser!);
    return Scaffold(
        appBar: AppBar(centerTitle: true,
          backgroundColor: Colors.brown,
          title: Text('Logs'),),
        body:Container(
            color: Colors.white,
            child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (BuildContext ctx,int i){
                  return logList(i);
                })
        ));
  }
}
