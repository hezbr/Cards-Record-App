import 'package:get/get.dart';

import '../view/widgets/public_widget.dart';
import 'app_Db.dart';

class BatchModel extends GetxController {
  int id = 0;
  final int categoryId;
  final int counts;
  final String date;
  final int distributorId;
  final String note;
  final String cateName;
  final String totalPrice;
  final String distName;

  BatchModel({
    this.id = 0,
    required this.categoryId,
    required  this.counts,
    required this.date,
    required this.distributorId,
    required this.note,
    required this.cateName,
    required this.totalPrice,
    required this.distName,
  });

  factory BatchModel.fromJson(Map<String, Object?> json) {
    return BatchModel(
      id: int.parse(json['id'].toString()),
      categoryId: int.parse(json['categoryId'].toString()),
      cateName: json['cateName'].toString(),
      counts: int.parse(json['counts'].toString()),
      totalPrice: json['totalPrice'].toString(),
      date: json['date'].toString(),
      distributorId: int.parse(json['distributorId'].toString()),
      distName: json['distName'].toString(),
      note: json['note'].toString(),
    );
  }

  // map تحويل بيانات الفئة إلى نوع
  Map<String, Object> toMap() {
    return {
      'categoryId': categoryId,
      'counts': counts,
      'date': date,
      'distributorId': distributorId,
      'note': note,
    };
  }

  // steing تحويل بيانات الفئة إلى نوع
  @override
  String toString() {
    return '''BatchData {id: $id, categoryId: $categoryId, cateName: $cateName,
    counts: $counts, totalPrice: $totalPrice, date: $date,
    distributorId: $distributorId, distName: $distName, note: $note}''';
  }

  static final _database = appDb.database;
  static Future<BatchModel?> getBatchById(String id) async {
    try {
      var batchData = (await (await _database).rawQuery(
          """select b.id, b.categoryId, c.name as cateName, b.counts, 
          (b.counts*c.price) as totalPrice, b.date, b.distributorId, d.name as distName, 
          b.note from batches b, categories c, distributors d 
          where b.id = ? and b.categoryId = c.id and b.distributorId= d.id""",
          [id]))[0];

      // print("The data>>>>>>>>>>$batchData");
      return BatchModel.fromJson(batchData);
    } catch (e) {
      print("Error in getBatchById:::: $e");
      buildSnackbar("There is error. try again");
    }
    return null;
  }

  static Future<List<BatchModel>?> getAllBatches() async {
    try {
      List<Map<String, Object?>> resultIds =
          await (await _database).query('Batches', columns: ['id']);

      List<BatchModel> batches= [];
      for(Map<String, Object?> batchId in resultIds){
        BatchModel? batch= await getBatchById(batchId['id'].toString());
        if (batch != null) batches.add(batch);
      }
      // print("batches::: ${batches}");
      return batches;
    } catch (e) {
      print("Error in getAllBatches:::: $e");
      buildSnackbar("There is error. try again");
    }
    return null;
  }
}
