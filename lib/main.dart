import 'package:ethern/auth/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "Insert your apiKey here",
            authDomain: "ethern-9cf13.firebaseapp.com",
            projectId: "ethern-9cf13",
            storageBucket: "ethern-9cf13.appspot.com",
            messagingSenderId: "86864087870",
            appId: "1:86864087870:web:7cc47eb8781f16a6963a6f"));
  } else {
    await Firebase.initializeApp();
  }

  // Desabilitar rotação de tela
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Cardo',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}
