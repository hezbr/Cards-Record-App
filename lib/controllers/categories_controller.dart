import 'package:flutter/material.dart' show BorderRadius, BorderSide, Color, EdgeInsets, FormState, GlobalKey, InputDecoration, OutlineInputBorder, Padding, Text, TextEditingController, TextFormField, TextInputType, Widget;
import 'package:get/get.dart';

import '../models/app_Db.dart' show appDb, Category;
import '../view/widgets/public_widget.dart' show buildSnackbar;

class CategoriesController extends GetxController{
  List<Category> categories= <Category>[].obs;
  RxInt cateNumber = 0.obs;

  @override
  void onInit() {
    getUpdateCategories();
    super.onInit();
  }

  Future getUpdateCategories() async {
    categories = [];
    categories = await appDb.getCategories();
    cateNumber.value = categories.length;
    // final AddBatchController addBatchController = Get.find();
    // addBatchController.updateDistributorSCategories();
    update();
  }

  String _cateName= "";
  String _catePrice= "";
  Widget buildTextFieldForm({required String label, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        decoration: InputDecoration(
          label: Text(label.tr),
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          fillColor: const Color(0xffdfe7fd),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xffAD7BE9), width: 0.0),
          ),
        ),
        style: Get.textTheme.bodyMedium,
        controller: controller,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == "") return "this field shoudn't empty".tr;
          return null;
        },
        onSaved: (newValue) {
          if (label== "Category Name") { _cateName= newValue!; }
          else { _catePrice= newValue!; }
        },
      ),
    );
  }

  // حفظ التغييرات من اضافة أو تعديل فئة
  void saveCategory({
    required GlobalKey<FormState> formKey,
    required bool isEdit,
    required int editId,
  }) async {
    final isValid = formKey.currentState!.validate();
    Get.focusScope!.unfocus();  // اخفاء الكيبورد

    if (isValid){
      formKey.currentState!.save();
      if (_cateName == "" || _catePrice == "") {
        buildSnackbar("There is error. try again");
        return;
      }
      String message= "";
      if (isEdit) {
        await appDb.updateCategory(
          Category(
            id: editId,
            name: _cateName,
            price: int.parse(_catePrice),
          ),
        );
        message = "Category edited successfully";
      } else {
        await appDb.insertCategory(
            Category(name: _cateName, price: int.parse(_catePrice)));
        message = "Category added successfully";
      }
      getUpdateCategories();
      Get.back();
      buildSnackbar(message);
    }
  }
}
