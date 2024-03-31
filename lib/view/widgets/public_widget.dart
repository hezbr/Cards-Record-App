import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

Future buildDialog(
    {required String title,
    required Widget content,
    required List<Widget> actionToolsList}) {
  return Get.defaultDialog(
    backgroundColor: Get.theme.canvasColor,
    barrierDismissible: false,
    title: title.tr,
    titleStyle: Get.textTheme.titleLarge,
    titlePadding: EdgeInsets.only(top: title == "" ? 0 : 20),
    content: SizedBox(width: Get.mediaQuery.size.width, child: content),
    contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
    actions: actionToolsList.isEmpty
        ? null
        : [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: actionToolsList,
              ),
            )
          ],
  );
}

buildDeleteDialog(
    {required String message,
    required int id,
    required Function deleteFunc,
    required Function updateFunc}) {
  buildDialog(
    title: "Delete!",
    content: Text(message.tr, textAlign: TextAlign.center),
    actionToolsList: [
      // زر حذف
      ElevatedButton(
        onPressed: () async {
          String msg = "There is error. try again";
          if (await deleteFunc(id) == 1) {
            msg = "Successful deleted";
          }
          // Get.back(closeOverlays: true);
          Get.back();
          buildSnackbar(msg);
          await updateFunc();
        },
        style: ElevatedButton.styleFrom().copyWith(
          backgroundColor: const MaterialStatePropertyAll(Colors.red),
          foregroundColor: const MaterialStatePropertyAll(Colors.white),
        ),
        child: Text("Delete".tr),
      ),

      // زر الغاء
      buildCancelElevatedButton(),
    ],
  );
}

ElevatedButton buildDeleteButton(
    {required String message,
    required int id,
    required Function deleteFunc,
    required Function updateFunc}) {
  return ElevatedButton(
    onPressed: () {
      Get.back();
      buildDeleteDialog(
        message: "Are you sure to delete this Batch?".tr,
        id: id,
        deleteFunc: deleteFunc,
        updateFunc: updateFunc,
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
    ),
    child: Text("Delete".tr),
  );
}

buildSnackbar(String message) {
  return Fluttertoast.showToast(
    msg: message.tr,
    toastLength: Toast.LENGTH_SHORT,
  );
  // return Get.snackbar(
  //   title.tr, message.tr,
  //   titleText: Text(title.tr, style: Get.textTheme.titleMedium),
  //   messageText: Text(message.tr, style: Get.textTheme.bodyMedium),
  //   snackPosition: SnackPosition.BOTTOM,
  //   margin: const EdgeInsets.all(8.0),
  //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  //   mainButton: TextButton(
  //     onPressed: () => Get.back(),
  //     child: Text("hide".tr),
  //   ),
  // );
}

ElevatedButton buildCancelElevatedButton() {
  return ElevatedButton(
    onPressed: () async {
      while (Get.isSnackbarOpen || (Get.isDialogOpen ?? false)) {
        Get.back();
      }
    },
    child: Text("Cancel".tr),
  );
}
