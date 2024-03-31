import 'package:flutter/material.dart' show BorderRadius, BorderSide, Card, Color, Colors, Column, EdgeInsets, ElevatedButton, Expanded, Form, FormState, GlobalKey, Icon, IconButton, Icons, InputDecoration, OutlineInputBorder, Padding, RoundedRectangleBorder, Row, SizedBox, Text, TextAlign, TextEditingController, TextFormField, TextInputType, Widget;
import 'package:get/get.dart';
import '../models/app_Db.dart' show appDb, Distributor;
import '../view/widgets/public_widget.dart';
import 'add_batch_controller.dart';
import 'operations_controller.dart';

class DistributorsController extends GetxController{
  // قائمة ستحتوي على بيانات الموزعين
  List<Distributor> distributors= [];
  final double _widthScreen = Get.mediaQuery.size.width;
  @override
  void onInit() {
    getUpdateDistributors();
    super.onInit();
  }
  
  // دالة لجلب وتحديث بيانات الموزعين من قاعدة البيانات
  Future<void> getUpdateDistributors() async {
    distributors = [];
    distributors= await appDb.getDistributors();
    final AddBatchController addBatchController= Get.find();
    addBatchController.updateDistributorSCategories();
    update();
  }

  Row _buildDetailRow(String title, String data) {
    return Row(
      children: [
        SizedBox(
          width: _widthScreen * 0.33,
          child: Text("  ${title.tr}: ",
            style: Get.textTheme.titleSmall!.copyWith(color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(data.tr,
            style: Get.textTheme.bodyMedium!.copyWith(color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  // دالة لانشاء بطاقة تحتوي على معلومات الموزع الذي تم استقباله
  Card buildDistributorCard(Distributor distributor) {
    return Card(
      color: const Color(0xffeae4e9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: _widthScreen * 0.02, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
        child: Row(
          children: [
            SizedBox(
              width: _widthScreen*0.81,
              child: Column(
                children: [
                  _buildDetailRow("Distributor Name", distributor.name),
                  _buildDetailRow("Phone", distributor.phone == 0 ? "Not Found"
                          : distributor.phone.toString()),                  
                ],
              ),
            ),
            SizedBox(
              width: _widthScreen * 0.1,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                splashColor: Get.theme.primaryColor,
                onPressed: () async {
                  buildDeleteDialog(
                    message: "Deleting this distributor will delete all related operations and batches.\n Do you really want to delete?",
                    id: distributor.id,
                    deleteFunc: (id) {
                      appDb.executeCommand('DELETE FROM Batches WHERE distributorId= $id');
                      return appDb.deleteDistributor(id);
                    },
                    updateFunc: () {
                      getUpdateDistributors();
                      Get.find<OperationsController>().updateOperation();
                    },
                  );
                },                
              ),
            )
          ],
        ),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController= TextEditingController();
  final TextEditingController _phoneController= TextEditingController();
  buildUpdateDistributorWidget(Distributor distributor) {
    _nameController.text = distributor.name;
    _phoneController.text = distributor.phone.toString();
    return buildDialog(
      title: "Edit Distributor",
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            buildTextFieldForm(
                label: "Distributor Name", controller: _nameController),
            buildTextFieldForm(
                label: "Phone (optional)", controller: _phoneController),
          ],
        ),
      ),
      actionToolsList: [
        ElevatedButton(
          onPressed: () =>
              saveDistributor(formKey: _formKey, isEdit: true, editId: distributor.id),
          child: Text("Ok".tr),
        ),
        buildCancelElevatedButton(),
      ],
    );
  }

  String _distName = "";
  int _distPhone = 0;
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
            gapPadding: 0,
          ),
        ),
        style: Get.textTheme.bodyMedium,
        controller: controller,
        keyboardType: label.contains('Name')? TextInputType.name:TextInputType.phone,
        validator: (value) {
          if (label.contains('Name') && value == "") return "this field shoudn't empty".tr;
          if (label.contains('Phone') && value!="" && int.tryParse(value.toString())==null) {
            return "the phone must to be just numbers".tr;
          }
          return null;
        },
        onSaved: (newValue) {
          if (label.contains("Name")) { _distName= newValue!; }
          else if (newValue != "") {
            _distPhone = int.parse(newValue.toString());
          }
        },
      ),
    );
  }

  // حفظ التغييرات من اضافة أو تعديل فئة
  void saveDistributor({
    required GlobalKey<FormState> formKey,
    required bool isEdit,
    required int editId,
  }) async {
    final isValid = formKey.currentState!.validate();
    Get.focusScope!.unfocus();  // اخفاء الكيبورد

    if (isValid){
      formKey.currentState!.save();
      if (_distName == "") {
        buildSnackbar("There is error. try again");
        return;
      }
      String message= "";
      if (isEdit) {
        await appDb.updateDistributor(
          Distributor(
            id: editId,
            name: _distName,
            phone: _distPhone,
          ),
        );
        message = "Distributor edited successfully";
      } else {
        await appDb.insertDistributor(
            Distributor(name: _distName, phone: _distPhone));
        message = "Distributor added successfully".tr;
      }
      getUpdateDistributors();
      Get.back();
      buildSnackbar(message);
    }
  }
}