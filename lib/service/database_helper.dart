import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/movie.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('movies_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_movies (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        overview TEXT,
        poster_path TEXT,
        backdrop_path TEXT,
        vote_average REAL,
        release_date TEXT,
        list_type TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertMovie(MovieModel movie, String listType) async {
    final db = await instance.database;
    final movieData = movie.toMap();
    movieData['list_type'] = listType;

    return await db.insert(
      'user_movies',
      movieData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MovieModel>> getMoviesByListType(String listType) async {
    final db = await instance.database;
    final result = await db.query(
      'user_movies',
      where: 'list_type = ?',
      whereArgs: [listType],
    );
    return result.map((json) => MovieModel.fromMap(json)).toList();
  }

  Future<int> deleteMovie(int id) async {
    final db = await instance.database;
    return await db.delete(
      'user_movies',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<String?> getMovieStatus(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'user_movies',
      columns: ['list_type'],
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first['list_type'] as String?;
    }
    return null;
  }
}
