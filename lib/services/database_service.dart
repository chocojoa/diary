import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/diary.dart';
import '../models/emotion_enum.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  // DB 가져오기 (없으면 초기화)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // DB 초기화 및 테이블 생성
  Future<Database> _initDatabase() async {
    // 폰 내부에 저장될 경로 설정
    String path = join(await getDatabasesPath(), 'diary_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // SQL 문법으로 테이블 만들기
        return db.execute(
          '''
          CREATE TABLE diaries(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            content TEXT, 
            createdAt TEXT, 
            emotion TEXT
          )
          ''',
        );
      },
    );
  }

  // 1. 저장 (Create) -> 저장된 ID 반환
  Future<int> addDiary(String content) async {
    final db = await database;
    final newDiary = Diary(
      content: content,
      createdAt: DateTime.now(),
      emotion: null,
    );
    // toMap()으로 변환해서 저장
    return await db.insert('diaries', newDiary.toMap());
  }

  // 2. 조회 (Read)
  Future<List<Diary>> getDiaries() async {
    final db = await database;
    // 최신순(DESC) 정렬해서 가져오기
    final List<Map<String, dynamic>> maps = await db.query(
      'diaries',
      orderBy: 'createdAt DESC',
    );
    // Map 리스트를 Diary 리스트로 변환
    return List.generate(maps.length, (i) => Diary.fromMap(maps[i]));
  }

  // 3. 감정 업데이트 (Update)
  Future<void> updateEmotion(int id, EmotionTag emotion) async {
    final db = await database;
    await db.update(
      'diaries',
      {'emotion': emotion.name}, // 변경할 내용
      where: 'id = ?',           // 변경할 조건 (해당 ID만)
      whereArgs: [id],
    );
  }

  // 4. 삭제 (Delete)
  Future<void> deleteDiary(int id) async {
    final db = await database;
    await db.delete(
      'diaries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}