import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_page.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  // ✅ GLOBAL THEME ACCESS
  static _MyAppState of(BuildContext context) =>

      context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() =>
      _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // 🌙 DARK MODE VARIABLE
  bool isDarkMode = false;

  // 🔥 TOGGLE FUNCTION
  void toggleTheme() {

    setState(() {

      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      // ✅ THEME MODE
      themeMode:
      isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,

      // 🌞 LIGHT THEME
      theme: ThemeData(

        brightness: Brightness.light,

        primarySwatch: Colors.green,

        scaffoldBackgroundColor:
        Colors.grey.shade100,

        appBarTheme: const AppBarTheme(

          backgroundColor: Colors.green,

          foregroundColor: Colors.white,
        ),
      ),

      // 🌙 DARK THEME
      darkTheme: ThemeData(

        brightness: Brightness.dark,

        primarySwatch: Colors.green,

        scaffoldBackgroundColor:
        Colors.black,

        appBarTheme: AppBarTheme(

          backgroundColor:
          Colors.grey.shade900,

          foregroundColor: Colors.white,
        ),
      ),

      // 🚀 ENTRY SCREEN
      home: const LoginPage(),

      routes: {

        '/login': (context) =>
        const LoginPage(),
      },
    );
  }
}