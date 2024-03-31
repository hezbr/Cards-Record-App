import 'package:flutter/material.dart' show BorderRadius, BorderSide, Card, Center, Color, Colors, Column, Container, Divider, DropdownButton, DropdownMenuItem, EdgeInsets, Expanded, FutureBuilder, InputDecoration, MainAxisAlignment, OutlineInputBorder, Padding, RoundedRectangleBorder, Row, SizedBox, Text, TextButton, TextFormField, TextInputType, ValueKey, Widget;
import 'package:get/get.dart';
import 'package:cards_record/core/app_functions.dart';
import 'package:cards_record/models/app_Db.dart' show appDb, Distributor, Category, Batch_;

import '../models/operations_on_db.dart' show getCategoryNameById, getCategoryPriceById;
import 'batches_controller.dart';
import 'operations_controller.dart';
import '../view/widgets/public_widget.dart' show buildSnackbar;


class AddBatchController extends GetxController {
  // الظاهرة Batch متغير استخدمه لعدد الـ
  int keys = 1;
  // قائمة اخزن فيها بيانات صندوق الفئة وصندوق عدد الكروت وصندوق الملاحظة
  // حتى اعيد توليدها مع بياناتها وكذلك استخدمها لحفظ البيانات
  final List<String> batchData = <String>["", "", "n"].obs;
  // قائمة ستحتوي بيانات الموزعين من قاعدة البيانات
  List<Distributor> distributors= [];
  // قائمة ستحتوي بيانات الموزعين من قاعدة البيانات
  List<Category> categories = [];
  // متغير سيحتوي على رقم الموزع
  int distValue= -1;
  // متغير سيحتوي على تاريخ الدفعة الحالية
  Rx<String> batchDate= initializeDate().obs;
  // Rx<DateTime> batchDate= DateTime.now().obs;

  void reset(){
    keys = 1;    
    // distributors= [];
    // categories = [];
    distValue= -1;
    batchDate.value = initializeDate();
  }

  @override
  void onInit() {
    reset();
    updateDistributorSCategories();
    super.onInit();
  }

  @override
  InternalFinalCallback<void> get onDelete {
    reset();
    return super.onDelete;
  }

  // دالة لجلب وتحديث بيانات الموزعين والفئات
  Future updateDistributorSCategories() async {
    distributors = [];
    categories = [];
    distributors = await appDb.getDistributors();
    categories = await appDb.getCategories();
    update();
  }

  void addBatchWidget() {
    keys++;
    batchData.addAll(["", "", "n"]);
    update();    
  }

  void deleteBatchWidget(int index) {
    batchData.removeAt(index * 3 + 2);
    batchData.removeAt(index * 3 + 1);
    batchData.removeAt(index * 3);
    keys--;
    update();
  }

  Future<String> buildSummaryTextForBatch(String cateId, String count) async {
    if (cateId != "") {
      String cateName = (await getCategoryNameById(cateId)).tr;
      int catePrice = await getCategoryPriceById(cateId);
      if (count.isEmpty) count = "0";
      int total = catePrice * (int.tryParse(count) ?? 0);
      return "'$count' ${'cards'.tr}, ${'cate.'.tr} '$cateName' = '$count * $catePrice' = $total";
    }
    return "";
  }

