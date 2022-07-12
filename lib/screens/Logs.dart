import 'package:cloud_firestore/cloud_firestore.dart';
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
      if(a['jobid'] == widget.jobid)
        {
          setState(() {
            logs.add(LogModel(date: a['date'],status: a['status'],name: a['employee']));
          });
        }
    }

  }

  logList(i){
    return Padding(padding: EdgeInsets.only(left: 5,right: 5,top:5),
    child: Column(children: [
      SizedBox(height: 5,),
      Row(
        children: [

          Text(logs[i].name != null ? logs[i].name : '',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 15),),
          Text(' has marked job as ',style: TextStyle(fontSize: 15),),
          Text(logs[i].status,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 15),),
          Text(' - '),
          Text(DateFormat('dd-MM-yyyy HH:mm:s a').format(DateTime.parse(logs[i].date)),style: TextStyle(fontSize: 15)),
        ],
      )
    ]),);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fillLogs();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true,
          backgroundColor: Colors.brown,
          title: Text('Logs'),),
        body:Container(
            color: Colors.white,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: logs.length,
                itemBuilder: (BuildContext ctx,int i){
                  return logList(i);
                })
        ));
  }
}
