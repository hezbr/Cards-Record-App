import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cards_record/controllers/operations_controller.dart';
import 'package:cards_record/core/app_functions.dart';
import 'package:cards_record/models/app_Db.dart';
import 'package:cards_record/view/widgets/public_widget.dart';

import '../../controllers/add_batch_controller.dart';
import '../../controllers/batches_controller.dart';

class EditBatchScreen extends StatefulWidget {
  final int batchId;
  final int cateId;
  final int distId;
  final String counts;
  final String date;
  final String note;

  const EditBatchScreen({
    super.key,
    required this.batchId,
    required this.cateId,
    required this.distId,
    required this.counts,
    required this.date,
    required this.note,
  });
  
  
  @override
  State<EditBatchScreen> createState() {
    final AddBatchController addBController = Get.find();
    addBController.reset();
    addBController.batchDate.value= date;
    // addBController.batchDate.value= DateFormat('yyyy/MM/dd').parse(date);
    addBController.distValue= distId;
    addBController.batchData[0] = cateId.toString();
    addBController.batchData[1] = counts.toString();
    addBController.batchData[2] = note;
    return _EditBatchScreenState();
  }
}


class _EditBatchScreenState extends State<EditBatchScreen> {
  @override
  Widget build(BuildContext context) {
    final AddBatchController addBController = Get.find();
    double widthScreen = MediaQuery.of(context).size.width;    
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Batch".tr),
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Obx(
                    ()=> Text(
                  // ${DateFormat('yyyy/MM/dd').format(addBController.batchDate.value)}
                  "${'Batch date'.tr}: ${formatDateToShow(addBController.batchDate.value)}",
                  // "${'Batch date'.tr}: ${DateFormat('yyyy/MM/dd').format(addBController.batchDate.value)}",
                  style: Get.textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ),
              // زر تعديل التاريخ
              IconButton(
                onPressed: () async {
                  addBController.batchDate.value = await getDateAndTimeFromUser(addBController.batchDate.value);
                  // showDatePicker(
                  //   context: context,
                  //   initialDate: addBController.batchDate.value,
                  //   firstDate: DateTime(2019),
                  //   lastDate: DateTime(2050),
                  // ).then((value) {
                  //   addBController.batchDate.value =
                  //     value ?? addBController.batchDate.value;
                  // });
                },
                icon: const Icon(
                  Icons.edit,
                ),
                splashColor: const Color(0xffAD7BE9),
              ),
            ],
          ),

          // card لاختيار الموزع
          GetBuilder<AddBatchController>(
            // init: AddBatchController(),
            builder: (controller) => Card(
              color: const Color(0xffeae4e9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 4,
              margin: EdgeInsets.symmetric(
                  horizontal: widthScreen * 0.02, vertical: 8),
              child: controller.buildDropDownButtonWithLabel(
                  label: "Distributor",
                  hint: "select distributor name",
                  items: controller.distributors,
                  onChanged: (value) {controller.distValue = 
                    (value!=null? int.parse(value.toString()): widget.distId);},
                  value: controller.distValue!=-1?controller.distValue: widget.distId,
                )
            ),
          ),
          const Divider(color: Colors.black38),

          // بطاقة لعرض الفئة والكمية
          GetBuilder(
            init: AddBatchController(),
            builder: (controller) =>
                controller.buildBatchWidget(0, canDelete: false),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: widthScreen * 0.02),
            child: ElevatedButton(
                onPressed: () async{
                  String message = "Batch edited successfully";
                  if (addBController.batchData[1] == "") {
                    message = "The count shoudn't be empty";
                  } else {
                    if (await appDb.updateBatch(
                          Batch_(
                            id: widget.batchId,
                            categoryId: int.parse(addBController.batchData[0]),
                            counts: int.parse(addBController.batchData[1]),
                            note: addBController.batchData[2],
                            date: addBController.batchDate.value,
                            // date: DateFormat('yyyy/MM/dd').format(addBController.batchDate.value),
                            distributorId: addBController.distValue,
                          ),
                        ) != 1) {
                      message = "There is error. try again";
                    }
                    Get.focusScope!.unfocus();
                    Get.back();
                    if (Get.isDialogOpen ?? false) Get.back();
                    buildSnackbar(message);
                    Get.find<OperationsController>().updateOperation();
                    Get.find<BatchesController>().getAndHandleBatches();
                  }
                },
                child: Text("Save".tr)),
          )
        ],
      ),
      // drawer: MainDrawer(),
    );
  }
}
