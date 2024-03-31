import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cards_record/core/app_functions.dart';

import '../../controllers/add_batch_controller.dart';
import '../../components/main_drawer.dart';

class AddBatchScreen extends StatelessWidget {
  AddBatchScreen({super.key});

  final AddBatchController addBController = Get.find();
  @override
  Widget build(BuildContext context) {
    // print(addBController.distValue);
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title:  Text("Add Batch".tr),
        actions: [
          IconButton(
            onPressed: () => addBController.addBatchWidget(),
            icon: const Icon(Icons.add_circle_outline_rounded),
            splashColor: Colors.white,
          ),
          IconButton(
            onPressed: addBController.saveBatch,
            icon: const Icon(Icons.save),
            splashColor: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Obx(
                  ()=> Text(
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
                onPressed: () async{
                  addBController.batchDate.value = await getDateAndTimeFromUser(addBController.batchDate.value);
                  // showDatePicker(
                  //   context: context,
                  //   initialDate: addBController.batchDate.value,
                  //   firstDate: DateTime(2019),
                  //   lastDate: DateTime(2050),
                  // ).then((value) {
                  //   addBController.batchDate.value =
                  //       value ?? addBController.batchDate.value;
                  // });
                },
                icon: const Icon(
                  Icons.edit,
                  // color: Colors.blue,
                ),
                splashColor: const Color(0xffAD7BE9),
              ),
            ],
          ),

          // card لاختيار الموزع
          GetBuilder(
            init: AddBatchController(),
            builder:(con) => Card(
              color: const Color(0xffeae4e9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 4,
              margin: EdgeInsets.symmetric(
                  horizontal: widthScreen * 0.02, vertical: 8),
              child: con.buildDropDownButtonWithLabel(
                label:"Distributor",
                hint:"select distributor name",
                items:con.distributors,
                onChanged: (value) {con.distValue = value!= null?int.parse(value.toString()):-1;},
                value: con.distValue == -1 ? null : con.distValue,
              ),
            ),
          ),
          const Divider(color: Colors.black38),

          Expanded(
            child: GetBuilder(
              init: AddBatchController(),
              builder: (controller) => ListView.builder(
                itemBuilder: (context, index) => controller.buildBatchWidget(index),
                itemCount: controller.keys,
              ),
            ),
          ),

          // زر اضافة فئة اخرى
          // Align(
          //   alignment: const Alignment(0, 0.90),
          //   child: ElevatedButton(
          //     onPressed: () => addBatchController.addBatchWidget(),
          //     child: const Text("Another Category"),
          //   ),
          // )
        ],
      ),
      drawer: const MainDrawer(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: ()=>addBController.reset2(),
      //   child: Icon(Icons.refresh),
      // ),
    );
  }
}
