import 'package:ethern/pages/home.dart';
import 'package:ethern/pages/menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(),
      builder:(context, snapshot) {
        if (snapshot.hasData){
          return MenuPage();
        }else{
          return HomePage();
        }
      },)
    );
  }
}