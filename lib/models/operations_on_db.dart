import 'app_Db.dart' show appDb;

Future<String> getCategoryNameById(String cateId) async{
  try{
    Object cateName = (await appDb.getDataByCommand(
        "select name from categories where id= $cateId"))[0]['name'] ?? "Unknown";
    return cateName.toString();
  } catch(e){
    print("Exception in operationOnDbe $e");
    return "Unknown";
  }
}

Future<int> getCategoryPriceById(String cateId) async{
  try{
    Object catePrice = (await appDb.getDataByCommand(
        "select price from categories where id= $cateId"))[0]['price'] ?? "0";
    return int.tryParse(catePrice.toString())?? 0;
  } catch(e){
    print("Exception in operationOnDbe $e");
    return 0;
  }
}

Future<int> getTotallAllBatches() async{
  try{
    String command= '''SELECT SUM(batches.counts * categories.price) AS totalAll
     FROM batches INNER JOIN categories ON batches.categoryId = categories.id''';
    Object total = (await appDb.getDataByCommand(command))[0]['totalAll']?? 0;
    return int.tryParse(total.toString())?? 0;
  } catch(e){
    print("Exception in operationOnDbe $e");
    return 0;
  }
}

Future<int> getTotallAllCreditorInstallments() async{
  try{
    String command= '''SELECT SUM(amount) AS totalAll FROM installments WHERE is_creditor= 1''';
    Object total = (await appDb.getDataByCommand(command))[0]['totalAll']?? 0;
    return int.tryParse(total.toString())?? 0;
  } catch(e){
    print("Exception in operationOnDbe $e");
    return 0;
  }
}

Future<int> getTotallAllCreditInstallments() async{
  try{
    String command= '''SELECT SUM(amount) AS totalAll FROM installments WHERE is_creditor= 0''';
    Object total = (await appDb.getDataByCommand(command))[0]['totalAll']?? 0;
    return int.tryParse(total.toString())?? 0;
  } catch(e){
    print("Exception in operationOnDbe $e");
    return 0;
  }
}