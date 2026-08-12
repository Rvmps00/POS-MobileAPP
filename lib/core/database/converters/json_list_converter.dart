import 'dart:convert';
import 'package:drift/drift.dart';

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    final decoded = json.decode(fromDb) as List;
    return decoded.map((e) => e.toString()).toList();
  }

  @override
  String toSql(List<String> value) {
    return json.encode(value);
  }
}

class MapListConverter
    extends TypeConverter<List<Map<String, dynamic>>, String> {
  const MapListConverter();

  @override
  List<Map<String, dynamic>> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    final decoded = json.decode(fromDb) as List;
    return decoded.map((e) => e as Map<String, dynamic>).toList();
  }

  @override
  String toSql(List<Map<String, dynamic>> value) {
    return json.encode(value);
  }
}
