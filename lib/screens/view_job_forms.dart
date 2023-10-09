import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamland/Constants/AppConstants.dart';
import 'package:dreamland/Constants/colors.dart';
import 'package:dreamland/Model/job_form_model.dart';
import 'package:dreamland/controllers/view_job_forms_controller.dart';
import 'package:dreamland/utils/global_functions.dart';
import 'package:dreamland/widgets/busy_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ViewJobForms extends StatelessWidget {
  ViewJobForms({Key? key, }) : super(key: key);

  final ViewJobFormsController controller = ViewJobFormsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Forms'),
        centerTitle: true,
        backgroundColor: AppColors.kcPrimaryColor,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection(CollectionKeys.jobForms).snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot) {
            if(snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if(snapshot.connectionState == ConnectionState.waiting || !(snapshot.hasData)) {
              return const Center(child: CircularProgressIndicator());
            }

            List<JobFormModel> jobForms = snapshot.data!.docs.map((e) => JobFormModel.fromMap(e.data())).toList();

            return ListView.builder(
                itemCount: jobForms.length,
                itemBuilder: (context, index) {
                  return _buildJobFormTile(jobForms[index]);
                });
          }
      ),
    );
  }

  Widget _buildJobFormTile(JobFormModel jobForm){
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        )
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 25.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Row(
            children: [
              Text(jobForm.jobRefNo ?? 'Empty Ref No',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(dateFormat.format(jobForm.createdAt ?? DateTime(2023,10,8)) ,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                )
              ),
            ],
          ),
          10.verticalSpace,
          Row(
            children: [
              Text(jobForm.customerName ?? 'Empty Customer Name',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Builder(
            builder: (context) {
              bool hasPdf = !(jobForm.pdfLink==null);
              return Obx(() => Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                child: BusyButton(
                    busy: controller.loading.value,
                    title: (!hasPdf) ? 'Create Job Form': 'View Job Form',
                    bgColor: hasPdf ? Colors.green : AppColors.kcPrimaryColor,
                    onPressed: () async{
                      await controller.handleMainButtonTap(jobForm);
                    },
                  onLongPress: () async{
                      await controller.overwritePdf(jobForm);
                  },

                ),
              ));
            }
          ),
          10.verticalSpace,
        ],
      ),
    );
  }
}