  Container buildBatchWidget(int index, {bool canDelete= true}) {
    double widthScreen = Get.mediaQuery.size.width;
    return Container(
      color: const Color(0xffeae4e9),
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          // card لاختيار الفئة
          buildCard(
            buildDropDownButtonWithLabel(
              label: "Category",
              hint: "select category",
              items: categories,
              onChanged: (value){batchData[index * 3] = value!=null? value.toString():"";},
              value: batchData[index * 3] != ""? int.parse(batchData[index * 3]) : null,
            ),
          ),
      
          // card لادخال عدد الكروت
          buildCard(
            TextFormField(
              key: ValueKey(keys),
              enableSuggestions: true,
              initialValue: batchData[index * 3 + 1],
              style: Get.textTheme.bodyMedium,
              decoration: InputDecoration(
                label: Text("Enter the number of cards".tr),
                labelStyle: Get.textTheme.bodyLarge,
                fillColor: const Color(0xffdfe7fd),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xffAD7BE9), width: 0.0),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (newValue) {
                batchData[index * 3 + 1] = newValue;
                update();
              },
            ),
          ),

          // card لكتابة ملاحظة
          buildCard(
            TextFormField(
              key: ValueKey(keys+1),
              enableSuggestions: true,
              initialValue: batchData[index * 3 + 2] != "n"? batchData[index * 3 + 2]: null,
              style: Get.textTheme.bodyMedium,
              decoration: InputDecoration(
                label: Text("Write note (optional)".tr),
                labelStyle: Get.textTheme.bodyLarge,
                fillColor: const Color(0xffdfe7fd),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xffAD7BE9), width: 0.0),
                ),
              ),
              keyboardType: TextInputType.text,
              onChanged: (newValue) {
                if (newValue.isEmpty) newValue= 'n';
                batchData[index * 3 + 2] = newValue;
                update();
              },
            ),
          ),
          
          // صف لوضع نص يحتوي على الاجمالي وكذلك زر لحذف بطاقة هذه الدفعة
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // نص يحتوي على الاجمالي للعدد والسعر
                FutureBuilder(
                  future: buildSummaryTextForBatch(batchData[index * 3], batchData[index * 3 + 1]),
                  builder: (context, snapshot) => SizedBox(
                    width: widthScreen * 0.65,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: canDelete ? 0 : 15),
                      child: Text(snapshot.data?? "", style: Get.textTheme.bodySmall,),
                    ),
                  ),
                ),
                // زر لحذف البطاقة الخاصة بهذه الدفعة
                if (canDelete)
                  SizedBox(
                    width: widthScreen * 0.3,
                    child: TextButton(
                      onPressed: () => deleteBatchWidget(index),
                      child: Text(
                        "Delete this cate.".tr,
                        style: Get.textTheme.bodySmall!.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 0, color: Colors.black45),
          // const SizedBox(height: 10),
        ],
      ),
    );
  }

  // دالة لحفظ بيانات الدفعة في قاعدة البيانات
  void saveBatch() {
    String msg = "message";
    if (keys == 0) {
      msg = "must least one caregory";
    } else if (distValue == -1 || batchData.contains("")) {
      msg = "fields must filled";
    } else {
      int distId = distValue;
      String date = batchDate.value;
      // String date = DateFormat('yyyy/MM/dd').format(batchDate.value);
      for (int i = 0; i < keys; i++) {
        appDb.insertBatch(
          Batch_(
            categoryId: int.parse(batchData[i * 3]),
            counts: int.parse(batchData[i * 3 + 1]),
            note: batchData[i * 3 +2],
            date: date,
            distributorId: distId,
          ),
        );
      }
      Get.find<OperationsController>().updateOperation();
      msg = "Batch Added";
      distValue= -1; keys= 1; batchData.clear();  batchData.addAll(["", "", "n"]);
      batchDate.value= initializeDate();
    }
    Get.focusScope!.unfocus();
    buildSnackbar(msg);
    update();
    Get.find<BatchesController>().getAndHandleBatches();
  }
  
  Card buildCard(Widget child) {
    double widthScreen= Get.mediaQuery.size.width;
    return Card(
      color: const Color(0xffdfe7fd),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: widthScreen * 0.02, vertical: 8),
      child: child,
    );
  }

  Row buildDropDownButtonWithLabel(
      {required String label,
      required String hint,
      required List items,
      required Function(Object?) onChanged,
      int? value}) {
    return Row(children: [
      Text("  ${label.tr}: ", style: Get.textTheme.titleSmall),
      Expanded(
        child: DropdownButton(
          style: Get.textTheme.bodyMedium,
          isExpanded: true,
          value: value,
          hint: Center(child: Text(hint.tr)),
          items: [
            ...items
                .map(
                  (item) => DropdownMenuItem(
                      value: item.id,
                      child: Center(child: Text(item.name))),
                )
                .toList(),
          ],
          onChanged: (value){
            onChanged(value);
            update();
          }
        ),
      ),
    ]);
  }
}
