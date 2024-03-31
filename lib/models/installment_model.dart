import 'package:get/get.dart';

import '../view/widgets/public_widget.dart';
import 'app_Db.dart';

class InstallmentModel extends GetxController {
  int id = 0;
  final int amount;
  final String receiver;
  final String date;
  final String note;
  final int rest;
  final bool is_creditor;

  InstallmentModel({
    this.id = 0,
    required this.amount,
    required this.receiver,
    required this.date,
    required this.note,
    required this.rest,
    this.is_creditor = true,
  });

  factory InstallmentModel.fromJson(Map<String, Object?> json) {
    return InstallmentModel(
      id: int.parse(json['id'].toString()),
      amount: int.parse(json['amount'].toString()),
      receiver: json['receiver'].toString(),
      date: json['date'].toString(),
      note: json['note'].toString(),
      rest: int.parse(json['rest'].toString()),
      is_creditor: json['is_creditor'].toString() == "0",
    );
  }

  // map تحويل بيانات الفئة إلى نوع
  Map<String, Object> toMap() {
    return {
      'amount': amount,
      'receiver': receiver,
      'date': date,
      'note': note,
      'rest': rest,
      'is_creditor': is_creditor,
    };
  }

  // steing تحويل بيانات الفئة إلى نوع
  @override
  String toString() {
    return '''Installment{id: $id, amount: $amount, receiver: $receiver,
      date: $date, note: $note, rest: $rest, is_creditor: $is_creditor,}''';
  }

  static final _database = appDb.database;
  static Future<InstallmentModel?> getInstallmentById(String id) async {
    try {
      var installmentData = (await (await _database).rawQuery(
          """select id, amount, receiver, date, note, rest, is_creditor 
          from Installments where id =?""", [id]))[0];

      // print("The data>>>>>>>>>>$batchData");
      return InstallmentModel.fromJson(installmentData);
    } catch (e) {
      print("Error in getInstallmentById:::: $e");
      buildSnackbar("There is error. try again");
    }
    return null;
  }

   static Future<List<InstallmentModel>?> getAllInstallments() async {
    try {
      List<Map<String, Object?>> installments =
          await (await _database).query('Installments');
      return List.generate(
        installments.length,
        (index) => InstallmentModel.fromJson(installments[index]),
      );
      // print("Installments::: ${Installments}");
    } catch (e) {
      print("Error in getAllInstallments:::: $e");
      buildSnackbar("There is error. try again");
    }
    return null;
  }
}