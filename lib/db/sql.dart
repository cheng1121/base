class Sql {
  Sql._();

  ///主键
  static const String dbPrimaryKey = 'PRIMARY KEY';

  ///主键自增长
  static const String dbPrimaryKeyAuto = 'PRIMARY KEY AUTOINCREMENT';

  ///升序排序关键字
  static const String dbASC = 'ASC';

  ///降序排序
  static const String dbDESC = 'DESC';

  ///临时表后缀
  static const String dbSuffix = '_TEMP';

  ///向表格中中添加一个字段
  static String dbAddColumnSql(
      String tableName, String columnName, String columnType) {
    return '''ALTER TABLE $tableName ADD $columnName $columnType''';
  }

  ///创建表格的sql
  static String createTableSql(String tableName, Map<String, String> column) {
    String columnSql = '';
    var lastKey = column.keys.last;
    column
        .map<String, String>((key, value) {
          var sqlStr = '';
          if (key == lastKey) {
            sqlStr = '$key $value';
          } else {
            sqlStr = '$key $value,';
          }
          return MapEntry(key, sqlStr);
        })
        .values
        .forEach((value) {
          columnSql += value;
        });

    ///创建表，IF NOT EXISTS 表示如果存在同名表则不创建
    return 'CREATE TABLE $tableName ($columnSql)';
  }

  ///重命名表格
  static String dbTableRenameSql(String name, String newName) {
    return '''ALTER TABLE $name RENAME TO $newName''';
  }

  /// 删除表格sql
  static String dbDropTableSql(String name) {
    return 'DROP TABLE IF EXISTS $name';
  }
}
