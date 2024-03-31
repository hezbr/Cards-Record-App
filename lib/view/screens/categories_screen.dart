import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cards_record/controllers/categories_controller.dart';
import 'package:cards_record/models/batch_model.dart';

import '../widgets/category_items.dart';
import '../widgets/public_widget.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});

  final CategoriesController cateController = Get.put(CategoriesController());
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
        children: [
          Obx(
            () => cateController.cateNumber.value == 0
                ? Container(
                    padding:
                        EdgeInsets.only(top: Get.mediaQuery.size.height / 3),
                    child: Text(
                      // "There are no Categories.\n Tab Add Category button to add",
                      "There are no Categories".tr,
                      textAlign: TextAlign.center,
                    ),
                  )
                : Container(
                    padding: EdgeInsets.only(
                      top: 20,
                      bottom: 5,
                      left: widthScreen * 0.02,
                      right: widthScreen * 0.02,
                    ),
                    child: Row(
                      children: [
                        buildContainer(widthScreen * 0.35, "Category"),
                        buildContainer(widthScreen * 0.24, "Price"),
                        buildContainer(widthScreen * 0.16, "Edit"),
                        buildContainer(widthScreen * 0.16, "Delete"),
                      ],
                    ),
                  ),
          ),

          // List<Widget> وذلك بعد تحويلها إلى controller عرض الفئات من مصفوفة الفئات في
          GetBuilder(
            init: CategoriesController(),
            builder: (controller) => Column(
              children: [
                ...controller.categories
                    .map(
                      (cate) => CategoryItem(
                        id: cate.id,
                        categoryName: cate.name,
                        categoryPrice: cate.price,
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ],
      ),
      // زر اضافة فئة جديدة
      floatingActionButton: SizedBox(
        height: 45,
        child: FloatingActionButton.extended(
          onPressed: () => buildDialog(
            title: "New Category",
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  cateController.buildTextFieldForm(label: "Category Name"),
                  cateController.buildTextFieldForm(label: "Purchasing Price"),
                ],
              ),
            ),
            actionToolsList: [
              SizedBox(
                width: Get.mediaQuery.size.width * 0.30,
                child: ElevatedButton(
                  onPressed: () => cateController.saveCategory(
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
          label: Text("Add Category".tr),
          icon: Icon(Icons.add_box_rounded),
          tooltip: "Click to add new category",
        ),
      ),
    );
  }

  Container buildContainer(double width, String text) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: width,
      child: Text(
        text.tr,
        // style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        style: Get.textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
