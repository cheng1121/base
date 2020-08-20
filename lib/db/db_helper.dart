import 'package:base/bean/base_bean.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static DBHelper _instance = DBHelper._();

  factory DBHelper.instance() => _instance;
  Database _database;

  Future<Database> openDb(String dbName,
      {int version,
      OnDatabaseConfigureFn onConfigure,
      OnDatabaseCreateFn onCreate,
      OnDatabaseVersionChangeFn onUpgrade,
      OnDatabaseVersionChangeFn onDowngrade,
      OnDatabaseOpenFn onOpen,
      bool readOnly = false,
      bool singleInstance = true}) async {
    _database = await openDatabase(
      dbName,
      version: version,
      onConfigure: onConfigure,
      onCreate: onCreate,
      onUpgrade: onUpgrade,
      onDowngrade: onDowngrade,
      onOpen: onOpen,
      readOnly: readOnly,
      singleInstance: singleInstance,
    );
    return _database;
  }

  Future<T> insert<T extends BaseBean>(String table, T t,
      {String nullColumnHack, ConflictAlgorithm conflictAlgorithm}) async {
    t.id = await _database.insert(table, t.toMap(),
        nullColumnHack: nullColumnHack, conflictAlgorithm: conflictAlgorithm);
    return t;
  }

  Future<List<Map>> get(
    String table,
    Object clazz, {
    bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset,
  }) async {
    List<Map> maps = await _database.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
    return maps;
  }

  Future<int> delete(String table, {String where, List<dynamic> whereArgs}) {
    return _database.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<int> update<T extends BaseBean>(String table, T t,
      {String where,
      List<dynamic> whereArgs,
      ConflictAlgorithm conflictAlgorithm}) {
    return _database.update(table, t.toMap(),
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: conflictAlgorithm);
  }

  Future<T> transaction<T extends BaseBean>(
      Future<T> Function(Transaction txn) action,
      {bool exclusive}) {
    return _database.transaction(action, exclusive: exclusive);
  }

  Future<int> rawInsert(String sql, [List<dynamic> arguments]) {
    return _database.rawInsert(sql, arguments);
  }

  Future<void> execute(String sql, [List<dynamic> arguments]) {
    return _database.execute(sql, arguments);
  }

  Future<List<Map<String, dynamic>>> rawQuery(String sql,
      [List<dynamic> arguments]) {
    return _database.rawQuery(sql, arguments);
  }

  Future<int> rawUpdate(String sql, [List<dynamic> arguments]) {
    return _database.rawUpdate(sql, arguments);
  }

  Future<int> rawDelete(String sql, [List<dynamic> arguments]) {
    return _database.rawDelete(sql, arguments);
  }

  Future<void> close() {
    return _database.close();
  }
}
