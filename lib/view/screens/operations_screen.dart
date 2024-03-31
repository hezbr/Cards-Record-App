import 'package:flutter/material.dart' show BuildContext, Center, Column, Expanded, FutureBuilder, ListView, RefreshIndicator, Scaffold, StatelessWidget, Text, Widget;
import 'package:get/get.dart';

import '../../controllers/operations_controller.dart';


class OperationsScreen extends StatelessWidget {
  OperationsScreen({super.key});
  final OperationsController opController = Get.find();
  Future<void> refreshData() async{
    await opController.updateOperation();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: Column(
          children: [
            Expanded(
              child: GetBuilder<OperationsController>(
                // init: OperationsController(),
                builder: (controller) => controller.widgets.isEmpty
                    ? Center(child: Text("You haven't had any operations yet.".tr))
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
            GetBuilder<OperationsController>(
              builder: (controller) => FutureBuilder(
                future: controller.buildSummaryTextPayment(),
                builder: (context, snapshot) => snapshot.data ?? const Text(""),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
