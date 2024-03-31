import 'package:flutter/material.dart' show Align, Alignment, BorderRadius, BuildContext, Card, Color, Column, Container, EdgeInsets, ElevatedButton, Form, FormState, GlobalKey, Icon, IconButton, IconData, Icons, MediaQuery, RoundedRectangleBorder, Row, SizedBox, StatelessWidget, Text, TextAlign, TextEditingController, Widget;
import 'package:get/get.dart';

import '../../controllers/categories_controller.dart';
import '../../controllers/operations_controller.dart';
import '../../models/app_Db.dart' show appDb;
import 'public_widget.dart' show buildCancelElevatedButton, buildDeleteDialog, buildDialog;

class CategoryItem extends StatelessWidget {
  final int id;
  final String categoryName;
  final int categoryPrice;
  final cateController= Get.put(CategoriesController());
  
  CategoryItem({super.key, 
    required this.id,
    required this.categoryName,
    required this.categoryPrice,
  });

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController= TextEditingController();
  final TextEditingController _priceController= TextEditingController();

  Container buildContainer(double width, String text) {
    return Container(
      padding: const EdgeInsets.all(4),
      width: width,
      child: Text(
        text,
        style: Get.textTheme.titleSmall,
        textAlign: TextAlign.center,
      ),
    );
  }

  SizedBox buildIconContainer(double width, IconData icon,
      {required var onPressed, Color? iconColor}) {
    return SizedBox(
      // padding: const EdgeInsets.all(0),
      width: width,
      child: Align(
        alignment: Alignment.center,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: 1.5 * Get.textTheme.titleSmall!.fontSize!),
          color: iconColor,
          splashColor: const Color(0xffAD7BE9),
          padding: const EdgeInsets.all(0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return Card(
      // color: Color(0xffeae4e9)
      color: const Color(0xffdfe7fd),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: widthScreen * 0.02, vertical: 8),
      child: Row(
        children: [
          // اسم الفئة
          buildContainer(widthScreen * 0.35, categoryName),
          // سعر الفئة
          buildContainer(widthScreen * 0.24, categoryPrice.toString()),
          // زر تعديل
          buildIconContainer(widthScreen * 0.16, Icons.edit, onPressed: () {
            _nameController.text = categoryName;
            _priceController.text = categoryPrice.toString();
            buildDialog(
              title: "Edit Category",
              content: Form(
                key: _formKey,
                child: Column(
                  children: [
                    cateController.buildTextFieldForm(
                        label: "Category Name", controller: _nameController),
                    cateController.buildTextFieldForm(
                        label: "Purchasing Price",
                        controller: _priceController),
                  ],
                ),
              ),
              actionToolsList: [
                ElevatedButton(
                  onPressed: () => cateController.saveCategory(
                      formKey: _formKey, isEdit: true, editId: id),
                  child: Text("Ok".tr),
                ),
                buildCancelElevatedButton(),
              ],
            );            
          }),
          // زر حذف
          buildIconContainer(widthScreen * 0.16, Icons.delete, 
            iconColor: const Color.fromARGB(255, 231, 42, 29),
            onPressed: () {
              buildDeleteDialog(
                id: id,
                message:
                    "Deleting this category will delete all related operations and batches.\n Do you really want to delete?",
                deleteFunc: (id) {
                  appDb.executeCommand('DELETE FROM Batches WHERE categoryId= $id');
                  return appDb.deleteCategory(id);
                },
                updateFunc: () {
                  cateController.getUpdateCategories();
                  Get.find<OperationsController>().updateOperation();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}