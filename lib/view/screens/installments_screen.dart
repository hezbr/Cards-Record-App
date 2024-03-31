import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/batches_controller.dart';

class InstallmentScreen extends StatelessWidget {
  InstallmentScreen({super.key});

  final BatchesController batchesController = Get.find();
  Future<void> refreshBatches() async {
    await batchesController.getAndHandleBatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshBatches,
        child: GetBuilder<BatchesController>(
          // init: OperationsController(),
          builder: (controller) => controller.widgets.isEmpty
              ? Center(child: Text("You haven't had any batches yet.".tr))
              : ListView.builder(
                  itemBuilder: (_, i) {
                    if (i < controller.widgets.length) {
                      return controller.widgets[i];
                    }
                    return null;
                  },
                  itemCount: controller.widgets.length,
                ),
        ),
      ),
    );
  }
}