import 'package:my_todo_app/db/cached_category.dart';
import 'package:my_todo_app/db/cached_todo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase getInstance = LocalDatabase._init();
  static Database? _database;

  factory LocalDatabase() {
    return getInstance;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB("todos.db");
      return _database!;
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const textType = "TEXT NOT NULL";
    const intType = "INTEGER DEFAULT 0";

    await db.execute('''
    CREATE TABLE $todoTable (
    ${CachedTodoFields.id} $idType,
    ${CachedTodoFields.categoryId} $intType,
    ${CachedTodoFields.dateTime} $textType,
    ${CachedTodoFields.isDone} $intType,
    ${CachedTodoFields.todoDescription} $textType,
    ${CachedTodoFields.todoTitle} $textType,
    ${CachedTodoFields.urgentLevel} $intType
    )
    ''');

    await db.execute('''
    CREATE TABLE $categoryTable (
    ${CachedCategoryFields.id} $idType,
    ${CachedCategoryFields.categoryColor} $intType,
    ${CachedCategoryFields.categoryName} $textType,
    ${CachedCategoryFields.categoryIcon} $textType
    )
    ''');
  }

  LocalDatabase._init();

  //--------------------------------------  Cached Category Table  ------------------------------------

  static Future<CachedCategory> insertCachedCategory(CachedCategory cachedCategory) async {
    final db = await getInstance.database;
    final id = await db.insert(categoryTable, cachedCategory.toJson());
    return cachedCategory.copyWith(id: id);
  }

  static Future<List<CachedCategory>> getAllCachedCategories() async {
    final db = await getInstance.database;
    final result = await db.query(categoryTable);
    return result.map((json) => CachedCategory.fromJson(json)).toList();
  }

  static Future<CachedCategory> getCachedCategoryById(int id) async {
    final db = await getInstance.database;
    final result = await db.query(
      categoryTable,
      where: "${CachedCategoryFields.id} = ?",
      whereArgs: [id],
    );
    return result.map((json) => CachedCategory.fromJson(json)).toList()[0];
  }

  static Future<int> deleteCachedCategoryById(int id) async {
    final db = await getInstance.database;
    var t = await db.delete(categoryTable, where: "${CachedCategoryFields.id}=?", whereArgs: [id]);
    if (t > 0) {
      return t;
    } else {
      return -1;
    }
  }

  static Future<int> updateCachedCategory(CachedCategory cachedCategory) async {
    Map<String, dynamic> row = {
      CachedCategoryFields.categoryName: cachedCategory.categoryName,
      CachedCategoryFields.categoryIcon: cachedCategory.categoryIcon,
      CachedCategoryFields.categoryColor: cachedCategory.categoryColor,
    };

    final db = await getInstance.database;
    return await db.update(
      categoryTable,
      row,
      where: '${CachedCategoryFields.id} = ?',
      whereArgs: [cachedCategory.id],
    );
  }

  static Future<int> deleteAllCachedCategories() async {
    final db = await getInstance.database;
    return await db.delete(categoryTable);
  }

  //-------------------------------------------Cached Todos Table------------------------------------

  static Future<CachedTodo> insertCachedTodo(CachedTodo cachedTodo) async {
    final db = await getInstance.database;
    final id = await db.insert(todoTable, cachedTodo.toJson());
    return cachedTodo.copyWith(id: id);
  }

  static Future<List<CachedTodo>> getAllCachedTodos() async {
    final db = await getInstance.database;
    const orderBy = "${CachedTodoFields.todoTitle} ASC";
    final result = await db.query(
      todoTable,
      orderBy: orderBy,
    );
    return result.map((json) => CachedTodo.fromJson(json)).toList();
  }

  static Future<List<CachedTodo>> getTodosByDone(int isDone) async {
    final db = await getInstance.database;
    const orderBy = "${CachedTodoFields.todoTitle} ASC";

    final result = await db.query(
      todoTable,
      orderBy: orderBy,
      where: "${CachedTodoFields.isDone} = ?",
      whereArgs: [isDone],
    );
    return result.map((json) => CachedTodo.fromJson(json)).toList();
  }

  static Future<int> deleteAllCachedTodos() async {
    final db = await getInstance.database;
    return await db.delete(todoTable);
  }

  static Future<int> deleteCachedTodoById(int id) async {
    final db = await getInstance.database;
    var t = await db
        .delete(todoTable, where: "${CachedTodoFields.id}=?", whereArgs: [id]);
    if (t > 0) {
      return t;
    } else {
      return -1;
    }
  }

  static Future<int> updateCachedTodoStatus(int id, int status) async {
    Map<String, dynamic> row = {
      CachedTodoFields.isDone: status,
    };

    final db = await getInstance.database;
    return db.update(
      todoTable,
      row,
      where: '${CachedTodoFields.id} = ?',
      whereArgs: [id],
    );
  }

  static Future<int> updateCachedTodoAll(
    int id,
    String title,
    String desc,
    int categoryId,
    int urgentLevel,

  ) async {
    Map<String, dynamic> row = {
      CachedTodoFields.todoTitle: title,
      CachedTodoFields.todoDescription: desc,
      CachedTodoFields.categoryId: categoryId,
      CachedTodoFields.urgentLevel: urgentLevel,
    };

    final db = await getInstance.database;
    return db.update(
      todoTable,
      row,
      where: '${CachedTodoFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await getInstance.database;
    db.close();
  }
}
