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
  ViewJobForms({
    Key? key,
  }) : super(key: key);

  final ViewJobFormsController controller = ViewJobFormsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Forms'),
        centerTitle: true,
        backgroundColor: AppColors.kcPrimaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    onChanged: (txt) => controller.onSearchTextChanged(txt),
                    controller: controller.searchController,
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
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: BusyButton(
                  title: 'Clear',
                  onPressed: () => controller.searchController.clear(),
                  busy: false,
                )),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(CollectionKeys.jobForms)
                    .orderBy('createdAt', descending: true)
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

                  controller.allJobForms = snapshot.data!.docs
                      .map((e) => JobFormModel.fromMap(e.data()))
                      .toList();
                  controller.fillLoadingMap(controller.allJobForms.length);
                  controller.filteredJobForms.value =
                      List.from(controller.allJobForms);

                  debugPrint(
                      'allJobsList length: ${controller.allJobForms.length}');

                  return Obx(() => ListView.builder(
                      itemCount: controller.filteredJobForms.length,
                      itemBuilder: (context, index) {
                        return _buildJobFormTile(
                            controller.filteredJobForms[index], index);
                      }));
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildJobFormTile(JobFormModel jobForm, int index) {



    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
        top: index == 0
            ? BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              )
            : BorderSide.none,
      )),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 25.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                jobForm.jobRefNo.getDefaultText(),
                style: getAppropriateTextStyle(jobForm.jobRefNo),
              ),
              Spacer(),
              Text(
                  dateFormat.format(jobForm.createdAt ?? DateTime(2023, 10, 8)),
                  style: getAppropriateTextStyle(dateFormat.format(jobForm.createdAt ?? DateTime(2023, 10, 8)))),
            ],
          ),
          10.verticalSpace,
          Row(
            children: [
              Text(
                jobForm.customerName.capitalizeEveryWord(),
                style: getAppropriateTextStyle(jobForm.customerName,bold: true,fontSize: 18.sp),
              ),
              Spacer(),
              Text(
                jobForm.telNo.getDefaultText(),
                style: getAppropriateTextStyle(jobForm.telNo),
              ),
            ],
          ),
          5.verticalSpace,
          // Row(
          //   children: [
          //     // Text(
          //     //   jobForm.telNo.getDefaultText(),
          //     //   style: getAppropriateTextStyle(jobForm.telNo),
          //     // ),
          //     Spacer(),
          //     // Text(
          //     //     jobForm.postCode.getDefaultText(),
          //     //     style: getAppropriateTextStyle(jobForm.postCode)),
          //   ],
          // ),
          10.verticalSpace,
          Row(
            children: [
              Text(
                jobForm.customerAddress.getDefaultText(),
                style: getAppropriateTextStyle(jobForm.customerAddress),
              ),
              Spacer(),
              Text(
                  jobForm.postCode.getDefaultText(),
                  style: getAppropriateTextStyle(jobForm.postCode))
            ],
          ),
          10.verticalSpace,
          Builder(builder: (context) {
            bool hasPdf = !(jobForm.pdfLink == null);
            return Obx(() => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.w),
                  child: BusyButton(
                    busy: controller.loadingStatesMap[jobForm.id]!.value,
                    title: (!hasPdf) ? 'Create Job Form' : 'View Job Form',
                    bgColor: hasPdf ? Colors.green : AppColors.kcPrimaryColor,
                    onPressed: () async {
                      await controller.handleMainButtonTap(jobForm, index);
                    },
                    onLongPress: () async {
                      await controller.overwritePdf(jobForm, index);
                    },
                  ),
                ));
          }),
          10.verticalSpace,
        ],
      ),
    );
  }

  TextStyle getAppropriateTextStyle(String? text, {bool bold = false, double? fontSize}){
    if(text == null || text.isEmpty){
      return TextStyle(
        fontSize: fontSize ?? 14.sp,
        fontWeight:  bold ? FontWeight.bold : FontWeight.w500,
        fontStyle: FontStyle.italic,
      );
    }

    return TextStyle(
      fontSize: fontSize ?? 14.sp,
      fontWeight:
      bold ? FontWeight.bold : FontWeight.w500,
    );
  }
}
