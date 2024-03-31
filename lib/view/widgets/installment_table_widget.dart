// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cards_record/models/installment_model.dart';

// import '../../controllers/installmentController.dart';
// import '../../core/app_functions.dart';

// class InstallmentTableWidget extends StatelessWidget {
//   final InstallmentModel installmentData;
//   InstallmentTableWidget({super.key, required this.installmentData});
//   double widthScreen = Get.mediaQuery.size.width;

//   @override
//   Widget build(BuildContext context) {
//     String date = installmentData.date;
//     bool is_creditor = installmentData.is_creditor;
//     return Card(
//       // key: Key(installmentData.date),
//       margin: EdgeInsets.symmetric(horizontal: widthScreen * 0.02, vertical: 6),
//       child: Padding(
//         padding: const EdgeInsets.only(bottom: 7),
//         // تاريخ القسط
//         child: InkWell(
//           // key: Key(element.date),
//         // child: buildInstallmentCard(element),
//         onLongPress: () {
//           final InstallmentController instlController = Get.find();
//           buildButtonsRowAsDialog(
//             [
//               // زر تعديل
//               ElevatedButton(
//                 onPressed: () => instlController.buildInstallmentDialog(
//                   initAmount: element.amount.toString(),
//                   initReceiver: element.receiver,
//                   initNote: element.note,
//                   date: element.date,
//                   rest: element.rest,
//                   idToEdit: element.id,
//                   is_creditor: element.is_creditor,
//                 ),
//                 child: Text("Edit".tr),
//               ),
//               // زر حذف
//               buildDeleteButton(
//                     message: "Are you sure to delete this Installment?".tr,
//                     id: element.id,
//                     deleteFunc: appDb.deleteInstallment,
//                     updateFunc: updateOperation,
//                   ),
//               // ElevatedButton(
//               //   onPressed: () {
//               //     Get.back();
//               //     buildDeleteButton(
//               //       message: "Are you sure to delete this Installment?".tr,
//               //       id: element.id,
//               //       deleteFunc: appDb.deleteInstallment,
//               //       updateFunc: updateOperation,
//               //     );
//               //   },
//               //   style: ElevatedButton.styleFrom(
//               //     backgroundColor: Colors.red,
//               //     foregroundColor: Colors.white,
//               //   ),
//                 // child: Text("Delete".tr),
//               // ),
//               // زر الغاء
//               buildCancelElevatedButton(),
//             ],
//           );
//         },
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.only(top: 10.0, bottom: 2),
//                 child: Text(
//                   "${'Installment date'.tr}: ${formatDateToShow(date, showTime: true)}",
//                   style: Get.textTheme.titleMedium!.copyWith(
//                     color: const Color(0xffAD7BE9),
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               // بيانات القسط
//               buildRowOfInstallmentData('Amount', installmentData.amount.toString(), color: Colors.red),
//               if (installmentData.receiver.isNotEmpty)
//                 buildRowOfInstallmentData('Receiver', installmentData.receiver),
//               if (installmentData.note.isNotEmpty)
//                 buildRowOfInstallmentData('Note', installmentData.note),
//               buildRowOfInstallmentData('Rest', installmentData.rest.toString(), color: Colors.red),
//               // for (int i = 0; i < 4; i++)
//               //   if (!((i == 1 && receiver == "") || (i == 2 && note == "")))
//               //     ...{
//               //       buildRowOfInstallmentData(
//               //         i == 0
//               //             ? "  ${'Amount'.tr}: "
//               //             : i == 1
//               //                 ? "  ${'Receiver'.tr}: "
//               //                 : i == 2
//               //                     ? "  ${'Note'.tr}: "
//               //                     : "  ${'Rest'.tr}: ",
//               //         i == 0
//               //             ? amount
//               //             : i == 1
//               //                 ? receiver
//               //                 : i == 2
//               //                     ? note
//               //                     : rest,
//               //         color: i == 0 || i == 3 ? Colors.red : Colors.black,
//               //       ),
//               //       Container(
//               //         padding: const EdgeInsets.only(bottom: 5),
//               //         child: Row(
//               //           children: [
//               //             SizedBox(
//               //               width: widthScreen * 0.33,
//               //               child: Text(
//               //                 i == 0
//               //                     ? "  ${'Amount'.tr}: "
//               //                     : i == 1
//               //                         ? "  ${'Receiver'.tr}: "
//               //                         : i == 2
//               //                             ? "  ${'Note'.tr}: "
//               //                             : "  ${'Rest'.tr}: ",
//               //                 style: Get.textTheme.titleSmall,
//               //                 textAlign: TextAlign.center,
//               //               ),
//               //             ),
//               //             Expanded(
//               //               child: Text(
//               //                 i == 0
//               //                     ? amount
//               //                     : i == 1
//               //                         ? receiver
//               //                         : i == 2
//               //                             ? note
//               //                             : rest,
//               //                 style: Get.textTheme.bodyMedium!.copyWith(
//               //                   color:
//               //                       i == 0 || i == 3 ? Colors.red : Colors.black,
//               //                 ),
//               //                 textAlign: TextAlign.center,
//               //               ),
//               //             ),
//               //           ],
//               //         ),
//               //       ),
//               //     }.toList(),
        
//               // اضافة نوع القسط
//               Container(
//                 padding: const EdgeInsets.symmetric(vertical: 5),
//                 child: Text(
//                   "${'Type installment'.tr}: ${is_creditor ? 'Creditor'.tr : 'Credit'.tr}",
//                   style: Get.textTheme.titleSmall,
//                   textAlign: TextAlign.center,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   buildRowOfInstallmentData(String subject, String value,
//       {Color color = Colors.black}) {
//     return Container(
//       padding: const EdgeInsets.only(bottom: 5),
//       child: Row(
//         children: [
//           SizedBox(
//             width: widthScreen * 0.33,
//             child: Text(
//               subject,
//               style: Get.textTheme.titleSmall,
//               textAlign: TextAlign.center,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: Get.textTheme.bodyMedium!.copyWith(
//                 color: color,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
