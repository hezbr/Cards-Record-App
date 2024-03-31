import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/main_drawer.dart';
import '../../controllers/distributors_controller.dart';
import '../widgets/public_widget.dart'
    show buildCancelElevatedButton, buildDialog;

class DistributorsScreen extends StatelessWidget {
  DistributorsScreen({super.key});

  final DistributorsController distController = Get.find();
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(title: Text("Distributors".tr)),
      drawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: GetBuilder(
          init: DistributorsController(),
          builder: (controller) {
            if (controller.distributors.isEmpty) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: Get.mediaQuery.size.height / 3),
                child: Text(
                  "No Distributors found".tr,
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return ListView.builder(
                itemBuilder: (context, index) => InkWell(
                  onTap: () => controller.buildUpdateDistributorWidget(
                      controller.distributors[index]),
                  child: controller
                      .buildDistributorCard(controller.distributors[index]),
                ),
                itemCount: controller.distributors.length,
              );
            }
          },
        ),
      ),
      // زر اضافة موزع جديدة
      floatingActionButton: SizedBox(
        height: 45,
        child: FloatingActionButton.extended(
          onPressed: () => buildDialog(
            title: "New Ditributer",
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  distController.buildTextFieldForm(label: "Distributor Name"),
                  distController.buildTextFieldForm(
                      label: "Phone (optional)".tr),
                ],
              ),
            ),
            actionToolsList: [
              SizedBox(
                width: Get.mediaQuery.size.width * 0.30,
                child: ElevatedButton(
                  // style: ElevatedButton.styleFrom(
                  //     textStyle: Get.textTheme.titleSmall),
                  onPressed: () => distController.saveDistributor(
                      formKey: _formKey, isEdit: false, editId: 0),
                  child: Text("Ok".tr),
                ),
              ),
              SizedBox(
                width: Get.mediaQuery.size.width * 0.30,
                child: buildCancelElevatedButton(),
              ),
            ],
          ),
          label: Text("Add Distributor".tr),
          icon: Icon(Icons.add_box_rounded),
          tooltip: "Click to add new distributer",
        ),
      ),
    );
  }
}
