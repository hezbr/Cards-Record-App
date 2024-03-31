import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

// انشاء كائن ستم استخدامه في كل الشاشات التي تحتاج التعمل مع قاعدة البيانات
// وذلك تجنبا للأخطاء التي حدثت
AppDatabase appDb = AppDatabase();

class AppDatabase {
  Future<Database> initDatabase() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), "MyAppDb.db"),
      onCreate: (db, version) async {
        print(version);
        // انشاء جدول الفئات
        await db.execute("""Create table Categories(id INTEGER NOT NULL 
            PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, price INTEGER NOT NULL)""");

        // اضافة فئات كقيم ابتدائية في التطبيق
        await db.rawInsert("insert into Categories(name, price) values('100','80')");
        await db.rawInsert("insert into Categories(name, price) values('200','180')");
        await db.rawInsert("insert into Categories(name, price) values('500','450')");
        
        // انشاء جدول الموزعين
        await db.execute("""Create table Distributors(id INTEGER NOT NULL 
            PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, phone INTEGER NOT NULL)""");
        
        // اضافة موزع كقيمة ابتدائية
        await db.rawInsert("insert into Distributors(name, phone) values('هزبر الحميدي',717317241)");
        
        // انشاء جدول الدفع (استلام دفعة)
        await db.execute("""Create table Batches(id INTEGER NOT NULL PRIMARY KEY
            AUTOINCREMENT, categoryId INTEGER NOT NULL, counts INTEGER NOT NULL
            , date TEXT NOT NULL, distributorId INTEGER NOT NULL, note Text,
            FOREIGN KEY (categoryId) REFERENCES Categories(id) ON DELETE CASCADE,
            FOREIGN KEY (distributorId) REFERENCES Distributors(id) ON DELETE CASCADE)""");

        // انشاء جدول الاقساط
        await db.execute("""Create table Installments(id INTEGER NOT NULL 
            PRIMARY KEY AUTOINCREMENT, amount INTEGER NOT NULL, receiver TEXT,
            date TEXT NOT NULL, note TEXT, rest INTEGER NOT NULL,
            is_creditor INTEGER NOT NULL DEFAULT(1))""");
      },
      version: 3,
      onUpgrade: (db, oldVersion, newVersion) async{
        if (oldVersion<2){
          await db.execute('''ALTER TABLE Installments ADD COLUMN is_creditor INTEGER NOT NULL DEFAULT(1)''');
        }
        if (oldVersion<3){
          await db.execute('''UPDATE Installments set date= date || " 0:00:0"''');
          await db.execute('''UPDATE Batches set date= date || " 0:00:0"''');
        }
      },
    );
    return database;
  }

  Database? _database;
  Future<Database> get database async {
    if (_database == null) print("Database null");
    _database ??= await initDatabase();
    return _database ?? await initDatabase();
  }

  //===================================================================
  // العمليات على الفئات وجدول الفئات
  //===================================================================
  // اضافة فئة جديدة إلى جدول الفئات
  Future<int> insertCategory(Category category) async {
    Database db = await database;
    return await db.insert(
      'Categories',
      category.toMap(),
      // في حال كان موجود مسبقا يتم استبداله
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // حذف فئة من جدول الفئات
  Future<int> deleteCategory(int id) async {
    Database db = await database;
    return await db.delete(
      'Categories',
      where: 'id= ?',
      whereArgs: [id],
    );
  }

  // تحديث فئة موجودة في جدول الفئات
  Future<int> updateCategory(Category category) async {
    Database db = await database;
    return await db.update(
      'Categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  // استرجاع كل الفئات وارجاعها على هيئة قائمة من الفئة
  Future<List<Category>> getCategories() async {
    try {
      Database db = await database;
      var data = [];
      data = await db.query('Categories');

      // List<Category> تحويل البيانات إلى قائمة من نوع
      return List.generate(
        data.length,
        (index) => Category(
          id: int.parse(data[index]['id'].toString()),
          name: data[index]['name'].toString(),
          price: int.parse(data[index]['price'].toString()),
        ),
      );
    } catch (e) {
      print(e);
      return [];
    }
  }

  //===================================================================
  // العمليات على الموزعين وجدول الموزعين
  //===================================================================
  // اضافة فئة جديدة إلى جدول الفئات
  Future<int> insertDistributor(Distributor distributor) async {
    Database db = await database;
    return await db.insert(
      'Distributors',
      distributor.toMap(),
      // في حال كان موجود مسبقا يتم استبداله
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // حذف فئة من جدول الفئات
  Future<int> deleteDistributor(int id) async {
    Database db = await database;
    return await db.delete(
      'Distributors',
      where: 'id= ?',
      whereArgs: [id],
    );
  }

  // تحديث فئة موجودة في جدول الفئات
  Future<int> updateDistributor(Distributor distributor) async {
    Database db = await database;
    return await db.update(
      'Distributors',
      distributor.toMap(),
      where: 'id = ?',
      whereArgs: [distributor.id],
    );
  }

  // استرجاع كل الفئات وارجاعها على هيئة قائمة من الفئة
  Future<List<Distributor>> getDistributors() async {
    try {
      Database db = await database;
      var data = [];
      data = await db.query('Distributors');

      // List<Category> تحويل البيانات إلى قائمة من نوع
      return List.generate(
        data.length,
        (index) => Distributor(
          id: int.parse(data[index]['id'].toString()),
          name: data[index]['name'].toString(),
          phone: int.parse(data[index]['phone'].toString()),
        ),
      );
    } catch (e) {
      print(e);
      return [];
    }
  }


  //===================================================================
  // العمليات على الدفع وجدول الدفع
  //===================================================================
  // اضافة دفعة جديدة إلى جدول الدفع
  Future<int> insertBatch(Batch_ batch) async {
    Database db = await database;
    return await db.insert(
      'Batches',
      batch.toMap(),
      // في حال كان موجود مسبقا يتم استبداله
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // حذف دفعة من جدول الدفع
  Future<int> deleteBatch(int id) async {
    Database db = await database;
    return await db.delete(
      'Batches',
      where: 'id= ?',
      whereArgs: [id],
    );
  }

  // تحديث بيانات دفعة موجودة في جدول الدفع
  Future<int> updateBatch(Batch_ batch) async {
    Database db = await database;
    return await db.update(
      'Batches',
      batch.toMap(),
      where: 'id = ?',
      whereArgs: [batch.id],
    );
  }

  // استرجاع كل الدفع وارجاعها على هيئة قائمة من الدفعة
  Future<List<Batch_>> getBatches() async {
    try {
      Database db = await database;
      List<Map<String, Object?>> data = [];
      data = await db.query('Batches');

      // List<Btach_> تحويل البيانات إلى قائمة من نوع
      return List.generate(
        data.length,
        (index) => Batch_(
          id: int.parse(data[index]['id'].toString()),
          categoryId: int.parse(data[index]['categoryId'].toString()),
          counts: int.parse(data[index]['counts'].toString()),
          date: data[index]['date'].toString(),
          distributorId: int.parse(data[index]['distributorId'].toString()),
          note: data[index]['note'].toString(),
        ),
      );
    } catch (e) {
      print(e);
      return [];
    }
  }


   //===================================================================
  // العمليات على الاقساط وجدول الاقساط
  //===================================================================
  // اضافة دفعة جديدة إلى جدول الدفع
  Future<int> insertInstallment(Installment installment) async {
    Database db = await database;
    return await db.insert(
      'Installments',
      installment.toMap(),
      // في حال كان موجود مسبقا يتم استبداله
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // حذف دفعة من جدول الدفع
  Future<int> deleteInstallment(int id) async {
    Database db = await database;
    return await db.delete(
      'Installments',
      where: 'id= ?',
      whereArgs: [id],
    );
  }

  // تحديث بيانات دفعة موجودة في جدول الدفع
  Future<int> updateInstallment(Installment installment) async {
    Database db = await database;
    return await db.update(
      'Installments',
      installment.toMap(),
      where: 'id = ?',
      whereArgs: [installment.id],
    );
  }

  // استرجاع كل الدفع وارجاعها على هيئة قائمة من الدفعة
  Future<List<Installment>> getInstallments() async {
    try {
      Database db = await database;
      var data = [];
      data = await db.query('Installments');

      // List<Installment> تحويل البيانات إلى قائمة من نوع
      return List.generate(
        data.length,
        (index) => Installment(
          id: int.parse(data[index]['id'].toString()),
          amount: int.parse(data[index]['amount'].toString()),
          receiver: data[index]['receiver'].toString(),
          date: data[index]['date'].toString(),
          note: data[index]['note'].toString(),
          rest: int.parse(data[index]['rest'].toString()),
          is_creditor: data[index]['is_creditor'] == 1,
        ),
      );
    } catch (e) {
      print('getInstallments Exception: $e');
      return [];
    }
  }


  //===================================================================
  //
  //===================================================================
  Future<void> executeCommand(String command) async {
    Database db = await database;
    await db.execute(command);
  }

  Future<List<Map<String, Object?>>> getDataByCommand(String command) async{
    Database db = await database;
    return await db.rawQuery(command);
  }

  Future<Future<List<Map<String, Object?>>>> getCreatedTableCommand(String tableName) async{
    Database db= await database;
    // PRAGMA table_info($tableName)
    return db.rawQuery("SELECT sql FROM sqlite_master WHERE type='table' AND name='$tableName'");
  }
}


//===================================================================
//
////===================================================================
// كلاس للفئة ليسهل العمليات الخاصة بالفئة على قواعد البيانات وغيرها
class Category {
  int id = 0;
  final String name;
  final int price;

  Category({this.id = 0, required this.name, required this.price});

  // map تحويل بيانات الفئة إلى نوع
  Map<String, Object> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }

  // steing تحويل بيانات الفئة إلى نوع
  @override
  String toString() {
    return "Category{name: $name, price: $price}";
  }
}

// كلاس للموزع ليسهل العمليات الخاصة بالفئة على قواعد البيانات وغيرها
class Distributor {
  int id = 0;
  final String name;
  int phone = 0;

  Distributor({this.id = 0, required this.name, this.phone = 0});

  // map تحويل بيانات الفئة إلى نوع
  Map<String, Object> toMap() {
    return {
      'name': name,
      'phone': phone,
    };
  }

  // steing تحويل بيانات الفئة إلى نوع
  @override
  String toString() {
    return "Distributor{id: $id, name: $name, phone: $phone}";
  }
}

// كلاس للدفعة من الكروت ليسهل العمليات الخاصة بالفئة على قواعد البيانات وغيرها
class Batch_ {
  int id = 0;
  final int categoryId;
  final int counts;
  final String date;
  final int distributorId;
  final String note;

  Batch_({
    this.id = 0,
    required this.categoryId,
    required this.counts,
    required this.date,
    required this.distributorId,
    required this.note,
  });

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
    return '''Batch{id: $id, categoryId: $categoryId, counts: $counts,
      date: $date, distributorId: $distributorId, note: $note}''';
  }
}

// كلاس للدفعة من الكروت ليسهل العمليات الخاصة بالفئة على قواعد البيانات وغيرها
class Installment {
  int id = 0;
  final int amount;
  final String receiver;
  final String date;
  final String note;
  final int rest;
  final bool is_creditor;

  Installment({
    this.id = 0,
    required this.amount,
    required this.receiver,
    required this.date,
    required this.note,
    required this.rest,
    this.is_creditor = true,
  });

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
}
