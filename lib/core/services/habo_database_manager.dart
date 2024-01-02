import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;

class HaboDatabaseManager {
  static const _dbVersion = 3;
  late Database db;

  Future<void> emptyTables() async {
    try {
      await db.delete("habits");
      await db.delete("events");
    } catch (_) {
      if (kDebugMode) {
        print(_);
      }
    }
  }

  void _updateTableEventsV1toV2(Batch batch) {
    batch.execute('ALTER TABLE Events ADD comment TEXT DEFAULT ""');
  }

  void _updateTableHabitsV2toV3(Batch batch) {
    batch.execute('ALTER TABLE habits ADD sanction TEXT DEFAULT "" NOT NULL');
    batch.execute(
        'ALTER TABLE habits ADD showSanction INTEGER DEFAULT 0 NOT NULL');
    batch.execute('ALTER TABLE habits ADD accountant TEXT DEFAULT "" NOT NULL');
  }

  void _createTableEventsV3(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS events');
    batch.execute('''CREATE TABLE events (
    id INTEGER,
    dateTime TEXT,
    dayType INTEGER,
    comment TEXT,
    PRIMARY KEY(id, dateTime),
    FOREIGN KEY (id) REFERENCES habits(id) ON DELETE CASCADE
    )''');
  }

  void _createTableHabitsV3(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS habits');
    batch.execute('''CREATE TABLE habits (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    position INTEGER,
    title TEXT,
    twoDayRule INTEGER,
    cue TEXT,
    routine TEXT,
    reward TEXT,
    showReward INTEGER,
    advanced INTEGER,
    notification INTEGER,
    notTime TEXT,
    sanction TEXT,
    showSanction INTEGER,
    accountant TEXT
    )''');
  }

  Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> initDatabase() async {
    final databasesPath = Platform.isLinux
        ? (await getApplicationSupportDirectory()).path
        : await getDatabasesPath();

    if (kDebugMode) {
      print(databasesPath);
    }

    final databaseFilePath = join(databasesPath, 'habo_db0.db');

    if (Platform.isLinux) {
      ffi.sqfliteFfiInit();
      db = await ffi.databaseFactoryFfi.openDatabase(databaseFilePath,
          options: OpenDatabaseOptions(
            version: _dbVersion,
            onCreate: _onCreate,
            onUpgrade: _onUpgrade,
          ));
    } else {
      db = await openDatabase(
        databaseFilePath,
        version: _dbVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    }
  }

  void _onCreate(db, version) {
    var batch = db.batch();
    _createTableHabitsV3(batch);
    _createTableEventsV3(batch);
    batch.commit();
  }

  void _onUpgrade(db, oldVersion, newVersion) {
    var batch = db.batch();
    if (oldVersion == 1) {
      _updateTableEventsV1toV2(batch);
      _updateTableHabitsV2toV3(batch);
    }
    if (oldVersion == 2) {
      _updateTableHabitsV2toV3(batch);
    }
    batch.commit();
  }
}
