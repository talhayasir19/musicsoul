import 'dart:async';
import 'dart:collection';

import 'package:musicsoul/Components/Local%20Database/PLSongModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'LaptopModel.dart';
import 'TableProperties.dart';

class LocalDb {
  static LocalDb? _instance;
  static const int version = 6;
  static Database? _db;
  Future<Database> get db async {
    return _db ??= await _initialize();
  }

  static LocalDb createInstance() {
    return _instance ??= LocalDb();
  }

  Future<Database> _initialize() async {
    return await openDatabase(
        join(
          await getDatabasesPath(),
          "localdatabase.db",
        ),
        onCreate: (db, version) => db.execute(
            "CREATE TABLE Playlists(Id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,nosongs INTEGER)"),
        version: version);
  }

  Future<List<String>> fetchPlaylist(String playListName) async {
    Database dB = await db;
    final playlistMap = await dB.query(playListName);
    return List.generate(
      playlistMap.length,
      (index) => playlistMap[index]['names'] as String,
    );
  }

  Future<void> addSongInPlaylist(String playList, String song) async {
    Database dB = await db;
    await dB.insert(playList, {"names": song});
    print("Done");
  }

  Future<void> createTable(String name) async {
    Database dB = await db;
    await dB.execute(
        "CREATE TABLE IF NOT EXISTS $name(Id INTEGER PRIMARY KEY AUTOINCREMENT,names TEXT)");
    print("Done");
  }

  Future<int> createPlaylist(String name) async {
    final database = await db;
    Map<String, Object> x = {"name": name, "nosongs": 2};
    var y = await database.insert("Playlists", x);

    print("Success");
    return y;
  }

  Future<List<PLSongModel>> getData() async {
    final database = await db;
    final List<Map<String, dynamic>> maps = await database.query("Playlists");
    return List.generate(
        maps.length,
        (index) => PLSongModel(
            name: maps[index]['name'], nosongs: maps[index]['nosongs']));
  }
  // Future<int> insertData(LaptopModel laptopModel) async {
  //   final database = await db("");
  //   int id =
  //       await database.insert(TableProperties.TABLENAME, laptopModel.toMap());
  //   print(id.toString());
  //   return id;
  // }

  // Future<List<LaptopModel>> getData() async {
  //   final database = await db("");
  //   final List<Map<String, dynamic>> maps =
  //       await database.query(TableProperties.TABLENAME);
  //   return List.generate(
  //       maps.length,
  //       (index) => LaptopModel(
  //             Id: maps[index][TableProperties.IdColumn],
  //             Model: maps[index][TableProperties.ModelColumn],
  //             Price: maps[index][TableProperties.PriceColumn],
  //           ));
  // }

  // void updateDate(LaptopModel laptopModel) async {
  //   final database = await db("");
  //   int x = await database.update(
  //       TableProperties.TABLENAME, laptopModel.toMap(),
  //       where: TableProperties.ModelColumn.toString() + " = ?",
  //       whereArgs: [laptopModel.Model]);
  //   print(x);
  // }
}
