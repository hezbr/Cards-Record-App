import 'package:flutter/material.dart' show Border, BorderSide, BoxDecoration, Card, Color, Colors, Column, Container, DefaultTextStyle, EdgeInsets, ElevatedButton, Expanded, FontWeight, InkWell, Key, MainAxisAlignment, Padding, Row, SizedBox, Text, TextAlign, TextStyle, Widget;
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:cards_record/core/app_functions.dart';
import 'package:cards_record/view/widgets/public_widget.dart' show buildCancelElevatedButton, buildDeleteButton, buildDeleteDialog, buildDialog;

import '../models/app_Db.dart' show appDb, Batch_, Installment;
import 'installment_controller.dart';
import '../models/operations_on_db.dart' show getTotallAllBatches, getTotallAllCreditInstallments, getTotallAllCreditorInstallments;
import '../view/screens/edit_batch_screen.dart';
import 'batches_controller.dart';

class OperationsController extends GetxController {
  // قائمة ستحتوي على بيانات الدفع المسترجعة من قاعدة البيانات
  // List<Batch_> batches= [];
  // قائمة ستحتوي على الاقساط المسترجعة من قاعدة البيانات
  List<Installment> installments = [];
  // قائمة ستحتوي على بيانات الدفع بعد تجهيز تلك البيانات من قاعدة البيانات
  List<Map<String, Object>> readyBatches = [];
  // قائمة ستحتوي على الادوات التي ستعرض في الشاشة
  List<Widget> widgets = [];
  var summaryPayment= "";

  @override
  void onInit() {
    super.onInit();
    updateOperation();
  }

   updateOperation() async {    
    widgets = [];
    getInstallments();
    getBatches();
    await buildSummaryTextPayment();
  }

