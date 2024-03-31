import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/app_functions.dart';
import '../models/batch_model.dart';
import '../view/widgets/batch_table_widget.dart';

class BatchesController extends GetxController{
  List<BatchModel> readyBatches = [];

  // قائمة ستحتوي على الادوات التي ستعرض في الشاشة
  List<Widget> widgets = [];

    @override
  void onInit() async{
    super.onInit();
    await getAndHandleBatches();
  }

  // دالة لاسترجاع الدفع من قاعدة البيانات ومن ثم اعادة تشكيلها وتجهيزها بجلب بيانات
  // كل دفعة من الجداول المختلفة على قاعدة البيانات
  Future<void> getAndHandleBatches() async {
    widgets = [];
    readyBatches= await BatchModel.getAllBatches()?? [];
    batchesProcessing();
    widgets = sortWidgetsByDate(widgets);
    update(); 
  }

  // دالة لمعالجة الدفع وتقسيمها حسب التاريخ وحسب الموزع لكل تاريخ
  // ثم بناء تلك الدفع بأدوات عرض مناسبة لتقسيمها
  void batchesProcessing() {
    // استخراج تواريخ الدفع المختلفة بدون تكرار وحفظها في قائمة
    final dates = readyBatches.map((batch) => batch.date).toSet().toList();

    // المرور على كل تاريخ منفرد وتجميع الدفع الخاصة بذلك التاريخ وتخزينها على قائمة منفصلة
    // ثم تقسيم الدفع من نفس التاريخ إلى اقسام حسب اختلاف الموزعين لهذه الدفع
    dates.forEach((date) {
      final batchesOfsameDate= readyBatches.where((batch) => batch.date==date).toList();
      final totalPriceOfGroup = batchesOfsameDate.fold(0, (sum, batch) => sum + int.parse(batch.totalPrice));
      // final distributors = batchesOfsameDate.map((batch) => batch.distName).toSet().toList();

      widgets.add(BatchTableWidget(batchData: batchesOfsameDate, totalPrice: totalPriceOfGroup));
      // widgets.add(buildBatchCard(batchesOfsameDate, date, totalPriceOfGroup));      
      // // اذا كان هناك موزع واحد فقط لكل الدفع ضمن التاريخ الواحد سيتم اضافة بطاقة لعرض
      // // كل هذه الدفع التي لها نفس التاريخ ضمن موزع واحد
      // if (distributors.length == 1) {
      //   widgets.add(buildBatchCard(batchesOfsameDate, date, totalPriceOfGroup));
      // }
      // // والا اذا كان هناك اكثر من موزع واحد للدفع التي هي ضمن تاريخ واحد
      // // فسيتم استخراج الدفع التي قام بها كل موزع على حداه وتخزينها في قائمة منفصلة
      // // بحيث ستكون كل تلك القوائم مخزنة في قائمة واحدة، حتى يتم من هذه القائمة الواحدة
      // // بناء بطاقة عرض واحدة بموزعين مختلفين 
      // else{
      //   final batchesGroupsByDistributer = distributors.map((distributor){
      //     return batchesOfsameDate.where((batch) => batch.distName==distributor).toList();
      //   }).toList();
      //   widgets.add(buildBatchCard(batchesGroupsByDistributer,date, totalPriceOfGroup));
      // }
    });
    // widgets = sortWidgetsByDate(widgets);
    // update();    
  }
  
  // Widget buildBatchCard(List batchesGroupsByDistributer, String date, int totalPriceOfGroup) {
  //   return Placeholder();
  // }
  
  // void sortWidgetsByDate() {}
}