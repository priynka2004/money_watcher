import 'package:money_watcher/dashboard/model/money_record_model.dart';
import 'package:money_watcher/login/model/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static const String userTableName = 'user';
  static const String moneyRecordTableName = 'money_record';

  late Database database;

  Future initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'money_tracker.db');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        createUserTable(db);
        createMoneyRecordTable(db);
        print('Table create successfully');
      },
    );
  }

  Future<void> createMoneyRecordTable(Database db) async {
    await db.execute('create table $moneyRecordTableName(id integer primary key'
        ' autoincrement,title text,amount real,category text,'
        'date integer,type text)');
  }

  Future<void> createUserTable(Database db) async {
    await db
        .execute('create table $userTableName(email text primary key,name text,'
            'password text)');
  }

  Future registerUser(User user) async {
    // await database.rawInsert(
    //     "insert into $userTableName values('${user.email}','${user.name}','${user.password}')");
    await database.rawInsert('insert into $userTableName values(?,?,?)',
        [user.email, user.name, user.password]);
    print('User added successfully');
  }

  Future<bool> isUserExists(User user) async {
    List list = await database
        .rawQuery('select * from $userTableName where email=? AND password=?', [
      user.email,
      user.password,
    ]);
    if (list.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future addMoneyRecord(MoneyRecord moneyRecord) async {
    await database.rawInsert(
        'insert into $moneyRecordTableName (title,amount,category,'
        'date,type) values(?,?,?,?,?)',
        [
          moneyRecord.title,
          moneyRecord.amount,
          moneyRecord.category,
          moneyRecord.date,
          moneyRecord.type.toString(),
        ]);
    print('Money Record added successfully');
  }

  Future<List<MoneyRecord>> getMoneyRecords() async {
    List<Map<String, dynamic>> records =
        await database.rawQuery('Select * from $moneyRecordTableName');
    List<MoneyRecord> moneyRecordList = [];

    for (int i = 0; i < records.length; i++) {
      Map<String, dynamic> map = records[i];
      MoneyRecord moneyRecord = MoneyRecord.fromJson(map);
      moneyRecordList.add(moneyRecord);
    }

    return moneyRecordList;
  }
}
