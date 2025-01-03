import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

var db = DB();

class DB {
  Database? _db;

  init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _db = await openDatabase(
      join(await getDatabasesPath(), 'XXXXxXxXz.db'),
      onCreate: (db, version) {
        db.execute(
          '''
            CREATE TABLE items(
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              title TEXT, description TEXT, 
              location TEXT, media TEXT, isDone BOOLEAN, board INTEGER
            )
          ''',
        );
        db.execute(
          '''
            CREATE TABLE boards(
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              title TEXT,
              file TEXT
            )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<int> insertBoard(Board b) {
    return _db!
        .insert("boards", b.toMap(), conflictAlgorithm: ConflictAlgorithm.fail);
  }

  
  Future<List<Board>> listBoards() async {
    final List<Map<String, Object?>> items = await _db!.query('boards');

    return [
      for (final {
            "id": id as int,
            "title": title as String,
            "file": file as String
          } in items)
        Board(
          id: id,
          title: title,
          file: file,
        ),
    ];
  }

  Future<int> insertItem(Item i) {
    return _db!
        .insert("items", i.toMap(), conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<int> toggleItemStatus(Item i) async {
    final updated = Item(
      id: i.id,
      title: i.title,
      description: i.description,
      location: i.description,
      media: i.media,
      isDone: !i.isDone,
      board: i.board,
    );

    return _db!.update("items", updated.toMap(), where: "id = ?", whereArgs: [i.id]);
  }

  Future<List<Item>> listItems(int board, int offset, int size) async {
    final List<Map<String, Object?>> items = await _db!.query('items',
        limit: size, offset: offset, where: "board = ?", whereArgs: [board]);

    return [
      for (final {
            "id": id as int,
            "title": title as String,
            "description": description as String,
            "location": location as String,
            "media": media as String,
            "isDone": isDone as int,
            "board": board as int
          } in items)
        Item(
          id: id,
          title: title,
          description: description,
          location: location,
          media: media,
          isDone: isDone == 1,
          board: board
        ),
    ];
  }
}

class Item {
  final int id;
  final String title;
  final String description;
  final String location;
  final String media;
  final bool isDone;
  final int board; 

  const Item({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.media,
    required this.isDone,
    required this.board,
  });

  Map<String, Object?> toMap() {
    return {
      "title": title,
      "description": description,
      "location": location,
      "media": media,
      "isDone": isDone,
      "board": board,
    };
  }
}

class Board {
  final int id;
  final String title;
  final String file;

  const Board({
    required this.id,
    required this.title,
    required this.file,
  });

  Map<String, Object?> toMap() {
    return {
      "title": title,
      "file": file,
    };
  }
}
