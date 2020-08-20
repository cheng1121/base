
class ColumnType{
  ColumnType._();

  static const String string = 'TEXT';
  ///Supported values: from -2^63 to 2^63 - 1
  static const String int = 'INTEGER';
  static const String num = 'REAL';
  static const String bool = 'INTEGER';
  static const String uint8List = 'BLOB';


}