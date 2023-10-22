import 'package:get/get.dart';

import '../Model/JobModel.dart';

class HomeController extends GetxController{
  List<JobModel> allJobsList = [];
  RxList<JobModel> filteredJobsList = RxList<JobModel>([]);

  void setFilteredList(List<JobModel> updatedList){
    filteredJobsList.value = List.from(updatedList);
  }

}