  Future<Container> buildSummaryTextPayment() async {
    int totalBatches = await getTotallAllBatches();
    int totalCreditorInstallments = await getTotallAllCreditorInstallments();
    int totalCreditInstallments = await getTotallAllCreditInstallments();
    summaryPayment = "${'The rest'.tr}: ${totalBatches - totalCreditorInstallments+ totalCreditInstallments}\n" +
            "${'Total on you'.tr}: ${totalBatches + totalCreditInstallments}\n"
            "${'Total payments'.tr}: $totalCreditorInstallments";
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Get.theme.primaryColor,
      width: double.infinity,
      child: Text(
        summaryPayment,
        style: Get.textTheme.titleSmall!.copyWith(
          color: Colors.white,
          fontFamily:
              Get.locale?.languageCode == 'ar' ? 'Al-Jazeera' : null,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
  
  Future<void> getInstallments() async {
    installments = await appDb.getInstallments();    
    for (Installment element in installments) {
      widgets.add(InkWell(
        key: Key(element.date),
        child: buildInstallmentCard(element),
        onLongPress: () {
          final InstallmentController instlController = Get.find();
          buildButtonsRowAsDialog(
            [
              // زر تعديل
              ElevatedButton(
                onPressed: () => instlController.buildInstallmentDialog(
                  initAmount: element.amount.toString(),
                  initReceiver: element.receiver,
                  initNote: element.note,
                  date: element.date,
                  rest: element.rest,
                  idToEdit: element.id,
                  is_creditor: element.is_creditor,
                ),
                child: Text("Edit".tr),
              ),
              // زر حذف
              buildDeleteButton(
                    message: "Are you sure to delete this Installment?".tr,
                    id: element.id,
                    deleteFunc: appDb.deleteInstallment,
                    updateFunc: updateOperation,
                  ),
              // ElevatedButton(
              //   onPressed: () {
              //     Get.back();
              //     buildDeleteButton(
              //       message: "Are you sure to delete this Installment?".tr,
              //       id: element.id,
              //       deleteFunc: appDb.deleteInstallment,
              //       updateFunc: updateOperation,
              //     );
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.red,
              //     foregroundColor: Colors.white,
              //   ),
                // child: Text("Delete".tr),
              // ),
              // زر الغاء
              buildCancelElevatedButton(),
            ],
          );
        },
      ));
    }
    sortWidgetsByDate();
  }

  Card buildInstallmentCard(Installment installmentData) {
    double widthScreen = Get.mediaQuery.size.width;
    String date = installmentData.date;
    String amount = installmentData.amount.toString();
    String receiver = installmentData.receiver;
    String note = installmentData.note;
    String rest= installmentData.rest.toString();
    bool is_creditor= installmentData.is_creditor;
    return Card(
      // key: Key(installmentData.date),
      // color: const Color(0xffdfe7fd),
      margin: EdgeInsets.symmetric(horizontal: widthScreen * 0.02, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 7),
        // تاريخ القسط
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top:10.0, bottom: 2),
              child: Text(
                "${'Installment date'.tr}: ${formatDateToShow(date, showTime: true)}",
                style: Get.textTheme.titleMedium!.copyWith(
                  color: const Color(0xffAD7BE9),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // بيانات القسط
            for (int i = 0; i < 4; i++)
              if (!((i == 1 && receiver == "") || (i == 2 && note == "")))
                ...{
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                          width: widthScreen * 0.33,
                          child: Text(
                            i == 0? "  ${'Amount'.tr}: ": i == 1? "  ${'Receiver'.tr}: ": 
                              i == 2 ? "  ${'Note'.tr}: ": "  ${'Rest'.tr}: ",
                            style: Get.textTheme.titleSmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            i == 0? amount: i == 1? receiver: i == 2? note: rest,
                            style: Get.textTheme.bodyMedium!.copyWith(
                              color: i == 0 || i == 3? Colors.red : Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                }.toList(),

                // اضافة نوع القسط
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "${'Type installment'.tr}: ${is_creditor?'Creditor'.tr:'Credit'.tr}",
                    style: Get.textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                )
          ],
        ),
      ),
    );
  }

  // دالة لاسترجاع الدفع من قاعدة البيانات ومن ثم اعادة تشكيلها وتجهيزها بجلب بيانات
  // كل دفعة من الجداول المختلفة على قاعدة البيانات
  Future<void> getBatches() async {
    // قائمة ستحتوي على الدفع المسترجعة من قاعدة البيانات
    List<Batch_> batches = await appDb.getBatches();
    // print(batches.length);

    // تجهيز وجلب بيانات كل دفعة من مختلف الجداول على قاعدة البيانات
    readyBatches = [];
    for (int i = 0; i < batches.length; i++) {
      // استرجاع اسم وسعر الفئة لهذه الدفعة من جدول الفئات
      List<Map<String, Object?>> cateData = await appDb
          .getDataByCommand('''select name, price from categories where id =
          ${batches[i].categoryId}''');

      List<Map<String, Object?>> distData= await appDb.getDataByCommand('''select name from distributors
          where id = ${batches[i].distributorId}''');

      if (cateData.isEmpty || distData.isEmpty) continue;
      Map<String, Object?> cateNamePrice= cateData[0];
      // استخراج سعر الفئة إلى متغير حتى يتم حساب اجمالي السعر لهذه الدفعة
      int catePrice = int.parse(cateNamePrice['price'].toString());

      // تجهيز بيانات الدفعة واضافتها إلى القائمة
      readyBatches.add({
        'id': batches[i].id,
        'cateId': batches[i].categoryId,
        'distId': batches[i].distributorId,
        'cateName': cateNamePrice['name'] ?? "No Object",
        'counts': batches[i].counts,
        'total': (batches[i].counts) * catePrice,
        'date': batches[i].date,
        'distName': distData[0]['name']?? "No Object",
          //   (await appDb.getDataByCommand('''select name from distributors
          // where id = ${batches[i].distributorId}'''))[0]['name'] ?? "No Object",
        'note': batches[i].note,
      });
    }
    batchesProcessing();
  }

  // دالة لمعالجة الدفع وتقسيمها حسب التاريخ وحسب الموزع لكل تاريخ
  // ثم بناء تلك الدفع بأدوات عرض مناسبة لتقسيمها
  void batchesProcessing() {
    // استخراج تواريخ الدفع المختلفة بدون تكرار وحفظها في قائمة
    List<String> allBatchesDate =
        readyBatches.map((batch) => batch['date'].toString()).toSet().toList();

    // المرور على كل تاريخ منفرد وتجميع الدفع الخاصة بذلك التاريخ وتخزينها على قائمة منفصلة
    // ثم تقسيم الدفع من نفس التاريخ إلى اقسم حسب اختلاف الموزعين لهذه الدفع
    for (int i = 0; i < allBatchesDate.length; i++) {
      // قائمة ستحتوي على كل الدفع من نفس التاريخ
      List<Map<String, Object>> sameDateBatches = readyBatches
          .where((batch) => batch['date'] == allBatchesDate[i])
          .toList();

      // متغير لحساب الاجمالي لكل الدفع من نفس التاريخ
      double totalAll = sameDateBatches.fold(
          0, (sum, batch) => sum + int.parse(batch['total'].toString()));

      // قائمة سيخزن فيها اسماء الموزعين للدفع التي هي من نفس التاريخ
      List<String> distributors =
          sameDateBatches.map((e) => e['distName'].toString()).toSet().toList();

      // اذا كان هناك موزع واحد فقط لكل الدفع ضمن التاريخ الواحد سيتم اضافة بطاقة لعرض
      // كل هذه الدفع التي لها نفس التاريخ ضمن موزع واحد
      if (distributors.length == 1) {
        widgets.add(
          buildBatchCard(
              sameDateBatches, sameDateBatches[0]['date'].toString(), totalAll),
        );
      }
      // والا اذا كان هناك اكثر من موزع واحد للدفع التي هي ضمن تاريخ واحد
      // فسيتم استخراج الدفع التي قام بها كل موزع على حداه وتخزينها في قائمة منفصلة
      // بحيث ستكون كل تلك القوائم مخزنة في قائمة واحدة، حتى يتم من هذه القائمة الواحدة
      // بناء بطاقة عرض واحدة بموزعين مختلفين
      else {
        List<List<Map<String, Object>>> allBatchesSameDateDifferentDist = [];
        for (String distributor in distributors) {
          // استخراج الدفع من نفس الموزع الواحد لنفس التاريخ الواحد واضافتها كقائمة
          // إلى القائمة الأب التي تحتوي القوائم المتعددة من الدفع للتاريخ الواحد ومختلف الموزعين
          allBatchesSameDateDifferentDist.add(sameDateBatches
              .where((batch) => batch['distName'] == distributor).toList());
        }
        widgets.add(
          buildBatchCard(allBatchesSameDateDifferentDist,
              sameDateBatches[0]['date'].toString(), totalAll),
        );
      }
    }
    sortWidgetsByDate();
    update();
  }

  Card buildBatchCard(List batchData, String date, double totalAll) {
    double widthScreen = Get.mediaQuery.size.width;
    return Card(
      key: Key(date),
      // color: const Color(0xffdfe7fd),
      margin: EdgeInsets.symmetric(horizontal: widthScreen * 0.02, vertical: 6),
      child: Column(
        children: [
          // تاريخ الدفعة
          Container(
            padding: EdgeInsets.only(top:10, bottom: (Get.locale!.languageCode=='en'? 6: 0)),
            child: Text(
              "${'Batch date'.tr}: ${formatDateToShow(date, showTime: true)}",
              style: Get.textTheme.titleMedium!.copyWith(
                color: const Color(0xffAD7BE9),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // عناوين الجدول
          Container(
            decoration: const BoxDecoration(
              // color: Get.theme.colorScheme.secondary,
              border: Border(
                bottom: BorderSide(width: 1.5, color: Colors.black),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 5),
            child: DefaultTextStyle(
              style: Get.textTheme.titleSmall!,
              child: Row(
                children: [
                  SizedBox(
                    width: widthScreen * 0.20,
                    child: Text("Category".tr, textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    width: widthScreen * 0.24,
                    child: Text("Count".tr, textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    width: widthScreen * 0.25,
                    child: Text("Total".tr, textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    width: widthScreen * 0.27,
                    child: Text("Note".tr, textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
          ),

          // فحص للبيانات المستلمة هل هي قائمة وبداخلها قائمة (أي عدة دفع بتاريخ واحد
          // لكن اكثر من موزع واحد) وسيتم عرضها بطريقة مناسبة
          if (batchData.runtimeType == List<List<Map<String, Object>>>)
            for (int i = 0; i < batchData.length; i++)
              ...{
                buildBatchesDataAsTable(batchData[i]),
                // اضافة اسم الموزع
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "${'Distributor'.tr}: ${batchData[i][0]['distName']}",
                    style: Get.textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                )
              }.toList(),
          // اما اذا كان نوع البيانات قائمة واحدة فهي دفع بتاريخ واحد وموزع واحد ليتم عرضها
          // بطريقة مناسبة
          if (batchData.runtimeType == List<Map<String, Object>>)
            buildBatchesDataAsTable(batchData),

          // الاجمالي للكل
          Row(
            children: [
              Container(
                width: widthScreen * 0.50,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  "${'Total All for this Batch'.tr}: ",
                  style: Get.textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: widthScreen * 0.46,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  "$totalAll",
                  style: Get.textTheme.titleSmall!.copyWith(
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          // اضافة اسم الموزع في حالة الدفع التي هي من نفس التاريخ الواحد والموزع
          if (batchData.runtimeType == List<Map<String, Object>>)
            Text(
              "${'Distributor'.tr}: ${batchData[0]['distName']}",
              style: Get.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 4),
          // const Divider(color: Colors.black54, height: 0),
        ],
      ),
    );
  }

  Column buildBatchesDataAsTable(List data) {
    double widthScreen = Get.mediaQuery.size.width;
    return Column(
      children: [
        for (int i = 0; i < data.length; i++)
          InkWell(
            onLongPress: () => buildButtonsRowAsDialog(
              [
                // زر تعديل
                ElevatedButton(
                  onPressed: () => Get.to(
                    () => EditBatchScreen(
                      batchId: int.parse(data[i]['id'].toString()),
                      cateId: int.parse(data[i]['cateId'].toString()),
                      distId: int.parse(data[i]['distId'].toString()),
                      counts: data[i]['counts'].toString(),
                      date: data[i]['date'].toString(),
                      note: data[i]['note'].toString(),
                    ),
                  ),
                  child: Text("Edit".tr),
                ),
                // زر حذف
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    buildDeleteDialog(
                    message: "Are you sure to delete this Batch?".tr,
                    id: int.parse(data[i]['id'].toString()),
                    deleteFunc: appDb.deleteBatch,
                    updateFunc: () {
                        updateOperation();
                        Get.find<BatchesController>().getAndHandleBatches();
                      },
                  );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Delete".tr),
                ),
                // زر الغاء
                buildCancelElevatedButton(),
              ],
            ),
            splashColor: Get.theme.primaryColor,
            child: DefaultTextStyle(
              style: Get.textTheme.bodyMedium!,
              child: Row(
                children: [
                  // اسم الفئة
                  Container(
                    color: Get.theme.colorScheme.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    width: widthScreen * 0.20,
                    child: Text("${data[i]['cateName']}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                  // عدد الكروت
                  SizedBox(
                    width: widthScreen * 0.24,
                    child: Text("${data[i]['counts']}",
                        textAlign: TextAlign.center),
                  ),
                  // اجمالي السعر لهده الدفعة
                  SizedBox(
                    width: widthScreen * 0.25,
                    child: Text("${data[i]['total']}",
                        textAlign: TextAlign.center),
                  ),
                  // الملاحظة
                  SizedBox(
                    width: widthScreen * 0.27,
                    child: Text(
                      "${data[i]['note'] == 'n' ? '_' : data[i]['note']}",
                      style: Get.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  buildButtonsRowAsDialog(List<Widget> buttonsList) {
    return buildDialog(
      title: "",
      content: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buttonsList,
        ),
      ),
      actionToolsList: [],
    );
  }

  void sortWidgetsByDate() {
    widgets.sort((a, b) {
      String keyString1 = a.key.toString();
      String date1 = keyString1.substring(3, keyString1.length - 3);
      String keyString2 = b.key.toString();
      String date2 = keyString2.substring(3, keyString2.length - 3);
      return DateFormat('yyyy/MM/dd H:mm:s')
          .parse(date2)
          .compareTo(DateFormat('yyyy/MM/dd H:mm:s').parse(date1));
    });
    // List<String> date= widgets.map((e) => e.key.toString()).toList();
    // print("date: $date");
  }
}
