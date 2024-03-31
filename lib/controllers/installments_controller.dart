import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/app_functions.dart';
import '../models/installment_model.dart';

class InstallmentsController extends GetxController {
  List<InstallmentModel> readyBatches = [];

  // قائمة ستحتوي على الادوات التي ستعرض في الشاشة
  List<Widget> widgets = [];

  @override
  void onInit() async {
    super.onInit();
    await getAndHandleBatches();
  }

  Future<void> getAndHandleBatches() async {
    widgets = [];
    readyBatches = await InstallmentModel.getAllInstallments() ?? [];
    installmentsProcessing();
    widgets = sortWidgetsByDate(widgets);
    update();
  }

  Future<void> installmentsProcessing() async {
    
  }
}
