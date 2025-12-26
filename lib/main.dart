import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'providers/diary_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  // 1. 플러터 엔진 초기화 (비동기 작업을 위해 필수)
  WidgetsFlutterBinding.ensureInitialized();

  // sqflite 초기화 (Windows/Linux/Mac용)
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(
    // 3. Provider 주입 (이제 앱 어디서든 DiaryProvider를 쓸 수 있음)
    ChangeNotifierProvider(
      create: (context) => DiaryProvider(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '감정 일기',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true, // 최신 안드로이드 디자인 적용
      ),
      home: const HomeScreen(),
    );
  }
}