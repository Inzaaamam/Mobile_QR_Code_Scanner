
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

// ignore: non_constant_identifier_names
class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute('''
          CREATE TABLE QR (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            age INT,
            address TEXT,
            profession TEXT
          )
        ''');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'qr_db.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        print('...database' );
        await createTables(database);
      },
    );
  }

  static Future<int> createItems(
    String name,
    int age,
    String address,
    String profession,
  ) async {
    final db = await SQLHelper.db();
    final data = {
      'name': name,
      'age': age,
      'address': address,
      'profession': profession
    };
    final id = await db.insert('QR', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('QR', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('QR', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // static Future<int> updateItem(
  //     int id, String name, int age, String address, String profession) async {
  //   final db = await SQLHelper.db();

  //   final data = {
  //     'name': name,
  //     'age': age,
  //     'address': address,
  //     'profession': profession
  //   };

  //   final result =
  //       await db.update('QR', data, where: "id = ?", whereArgs: [id]);
  //   return result;
  // }
  static Future<void> deleteItem(String name, int age) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(
        "QR",
        where: "name = ? AND age = ?",
        whereArgs: [name, age],
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
// @immutable
// class DataModel {
//   final String name;
//   final int age;
//   final String address;
//   final String profession;

//   const DataModel({
//     required this.name,
//     required this.age,
//     required this.address,
//     required this.profession,
//   });

//   @override
//   String toString() {
//     return 'DataModel{name: $name, age: $age, address: $address, profession: $profession}';
//   }

//   factory DataModel.fromJson(Map<String, dynamic> json) {
//     return DataModel(
//       name: json['name'],
//       age: json['age'],
//       address: json['address'],
//       profession: json['profession'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'age': age,
//       'address': address,
//       'profession': profession,
//     };
//   }
// }

