import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cards_record/controllers/batches_controller.dart';
import 'package:cards_record/controllers/operations_controller.dart';

import '../../core/app_functions.dart';
import '../../models/batch_model.dart';
import '../../models/app_Db.dart';
import '../screens/edit_batch_screen.dart';
import 'public_widget.dart';

class BatchTableWidget extends StatelessWidget {
  // final String date;
  final List<BatchModel> batchData;
  final int totalPrice;
  BatchTableWidget({
    // super.key,
    // required this.date,
    required this.batchData,
    required this.totalPrice,
  }) : super(key: Key(batchData[0].date));

  final double widthScreen = Get.mediaQuery.size.width;

  @override
  Widget build(BuildContext context) {
    final String date = batchData[0].date;
    double widthScreen = Get.mediaQuery.size.width;
    return Card(
      key: Key(date),
      margin: EdgeInsets.symmetric(horizontal: widthScreen * 0.02, vertical: 6),
      child: Column(
        children: [
          // تاريخ الدفعة
          Container(
            padding: EdgeInsets.only(
                top: 10, bottom: (Get.locale!.languageCode == 'en' ? 6 : 0)),
            child: Text(
              "${'Batch date'.tr}: ${formatDateToShow(date, showTime: true)}",
              style: Get.textTheme.titleMedium!.copyWith(
                color: const Color(0xffAD7BE9),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // عناوين الجدول
          buildTableSubjects(),

          // بيانات الجدول
          for (int i = 0; i < batchData.length; i++)
            ...{
              buildClickedRowOfBatchData(batchData[i]),
            }.toList(),

          // الاجمالي للكل
          buildRowOfTotalAllData(),

          // اسم الموزع
          Text(
            "${'Distributor'.tr}: ${batchData[0].distName}",
            style: Get.textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 3),
        ],
      ),
    );
  }

  Row buildRowOfTotalAllData() {
    return Row(
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
            "$totalPrice",
            style: Get.textTheme.titleSmall!.copyWith(
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  SizedBox buildCellOfData(
      {required Object cellText, required double widthPer, TextStyle? style}) {
    return SizedBox(
      width: widthScreen * widthPer,
      child: Text(
        "$cellText",
        style: style ?? Get.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildTableSubjects() {
    final titleSmallStyle = Get.textTheme.titleSmall;
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.5, color: Colors.black),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          buildCellOfData(
              cellText: "Category".tr, widthPer: 0.20, style: titleSmallStyle),
          buildCellOfData(
              cellText: "Count".tr, widthPer: 0.24, style: titleSmallStyle),
          buildCellOfData(
              cellText: "Total".tr, widthPer: 0.25, style: titleSmallStyle),
          buildCellOfData(
              cellText: "Note".tr, widthPer: 0.27, style: titleSmallStyle),
        ],
      ),
    );
  }

  Widget buildClickedRowOfBatchData(BatchModel batch) {
    return InkWell(
      onLongPress: () => buildButtonsRowAsDialog(
        [
          // زر تعديل
          ElevatedButton(
            onPressed: () => Get.to(
              () => EditBatchScreen(
                batchId: batch.id,
                cateId: batch.categoryId,
                distId: batch.distributorId,
                counts: batch.counts.toString(),
                date: batch.date,
                note: batch.note,
              ),
            ),
            child: Text("Edit".tr),
          ),
          // زر حذف
          buildDeleteButton(
            message: "Are you sure to delete this Batch?",
            id: batch.id,
            deleteFunc: appDb.deleteBatch,
            updateFunc: () {
              Get.find<OperationsController>().updateOperation();
              Get.find<BatchesController>().getAndHandleBatches();
            },
          ),
          // زر الغاء
          buildCancelElevatedButton(),
        ],
      ),
      splashColor: Get.theme.primaryColor,
      child: buildRowOfBatchData(batch),
    );
  }

  Widget buildRowOfBatchData(BatchModel batch) {
    return Row(
      children: [
        // اسم الفئة
        Container(
          color: Get.theme.colorScheme.secondary,
          padding: const EdgeInsets.symmetric(vertical: 5),
          width: widthScreen * 0.20,
          child: Text("${batch.cateName}",
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        ),
        // عدد الكروت
        buildCellOfData(cellText: batch.counts, widthPer: 0.24),
        // اجمالي السعر لهده الدفعة
        buildCellOfData(cellText: batch.totalPrice, widthPer: 0.25),
        // الملاحظة
        buildCellOfData(
          cellText: batch.note == 'n' ? '_' : batch.note,
          widthPer: 0.27,
          style: Get.textTheme.bodySmall,
        ),
      ],
    );
  }
}
